package app.revanced.extension.gamehub;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Environment;
import android.widget.Toast;

import org.json.JSONObject;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Iterator;
import java.util.Map;

/**
 * BhSettingsExporter — per-game settings import/export.
 *
 * Export: reads pc_g_setting<gameId> SharedPreferences → JSON file
 *         saved as /sdcard/BannerHub/configs/<gamename>-<model>.json
 *
 * Import: lists .json files in /sdcard/BannerHub/configs/, shows a dialog,
 *         applies selected file's keys back to pc_g_setting<gameId>.
 */
public class BhSettingsExporter {
    private static final String SP_PREFIX = "pc_g_setting";
    private static final String EXPORT_DIR = "BannerHub/configs";

    public static void exportConfig(Context ctx, int gameId, String gameName) {
        try {
            SharedPreferences sp = ctx.getSharedPreferences(SP_PREFIX + gameId, Context.MODE_PRIVATE);
            Map<String, ?> all = sp.getAll();

            JSONObject json = new JSONObject();
            for (Map.Entry<String, ?> entry : all.entrySet()) {
                json.put(entry.getKey(), entry.getValue());
            }

            String safeName = gameName.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String deviceName = Build.MODEL.replaceAll("[^a-zA-Z0-9_\\-]", "_");
            String fileName = safeName + "-" + deviceName + ".json";

            File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
            //noinspection ResultOfMethodCallIgnored
            dir.mkdirs();
            File out = new File(dir, fileName);
            FileWriter fw = new FileWriter(out);
            fw.write(json.toString(2));
            fw.close();

            Toast.makeText(ctx, "Exported: " + fileName, Toast.LENGTH_LONG).show();
        } catch (Exception e) {
            Toast.makeText(ctx, "Export failed: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
    }

    public static void showImportDialog(final Context ctx, final int gameId, final String gameName) {
        try {
            File dir = new File(Environment.getExternalStorageDirectory(), EXPORT_DIR);
            if (!dir.exists()) {
                Toast.makeText(ctx, "No configs folder — export one first", Toast.LENGTH_SHORT).show();
                return;
            }
            File[] files = dir.listFiles((d, name) -> name.endsWith(".json"));
            if (files == null || files.length == 0) {
                Toast.makeText(ctx, "No .json configs found in BannerHub/configs/", Toast.LENGTH_SHORT).show();
                return;
            }

            final File[] finalFiles = files;
            final String[] names = new String[files.length];
            for (int i = 0; i < files.length; i++) {
                names[i] = files[i].getName();
            }

            new AlertDialog.Builder(ctx)
                    .setTitle("Import Config for " + gameName)
                    .setItems(names, (dialog, which) -> applyConfig(ctx, gameId, finalFiles[which]))
                    .setNegativeButton("Cancel", null)
                    .show();
        } catch (Exception e) {
            Toast.makeText(ctx, "Import error: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }

    private static void applyConfig(Context ctx, int gameId, File configFile) {
        try {
            char[] buf = new char[(int) configFile.length()];
            FileReader fr = new FileReader(configFile);
            int read = fr.read(buf);
            fr.close();

            JSONObject json = new JSONObject(new String(buf, 0, read));
            SharedPreferences.Editor editor = ctx.getSharedPreferences(
                    SP_PREFIX + gameId, Context.MODE_PRIVATE).edit();

            Iterator<String> keys = json.keys();
            while (keys.hasNext()) {
                String key = keys.next();
                Object val = json.get(key);
                if (val instanceof Boolean) {
                    editor.putBoolean(key, (Boolean) val);
                } else if (val instanceof Integer) {
                    editor.putInt(key, (Integer) val);
                } else if (val instanceof Long) {
                    editor.putLong(key, (Long) val);
                } else if (val instanceof Float || val instanceof Double) {
                    editor.putFloat(key, ((Number) val).floatValue());
                } else if (val instanceof String) {
                    editor.putString(key, (String) val);
                }
            }
            editor.apply();
            Toast.makeText(ctx, "Config applied from " + configFile.getName(), Toast.LENGTH_LONG).show();
        } catch (Exception e) {
            Toast.makeText(ctx, "Apply failed: " + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }
}
