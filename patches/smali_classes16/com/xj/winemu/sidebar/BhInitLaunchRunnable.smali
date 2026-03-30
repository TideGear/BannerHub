.class public Lcom/xj/winemu/sidebar/BhInitLaunchRunnable;
.super Ljava/lang/Object;
.source "SourceFile"

# Background Runnable: reads WINEPREFIX via BhWineLaunchHelper, stores it as
# fragment.wineRootPath, then posts a BhBrowseToRunnable to the main thread.

.implements Ljava/lang/Runnable;

.field public final fragment:Lcom/xj/winemu/sidebar/BhTaskManagerFragment;

.method public constructor <init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/xj/winemu/sidebar/BhInitLaunchRunnable;->fragment:Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
    return-void
.end method

.method public run()V
    .locals 5
    # v0 = fragment
    # v1 = prefix string
    # v2 = Handler (main looper)
    # v3 = Looper
    # v4 = BhBrowseToRunnable

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhInitLaunchRunnable;->fragment:Lcom/xj/winemu/sidebar/BhTaskManagerFragment;

    # Get WINEPREFIX
    invoke-static {}, Lapp/revanced/extension/gamehub/BhWineLaunchHelper;->getWinePrefix()Ljava/lang/String;
    move-result-object v1

    # Fallback to "/" if not found
    if-nez v1, :got_prefix
    const-string v1, "/"

    :got_prefix
    # Store as wineRootPath
    iput-object v1, v0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->wineRootPath:Ljava/lang/String;

    # Post browseTo(prefix) to main thread
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v3
    new-instance v2, Landroid/os/Handler;
    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v4, Lcom/xj/winemu/sidebar/BhBrowseToRunnable;
    invoke-direct {v4, v0, v1}, Lcom/xj/winemu/sidebar/BhBrowseToRunnable;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;Ljava/lang/String;)V
    invoke-virtual {v2, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
