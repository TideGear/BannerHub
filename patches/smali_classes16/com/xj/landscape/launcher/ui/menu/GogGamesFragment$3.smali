.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;
.super Ljava/lang/Object;

# BannerHub: OnClickListener for each game card in GogGamesFragment.
# Shows an AlertDialog with:
#   - cover art ImageView (200dp height, loaded async by GogGamesFragment$4)
#   - info TextView: Genre, Rating (/100), DLC count
#   - store URL TextView (blue)
# Dialog title is set to the game title via AlertDialog.Builder.setTitle().

.implements Landroid/view/View$OnClickListener;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Lcom/xj/landscape/launcher/ui/menu/GogGame;


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    return-void
.end method


.method public onClick(Landroid/view/View;)V
    .locals 11

    # v0 = context
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v0
    if-eqz v0, :done

    # v1 = GogGame
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;->b:Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # v8 = display density float (used throughout for dp→px)
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v7
    invoke-virtual {v7}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v7
    iget v8, v7, Landroid/util/DisplayMetrics;->density:F

    # ── Root LinearLayout (vertical, dark bg) ────────────────────────────────
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v7, 0x1  # VERTICAL
    invoke-virtual {v2, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const v7, 0xFF0D0D0D
    invoke-virtual {v2, v7}, Landroid/view/View;->setBackgroundColor(I)V

    # ── Cover art ImageView (MATCH_PARENT × 200dp) ───────────────────────────
    new-instance v3, Landroid/widget/ImageView;
    invoke-direct {v3, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    const v7, 0xFF1A1A1A  # placeholder bg
    invoke-virtual {v3, v7}, Landroid/view/View;->setBackgroundColor(I)V

    sget-object v7, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v3, v7}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    # LP: MATCH_PARENT × 200dp
    const/high16 v7, 0x43480000  # 200.0f
    mul-float v7, v8, v7
    float-to-int v7, v7  # v7 = 200dp in px

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v10, -0x1  # MATCH_PARENT
    invoke-direct {v9, v10, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v2, v3, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Start async cover art loader ($4)
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->imageUrl:Ljava/lang/String;
    if-eqz v9, :skip_cover_load

    new-instance v10, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;
    invoke-direct {v10, v9, v3}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;-><init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    new-instance v9, Ljava/lang/Thread;
    invoke-direct {v9, v10}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v9}, Ljava/lang/Thread;->start()V

    :skip_cover_load

    # ── Info TextView (genre, rating, dlc) ───────────────────────────────────
    # Build info string with StringBuilder
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    # Genre
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->category:Ljava/lang/String;
    if-eqz v9, :info_no_genre
    const-string v10, "Genre: "
    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :info_no_genre

    # Rating (0-100 scale)
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->rating:Ljava/lang/String;
    if-eqz v9, :info_no_rating
    const-string v10, "\nRating: "
    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v10, "/100"
    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :info_no_rating

    # DLC count (skip if "0")
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->dlcCount:Ljava/lang/String;
    if-eqz v9, :info_no_dlc
    const-string v10, "0"
    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v10
    if-nez v10, :info_no_dlc
    const-string v10, "\nDLC Packs: "
    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :info_no_dlc

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v9  # v9 = info string

    new-instance v4, Landroid/widget/TextView;
    invoke-direct {v4, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v9, 0xFFCCCCCC
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41600000  # 14.0f
    invoke-virtual {v4, v9}, Landroid/widget/TextView;->setTextSize(F)V

    # Padding: 16dp H, 10dp V
    const/high16 v9, 0x41800000  # 16.0f
    mul-float v9, v8, v9
    float-to-int v9, v9  # v9 = 16dp px

    const/high16 v10, 0x41200000  # 10.0f
    mul-float v10, v8, v10
    float-to-int v10, v10  # v10 = 10dp px

    invoke-virtual {v4, v9, v10, v9, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Store URL TextView ────────────────────────────────────────────────────
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->storeUrl:Ljava/lang/String;
    if-eqz v9, :skip_store

    new-instance v5, Landroid/widget/TextView;
    invoke-direct {v5, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v9, 0xFF5B9BD5  # blue
    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41400000  # 12.0f
    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setTextSize(F)V

    const/high16 v9, 0x41800000  # 16dp
    mul-float v9, v8, v9
    float-to-int v9, v9
    const/high16 v10, 0x41000000  # 8dp
    mul-float v10, v8, v10
    float-to-int v10, v10

    invoke-virtual {v5, v9, v10, v9, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    invoke-virtual {v2, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    :skip_store

    # ── AlertDialog ───────────────────────────────────────────────────────────
    new-instance v6, Landroid/app/AlertDialog$Builder;
    invoke-direct {v6, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    # Set title to game title
    iget-object v9, v1, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;
    if-eqz v9, :no_dialog_title
    invoke-virtual {v6, v9}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;
    :no_dialog_title

    invoke-virtual {v6, v2}, Landroid/app/AlertDialog$Builder;->setView(Landroid/view/View;)Landroid/app/AlertDialog$Builder;

    const-string v9, "Close"
    const/4 v10, 0x0
    invoke-virtual {v6, v9, v10}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v6}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    :done
    return-void
.end method
