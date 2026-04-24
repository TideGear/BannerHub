.class public final synthetic Lcom/xj/landscape/launcher/ui/gamedetail/BhFrontendExportLambda;
.super Ljava/lang/Object;

# implements kotlin.jvm.functions.Function1 — called when user taps Frontend Export
.implements Lkotlin/jvm/functions/Function1;

# instance fields
.field public final a:Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;
.field public final b:Lcom/xj/common/service/bean/GameDetailEntity;

# direct methods
.method public synthetic constructor <init>(Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;Lcom/xj/common/service/bean/GameDetailEntity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhFrontendExportLambda;->a:Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhFrontendExportLambda;->b:Lcom/xj/common/service/bean/GameDetailEntity;

    return-void
.end method

# virtual methods
.method public final invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 5

    # v0 = GameDetailSettingMenu
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhFrontendExportLambda;->a:Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;

    # v1 = FragmentActivity (Activity context — required for AlertDialog)
    invoke-virtual {v0}, Lcom/xj/landscape/launcher/ui/gamedetail/GameDetailSettingMenu;->z()Landroidx/fragment/app/FragmentActivity;
    move-result-object v1

    # v2 = GameDetailEntity
    iget-object v2, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhFrontendExportLambda;->b:Lcom/xj/common/service/bean/GameDetailEntity;

    # Resolve gameId: getId() > 0 → Steam/catalog ID, else → localGameId
    invoke-virtual {v2}, Lcom/xj/common/service/bean/GameDetailEntity;->getId()I
    move-result v3

    if-gtz v3, :has_server_id

    invoke-virtual {v2}, Lcom/xj/common/service/bean/GameDetailEntity;->getLocalGameId()Ljava/lang/String;
    move-result-object v3
    goto :resolve_done

    :has_server_id
    invoke-static {v3}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;
    move-result-object v3

    :resolve_done

    # v4 = gameName (String)
    invoke-virtual {v2}, Lcom/xj/common/service/bean/GameDetailEntity;->getName()Ljava/lang/String;
    move-result-object v4

    invoke-static {v1, v3, v4}, Lapp/revanced/extension/gamehub/BhSettingsExporter;->showFrontendExportDialog(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    const/4 v0, 0x0
    return-object v0
.end method
