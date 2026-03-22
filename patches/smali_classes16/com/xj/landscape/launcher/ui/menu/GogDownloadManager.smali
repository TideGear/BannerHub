.class public Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager;
.super Ljava/lang/Object;

# BannerHub: GOG Gen 2 download pipeline entry point.
# startDownload(Context, GogGame) spawns a background thread that runs
# the full 7-step pipeline in GogDownloadManager$1.


.method public static startDownload(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    .locals 3

    new-instance v0, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;
    invoke-direct {v0, p0, p1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager$1;-><init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V

    new-instance v1, Ljava/lang/Thread;
    invoke-direct {v1, v0}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    return-void
.end method
