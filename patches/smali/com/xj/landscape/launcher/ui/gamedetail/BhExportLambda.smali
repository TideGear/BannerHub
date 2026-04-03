.class public final synthetic Lcom/xj/landscape/launcher/ui/gamedetail/BhExportLambda;
.super Ljava/lang/Object;

# implements kotlin.jvm.functions.Function1 — called when user taps Export Config
.implements Lkotlin/jvm/functions/Function1;

# instance fields
.field public final a:Lcom/xj/common/service/bean/GameDetailEntity;

# direct methods
.method public synthetic constructor <init>(Lcom/xj/common/service/bean/GameDetailEntity;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhExportLambda;->a:Lcom/xj/common/service/bean/GameDetailEntity;

    return-void
.end method

# virtual methods
.method public final invoke(Ljava/lang/Object;)Ljava/lang/Object;
    .locals 4

    # v0 = GameDetailEntity
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/gamedetail/BhExportLambda;->a:Lcom/xj/common/service/bean/GameDetailEntity;

    # v1 = Application context
    invoke-static {}, Lcom/blankj/utilcode/util/Utils;->a()Landroid/app/Application;
    move-result-object v1

    # v2 = gameId (int)
    invoke-virtual {v0}, Lcom/xj/common/service/bean/GameDetailEntity;->getId()I
    move-result v2

    # v3 = gameName (String)
    invoke-virtual {v0}, Lcom/xj/common/service/bean/GameDetailEntity;->getName()Ljava/lang/String;
    move-result-object v3

    invoke-static {v1, v2, v3}, Lapp/revanced/extension/gamehub/BhSettingsExporter;->exportConfig(Landroid/content/Context;ILjava/lang/String;)V

    const/4 v0, 0x0
    return-object v0
.end method
