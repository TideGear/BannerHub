.class public final Lcom/xj/winemu/settings/CpuMultiSelectHelper;
.super Ljava/lang/Object;

# BannerHub: multi-select CPU core dialog helper.
# p0 = View (anchor — passed to callback as non-null; j3 expects android.view.View)
# p1 = String gameId
# p2 = int contentType (CONTENT_TYPE_CORE_LIMIT)
# p3 = Function1 UI refresh callback

.method public static show(Landroid/view/View;Ljava/lang/String;ILkotlin/jvm/functions/Function1;)V
    .locals 12

    # --- Get Context from anchor View ---
    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v0   # v0 = Context (temporary)

    # --- Get helper singleton ---
    sget-object v1, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->a:Lcom/xj/winemu/settings/PcGameSettingDataHelper;

    # --- Get operations for this game ---
    invoke-virtual {v1, p1}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;
    move-result-object v2   # v2 = ops

    # --- Get SPUtils (for saving) ---
    invoke-virtual {v2}, Lcom/xj/winemu/settings/PcGameSettingOperations;->c0()Lcom/blankj/utilcode/util/SPUtils;
    move-result-object v3   # v3 = sputils

    # --- Get MMKV key ---
    const/4 v4, 0x2
    const/4 v5, 0x0
    invoke-static {v1, p2, v5, v4, v5}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->A(Lcom/xj/winemu/settings/PcGameSettingDataHelper;ILjava/lang/String;ILjava/lang/Object;)Ljava/lang/String;
    move-result-object v4   # v4 = key

    # v1 (helper), v5 (zero) are free now

    # --- Get current mask via C(ops, 0, 1, null) ---
    const/4 v5, 0x0
    const/4 v1, 0x1
    invoke-static {v2, v5, v1, v5}, Lcom/xj/winemu/settings/PcGameSettingOperations;->C(Lcom/xj/winemu/settings/PcGameSettingOperations;IILjava/lang/Object;)I
    move-result v5   # v5 = currentMask

    # v1, v2 are free now

    # --- Build CharSequence[8] labels ---
    const/16 v1, 0x8
    new-array v1, v1, [Ljava/lang/CharSequence;
    const/4 v2, 0x0
    const-string v6, "Core 0 (Efficiency)"
    aput-object v6, v1, v2
    const/4 v2, 0x1
    const-string v6, "Core 1 (Efficiency)"
    aput-object v6, v1, v2
    const/4 v2, 0x2
    const-string v6, "Core 2 (Efficiency)"
    aput-object v6, v1, v2
    const/4 v2, 0x3
    const-string v6, "Core 3 (Efficiency)"
    aput-object v6, v1, v2
    const/4 v2, 0x4
    const-string v6, "Core 4 (Performance)"
    aput-object v6, v1, v2
    const/4 v2, 0x5
    const-string v6, "Core 5 (Performance)"
    aput-object v6, v1, v2
    const/4 v2, 0x6
    const-string v6, "Core 6 (Performance)"
    aput-object v6, v1, v2
    const/4 v2, 0x7
    const-string v6, "Core 7 (Prime)"
    aput-object v6, v1, v2
    # v1 = labels, v2/v6 free now

    # --- Build boolean[8] checked from currentMask ---
    const/16 v2, 0x8
    new-array v2, v2, [Z

    # Core 0 (bit mask = 1)
    const/4 v6, 0x0
    const/4 v7, 0x1
    and-int/2addr v7, v5
    if-eqz v7, :cond_c0f
    const/4 v7, 0x1
    goto :goto_c0
    :cond_c0f
    const/4 v7, 0x0
    :goto_c0
    aput-boolean v7, v2, v6

    # Core 1 (bit mask = 2)
    const/4 v6, 0x1
    const/4 v7, 0x2
    and-int/2addr v7, v5
    if-eqz v7, :cond_c1f
    const/4 v7, 0x1
    goto :goto_c1
    :cond_c1f
    const/4 v7, 0x0
    :goto_c1
    aput-boolean v7, v2, v6

    # Core 2 (bit mask = 4)
    const/4 v6, 0x2
    const/4 v7, 0x4
    and-int/2addr v7, v5
    if-eqz v7, :cond_c2f
    const/4 v7, 0x1
    goto :goto_c2
    :cond_c2f
    const/4 v7, 0x0
    :goto_c2
    aput-boolean v7, v2, v6

    # Core 3 (bit mask = 8)
    const/4 v6, 0x3
    const/16 v7, 0x8
    and-int/2addr v7, v5
    if-eqz v7, :cond_c3f
    const/4 v7, 0x1
    goto :goto_c3
    :cond_c3f
    const/4 v7, 0x0
    :goto_c3
    aput-boolean v7, v2, v6

    # Core 4 (bit mask = 16 = 0x10)
    const/4 v6, 0x4
    const/16 v7, 0x10
    and-int/2addr v7, v5
    if-eqz v7, :cond_c4f
    const/4 v7, 0x1
    goto :goto_c4
    :cond_c4f
    const/4 v7, 0x0
    :goto_c4
    aput-boolean v7, v2, v6

    # Core 5 (bit mask = 32 = 0x20)
    const/4 v6, 0x5
    const/16 v7, 0x20
    and-int/2addr v7, v5
    if-eqz v7, :cond_c5f
    const/4 v7, 0x1
    goto :goto_c5
    :cond_c5f
    const/4 v7, 0x0
    :goto_c5
    aput-boolean v7, v2, v6

    # Core 6 (bit mask = 64 = 0x40)
    const/4 v6, 0x6
    const/16 v7, 0x40
    and-int/2addr v7, v5
    if-eqz v7, :cond_c6f
    const/4 v7, 0x1
    goto :goto_c6
    :cond_c6f
    const/4 v7, 0x0
    :goto_c6
    aput-boolean v7, v2, v6

    # Core 7 (bit mask = 128 = 0x80)
    const/4 v6, 0x7
    const/16 v7, 0x80
    and-int/2addr v7, v5
    if-eqz v7, :cond_c7f
    const/4 v7, 0x1
    goto :goto_c7
    :cond_c7f
    const/4 v7, 0x0
    :goto_c7
    aput-boolean v7, v2, v6

    # v1 = labels  v2 = checked  v3 = sputils  v4 = key  p0 = View (anchor)
    # v5/v6/v7 free now

    # --- Create listener instances ---
    # $1: OnMultiChoiceClickListener(boolean[] checked)
    new-instance v5, Lcom/xj/winemu/settings/CpuMultiSelectHelper$1;
    invoke-direct {v5, v2}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$1;-><init>([Z)V

    # $2: PositiveButton(boolean[], SPUtils, String, Function1, View)
    new-instance v6, Lcom/xj/winemu/settings/CpuMultiSelectHelper$2;
    invoke-direct {v6, v2, v3, v4, p3, p0}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$2;-><init>([ZLcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;Landroid/view/View;)V

    # $3: NegativeButton(SPUtils, String, Function1, View)
    new-instance v7, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;
    invoke-direct {v7, v3, v4, p3, p0}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;-><init>(Lcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;Landroid/view/View;)V

    # --- Build AlertDialog (reuse v0 = Context from earlier) ---
    new-instance v8, Landroid/app/AlertDialog$Builder;
    invoke-direct {v8, v0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v9, "CPU Core Limit"
    invoke-virtual {v8, v9}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v8, v1, v2, v5}, Landroid/app/AlertDialog$Builder;->setMultiChoiceItems([Ljava/lang/CharSequence;[ZLandroid/content/DialogInterface$OnMultiChoiceClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v9, "Apply"
    invoke-virtual {v8, v9, v6}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v9, "No Limit"
    invoke-virtual {v8, v9, v7}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v9, "Cancel"
    const/4 v10, 0x0
    invoke-virtual {v8, v9, v10}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v8}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;
    move-result-object v8   # v8 = AlertDialog

    # --- Limit dialog height to 70% of screen height ---
    invoke-virtual {v8}, Landroid/app/AlertDialog;->getWindow()Landroid/view/Window;
    move-result-object v8   # v8 = Window (reuse)
    if-eqz v8, :cond_bh_nosize

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
    move-result-object v9
    invoke-virtual {v9}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
    move-result-object v9
    invoke-virtual {v9}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;
    move-result-object v9
    iget v9, v9, Landroid/util/DisplayMetrics;->heightPixels:I

    # height = heightPixels * 7 / 10  (70%)
    mul-int/lit16 v9, v9, 0x7
    div-int/lit16 v9, v9, 0xa

    # WRAP_CONTENT = -2
    const/16 v10, -0x2
    invoke-virtual {v8, v10, v9}, Landroid/view/Window;->setLayout(II)V

    :cond_bh_nosize
    return-void
.end method
