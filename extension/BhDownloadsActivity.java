package app.revanced.extension.gamehub;

import android.app.Activity;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.ScrollView;
import android.widget.TextView;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/** Shows all in-progress store downloads with live progress and per-download cancel. */
public class BhDownloadsActivity extends Activity {

    private final Handler uiHandler = new Handler(Looper.getMainLooper());
    private LinearLayout listLayout;
    private TextView emptyTV;
    private final Map<String, View[]> rows = new ConcurrentHashMap<>();
    // rows value: [card, progressBar (ProgressBar cast), labelTV (TextView cast)]

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        buildUi();
    }

    @Override
    protected void onResume() {
        super.onResume();
        // Populate rows for any already-running downloads
        for (String gameId : BhDownloadService.getActiveJobs()) {
            if (!rows.containsKey(gameId)) {
                String name = BhDownloadService.getGameName(gameId);
                String msg  = BhDownloadService.getLastMsg(gameId);
                int    pct  = BhDownloadService.getLastPct(gameId);
                uiHandler.post(() -> addRow(gameId, name, msg, pct));
            }
        }
        uiHandler.post(this::updateEmptyState);
        BhDownloadService.addGlobalListener(globalListener);
    }

    @Override
    protected void onPause() {
        super.onPause();
        BhDownloadService.removeGlobalListener(globalListener);
    }

    private final BhDownloadService.GlobalListener globalListener = new BhDownloadService.GlobalListener() {
        @Override public void onAnyProgress(String gameId, String gameName, String msg, int pct) {
            uiHandler.post(() -> {
                if (!rows.containsKey(gameId)) {
                    addRow(gameId, gameName, msg, pct);
                    updateEmptyState();
                } else {
                    View[] row = rows.get(gameId);
                    ((ProgressBar) row[1]).setProgress(pct);
                    ((TextView)    row[2]).setText(msg);
                }
            });
        }
        @Override public void onAnyComplete(String gameId, String gameName) {
            uiHandler.post(() -> { removeRow(gameId); updateEmptyState(); });
        }
        @Override public void onAnyError(String gameId, String msg) {
            uiHandler.post(() -> {
                View[] row = rows.get(gameId);
                if (row != null) ((TextView) row[2]).setText("Error: " + msg);
                uiHandler.postDelayed(() -> { removeRow(gameId); updateEmptyState(); }, 3000);
            });
        }
        @Override public void onAnyCancelled(String gameId) {
            uiHandler.post(() -> { removeRow(gameId); updateEmptyState(); });
        }
    };

    private void buildUi() {
        LinearLayout root = new LinearLayout(this);
        root.setOrientation(LinearLayout.VERTICAL);
        root.setBackgroundColor(0xFF0D0D0D);

        // Header
        LinearLayout header = new LinearLayout(this);
        header.setOrientation(LinearLayout.HORIZONTAL);
        header.setBackgroundColor(0xFF1A1A2E);
        header.setGravity(Gravity.CENTER_VERTICAL);
        header.setPadding(dp(8), dp(8), dp(8), dp(8));

        Button backBtn = new Button(this);
        backBtn.setText("←");
        backBtn.setTextColor(0xFFFFFFFF);
        GradientDrawable backBg = new GradientDrawable();
        backBg.setColor(0xFF333333);
        backBg.setCornerRadius(dp(4));
        backBtn.setBackground(backBg);
        backBtn.setTextSize(16f);
        backBtn.setPadding(dp(12), 0, dp(12), 0);
        backBtn.setOnClickListener(v -> finish());
        header.addView(backBtn, new LinearLayout.LayoutParams(-2, dp(40)));

        TextView titleTV = new TextView(this);
        titleTV.setText("Downloads");
        titleTV.setTextColor(0xFFFFFFFF);
        titleTV.setTextSize(18f);
        titleTV.setTypeface(null, Typeface.BOLD);
        titleTV.setPadding(dp(12), 0, 0, 0);
        header.addView(titleTV, new LinearLayout.LayoutParams(0, -2, 1f));

        root.addView(header, new LinearLayout.LayoutParams(-1, -2));

        // Content
        ScrollView scrollView = new ScrollView(this);
        listLayout = new LinearLayout(this);
        listLayout.setOrientation(LinearLayout.VERTICAL);
        listLayout.setPadding(dp(8), dp(8), dp(8), dp(8));

        emptyTV = new TextView(this);
        emptyTV.setText("No active downloads");
        emptyTV.setTextColor(0xFF888888);
        emptyTV.setTextSize(16f);
        emptyTV.setGravity(Gravity.CENTER);
        emptyTV.setPadding(dp(16), dp(40), dp(16), dp(40));
        listLayout.addView(emptyTV, new LinearLayout.LayoutParams(-1, -2));

        scrollView.addView(listLayout, new LinearLayout.LayoutParams(-1, -2));
        root.addView(scrollView, new LinearLayout.LayoutParams(-1, 0, 1f));
        setContentView(root);
    }

    private void addRow(String gameId, String gameName, String msg, int pct) {
        if (rows.containsKey(gameId)) return;

        // Card background
        LinearLayout card = new LinearLayout(this);
        card.setOrientation(LinearLayout.VERTICAL);
        GradientDrawable cardBg = new GradientDrawable();
        cardBg.setColor(0xFF1A1A2E);
        cardBg.setCornerRadius(dp(8));
        card.setBackground(cardBg);
        card.setPadding(dp(14), dp(12), dp(14), dp(12));

        LinearLayout.LayoutParams cardLp = new LinearLayout.LayoutParams(-1, -2);
        cardLp.setMargins(0, 0, 0, dp(10));

        // Title row
        LinearLayout titleRow = new LinearLayout(this);
        titleRow.setOrientation(LinearLayout.HORIZONTAL);
        titleRow.setGravity(Gravity.CENTER_VERTICAL);

        TextView nameTV = new TextView(this);
        nameTV.setText(gameName);
        nameTV.setTextColor(0xFFFFFFFF);
        nameTV.setTextSize(15f);
        nameTV.setTypeface(null, Typeface.BOLD);
        titleRow.addView(nameTV, new LinearLayout.LayoutParams(0, -2, 1f));

        Button cancelBtn = new Button(this);
        cancelBtn.setText("Cancel");
        cancelBtn.setTextColor(0xFFFFFFFF);
        cancelBtn.setTextSize(12f);
        GradientDrawable cancelBg = new GradientDrawable();
        cancelBg.setColor(0xFF8B0000);
        cancelBg.setCornerRadius(dp(4));
        cancelBtn.setBackground(cancelBg);
        cancelBtn.setPadding(dp(10), 0, dp(10), 0);
        cancelBtn.setOnClickListener(v -> BhDownloadService.cancel(this, gameId));
        titleRow.addView(cancelBtn, new LinearLayout.LayoutParams(-2, dp(34)));

        card.addView(titleRow, new LinearLayout.LayoutParams(-1, -2));

        // Progress bar
        ProgressBar progressBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
        progressBar.setMax(100);
        progressBar.setProgress(pct);
        LinearLayout.LayoutParams pbLp = new LinearLayout.LayoutParams(-1, dp(8));
        pbLp.setMargins(0, dp(10), 0, dp(4));
        card.addView(progressBar, pbLp);

        // Progress label
        TextView labelTV = new TextView(this);
        labelTV.setText(msg);
        labelTV.setTextColor(0xFFAAAAAA);
        labelTV.setTextSize(12f);
        card.addView(labelTV, new LinearLayout.LayoutParams(-1, -2));

        rows.put(gameId, new View[]{card, progressBar, labelTV});
        listLayout.addView(card, cardLp);
    }

    private void removeRow(String gameId) {
        View[] row = rows.remove(gameId);
        if (row != null) listLayout.removeView(row[0]);
    }

    private void updateEmptyState() {
        emptyTV.setVisibility(rows.isEmpty() ? View.VISIBLE : View.GONE);
    }

    private int dp(int value) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value,
                getResources().getDisplayMetrics());
    }
}
