.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;
.super Ljava/lang/Object;

# BannerHub: UI-thread Runnable for GogGamesFragment.
# Receives ArrayList<GogGame> from $1 and builds a card list:
#   Each card = horizontal LinearLayout (dark rounded bg)
#     Left: ImageView 60dp×60dp (thumbnail, loaded async by $4)
#     Right: vertical LinearLayout
#       - Title TextView (white, 15sp, bold)
#       - Meta TextView (grey, 13sp): "Category · rating% · DLC: N"
#   Tap on card opens GogGamesFragment$3 detail dialog.
# Null list = session expired. Empty list = no games.

.implements Ljava/lang/Runnable;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Ljava/util/ArrayList;  # ArrayList<GogGame>


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/util/ArrayList;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->b:Ljava/util/ArrayList;

    return-void
.end method


.method public run()V
    .locals 16

    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;->b:Ljava/util/ArrayList;

    # Null = session expired (token cleared by $1 after non-200 response)
    if-eqz v1, :session_expired

    # Empty = no games in library
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v2
    if-nez v2, :has_games

    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->statusView:Landroid/widget/TextView;
    if-eqz v3, :done
    const-string v4, "No GOG games found"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v4, 0x0  # VISIBLE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    goto :done

    :session_expired
    iget-object v3, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->statusView:Landroid/widget/TextView;
    if-eqz v3, :done
    const-string v4, "Session expired - sign in again via the GOG side menu"
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const/4 v4, 0x0  # VISIBLE
    invoke-virtual {v3, v4}, Landroid/view/View;->setVisibility(I)V
    goto :done

    :has_games

    # Get context
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v3
    if-eqz v3, :done

    # Get gameListLayout, clear existing children
    iget-object v4, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->gameListLayout:Landroid/widget/LinearLayout;
    if-eqz v4, :done
    invoke-virtual {v4}, Landroid/widget/LinearLayout;->removeAllViews()V

    # v2 = display density float (stored for dp→px throughout loop)
    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v2
    invoke-virtual {v2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v2
    iget v2, v2, Landroid/util/DisplayMetrics;->density:F

    # Loop: v5 = i
    const/4 v5, 0x0

    :loop_start
    invoke-virtual {v1}, Ljava/util/ArrayList;->size()I
    move-result v14
    if-ge v5, v14, :loop_done

    # v6 = GogGame
    invoke-virtual {v1, v5}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v6
    check-cast v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;

    # ── Card root: horizontal LinearLayout ───────────────────────────────────
    new-instance v7, Landroid/widget/LinearLayout;
    invoke-direct {v7, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v14, 0x0  # HORIZONTAL
    invoke-virtual {v7, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Rounded dark background via GradientDrawable
    new-instance v12, Landroid/graphics/GradientDrawable;
    invoke-direct {v12}, Landroid/graphics/GradientDrawable;-><init>()V
    const v14, 0xFF1A1A1A
    invoke-virtual {v12, v14}, Landroid/graphics/GradientDrawable;->setColor(I)V
    # corner radius = 10dp (float, not converted to int)
    const/high16 v14, 0x41200000  # 10.0f
    mul-float v14, v2, v14
    invoke-virtual {v12, v14}, Landroid/graphics/GradientDrawable;->setCornerRadius(F)V
    invoke-virtual {v7, v12}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    # Card padding: 12dp all sides
    const/high16 v14, 0x41400000  # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    invoke-virtual {v7, v14, v14, v14, v14}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Make card clickable (required for onClick ripple)
    const/4 v14, 0x1
    invoke-virtual {v7, v14}, Landroid/view/View;->setClickable(Z)V

    # ── Thumbnail ImageView (60dp × 60dp) ────────────────────────────────────
    new-instance v8, Landroid/widget/ImageView;
    invoke-direct {v8, v3}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    const v14, 0xFF262626  # placeholder dark grey
    invoke-virtual {v8, v14}, Landroid/view/View;->setBackgroundColor(I)V

    sget-object v14, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;
    invoke-virtual {v8, v14}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    # Fixed LP: 60dp × 60dp
    const/high16 v14, 0x42700000  # 60.0f
    mul-float v14, v2, v14
    float-to-int v14, v14

    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    invoke-direct {v13, v14, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v7, v8, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Launch $4 thumbnail loader
    iget-object v15, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->imageUrl:Ljava/lang/String;
    if-eqz v15, :skip_thumb

    new-instance v12, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;
    invoke-direct {v12, v15, v8}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$4;-><init>(Ljava/lang/String;Landroid/widget/ImageView;)V
    new-instance v15, Ljava/lang/Thread;
    invoke-direct {v15, v12}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v15}, Ljava/lang/Thread;->start()V

    :skip_thumb

    # ── Right info LinearLayout (vertical) ───────────────────────────────────
    new-instance v9, Landroid/widget/LinearLayout;
    invoke-direct {v9, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v14, 0x1  # VERTICAL
    invoke-virtual {v9, v14}, Landroid/widget/LinearLayout;->setOrientation(I)V

    # Left padding = 12dp (gap between image and text)
    const/high16 v14, 0x41400000  # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14
    const/4 v15, 0x0
    invoke-virtual {v9, v14, v15, v15, v15}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Vertically centre the text block within the card
    const/16 v14, 0x10  # Gravity.CENTER_VERTICAL
    invoke-virtual {v9, v14}, Landroid/widget/LinearLayout;->setGravity(I)V

    # ── Title TextView ────────────────────────────────────────────────────────
    new-instance v10, Landroid/widget/TextView;
    invoke-direct {v10, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iget-object v15, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;
    if-eqz v15, :no_title
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :no_title

    const v15, 0xFFF0F0F0
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v15, 0x41700000  # 15.0f
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setTextSize(F)V

    sget-object v15, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;
    invoke-virtual {v10, v15}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v9, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Meta string: "Category · rating% · DLC: N" ───────────────────────────
    new-instance v12, Ljava/lang/StringBuilder;
    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v14, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->category:Ljava/lang/String;
    if-eqz v14, :meta_no_cat
    invoke-virtual {v12, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :meta_no_cat

    iget-object v14, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->rating:Ljava/lang/String;
    if-eqz v14, :meta_no_rating
    const-string v15, " · "
    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v12, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v15, "%"
    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :meta_no_rating

    iget-object v14, v6, Lcom/xj/landscape/launcher/ui/menu/GogGame;->dlcCount:Ljava/lang/String;
    if-eqz v14, :meta_no_dlc
    const-string v15, "0"
    invoke-virtual {v14, v15}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v15
    if-nez v15, :meta_no_dlc
    const-string v15, " · DLC: "
    invoke-virtual {v12, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v12, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    :meta_no_dlc

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v14  # v14 = meta string

    # ── Meta TextView ─────────────────────────────────────────────────────────
    new-instance v11, Landroid/widget/TextView;
    invoke-direct {v11, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v15, 0xFF888888
    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v15, 0x41500000  # 13.0f
    invoke-virtual {v11, v15}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v9, v11}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── Add right layout to card with weight=1 ────────────────────────────────
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v14, 0x0    # width = 0 (weight-driven)
    const/4 v15, -0x1   # height = MATCH_PARENT
    const/high16 v12, 0x3f800000  # weight = 1.0f
    invoke-direct {v13, v14, v15, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V
    invoke-virtual {v7, v9, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── Click listener: $3 takes GogGame, opens detail dialog ────────────────
    new-instance v12, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;
    invoke-direct {v12, v0, v6}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$3;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Lcom/xj/landscape/launcher/ui/menu/GogGame;)V
    invoke-virtual {v7, v12}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    # ── Outer LP: MATCH_PARENT × WRAP_CONTENT + margins 12/6dp ──────────────
    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v14, -0x1   # MATCH_PARENT
    const/4 v15, -0x2   # WRAP_CONTENT
    invoke-direct {v13, v14, v15}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    # margins: left=12dp, top=6dp, right=12dp, bottom=6dp
    const/high16 v14, 0x41400000  # 12.0f
    mul-float v14, v2, v14
    float-to-int v14, v14  # v14 = 12dp px

    const/high16 v15, 0x40C00000  # 6.0f
    mul-float v15, v2, v15
    float-to-int v15, v15  # v15 = 6dp px

    invoke-virtual {v13, v14, v15, v14, v15}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v4, v7, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    add-int/lit8 v5, v5, 0x1
    goto :loop_start

    :loop_done

    # Hide statusView, show scrollView
    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->statusView:Landroid/widget/TextView;
    if-eqz v5, :show_scroll
    const/16 v6, 0x8  # GONE
    invoke-virtual {v5, v6}, Landroid/view/View;->setVisibility(I)V

    :show_scroll
    iget-object v5, v0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;->scrollView:Landroid/widget/ScrollView;
    if-eqz v5, :done
    const/4 v6, 0x0  # VISIBLE
    invoke-virtual {v5, v6}, Landroid/view/View;->setVisibility(I)V

    :done
    return-void
.end method
