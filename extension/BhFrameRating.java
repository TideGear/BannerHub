package com.xj.winemu.sidebar;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.os.BatteryManager;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Winlator-style compact HUD overlay.
 * Outer container is always VERTICAL; an inner mainRow LinearLayout toggles H↔V on tap.
 * Extra detail block sits below mainRow in both horizontal and vertical orientations.
 * "Extra Detailed" pref (hud_extra_detail) controls the extra block; BhFrameRating
 * reads the pref each second and auto-syncs — no direct call from smali required.
 */
public class BhFrameRating extends LinearLayout implements Runnable {

    // Main stats labels (live in mainRow)
    private final TextView tvApi, tvGpu, tvCpu, tvRam, tvBat, tvTmp, tvFps;
    private final FpsGraphView fpsGraph;
    private final LinearLayout mainRow;
    private final Handler handler = new Handler(Looper.getMainLooper());
    private final Activity activity;
    private final List<View> sepViews = new ArrayList<>();

    // Extra detail block
    private final LinearLayout extraDetailGroup;
    private final TextView tvCpuCores, tvGpuInfo, tvGpuTemp, tvRamDetail,
            tvSwap, tvBatPct, tvSkn, tvFan, tvTime;
    private boolean extraDetail = false;

    // CPU stat tracking
    private long prevTotal = 0, prevIdle = 0;
    private volatile boolean running = false;

    // Drag state
    private float dragLastX, dragLastY, dragStartX, dragStartY;
    private boolean dragMoved;

    // Orientation of mainRow (starts horizontal)
    private boolean isVertical = false;

