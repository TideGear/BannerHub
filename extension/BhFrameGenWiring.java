package com.xj.winemu.sidebar;

import android.content.Context;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.ImageButton;

/**
 * Wires the Frame Generation switch + gear button added to the in-game
 * sidebar (winemu_sidebar_controls_fragment.xml) to BhFrameGenWriter +
 * BhFrameGenDialog.
 *
 * Called from SidebarControlsFragment.onResume() via a smali patch that
 * invokes Fragment.getView() and passes the resulting View here.
 */
public class BhFrameGenWiring {

    /** Find a view by its R.id name without requiring R.id at compile time. */
    private static View viewById(View root, String idName) {
        Context ctx = root.getContext();
        int id = ctx.getResources().getIdentifier(idName, "id", ctx.getPackageName());
        if (id == 0) return null;
        return root.findViewById(id);
    }

    /** Bind switch + gear button. Idempotent — onResume can call repeatedly. */
    public static void bind(final View root) {
        if (root == null) return;
        final Context ctx = root.getContext();

        // SidebarSwitchItemView is the host's custom switch widget. We look it up by id name.
        final View switchView = viewById(root, "switch_frame_gen");
        final View gearButton = viewById(root, "btn_frame_gen_settings");

        if (gearButton instanceof ImageButton) {
            gearButton.setVisibility(View.VISIBLE);
            gearButton.setOnClickListener(v -> BhFrameGenDialog.show(ctx));
        } else if (gearButton != null) {
            gearButton.setVisibility(View.VISIBLE);
            gearButton.setOnClickListener(v -> BhFrameGenDialog.show(ctx));
        }

        if (switchView != null) {
            BhFrameGenSettings settings = BhFrameGenSettings.load(ctx);
            // SidebarSwitchItemView typically wraps a CompoundButton — try to find one inside.
            CompoundButton inner = findCompoundButton(switchView);
            if (inner != null) {
                inner.setOnCheckedChangeListener(null);
                inner.setChecked(settings.enabled);
                inner.setOnCheckedChangeListener((b, checked) -> {
                    BhFrameGenSettings s = BhFrameGenSettings.load(ctx);
                    s.enabled = checked;
                    BhFrameGenWriter.writeEnabled(BhFrameGenWriter.resolveControlPath(ctx), checked);
                    s.save(ctx);
                });
            } else {
                // Fall back: clicking the row toggles state and writes
                final boolean[] state = new boolean[]{settings.enabled};
                switchView.setOnClickListener(v -> {
                    state[0] = !state[0];
                    BhFrameGenSettings s = BhFrameGenSettings.load(ctx);
                    s.enabled = state[0];
                    BhFrameGenWriter.writeEnabled(BhFrameGenWriter.resolveControlPath(ctx), state[0]);
                    s.save(ctx);
                });
            }
        }
    }

    /** Recursively search a view subtree for the first CompoundButton (e.g. the inner Switch
     *  inside SidebarSwitchItemView). */
    private static CompoundButton findCompoundButton(View v) {
        if (v instanceof CompoundButton) return (CompoundButton) v;
        if (v instanceof android.view.ViewGroup) {
            android.view.ViewGroup vg = (android.view.ViewGroup) v;
            for (int i = 0; i < vg.getChildCount(); i++) {
                CompoundButton cb = findCompoundButton(vg.getChildAt(i));
                if (cb != null) return cb;
            }
        }
        return null;
    }
}
