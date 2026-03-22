.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for the "Install" button in the game detail dialog.
# Calls GogDownloadManager.startDownload(context, game) and shows a Toast.

.implements Landroid/view/View$OnClickListener;

.field public final a:Landroid/content/Context;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;


.method public constructor <init>(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->a:Landroid/content/Context;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 3

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->a:Landroid/content/Context;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$6;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    invoke-static {v0, v1}, Lcom/xj/landscape/launcher/ui/menu/GogDownloadManager;->startDownload(Landroid/content/Context;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V

    const-string v2, "Starting download..."
    const/4 v1, 0x0
    invoke-static {v0, v2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;
    move-result-object v1
    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    return-void
.end method
