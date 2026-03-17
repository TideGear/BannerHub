.class public final Lcom/xj/winemu/settings/CpuMultiSelectHelper;
.super Ljava/lang/Object;

# BannerHub: multi-select CPU core dialog helper.
# Shows an AlertDialog.Builder.setMultiChoiceItems() dialog for picking any
# combination of cores 0-7. Each core maps to its sched_setaffinity bitmask bit.
# Called from SelectAndSingleInputDialog$Companion.d() when CONTENT_TYPE_CORE_LIMIT.

.method public static show(Landroid/content/Context;Ljava/lang/String;ILkotlin/jvm/functions/Function1;)V
    .locals 12

    # p0 = Context (anchor View's context)
    # p1 = String gameId
    # p2 = int contentType (CONTENT_TYPE_CORE_LIMIT)
    # p3 = Function1 UI refresh callback

    # --- Get helper singleton ---
    sget-object v0, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->a:Lcom/xj/winemu/settings/PcGameSettingDataHelper;

    # --- Get operations for this game ---
    invoke-virtual {v0, p1}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->v(Ljava/lang/String;)Lcom/xj/winemu/settings/PcGameSettingOperations;
    move-result-object v1

    # --- Get SPUtils (for saving) ---
    invoke-virtual {v1}, Lcom/xj/winemu/settings/PcGameSettingOperations;->c0()Lcom/blankj/utilcode/util/SPUtils;
    move-result-object v2

    # --- Get MMKV key via PcGameSettingDataHelper.A(helper, contentType, null, 2, null) ---
    const/4 v3, 0x2
    const/4 v4, 0x0
    invoke-static {v0, p2, v4, v3, v4}, Lcom/xj/winemu/settings/PcGameSettingDataHelper;->A(Lcom/xj/winemu/settings/PcGameSettingDataHelper;ILjava/lang/String;ILjava/lang/Object;)Ljava/lang/String;
    move-result-object v3

    # --- Get current mask via C(ops, 0, 1, null) ---
    const/4 v4, 0x0
    const/4 v5, 0x1
    invoke-static {v1, v4, v5, v4}, Lcom/xj/winemu/settings/PcGameSettingOperations;->C(Lcom/xj/winemu/settings/PcGameSettingOperations;IILjava/lang/Object;)I
    move-result v4

    # v0 = helper (free after this point)
    # v1 = ops    (free after this point)
    # v2 = SPUtils (kept)
    # v3 = key String (kept)
    # v4 = currentMask (int)

    # --- Build CharSequence[8] labels ---
    const/16 v5, 0x8
    new-array v5, v5, [Ljava/lang/CharSequence;
    const/4 v6, 0x0
    const-string v7, "Core 0 (Efficiency)"
    aput-object v7, v5, v6
    const/4 v6, 0x1
    const-string v7, "Core 1 (Efficiency)"
    aput-object v7, v5, v6
    const/4 v6, 0x2
    const-string v7, "Core 2 (Efficiency)"
    aput-object v7, v5, v6
    const/4 v6, 0x3
    const-string v7, "Core 3 (Efficiency)"
    aput-object v7, v5, v6
    const/4 v6, 0x4
    const-string v7, "Core 4 (Performance)"
    aput-object v7, v5, v6
    const/4 v6, 0x5
    const-string v7, "Core 5 (Performance)"
    aput-object v7, v5, v6
    const/4 v6, 0x6
    const-string v7, "Core 6 (Performance)"
    aput-object v7, v5, v6
    const/4 v6, 0x7
    const-string v7, "Core 7 (Prime)"
    aput-object v7, v5, v6

    # --- Build boolean[8] checked from currentMask ---
    const/16 v6, 0x8
    new-array v6, v6, [Z

    # Core 0 (bit mask = 1)
    const/4 v7, 0x0
    const/4 v8, 0x1
    and-int/2addr v8, v4
    if-eqz v8, :cond_c0f
    const/4 v8, 0x1
    goto :goto_c0
    :cond_c0f
    const/4 v8, 0x0
    :goto_c0
    aput-boolean v8, v6, v7

    # Core 1 (bit mask = 2)
    const/4 v7, 0x1
    const/4 v8, 0x2
    and-int/2addr v8, v4
    if-eqz v8, :cond_c1f
    const/4 v8, 0x1
    goto :goto_c1
    :cond_c1f
    const/4 v8, 0x0
    :goto_c1
    aput-boolean v8, v6, v7

    # Core 2 (bit mask = 4)
    const/4 v7, 0x2
    const/4 v8, 0x4
    and-int/2addr v8, v4
    if-eqz v8, :cond_c2f
    const/4 v8, 0x1
    goto :goto_c2
    :cond_c2f
    const/4 v8, 0x0
    :goto_c2
    aput-boolean v8, v6, v7

    # Core 3 (bit mask = 8)
    const/4 v7, 0x3
    const/16 v8, 0x8
    and-int/2addr v8, v4
    if-eqz v8, :cond_c3f
    const/4 v8, 0x1
    goto :goto_c3
    :cond_c3f
    const/4 v8, 0x0
    :goto_c3
    aput-boolean v8, v6, v7

    # Core 4 (bit mask = 16 = 0x10)
    const/4 v7, 0x4
    const/16 v8, 0x10
    and-int/2addr v8, v4
    if-eqz v8, :cond_c4f
    const/4 v8, 0x1
    goto :goto_c4
    :cond_c4f
    const/4 v8, 0x0
    :goto_c4
    aput-boolean v8, v6, v7

    # Core 5 (bit mask = 32 = 0x20)
    const/4 v7, 0x5
    const/16 v8, 0x20
    and-int/2addr v8, v4
    if-eqz v8, :cond_c5f
    const/4 v8, 0x1
    goto :goto_c5
    :cond_c5f
    const/4 v8, 0x0
    :goto_c5
    aput-boolean v8, v6, v7

    # Core 6 (bit mask = 64 = 0x40)
    const/4 v7, 0x6
    const/16 v8, 0x40
    and-int/2addr v8, v4
    if-eqz v8, :cond_c6f
    const/4 v8, 0x1
    goto :goto_c6
    :cond_c6f
    const/4 v8, 0x0
    :goto_c6
    aput-boolean v8, v6, v7

    # Core 7 (bit mask = 128 = 0x80)
    const/4 v7, 0x7
    const/16 v8, 0x80
    and-int/2addr v8, v4
    if-eqz v8, :cond_c7f
    const/4 v8, 0x1
    goto :goto_c7
    :cond_c7f
    const/4 v8, 0x0
    :goto_c7
    aput-boolean v8, v6, v7

    # --- Create listener instances ---
    # $1: OnMultiChoiceClickListener(boolean[] checked)
    new-instance v7, Lcom/xj/winemu/settings/CpuMultiSelectHelper$1;
    invoke-direct {v7, v6}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$1;-><init>([Z)V

    # $2: PositiveButton OnClickListener(boolean[], SPUtils, String, Function1)
    new-instance v8, Lcom/xj/winemu/settings/CpuMultiSelectHelper$2;
    invoke-direct {v8, v6, v2, v3, p3}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$2;-><init>([ZLcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;)V

    # $3: NegativeButton OnClickListener(SPUtils, String, Function1) — "No Limit"
    new-instance v9, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;
    invoke-direct {v9, v2, v3, p3}, Lcom/xj/winemu/settings/CpuMultiSelectHelper$3;-><init>(Lcom/blankj/utilcode/util/SPUtils;Ljava/lang/String;Lkotlin/jvm/functions/Function1;)V

    # --- Build AlertDialog ---
    new-instance v0, Landroid/app/AlertDialog$Builder;
    invoke-direct {v0, p0}, Landroid/app/AlertDialog$Builder;-><init>(Landroid/content/Context;)V

    const-string v1, "CPU Core Limit"
    invoke-virtual {v0, v1}, Landroid/app/AlertDialog$Builder;->setTitle(Ljava/lang/CharSequence;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v0, v5, v6, v7}, Landroid/app/AlertDialog$Builder;->setMultiChoiceItems([Ljava/lang/CharSequence;[ZLandroid/content/DialogInterface$OnMultiChoiceClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v1, "Apply"
    invoke-virtual {v0, v1, v8}, Landroid/app/AlertDialog$Builder;->setPositiveButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v1, "No Limit"
    invoke-virtual {v0, v1, v9}, Landroid/app/AlertDialog$Builder;->setNegativeButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    const-string v1, "Cancel"
    const/4 v2, 0x0
    invoke-virtual {v0, v1, v2}, Landroid/app/AlertDialog$Builder;->setNeutralButton(Ljava/lang/CharSequence;Landroid/content/DialogInterface$OnClickListener;)Landroid/app/AlertDialog$Builder;

    invoke-virtual {v0}, Landroid/app/AlertDialog$Builder;->show()Landroid/app/AlertDialog;

    return-void
.end method