    public BhFrameRating(Context ctx) {
        super(ctx);
        this.activity = ctx instanceof Activity ? (Activity) ctx : null;

        // Outer container is always VERTICAL so the extra detail block sits below mainRow
        setOrientation(VERTICAL);
        setBackgroundColor(0xCC000000);
        setPadding(16, 8, 16, 8);

        // ── Inner row that toggles H↔V on tap ────────────────────────────────
        mainRow = new LinearLayout(ctx);
        mainRow.setOrientation(HORIZONTAL);

        tvApi = addLabel(mainRow, ctx, "API", 0xFFCE93D8);
        sepViews.add(addSep(mainRow, ctx));
        tvGpu = addLabel(mainRow, ctx, "GPU --%", 0xFFFFAB91);
        sepViews.add(addSep(mainRow, ctx));
        tvCpu = addLabel(mainRow, ctx, "CPU --%", 0xFFFFFFFF);
        sepViews.add(addSep(mainRow, ctx));
        tvRam = addLabel(mainRow, ctx, "RAM --%", 0xFF90CAF9);
        sepViews.add(addSep(mainRow, ctx));
        tvBat = addLabel(mainRow, ctx, "BAT --W", 0xFFFFD54F);
        sepViews.add(addSep(mainRow, ctx));
        tvTmp = addLabel(mainRow, ctx, "TMP --\u00b0C", 0xFFEF9A9A);
        sepViews.add(addSep(mainRow, ctx));
        tvFps = addLabel(mainRow, ctx, "FPS --", 0xFF76FF03);

        fpsGraph = new FpsGraphView(ctx);
        LinearLayout.LayoutParams gp = new LinearLayout.LayoutParams(
                dpToPx(ctx, 60), ViewGroup.LayoutParams.MATCH_PARENT);
        gp.gravity = Gravity.CENTER_VERTICAL;
        gp.leftMargin = dpToPx(ctx, 6);
        mainRow.addView(fpsGraph, gp);

        addView(mainRow, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        // ── Extra detail block ────────────────────────────────────────────────
        extraDetailGroup = new LinearLayout(ctx);
        extraDetailGroup.setOrientation(VERTICAL);
        extraDetailGroup.setVisibility(GONE);

        View divider = new View(ctx);
        divider.setBackgroundColor(0xFF333333);
        LinearLayout.LayoutParams divLp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, dpToPx(ctx, 1));
        divLp.topMargin = dpToPx(ctx, 4);
        divLp.bottomMargin = dpToPx(ctx, 4);
        extraDetailGroup.addView(divider, divLp);

        // CPU cores: 2 lines of 4 cores — setMaxLines(2) so \n works, no single-line
        tvCpuCores = addExtraLabel(ctx, "C0:--  C1:--  C2:--  C3:--\nC4:--  C5:--  C6:--  C7:--", 0xFFFFFFFF, false);
        // All other extra labels: single-line so they expand the overlay width rather than wrap
        tvGpuInfo   = addExtraLabel(ctx, "GPU -- | --MHz", 0xFFFFAB91, true);
        tvGpuTemp   = addExtraLabel(ctx, "GPU TMP --\u00b0C", 0xFFEF9A9A, true);
        tvRamDetail = addExtraLabel(ctx, "RAM --G / --G", 0xFF90CAF9, true);
        tvSwap      = addExtraLabel(ctx, "SWAP --G / --G", 0xFFB39DDB, true);
        tvBatPct    = addExtraLabel(ctx, "BAT --%", 0xFFFFD54F, true);
        tvSkn       = addExtraLabel(ctx, "SKN --\u00b0C", 0xFFEF9A9A, true);
        tvFan       = addExtraLabel(ctx, "FAN --", 0xFFB0BEC5, true);
        tvTime      = addExtraLabel(ctx, "TIME --:--", 0xFFFFFFFF, true);

        addView(extraDetailGroup, new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        // ── Touch: drag to move, tap to toggle mainRow orientation ────────────
        setOnTouchListener(new OnTouchListener() {
            private static final int TAP_SLOP = 10;
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) v.getLayoutParams();
                if (lp == null) return false;
                switch (event.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        if (lp.gravity != 0) {
                            lp.gravity = 0;
                            lp.leftMargin = v.getLeft();
                            lp.topMargin = v.getTop();
                            v.setLayoutParams(lp);
                        }
                        dragLastX = event.getRawX();
                        dragLastY = event.getRawY();
                        dragStartX = event.getRawX();
                        dragStartY = event.getRawY();
                        dragMoved = false;
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        float mx = event.getRawX() - dragStartX;
                        float my = event.getRawY() - dragStartY;
                        if (!dragMoved && (Math.abs(mx) > TAP_SLOP || Math.abs(my) > TAP_SLOP)) {
                            dragMoved = true;
                        }
                        int dx = (int) (event.getRawX() - dragLastX);
                        int dy = (int) (event.getRawY() - dragLastY);
                        lp.leftMargin += dx;
                        lp.topMargin += dy;
                        v.setLayoutParams(lp);
                        dragLastX = event.getRawX();
                        dragLastY = event.getRawY();
                        return true;
                    case MotionEvent.ACTION_UP:
                        if (!dragMoved) toggleOrientation();
                        return true;
                }
                return false;
            }
        });
    }

    /** Adds a stat label to the given parent (mainRow). */
    private TextView addLabel(ViewGroup parent, Context ctx, String text, int color) {
        TextView tv = new TextView(ctx);
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(11f);
        tv.setPadding(4, 0, 4, 0);
        tv.setTypeface(Typeface.MONOSPACE);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        parent.addView(tv, lp);
        return tv;
    }

    /** Adds a " | " separator to the given parent (mainRow). */
    private View addSep(ViewGroup parent, Context ctx) {
        TextView tv = new TextView(ctx);
        tv.setText(" | ");
        tv.setTextColor(0xFF555555);
        tv.setTextSize(11f);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.gravity = Gravity.CENTER_VERTICAL;
        parent.addView(tv, lp);
        return tv;
    }

    /**
     * Adds a label row to extraDetailGroup.
     * singleLine=true: prevents word-wrap, forces the overlay to grow wide enough.
     * singleLine=false: used for CPU cores (explicit \n newlines, max 2 lines).
     */
    private TextView addExtraLabel(Context ctx, String text, int color, boolean singleLine) {
        TextView tv = new TextView(ctx);
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(10f);
        tv.setPadding(4, 2, 4, 2);
        tv.setTypeface(Typeface.MONOSPACE);
        if (singleLine) {
            tv.setSingleLine(true);
            tv.setEllipsize(TextUtils.TruncateAt.END);
        } else {
            tv.setMaxLines(2);
        }
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        extraDetailGroup.addView(tv, lp);
        return tv;
    }

    private int dpToPx(Context ctx, int dp) {
        return Math.round(dp * ctx.getResources().getDisplayMetrics().density);
    }

    private void toggleOrientation() {
        isVertical = !isVertical;
        mainRow.setOrientation(isVertical ? VERTICAL : HORIZONTAL);

        // Show/hide " | " separators (only in horizontal mainRow)
        int sepVis = isVertical ? GONE : VISIBLE;
        for (View sep : sepViews) sep.setVisibility(sepVis);

        // FPS graph: 60dp wide × MATCH_PARENT tall in horizontal; MATCH_PARENT wide × 40dp tall in vertical
        LinearLayout.LayoutParams gp;
        if (isVertical) {
            gp = new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, dpToPx(getContext(), 40));
            gp.topMargin = dpToPx(getContext(), 4);
        } else {
            gp = new LinearLayout.LayoutParams(
                    dpToPx(getContext(), 60), ViewGroup.LayoutParams.MATCH_PARENT);
            gp.gravity = Gravity.CENTER_VERTICAL;
            gp.leftMargin = dpToPx(getContext(), 6);
        }
        fpsGraph.setLayoutParams(gp);

        // Center labels in vertical mainRow
        int labelGravity = isVertical ? Gravity.CENTER_HORIZONTAL : Gravity.CENTER_VERTICAL;
        for (TextView tv : new TextView[]{tvApi, tvGpu, tvCpu, tvRam, tvBat, tvTmp, tvFps}) {
            LinearLayout.LayoutParams lp = (LinearLayout.LayoutParams) tv.getLayoutParams();
            lp.gravity = labelGravity;
            tv.setLayoutParams(lp);
        }

        requestLayout();
    }

    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        try {
            SharedPreferences sp = getContext().getSharedPreferences("bh_prefs", 0);
            extraDetail = sp.getBoolean("hud_extra_detail", false);
            extraDetailGroup.setVisibility(extraDetail ? VISIBLE : GONE);
        } catch (Exception ignored) {}
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
                final String api       = readApiName();
                final int gpu          = readGpu();
                final int cpu          = readCpu();
                final int ram          = readRam();
                final boolean charging = isCharging();
                final float bat        = charging ? 0f : readBattery();
                final int tmp          = readTemp();
                final float fps        = readFps();

                final boolean newExtra = getContext()
                        .getSharedPreferences("bh_prefs", 0)
                        .getBoolean("hud_extra_detail", false);

                final int[] coreMhz     = newExtra ? readCoreMhz() : null;
                final String gpuModel   = newExtra ? readGpuModel() : null;
                final int gpuMhz        = newExtra ? readGpuMhz() : 0;
                final int gpuThermal    = newExtra ? readGpuThermal() : 0;
                final float[] ramDetail = newExtra ? readRamDetail() : null;
                final String swapStr    = newExtra ? readSwap() : null;
                final int batPct        = newExtra ? readBatPercent() : 0;
                final int skinTemp      = newExtra ? readSkinTemp() : 0;
                final int fanSpeed      = newExtra ? readFanSpeed() : 0;
                final String timeStr    = newExtra ? readTime() : null;

                handler.post(new Runnable() {
                    @Override public void run() {
                        if (!isAttachedToWindow()) return;

                        tvApi.setText(api);
                        tvGpu.setText("GPU " + gpu + "%");
                        tvCpu.setText("CPU " + cpu + "%");
                        tvRam.setText("RAM " + ram + "%");
                        tvBat.setText(charging ? "CHRG" : String.format("BAT %.1fW", bat));
                        tvTmp.setText("TMP " + tmp + "\u00b0C");
                        tvFps.setText(fps > 0 ? String.format("FPS %.0f", fps) : "FPS --");
                        fpsGraph.push(fps);

                        // Sync extra detail pref change
                        if (newExtra != extraDetail) {
                            extraDetail = newExtra;
                            extraDetailGroup.setVisibility(extraDetail ? VISIBLE : GONE);
                        }

                        // Update extra detail rows (shown in both H and V modes)
                        if (extraDetail) {
                            if (coreMhz != null && coreMhz.length >= 8) {
                                tvCpuCores.setText(String.format(
                                        "C0:%4d  C1:%4d  C2:%4d  C3:%4d\n" +
                                        "C4:%4d  C5:%4d  C6:%4d  C7:%4d",
                                        coreMhz[0], coreMhz[1], coreMhz[2], coreMhz[3],
                                        coreMhz[4], coreMhz[5], coreMhz[6], coreMhz[7]));
                            }
                            String model = gpuModel != null ? gpuModel : "--";
                            tvGpuInfo.setText("GPU " + model + " | " + gpuMhz + "MHz");
                            tvGpuTemp.setText("GPU TMP " + gpuThermal + "\u00b0C");
                            if (ramDetail != null && ramDetail.length >= 2) {
                                tvRamDetail.setText(String.format(
                                        "RAM %.1fG / %.1fG", ramDetail[0], ramDetail[1]));
                            }
                            if (swapStr != null) tvSwap.setText(swapStr);
                            tvBatPct.setText("BAT " + batPct + "%");
                            tvSkn.setText("SKN " + skinTemp + "\u00b0C");
                            tvFan.setText(fanSpeed > 0 ? "FAN " + fanSpeed : "FAN --");
                            if (timeStr != null) tvTime.setText("TIME " + timeStr);
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

    // ── API name ─────────────────────────────────────────────────────────────

    private String readApiName() {
        if (activity == null) return "API";
        try {
            Field gField = activity.getClass().getDeclaredField("g");
            gField.setAccessible(true);
            Object binding = gField.get(activity);
            if (binding == null) return "API";
            Field hudLayerField = binding.getClass().getDeclaredField("hudLayer");
            hudLayerField.setAccessible(true);
            Object hudLayer = hudLayerField.get(binding);
            if (hudLayer == null) return "API";
            Field bField = hudLayer.getClass().getDeclaredField("b");
            bField.setAccessible(true);
            Object unifiedHud = bField.get(hudLayer);
            if (unifiedHud == null) return "API";
            Field aField = unifiedHud.getClass().getDeclaredField("a");
            aField.setAccessible(true);
            Object nameObj = aField.get(unifiedHud);
            if (nameObj == null) return "API";
            String name = nameObj.toString().trim();
            if (name.isEmpty() || name.equals("N/A")) return "API";
            return name;
        } catch (Exception e) {
            return "API";
        }
    }

    // ── Charging ──────────────────────────────────────────────────────────────

    private boolean isCharging() {
        try {
            Intent intent = getContext().registerReceiver(
                    null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            if (intent == null) return false;
            int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
            return status == BatteryManager.BATTERY_STATUS_CHARGING
                    || status == BatteryManager.BATTERY_STATUS_FULL;
        } catch (Exception e) {
            return false;
        }
    }

    // ── Main data readers ─────────────────────────────────────────────────────

    private int readGpu() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpubusy");
        if (v != null) {
            try {
                String[] p = v.trim().split("\\s+");
                if (p.length >= 2) {
                    long busy = Long.parseLong(p[0]), total = Long.parseLong(p[1]);
                    if (total > 0) return (int) (100L * busy / total);
                }
            } catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_busy_percentage");
        if (v != null) {
            try { return Integer.parseInt(v.trim().replaceAll("[^0-9]", "")); }
            catch (NumberFormatException ignored) {}
        }
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
        String[] p = line.trim().split("\\s+");
        if (p.length < 5) return 0;
        try {
            long user = Long.parseLong(p[1]), nice = Long.parseLong(p[2]),
                    sys = Long.parseLong(p[3]), idle = Long.parseLong(p[4]),
                    iow = p.length > 5 ? Long.parseLong(p[5]) : 0;
            long total = user + nice + sys + idle + iow;
            long dTotal = total - prevTotal, dIdle = (idle + iow) - prevIdle;
            prevTotal = total; prevIdle = idle + iow;
            if (dTotal <= 0) return 0;
            return (int) (100L * (dTotal - dIdle) / dTotal);
        } catch (NumberFormatException e) { return 0; }
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
            long cur = bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW);
            if (cur == Long.MIN_VALUE) return 0f;
            float voltage = 3.7f;
            String vs = readSysfsLine("/sys/class/power_supply/battery/voltage_now");
            if (vs != null) {
                try { voltage = Float.parseFloat(vs.trim()) / 1_000_000f; }
                catch (NumberFormatException ignored) {}
            }
            float ampA = Math.abs(cur) / 1_000_000f;
            if (ampA < 0.01f) ampA = Math.abs(cur) / 1_000f;
            return voltage * ampA;
        } catch (Exception e) { return 0f; }
    }

    private int readTemp() {
        String v = readSysfsLine("/sys/class/power_supply/battery/temp");
        if (v != null) {
            try { return Integer.parseInt(v.trim()) / 10; }
            catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/thermal/thermal_zone0/temp");
        if (v != null) {
            try { int t = Integer.parseInt(v.trim()); return t > 1000 ? t / 1000 : t; }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private float readFps() {
        if (activity == null) return 0f;
        try {
            Field jField = activity.getClass().getField("j");
            Object provider = jField.get(activity);
            if (provider == null) return 0f;
            Method getA = provider.getClass().getMethod("a");
            Object result = getA.invoke(provider);
            return result == null ? 0f : (float) result;
        } catch (Exception e) { return 0f; }
    }

    // ── Extra detail readers ──────────────────────────────────────────────────

    private int[] readCoreMhz() {
        int[] r = new int[8];
        for (int i = 0; i < 8; i++) {
            String v = readSysfsLine(
                    "/sys/devices/system/cpu/cpu" + i + "/cpufreq/scaling_cur_freq");
            if (v != null) {
                try { r[i] = Integer.parseInt(v.trim()) / 1000; }
                catch (NumberFormatException ignored) {}
            }
        }
        return r;
    }

    private int readGpuMhz() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpuclk");
        if (v != null) {
            try { return (int) (Long.parseLong(v.trim()) / 1_000_000L); }
            catch (NumberFormatException ignored) {}
        }
        v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/clock_mhz");
        if (v != null) {
            try { return Integer.parseInt(v.trim()); }
            catch (NumberFormatException ignored) {}
        }
        return 0;
    }

    private String readGpuModel() {
        String v = readSysfsLine("/sys/class/kgsl/kgsl-3d0/gpu_model");
        if (v != null) return v.trim().replace("(TM)", "").replaceAll("\\s+", " ").trim();
        return null;
    }

    private int readGpuThermal() { return readThermalZone("gpu"); }
    private int readSkinTemp()   { return readThermalZone("skin"); }

    private int readThermalZone(String typeName) {
        for (int i = 0; i < 30; i++) {
            String type = readSysfsLine("/sys/class/thermal/thermal_zone" + i + "/type");
            if (type != null && type.trim().equalsIgnoreCase(typeName)) {
                String temp = readSysfsLine("/sys/class/thermal/thermal_zone" + i + "/temp");
                if (temp != null) {
                    try { int t = Integer.parseInt(temp.trim()); return t > 1000 ? t / 1000 : t; }
                    catch (NumberFormatException ignored) {}
                }
            }
        }
        return 0;
    }

    private float[] readRamDetail() {
        ActivityManager am = (ActivityManager)
                getContext().getSystemService(Context.ACTIVITY_SERVICE);
        if (am == null) return null;
        ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
        am.getMemoryInfo(mi);
        return new float[]{
                (mi.totalMem - mi.availMem) / 1_073_741_824f,
                mi.totalMem / 1_073_741_824f
        };
    }

    private String readSwap() {
        long swapTotal = 0, swapFree = 0;
        try (BufferedReader br = new BufferedReader(new FileReader("/proc/meminfo"))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith("SwapTotal:"))      swapTotal = parseMemInfoKb(line);
                else if (line.startsWith("SwapFree:")) { swapFree  = parseMemInfoKb(line); break; }
            }
        } catch (IOException ignored) {}
        return String.format("SWAP %.1fG / %.1fG",
                (swapTotal - swapFree) / (1024f * 1024f),
                swapTotal / (1024f * 1024f));
    }

    private long parseMemInfoKb(String line) {
        try { return Long.parseLong(line.trim().split("\\s+")[1]); }
        catch (Exception e) { return 0; }
    }

    private int readBatPercent() {
        try {
            BatteryManager bm = (BatteryManager)
                    getContext().getSystemService(Context.BATTERY_SERVICE);
            if (bm == null) return 0;
            return Math.max(0, Math.min(100,
                    (int) bm.getLongProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)));
        } catch (Exception e) { return 0; }
    }

    private int readFanSpeed() {
        for (int h = 0; h < 5; h++) for (int f = 1; f <= 3; f++) {
            String v = readSysfsLine("/sys/class/hwmon/hwmon" + h + "/fan" + f + "_input");
            if (v != null) { try { return Integer.parseInt(v.trim()); } catch (NumberFormatException ignored) {} }
        }
        return 0;
    }

    private String readTime() {
        return new SimpleDateFormat("HH:mm", Locale.getDefault()).format(new Date());
    }

    private String readSysfsLine(String path) {
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            return br.readLine();
        } catch (IOException e) { return null; }
    }

    // ── FPS Graph ─────────────────────────────────────────────────────────────

    private static class FpsGraphView extends View {
        private static final int HISTORY = 30;
        private final float[] samples = new float[HISTORY];
        private int head = 0, count = 0;
        private final Paint barPaint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final Paint bgPaint  = new Paint();

        public FpsGraphView(Context ctx) {
            super(ctx);
            bgPaint.setColor(0x44000000);
        }

        public void push(float fps) {
            samples[head] = fps;
            head = (head + 1) % HISTORY;
            if (count < HISTORY) count++;
            invalidate();
        }

        @Override
        protected void onDraw(Canvas canvas) {
            int w = getWidth(), h = getHeight();
            canvas.drawRect(0, 0, w, h, bgPaint);
            if (count == 0) return;
            float max = 1f;
            for (int i = 0; i < count; i++) if (samples[i] > max) max = samples[i];
            float barW = (float) w / HISTORY;
            for (int i = 0; i < count; i++) {
                int idx = (head - count + i + HISTORY) % HISTORY;
                float fps = samples[idx], barH = (fps / max) * h, ratio = fps / max;
                barPaint.setColor(Color.rgb((int)(255*(1f-ratio)), (int)(255*ratio), 0));
                canvas.drawRect(i * barW, h - barH, i * barW + barW - 1f, h, barPaint);
            }
        }
    }
}
