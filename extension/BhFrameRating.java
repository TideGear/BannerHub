package com.xj.winemu.sidebar;

import android.app.ActivityManager;
import android.content.Context;
import android.graphics.Typeface;
import android.os.BatteryManager;
import android.os.Handler;
import android.os.Looper;
import android.view.Gravity;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;

/**
 * Winlator-style compact HUD overlay bar.
 * Shows GPU | CPU | RAM | BAT | TMP | FPS in a horizontal strip.
 * Data is read every second on a background thread.
 * Add to DecorView with Gravity.TOP|Gravity.RIGHT LayoutParams.
 * Tag: "bh_frame_rating"
 */
public class BhFrameRating extends LinearLayout implements Runnable {

    private final TextView tvGpu, tvCpu, tvRam, tvBat, tvTmp, tvFps;
    private final Handler handler = new Handler(Looper.getMainLooper());

    // CPU stat tracking across samples
    private long prevTotal = 0, prevIdle = 0;

    private volatile boolean running = false;

    public BhFrameRating(Context ctx) {
        super(ctx);
        setOrientation(HORIZONTAL);
        setBackgroundColor(0xCC000000); // semi-transparent black
        setPadding(16, 8, 16, 8);

        tvGpu = addLabel(ctx, "GPU --%", 0xFFFFAB91);
        addSep(ctx);
        tvCpu = addLabel(ctx, "CPU --%", 0xFFFFFFFF);
        addSep(ctx);
        tvRam = addLabel(ctx, "RAM --%", 0xFF90CAF9);
        addSep(ctx);
        tvBat = addLabel(ctx, "BAT --W", 0xFFFFD54F);
        addSep(ctx);
        tvTmp = addLabel(ctx, "TMP --\u00b0C", 0xFFEF9A9A);
        addSep(ctx);
        tvFps = addLabel(ctx, "FPS --", 0xFF76FF03);
    }

    private TextView addLabel(Context ctx, String text, int color) {
        TextView tv = new TextView(ctx);
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(11f);
        tv.setPadding(4, 0, 4, 0);
        tv.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        addView(tv, lp);
        return tv;
    }

    private void addSep(Context ctx) {
        TextView tv = new TextView(ctx);
        tv.setText(" | ");
        tv.setTextColor(0xFF555555);
        tv.setTextSize(11f);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT,
                ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        addView(tv, lp);
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        running = true;
        Thread t = new Thread(this, "BhFrameRating");
        t.setDaemon(true);
        t.start();
    }

    @Override
    protected void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        running = false;
    }

    @Override
    public void run() {
        while (running) {
            try {
                final int gpu  = readGpu();
                final int cpu  = readCpu();
                final int ram  = readRam();
                final float bat = readBattery();
                final int tmp  = readTemp();
                final float fps = readFps();

                handler.post(new Runnable() {
                    @Override public void run() {
                        if (!isAttachedToWindow()) return;
                        tvGpu.setText("GPU " + gpu + "%");
                        tvCpu.setText("CPU " + cpu + "%");
                        tvRam.setText("RAM " + ram + "%");
                        tvBat.setText(String.format("BAT %.1fW", bat));
                        tvTmp.setText("TMP " + tmp + "\u00b0C");
                        if (fps > 0) {
                            tvFps.setText(String.format("FPS %.0f", fps));
                        } else {
                            tvFps.setText("FPS --");
                        }
                    }
                });

                Thread.sleep(1000);
            } catch (InterruptedException e) {
                break;
            } catch (Exception ignored) {
            }
        }
    }

    // ── Data readers ────────────────────────────────────────────────────

    private int readGpu() {
        // Adreno: gpu_busy_percentage
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage");
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
        // Adreno fallback: devfreq/gpu_load
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/devfreq/gpu_load");
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
        // Mali
        v = readSysfsLine("/sys/class/misc/mali0/device/utilisation");
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private int readCpu() {
        String line = readSysfsLine("/proc/stat");
        if (line == null || !line.startsWith("cpu ")) return 0;
        String[] parts = line.trim().split("\\s+");
        if (parts.length < 5) return 0;
        try {
            long user  = Long.parseLong(parts[1]);
            long nice  = Long.parseLong(parts[2]);
            long sys   = Long.parseLong(parts[3]);
            long idle  = Long.parseLong(parts[4]);
            long iowait = parts.length > 5 ? Long.parseLong(parts[5]) : 0;
            long total = user + nice + sys + idle + iowait;
            long diffTotal = total - prevTotal;
            long diffIdle  = (idle + iowait) - prevIdle;
            prevTotal = total;
            prevIdle  = idle + iowait;
            if (diffTotal <= 0) return 0;
            return (int) (100L * (diffTotal - diffIdle) / diffTotal);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private int readRam() {
        ActivityManager am = (ActivityManager)
                getContext().getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) return 0;
        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
        am.getMemoryInfo(mi);
        if (mi.totalMem <= 0) return 0;
        return (int) (100L * (mi.totalMem - mi.availMem) / mi.totalMem);
    }

    private float readBattery() {
        try {
            BatteryManager bm = (BatteryManager)
                    getContext().getSystemService(Context.BATTERY_SERVICE);
            if (bm == null) return 0f;

            long currentNow = bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
            if (currentNow == Long.MIN_VALUE) return 0f;

            // Voltage from sysfs (µV)
            float voltage = 3.7f;
            String voltStr = readSysfsLine("/sys/class/power_supply/battery/voltage_now");
            if (voltStr != null) {
                try { voltage = Float.parseFloat(voltStr.trim()) / 1_000_000f; }
                catch (NumberFormatException ignored) {}
            }

            // currentNow may be µA or mA depending on device
            float currentA = Math.abs(currentNow) / 1_000_000f; // assume µA
            if (currentA < 0.01f) { // likely mA, not µA
                currentA = Math.abs(currentNow) / 1_000f;
            }
            return voltage * currentA;
        } catch (Exception e) {
            return 0f;
        }
    }

    private int readTemp() {
        // Battery temp (tenths of °C)
        String v = readSysfsLine("/sys/class/power_supply/battery/temp");
        if (v != null) {
            try { return Integer.parseInt(v.trim()) / 10; }
            catch (NumberFormatException ignored) {}
        }
        // CPU thermal zone0
        v = readSysfsLine("/sys/class/thermal/thermal_zone0/temp");
        if (v != null) {
            try {
                int t = Integer.parseInt(v.trim());
                return t > 1000 ? t / 1000 : t;
            } catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    /** Reads FPS via reflection from GameHub's ProfilePuller singleton. */
    private float readFps() {
        try {
            // ProfilePuller.a = Companion object
            Class<?> cls = Class.forName("com.winemu.core.utils.ProfilePuller");
            Field fCompanion = cls.getField("a");
            Object companion = fCompanion.get(null);
            // ProfilePuller$Companion.a() → ProfilePuller instance
            Method getInstance = companion.getClass().getMethod("a");
            Object puller = getInstance.invoke(companion);
            if (puller == null) return 0f;
            // ProfilePuller.c() → float FPS
            Method getFps = puller.getClass().getMethod("c");
            Object result = getFps.invoke(puller);
            return result == null ? 0f : (float) result;
        } catch (Exception e) {
            return 0f;
        }
    }

    private String readSysfsLine(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            return br.readLine();
        } catch (IOException e) {
            return null;
        }
    }
}
