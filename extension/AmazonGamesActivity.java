package app.revanced.extension.gamehub;

import android.app.Activity;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.FrameLayout;
import android.widget.TextView;

/**
 * Amazon Games library screen.
 * Phase 1 stub — full implementation in Phase 2.
 */
public class AmazonGamesActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FrameLayout root = new FrameLayout(this);
        root.setBackgroundColor(0xFF0D0D0D);

        TextView placeholder = new TextView(this);
        placeholder.setText("Amazon Game Library\n(coming soon)");
        placeholder.setTextColor(0xFFAAAAAA);
        placeholder.setTextSize(16f);
        placeholder.setGravity(Gravity.CENTER);
        root.addView(placeholder, new FrameLayout.LayoutParams(-1, -1));

        setContentView(root);
    }
}
