.class public Lcom/xj/winemu/sidebar/BhTaskManagerFragment;
.super Landroidx/fragment/app/Fragment;
.source "SourceFile"

# Wine Task Manager sidebar tab.
# Shows: CPU cores, RAM (used/total), VRAM (KGSL), running Wine processes
# with per-process Kill buttons and a Refresh button.

.field public processListLayout:Landroid/widget/LinearLayout;
.field public bhContext:Landroid/content/Context;

# ── Text constants ──────────────────────────────────────────────
# Colors (0xAARRGGBB signed ints):
#   white    = -1          (0xFFFFFFFF)
#   yellow   = -13312      (0xFFFFCC00)  section headers
#   lt-gray  = -5592406    (0xFFAAAAAA)  placeholder text
#   dk-gray  = -13421773   (0xFF333333)  divider
#   red-kill = -7864321    (0xFF870F0F)  Kill button bg
#   green    = -12245088   (0xFF4CAF50)  value text (info rows)
# ────────────────────────────────────────────────────────────────

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroidx/fragment/app/Fragment;-><init>()V
    return-void
.end method

# ── Read first line of a file; returns null on error ─────────────
.method private static readFileLine(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    :try_start_0
    new-instance v0, Ljava/io/RandomAccessFile;
    const-string v1, "r"
    invoke-direct {v0, p0, v1}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v0}, Ljava/io/RandomAccessFile;->close()V
    return-object v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :err
    :err
    const/4 v0, 0x0
    return-object v0
.end method

# ── Parse kB value from a /proc/meminfo line ─────────────────────
# e.g. "MemTotal:       7861248 kB" -> 7861248
.method private static parseMemKb(Ljava/lang/String;)J
    .locals 4
    :try_start_0
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    # split on whitespace
    const-string v1, "\\s+"
    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;
    move-result-object v0
    # index 1 is the number
    const/4 v1, 0x1
    aget-object v0, v0, v1
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v2
    return-wide v2
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :err
    :err
    const-wide/16 v0, 0x0
    return-wide v0
.end method

# ── Build the RAM info string ────────────────────────────────────
# Returns e.g. "4096 MB used / 7629 MB total"
.method private static getRamInfo()Ljava/lang/String;
    .locals 10
    const-wide/16 v0, 0x0   # totalKb
    const-wide/16 v2, 0x0   # availKb

    :try_start_0
    new-instance v4, Ljava/io/RandomAccessFile;
    const-string v5, "/proc/meminfo"
    const-string v6, "r"
    invoke-direct {v4, v5, v6}, Ljava/io/RandomAccessFile;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    :read_loop
    invoke-virtual {v4}, Ljava/io/RandomAccessFile;->readLine()Ljava/lang/String;
    move-result-object v5
    if-eqz v5, :read_done

    const-string v6, "MemTotal:"
    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v6
    if-eqz v6, :check_avail
    invoke-static {v5}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->parseMemKb(Ljava/lang/String;)J
    move-result-wide v0
    goto :read_loop

    :check_avail
    const-string v6, "MemAvailable:"
    invoke-virtual {v5, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v6
    if-eqz v6, :read_loop
    invoke-static {v5}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->parseMemKb(Ljava/lang/String;)J
    move-result-wide v2
    goto :read_done

    :read_done
    invoke-virtual {v4}, Ljava/io/RandomAccessFile;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :ram_err

    # usedKb = totalKb - availKb
    sub-long v4, v0, v2
    # convert to MB: / 1024
    const-wide/16 v6, 0x400
    div-long/2addr v4, v6
    div-long/2addr v0, v6

    new-instance v6, Ljava/lang/StringBuilder;
    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v7, " MB used / "
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6, v0}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v7, " MB total"
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0

    :ram_err
    const-string v0, "N/A"
    return-object v0
.end method

