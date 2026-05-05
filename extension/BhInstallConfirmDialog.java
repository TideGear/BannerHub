package app.revanced.extension.gamehub;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.File;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Centralized install-confirmation dialog used by GOG / Epic / Amazon list activities
 * and detail activities. Shows install size, available space, and a per-download
 * thread-count picker. Default opens at {@link BhDownloadConfig#DEFAULT_THREADS}.
 *
 * The chosen thread count is delivered to the caller's onConfirm callback. It is
 * not persisted anywhere — every install starts fresh at the default.
 */
public final class BhInstallConfirmDialog {

    public interface Callback {
        /** Called with the user's chosen thread count when they tap Install. */
        void onConfirm(int threadCount);
    }

    /** Runtime hook for fetching the install size async (e.g. via a manifest fetch). */
    public interface SizeFetcher {
        /** Implementations should call back on the UI thread. */
        void fetch(SizeCallback cb);
    }

    public interface SizeCallback {
        /** Pass the final size in bytes (or 0 if unknown). */
        void onSize(long bytes);
    }

    private BhInstallConfirmDialog() {}

    /**
     * Show the dialog with a known install size.
     *
     * @param activity  hosting activity
     * @param title     game title (e.g. "Cyberpunk 2077")
     * @param sizeBytes install size in bytes; 0 = unknown
     * @param storeDir  store dir name passed to BhStoragePath (e.g. "gog_games", "epic_games", "Amazon")
     * @param callback  invoked with the chosen thread count on Install
     */
    public static void show(Activity activity, String title, long sizeBytes,
                            String storeDir, Callback callback) {
        showAsync(activity, title, storeDir, callback, sizeBytes, null);
    }

    /**
     * Show the dialog when install size needs to be fetched async (e.g. Amazon manifest
     * fetch). The dialog opens immediately with "Fetching…" in the size row, then
     * updates when {@code fetcher} delivers the result.
     */
    public static void showAsync(Activity activity, String title, String storeDir,
                                 Callback callback, long initialSizeBytes,
                                 SizeFetcher fetcher) {
        final Context ctx = activity;
        final long freeBytes = computeFreeBytes(activity, storeDir);

        LinearLayout content = new LinearLayout(ctx);
        content.setOrientation(LinearLayout.VERTICAL);
        content.setPadding(dp(ctx, 20), dp(ctx, 12), dp(ctx, 20), dp(ctx, 4));

        final TextView sizeTV = makeRow(ctx,
                "Install size:  " + (initialSizeBytes > 0 ? formatBytes(initialSizeBytes)
                        : (fetcher != null ? "Fetching…" : "Unknown")),
                0xFFCCCCCC);
        content.addView(sizeTV);

        TextView freeTV = makeRow(ctx,
                "Available space:  " + (freeBytes >= 0 ? formatBytes(freeBytes) : "Unknown"),
                0xFF88CC88);
        content.addView(freeTV);

        // Download speed row — tappable, opens preset picker
        final AtomicInteger threads = new AtomicInteger(BhDownloadConfig.DEFAULT_THREADS);
        final TextView speedTV = makeRow(ctx,
                "Download speed:  " + BhDownloadConfig.labelFor(threads.get()) + "  ▾",
                0xFFAACCFF);
        speedTV.setPadding(0, dp(ctx, 12), 0, dp(ctx, 4));
        speedTV.setOnClickListener(v -> {
            String[] labels = BhDownloadConfig.presetLabels();
            int[] values = BhDownloadConfig.presets();
            int currentIdx = 0;
            for (int i = 0; i < values.length; i++) {
                if (values[i] == threads.get()) { currentIdx = i; break; }
            }
            new AlertDialog.Builder(activity)
                    .setTitle("Download speed")
                    .setSingleChoiceItems(labels, currentIdx, (d, which) -> {
                        threads.set(BhDownloadConfig.clamp(values[which]));
                        speedTV.setText("Download speed:  "
                                + BhDownloadConfig.labelFor(threads.get()) + "  ▾");
                        d.dismiss();
                    })
                    .setNegativeButton("Cancel", null)
                    .show();
        });
        content.addView(speedTV);

        TextView hint = new TextView(ctx);
        hint.setText("Higher = faster but uses more CPU and battery. Default is Low.");
        hint.setTextColor(0xFF888888);
        hint.setTextSize(11f);
        hint.setPadding(0, dp(ctx, 4), 0, 0);
        content.addView(hint);

        AlertDialog dialog = new AlertDialog.Builder(activity)
                .setTitle("Install " + title + "?")
                .setView(content)
                .setPositiveButton("Install", null)
                .setNegativeButton("Cancel", null)
                .create();
        dialog.show();

        dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(v -> {
            dialog.dismiss();
            callback.onConfirm(threads.get());
        });

        if (fetcher != null && initialSizeBytes <= 0) {
            fetcher.fetch(bytes -> {
                if (dialog.isShowing()) {
                    sizeTV.setText("Install size:  "
                            + (bytes > 0 ? formatBytes(bytes) : "Unknown"));
                }
            });
        }
    }

    private static TextView makeRow(Context ctx, String text, int color) {
        TextView tv = new TextView(ctx);
        tv.setText(text);
        tv.setTextColor(color);
        tv.setTextSize(14f);
        tv.setGravity(Gravity.START);
        return tv;
    }

    private static long computeFreeBytes(Context ctx, String storeDir) {
        try {
            File base = BhStoragePath.getInstallDir(ctx, storeDir, "_check");
            File parent = base.getParentFile();
            if (parent != null) parent.mkdirs();
            android.os.StatFs sf = new android.os.StatFs(
                    parent != null ? parent.getAbsolutePath()
                            : ctx.getCacheDir().getAbsolutePath());
            return sf.getAvailableBlocksLong() * sf.getBlockSizeLong();
        } catch (Exception e) {
            return -1;
        }
    }

    private static int dp(Context ctx, int v) {
        return (int) (v * ctx.getResources().getDisplayMetrics().density);
    }

    private static String formatBytes(long bytes) {
        if (bytes <= 0) return "0 B";
        if (bytes >= 1_073_741_824L) return String.format("%.2f GB", bytes / 1_073_741_824.0);
        if (bytes >= 1_048_576L)     return String.format("%.1f MB", bytes / 1_048_576.0);
        if (bytes >= 1024L)          return String.format("%.1f KB", bytes / 1024.0);
        return bytes + " B";
    }
}
