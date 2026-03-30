package app.revanced.extension.gamehub;

import android.content.Context;
import android.widget.Toast;

import java.io.File;
import java.io.FileInputStream;
import java.io.RandomAccessFile;
import java.util.Arrays;

/**
 * BhWineLaunchHelper — helpers for the Launch tab in BhTaskManagerFragment.
 * Finds the running Wine binary, reads the Wine prefix and environment from
 * /proc, lists directories, and launches executables inside the Wine session.
 */
public class BhWineLaunchHelper {

    /**
     * Find the wine64/wine binary by locating a running wineserver or
     * wine64-preloader process in /proc and resolving its /proc/<pid>/exe
     * symlink, then looking for wine64/wine in the same directory.
     */
    public static String findWineBinary() {
        try {
            File proc = new File("/proc");
            File[] entries = proc.listFiles();
            if (entries == null) return null;
            for (File entry : entries) {
                try { Integer.parseInt(entry.getName()); } catch (NumberFormatException e) { continue; }
                String comm = readFirstLine("/proc/" + entry.getName() + "/comm");
                if (comm == null) continue;
                String lower = comm.trim().toLowerCase();
                if (!lower.equals("wineserver") && !lower.startsWith("wine64-preload")) continue;
                String exePath = new File("/proc/" + entry.getName() + "/exe").getCanonicalPath();
                if (exePath == null) continue;
                int slash = exePath.lastIndexOf('/');
                if (slash < 0) continue;
                String dir = exePath.substring(0, slash);
                File w64 = new File(dir, "wine64");
                if (w64.exists()) return w64.getAbsolutePath();
                File w = new File(dir, "wine");
                if (w.exists()) return w.getAbsolutePath();
            }
        } catch (Exception ignored) {}
        return null;
    }

    /**
     * Read WINEPREFIX from the environment of a running Wine process.
     * Returns null if no Wine process is found or WINEPREFIX is not set.
     */
    public static String getWinePrefix() {
        return readWineEnvVar("WINEPREFIX");
    }

    /**
     * Read the full environment block from the first running .exe process.
     * Returns a "KEY=VALUE" String array, or null if not found.
     */
    public static String[] getWineEnviron() {
        try {
            File proc = new File("/proc");
            File[] entries = proc.listFiles();
            if (entries == null) return null;
            for (File entry : entries) {
                try { Integer.parseInt(entry.getName()); } catch (NumberFormatException e) { continue; }
                String comm = readFirstLine("/proc/" + entry.getName() + "/comm");
                if (comm == null) continue;
                if (!comm.trim().toLowerCase().endsWith(".exe")) continue;
                byte[] buf = new byte[65536];
                FileInputStream fis = new FileInputStream("/proc/" + entry.getName() + "/environ");
                int read = fis.read(buf);
                fis.close();
                if (read <= 0) continue;
                String content = new String(buf, 0, read);
                return content.split("\u0000");
            }
        } catch (Exception ignored) {}
        return null;
    }

    /**
     * List a directory's contents.  Directories are returned with a trailing
     * "/" suffix.  Results are sorted: directories first, then files,
     * alphabetically within each group.  Returns an empty array on error.
     */
    public static String[] listDir(String path) {
        try {
            File dir = new File(path);
            File[] files = dir.listFiles();
            if (files == null) return new String[0];
            Arrays.sort(files, (a, b) -> {
                if (a.isDirectory() != b.isDirectory()) return a.isDirectory() ? -1 : 1;
                return a.getName().compareToIgnoreCase(b.getName());
            });
            String[] result = new String[files.length];
            for (int i = 0; i < files.length; i++) {
                result[i] = files[i].isDirectory()
                        ? files[i].getName() + "/"
                        : files[i].getName();
            }
            return result;
        } catch (Exception ignored) {
            return new String[0];
        }
    }

    /**
     * Returns true if the filename has a launchable Windows extension.
     */
    public static boolean isLaunchable(String name) {
        String lower = name.toLowerCase();
        return lower.endsWith(".exe") || lower.endsWith(".msi")
                || lower.endsWith(".bat") || lower.endsWith(".cmd");
    }

    /**
     * Launch a Windows executable using the running Wine binary and
     * environment.  Runs on a background thread; shows a Toast on the
     * calling thread before dispatching.
     */
    public static void launchExe(final String exePath) {
        new Thread(() -> {
            try {
                String wineBin = findWineBinary();
                if (wineBin == null) return;
                String[] env = getWineEnviron();
                Runtime.getRuntime().exec(new String[]{wineBin, exePath}, env, null);
            } catch (Exception ignored) {}
        }).start();
    }

    // ── private helpers ───────────────────────────────────────────────

    private static String readFirstLine(String path) {
        try {
            RandomAccessFile raf = new RandomAccessFile(path, "r");
            String line = raf.readLine();
            raf.close();
            return line;
        } catch (Exception e) {
            return null;
        }
    }

    private static String readWineEnvVar(String key) {
        try {
            File proc = new File("/proc");
            File[] entries = proc.listFiles();
            if (entries == null) return null;
            for (File entry : entries) {
                try { Integer.parseInt(entry.getName()); } catch (NumberFormatException e) { continue; }
                String comm = readFirstLine("/proc/" + entry.getName() + "/comm");
                if (comm == null) continue;
                String lower = comm.trim().toLowerCase();
                if (!lower.endsWith(".exe") && !lower.startsWith("wine")) continue;
                byte[] buf = new byte[65536];
                FileInputStream fis = new FileInputStream("/proc/" + entry.getName() + "/environ");
                int read = fis.read(buf);
                fis.close();
                if (read <= 0) continue;
                String content = new String(buf, 0, read);
                String prefix = key + "=";
                int idx = content.indexOf(prefix);
                if (idx < 0) continue;
                int start = idx + prefix.length();
                int end = content.indexOf('\u0000', start);
                if (end < 0) return content.substring(start);
                return content.substring(start, end);
            }
        } catch (Exception ignored) {}
        return null;
    }
}