# ── Build the VRAM info string ────────────────────────────────────
# Reads from Qualcomm KGSL sysfs; falls back to "N/A"
.method private static getVramInfo()Ljava/lang/String;
    .locals 4
    const-string v0, "/sys/class/kgsl/kgsl-3d0/gpumem_mapped"
    invoke-static {v0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readFileLine(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :try_gpu_total

    :try_start_0
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    const-wide/16 v2, 0x100000  # 1 MB = 1048576
    div-long/2addr v0, v2
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v3, " MB (mapped)"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :try_gpu_total

    :try_gpu_total
    const-string v0, "/sys/class/kgsl/kgsl-3d0/gpumem_alloc"
    invoke-static {v0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readFileLine(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v0
    if-eqz v0, :vram_na
    :try_start_1
    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v0
    invoke-static {v0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J
    move-result-wide v0
    const-wide/16 v2, 0x100000
    div-long/2addr v0, v2
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;
    const-string v3, " MB (alloc)"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v0
    return-object v0
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :vram_na

    :vram_na
    const-string v0, "N/A"
    return-object v0
.end method

# ── Count online CPU cores ────────────────────────────────────────
.method private static getActiveCores()I
    .locals 5
    const/4 v0, 0x0  # active count
    const/4 v1, 0x0  # core index

    :core_loop
    # Build path: /sys/devices/system/cpu/cpu{i}/online
    new-instance v2, Ljava/lang/StringBuilder;
    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
    const-string v3, "/sys/devices/system/cpu/cpu"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v3, "/online"
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v2

    invoke-static {v2}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->readFileLine(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    if-eqz v2, :cores_done  # no more cpuN dirs

    :try_start_0
    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;
    move-result-object v2
    const-string v3, "1"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v3
    if-eqz v3, :next_core
    add-int/lit8 v0, v0, 0x1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :next_core

    :next_core
    add-int/lit8 v1, v1, 0x1
    # Safety: max 32 cores
    const/16 v3, 0x20
    if-lt v1, v3, :core_loop

    :cores_done
    # cpu0 is always online (no "online" file for it) — add 1 for cpu0
    add-int/lit8 v0, v0, 0x1
    return v0
.end method

# ── Helper: make a simple info-row TextView ───────────────────────
.method private static makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v1, -0x1       # white = 0xFFFFFFFF
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v1, 0x4150   # 13.0f sp
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v1, 0x6
    invoke-virtual {v0, v1, v1, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V
    return-object v0
.end method

# ── Helper: make a section header TextView ────────────────────────
.method private static makeHeaderText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    .locals 3
    new-instance v0, Landroid/widget/TextView;
    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v1, -0x3400    # yellow = 0xFFFFCC00
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v1, 0x4160   # 14.0f sp
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextSize(F)V
    const/16 v1, 0x4
    const/16 v2, 0xC
    invoke-virtual {v0, v1, v2, v1, v1}, Landroid/widget/TextView;->setPadding(IIII)V
    return-object v0
.end method

# ── onCreateView ────────────────────────────────────────────────────
.method public onCreateView(Landroid/view/LayoutInflater;Landroid/view/ViewGroup;Landroid/os/Bundle;)Landroid/view/View;
    .locals 8
    # v0 = Context
    # v1 = root ScrollView
    # v2 = content LinearLayout (vertical)
    # v3 = temp View/LP/StringBuilder
    # v4 = temp
    # v5 = temp int/float
    # v6 = temp
    # v7 = processListLayout

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getActivity()Landroidx/fragment/app/FragmentActivity;
    move-result-object v0
    if-eqz v0, :return_null

    iput-object v0, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->bhContext:Landroid/content/Context;

    # Root: ScrollView
    new-instance v1, Landroid/widget/ScrollView;
    invoke-direct {v1, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    # Content: vertical LinearLayout
    new-instance v2, Landroid/widget/LinearLayout;
    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1  # VERTICAL
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v3, 0x18  # 24px padding
    invoke-virtual {v2, v3, v3, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Add content to ScrollView (MATCH_PARENT x WRAP_CONTENT)
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;
    const/4 v4, -0x1   # MATCH_PARENT
    const/4 v5, -0x2   # WRAP_CONTENT
    invoke-direct {v3, v4, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V
    invoke-virtual {v1, v2, v3}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── TITLE ────────────────────────────────────────────────────────
    const-string v3, "Wine Task Manager"
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeHeaderText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    const/high16 v4, 0x4180   # 16.0f sp (larger for title)
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextSize(F)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── CONTAINER INFO HEADER ─────────────────────────────────────────
    const-string v3, "Container Info"
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeHeaderText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # CPU — total cores (availableProcessors)
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;
    move-result-object v3
    invoke-virtual {v3}, Ljava/lang/Runtime;->availableProcessors()I
    move-result v3  # total cores

    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getActiveCores()I
    move-result v4  # active cores

    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "CPU Cores:  "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v6, " active / "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v6, " total"
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # RAM info
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getRamInfo()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "RAM:         "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # VRAM info
    invoke-static {}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->getVramInfo()Ljava/lang/String;
    move-result-object v3
    new-instance v4, Ljava/lang/StringBuilder;
    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V
    const-string v5, "VRAM:        "
    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v3
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── THIN DIVIDER ─────────────────────────────────────────────────
    new-instance v3, Landroid/view/View;
    invoke-direct {v3, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V
    const v4, -0xcccccd    # 0xFF333333 dark divider
    invoke-virtual {v3, v4}, Landroid/view/View;->setBackgroundColor(I)V
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v5, -0x1   # MATCH_PARENT
    const/4 v6, 0x2    # 2px height
    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/16 v5, 0x10
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I
    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I
    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # ── WINE PROCESSES HEADER + REFRESH BUTTON ────────────────────────
    const-string v3, "Wine Processes"
    invoke-static {v0, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeHeaderText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # Refresh button
    new-instance v3, Landroid/widget/Button;
    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v4, "Refresh"
    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    new-instance v4, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$RefreshListener;
    invoke-direct {v4, p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$RefreshListener;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    # ── PROCESS LIST container ─────────────────────────────────────────
    new-instance v7, Landroid/widget/LinearLayout;
    invoke-direct {v7, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v3, 0x1  # VERTICAL
    invoke-virtual {v7, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V
    invoke-virtual {v2, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    iput-object v7, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->processListLayout:Landroid/widget/LinearLayout;

    # Kick off initial scan
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->startScan()V

    return-object v1

    :return_null
    const/4 v0, 0x0
    return-object v0
.end method

# ── startScan ───────────────────────────────────────────────────────
.method public startScan()V
    .locals 2
    new-instance v0, Ljava/lang/Thread;
    new-instance v1, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$ScanRunnable;
    invoke-direct {v1, p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$ScanRunnable;-><init>(Lcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V
    return-void
.end method

# ── onScanComplete — called on main thread ───────────────────────────
# p1 = ArrayList<String> names, p2 = ArrayList<Integer> pids
.method public onScanComplete(Ljava/util/ArrayList;Ljava/util/ArrayList;)V
    .locals 12
    # v0  = processListLayout
    # v1  = context
    # v2  = list size
    # v3  = loop index
    # v4  = current name String
    # v5  = current pid int
    # v6  = row LinearLayout
    # v7  = process name TextView
    # v8  = StringBuilder
    # v9  = temp string
    # v10 = Kill Button
    # v11 = KillListener / LP

    iget-object v0, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->processListLayout:Landroid/widget/LinearLayout;
    if-eqz v0, :done

    iget-object v1, p0, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->bhContext:Landroid/content/Context;
    if-eqz v1, :done

    invoke-virtual {v0}, Landroid/widget/LinearLayout;->removeAllViews()V

    invoke-virtual {p1}, Ljava/util/ArrayList;->size()I
    move-result v2
    if-nez v2, :has_procs

    # No wine processes found
    const-string v3, "No Wine processes detected"
    invoke-static {v1, v3}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment;->makeInfoText(Landroid/content/Context;Ljava/lang/String;)Landroid/widget/TextView;
    move-result-object v3
    const v4, -0x555556    # 0xFFAAAAAA gray
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V
    invoke-virtual {v0, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    goto :done

    :has_procs
    const/4 v3, 0x0  # loop index

    :proc_loop
    if-ge v3, v2, :done

    invoke-virtual {p1, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v4
    check-cast v4, Ljava/lang/String;

    invoke-virtual {p2, v3}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;
    move-result-object v5
    check-cast v5, Ljava/lang/Integer;
    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I
    move-result v5

    # Row: horizontal LinearLayout, center_vertical gravity
    new-instance v6, Landroid/widget/LinearLayout;
    invoke-direct {v6, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V
    const/4 v7, 0x0  # HORIZONTAL
    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->setOrientation(I)V
    const/16 v7, 0x10  # CENTER_VERTICAL
    invoke-virtual {v6, v7}, Landroid/widget/LinearLayout;->setGravity(I)V
    const/4 v7, 0x4  # 4px padding
    invoke-virtual {v6, v7, v7, v7, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    # Process name TextView (weight=1 to fill space)
    new-instance v7, Landroid/widget/TextView;
    invoke-direct {v7, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
    # Build "name  (PID xxx)"
    new-instance v8, Ljava/lang/StringBuilder;
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V
    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    const-string v9, "  (PID "
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;
    const-string v9, ")"
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v8
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    const v8, -0x1     # white
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setTextColor(I)V
    const/high16 v8, 0x4140   # 12.0f sp (compact for process list)
    invoke-virtual {v7, v8}, Landroid/widget/TextView;->setTextSize(F)V
    # LP: width=0, height=WRAP_CONTENT, weight=1
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;
    const/4 v9, 0x0
    const/4 v9, -0x2   # can't reuse same register for two values...
    # Use direct const for each param
    const/4 v9, 0x0       # width = 0 (for weight-based expansion)
    const/4 v11, -0x2     # height = WRAP_CONTENT
    invoke-direct {v8, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V
    const/high16 v9, 0x3f800000  # 1.0f weight
    iput v9, v8, Landroid/widget/LinearLayout$LayoutParams;->weight:F
    invoke-virtual {v6, v7, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # Kill Button
    new-instance v10, Landroid/widget/Button;
    invoke-direct {v10, v1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V
    const-string v8, "Kill"
    invoke-virtual {v10, v8}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V
    const v8, -0x1    # white text
    invoke-virtual {v10, v8}, Landroid/widget/Button;->setTextColor(I)V
    const/high16 v8, 0x4140   # 12.0f sp
    invoke-virtual {v10, v8}, Landroid/widget/Button;->setTextSize(F)V
    new-instance v11, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$KillListener;
    invoke-direct {v11, v5, p0}, Lcom/xj/winemu/sidebar/BhTaskManagerFragment$KillListener;-><init>(ILcom/xj/winemu/sidebar/BhTaskManagerFragment;)V
    invoke-virtual {v10, v11}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    invoke-virtual {v6, v10}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    invoke-virtual {v0, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v3, v3, 0x1
    goto :proc_loop

    :done
    return-void
.end method
