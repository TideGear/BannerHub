.class public final Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;
.super Lcom/xj/common/view/focus/focus/app/FocusableFragment;
.source "r8-map-id-712846b76e3224c0169ce621759774aea144e14d75c3fb3c733f7f2b03c1bb19"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$Companion;,
        Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;
    }
.end annotation

.annotation system Ldalvik/annotation/Signature;
    value = {
        "Lcom/xj/common/view/focus/focus/app/FocusableFragment<",
        "Lcom/xj/base/base/viewmodel/BaseViewModel;",
        "Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;",
        ">;"
    }
.end annotation

.annotation runtime Lkotlin/Metadata;
.end annotation

.annotation build Lkotlin/jvm/internal/SourceDebugExtension;
.end annotation


# static fields
.field public static final D:Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$Companion;


# instance fields
.field public final A:Lcom/tencent/mmkv/MMKV;

.field public B:Lcom/xj/winemu/api/bean/WineActivityData;

.field public C:Z

.field public o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

.field public p:Z

.field public q:Z

.field public r:Z

.field public s:Z

.field public t:Z

.field public u:Z

.field public v:Z

.field public w:Z

.field public x:Ljava/lang/String;

.field public y:Z

.field public z:Lcom/xj/winemu/utils/WineInGameSettings;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 1
    .line 2
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$Companion;

    .line 3
    const/4 v1, 0x0

    .line 4
    .line 5
    .line 6
    invoke-direct {v0, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$Companion;-><init>(Lkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 7
    .line 8
    sput-object v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->D:Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$Companion;

    .line 9
    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-direct {p0}, Lcom/xj/common/view/focus/focus/app/FocusableFragment;-><init>()V

    .line 4
    .line 5
    sget-object v0, Lcom/xj/winemu/sidebar/PcEmuGameLocalConfigHelper;->a:Lcom/xj/winemu/sidebar/PcEmuGameLocalConfigHelper;

    .line 6
    .line 7
    .line 8
    invoke-virtual {v0}, Lcom/xj/winemu/sidebar/PcEmuGameLocalConfigHelper;->a()Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 9
    move-result-object v0

    .line 10
    .line 11
    iput-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 12
    .line 13
    .line 14
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 15
    move-result-object v0

    .line 16
    .line 17
    .line 18
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->b()Z

    .line 19
    move-result v0

    .line 20
    .line 21
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->p:Z

    .line 22
    .line 23
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 24
    .line 25
    .line 26
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 27
    move-result-object v0

    .line 28
    .line 29
    .line 30
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->e()Z

    .line 31
    move-result v0

    .line 32
    .line 33
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->q:Z

    .line 34
    .line 35
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 36
    .line 37
    .line 38
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 39
    move-result-object v0

    .line 40
    .line 41
    .line 42
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->c()Z

    .line 43
    move-result v0

    .line 44
    .line 45
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->r:Z

    .line 46
    .line 47
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 48
    .line 49
    .line 50
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 51
    move-result-object v0

    .line 52
    .line 53
    .line 54
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->d()Z

    .line 55
    move-result v0

    .line 56
    .line 57
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->s:Z

    .line 58
    .line 59
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 60
    .line 61
    .line 62
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 63
    move-result-object v0

    .line 64
    .line 65
    .line 66
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->f()Z

    .line 67
    move-result v0

    .line 68
    .line 69
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->t:Z

    .line 70
    .line 71
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 72
    .line 73
    .line 74
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 75
    move-result-object v0

    .line 76
    .line 77
    .line 78
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->h()Z

    .line 79
    move-result v0

    .line 80
    .line 81
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->u:Z

    .line 82
    .line 83
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 84
    .line 85
    .line 86
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 87
    move-result-object v0

    .line 88
    .line 89
    .line 90
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->g()Z

    .line 91
    move-result v0

    .line 92
    .line 93
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->v:Z

    .line 94
    .line 95
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 96
    .line 97
    .line 98
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 99
    move-result-object v0

    .line 100
    .line 101
    .line 102
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->a()Z

    .line 103
    move-result v0

    .line 104
    .line 105
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->w:Z

    .line 106
    .line 107
    const-string v0, "WineFile"

    .line 108
    const/4 v1, 0x2

    .line 109
    .line 110
    .line 111
    invoke-static {v0, v1}, Lcom/tencent/mmkv/MMKV;->F(Ljava/lang/String;I)Lcom/tencent/mmkv/MMKV;

    .line 112
    move-result-object v0

    .line 113
    .line 114
    const-string v1, "mmkvWithID(...)"

    .line 115
    .line 116
    .line 117
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 118
    .line 119
    iput-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->A:Lcom/tencent/mmkv/MMKV;

    .line 120
    return-void
.end method

.method public static synthetic A0(Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->l1(Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static final A1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;ILcom/xj/winemu/bean/CollapseItemMenu;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    const-string v0, "item"

    .line 3
    .line 4
    .line 5
    invoke-static {p3, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    iget-object p3, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 8
    .line 9
    const-string v0, "wineInGameSettings"

    .line 10
    const/4 v1, 0x0

    .line 11
    .line 12
    if-nez p3, :cond_0

    .line 13
    .line 14
    .line 15
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 16
    move-object p3, v1

    .line 17
    .line 18
    .line 19
    :cond_0
    invoke-interface {p1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    .line 20
    move-result-object p2

    .line 21
    .line 22
    check-cast p2, Lcom/xj/winemu/bean/NativeRenderingMode;

    .line 23
    .line 24
    .line 25
    invoke-virtual {p3, p2}, Lcom/xj/winemu/utils/WineInGameSettings;->y(Lcom/xj/winemu/bean/NativeRenderingMode;)V

    .line 26
    .line 27
    new-instance p2, Lcom/xj/winemu/UpdateNativeRenderingMode;

    .line 28
    .line 29
    iget-object p3, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 30
    .line 31
    if-nez p3, :cond_1

    .line 32
    .line 33
    .line 34
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 35
    move-object p3, v1

    .line 36
    .line 37
    .line 38
    :cond_1
    invoke-virtual {p3}, Lcom/xj/winemu/utils/WineInGameSettings;->j()Lcom/xj/winemu/bean/NativeRenderingMode;

    .line 39
    move-result-object p3

    .line 40
    .line 41
    .line 42
    invoke-direct {p2, p3}, Lcom/xj/winemu/UpdateNativeRenderingMode;-><init>(Lcom/xj/winemu/bean/NativeRenderingMode;)V

    .line 43
    const/4 p3, 0x2

    .line 44
    .line 45
    .line 46
    invoke-static {p2, v1, p3, v1}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 47
    .line 48
    .line 49
    invoke-virtual {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->w1(Ljava/util/List;)V

    .line 50
    .line 51
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 52
    return-object p0
.end method

.method public static synthetic C0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusableView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->n1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusableView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static final C1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;ILcom/xj/winemu/bean/CollapseItemMenu;)Lkotlin/Unit;
    .locals 2

    .line 1
    .line 2
    const-string v0, "item"

    .line 3
    .line 4
    .line 5
    invoke-static {p3, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    iget-object p3, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 8
    const/4 v0, 0x0

    .line 9
    .line 10
    if-nez p3, :cond_0

    .line 11
    .line 12
    const-string p3, "wineInGameSettings"

    .line 13
    .line 14
    .line 15
    invoke-static {p3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 16
    move-object p3, v0

    .line 17
    .line 18
    .line 19
    :cond_0
    invoke-interface {p1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    .line 20
    move-result-object v1

    .line 21
    .line 22
    check-cast v1, Lcom/xj/winemu/bean/RedMagicPerformanceMode;

    .line 23
    .line 24
    .line 25
    invoke-virtual {p3, v1}, Lcom/xj/winemu/utils/WineInGameSettings;->z(Lcom/xj/winemu/bean/RedMagicPerformanceMode;)V

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x1(Ljava/util/List;)V

    .line 29
    .line 30
    new-instance p0, Lcom/xj/winemu/ChangeRedMagicPerformanceMode;

    .line 31
    .line 32
    .line 33
    invoke-interface {p1, p2}, Ljava/util/List;->get(I)Ljava/lang/Object;

    .line 34
    move-result-object p1

    .line 35
    .line 36
    check-cast p1, Lcom/xj/winemu/bean/RedMagicPerformanceMode;

    .line 37
    .line 38
    .line 39
    invoke-direct {p0, p1}, Lcom/xj/winemu/ChangeRedMagicPerformanceMode;-><init>(Lcom/xj/winemu/bean/RedMagicPerformanceMode;)V

    .line 40
    const/4 p1, 0x2

    .line 41
    .line 42
    .line 43
    invoke-static {p0, v0, p1, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 44
    .line 45
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 46
    return-object p0
.end method

.method public static synthetic D0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusEvent;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic E0(IZ)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->a1(IZ)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic F0(Landroid/view/View;Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->t1(Landroid/view/View;Z)V

    .line 4
    return-void
.end method

.method public static synthetic G0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->f1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic H0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;IZ)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->m1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;IZ)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic I0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;ILcom/xj/winemu/bean/CollapseItemMenu;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;ILcom/xj/winemu/bean/CollapseItemMenu;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic J0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->u1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusEvent;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic K0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->s1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic L0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->v1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;)V

    .line 4
    return-void
.end method

.method public static synthetic M0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->e1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic N0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;Lcom/drake/brv/BindingAdapter;Landroidx/recyclerview/widget/RecyclerView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->h1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;Lcom/drake/brv/BindingAdapter;Landroidx/recyclerview/widget/RecyclerView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic O0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->b1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic P0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->d1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic Q0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;Lcom/drake/brv/BindingAdapter$BindingViewHolder;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->i1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;Lcom/drake/brv/BindingAdapter$BindingViewHolder;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic R0(IZ)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->c1(IZ)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic S0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->p1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;Landroid/view/MotionEvent;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic T0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->g1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic U0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lkotlin/jvm/functions/Function1;Landroid/view/View;)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3, p4}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->k1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lkotlin/jvm/functions/Function1;Landroid/view/View;)V

    .line 4
    return-void
.end method

.method public static synthetic V0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->r1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public static synthetic W0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;IIII)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static/range {p0 .. p5}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->q1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;IIII)V

    .line 4
    return-void
.end method

.method public static final a1(IZ)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    if-eqz p1, :cond_0

    .line 3
    int-to-float p0, p0

    .line 4
    .line 5
    .line 6
    const p1, 0x3e4ccccd    # 0.2f

    .line 7
    mul-float/2addr p0, p1

    .line 8
    .line 9
    new-instance p1, Lcom/xj/winemu/UpdateCasEffectConfig;

    .line 10
    .line 11
    .line 12
    invoke-direct {p1, p0}, Lcom/xj/winemu/UpdateCasEffectConfig;-><init>(F)V

    .line 13
    const/4 p0, 0x2

    .line 14
    const/4 v0, 0x0

    .line 15
    .line 16
    .line 17
    invoke-static {p1, v0, p0, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 18
    .line 19
    :cond_0
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 20
    return-object p0
.end method

.method public static final b1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 3

    .line 1
    const/4 v0, 0x1

    .line 2
    .line 3
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 7
    move-result v1

    .line 8
    .line 9
    if-eqz v1, :cond_0

    .line 10
    const/4 v0, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 14
    goto :goto_0

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 18
    .line 19
    .line 20
    :goto_0
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 21
    move-result v0

    .line 22
    .line 23
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C:Z

    .line 24
    .line 25
    new-instance v1, Lcom/xj/winemu/UpdateHUDConfig;

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->Z0()Lcom/winemu/ui/HUDConfig;

    .line 29
    move-result-object v2

    .line 30
    .line 31
    .line 32
    invoke-direct {v1, v0, v2}, Lcom/xj/winemu/UpdateHUDConfig;-><init>(ZLcom/winemu/ui/HUDConfig;)V

    .line 33
    const/4 v0, 0x2

    .line 34
    const/4 v2, 0x0

    .line 35
    .line 36
    .line 37
    invoke-static {v1, v2, v0, v2}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 38
    .line 39
    .line 40
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 41
    move-result-object v0

    .line 42
    .line 43
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 44
    .line 45
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudOptionsRv:Lcom/xj/common/view/focus/focus/view/FocusableRecyclerView;

    .line 46
    .line 47
    .line 48
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 49
    move-result p1

    .line 50
    .line 51
    .line 52
    invoke-virtual {v0, p1}, Landroid/view/View;->setEnabled(Z)V

    .line 53
    .line 54
    .line 55
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 56
    move-result-object p0

    .line 57
    .line 58
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 59
    .line 60
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudOptionsRv:Lcom/xj/common/view/focus/focus/view/FocusableRecyclerView;

    .line 61
    .line 62
    .line 63
    invoke-virtual {p0}, Lcom/xj/common/view/focus/focus/view/FocusableRecyclerView;->getAdapter()Landroidx/recyclerview/widget/RecyclerView$Adapter;

    .line 64
    move-result-object p0

    .line 65
    .line 66
    if-eqz p0, :cond_1

    .line 67
    .line 68
    .line 69
    invoke-virtual {p0}, Landroidx/recyclerview/widget/RecyclerView$Adapter;->notifyDataSetChanged()V

    .line 70
    .line 71
    :cond_1
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 72
    return-object p0
.end method

.method public static final c1(IZ)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    if-eqz p1, :cond_0

    .line 3
    .line 4
    new-instance p1, Lcom/xj/winemu/UpdateLimitFPS;

    .line 5
    .line 6
    .line 7
    invoke-direct {p1, p0}, Lcom/xj/winemu/UpdateLimitFPS;-><init>(I)V

    .line 8
    const/4 p0, 0x2

    .line 9
    const/4 v0, 0x0

    .line 10
    .line 11
    .line 12
    invoke-static {p1, v0, p0, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 13
    .line 14
    :cond_0
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 15
    return-object p0
.end method

.method public static final d1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 3

    .line 1
    const/4 v0, 0x1

    .line 2
    .line 3
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 7
    move-result v1

    .line 8
    .line 9
    if-eqz v1, :cond_0

    .line 10
    const/4 v1, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, v1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 14
    goto :goto_0

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 18
    .line 19
    .line 20
    :goto_0
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 21
    move-result-object v1

    .line 22
    .line 23
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 24
    .line 25
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 26
    .line 27
    .line 28
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 29
    move-result v2

    .line 30
    xor-int/2addr v0, v2

    .line 31
    .line 32
    .line 33
    invoke-virtual {v1, v0}, Lcom/xj/winemu/view/SidebarProgressItemView;->setDisabled(Z)V

    .line 34
    .line 35
    .line 36
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 37
    move-result-object p0

    .line 38
    .line 39
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 40
    .line 41
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 42
    .line 43
    .line 44
    invoke-virtual {p0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    .line 45
    move-result-object p0

    .line 46
    .line 47
    instance-of v0, p0, Landroid/view/View;

    .line 48
    const/4 v1, 0x0

    .line 49
    .line 50
    if-eqz v0, :cond_1

    .line 51
    .line 52
    check-cast p0, Landroid/view/View;

    .line 53
    goto :goto_1

    .line 54
    :cond_1
    move-object p0, v1

    .line 55
    .line 56
    :goto_1
    if-eqz p0, :cond_2

    .line 57
    .line 58
    .line 59
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 60
    move-result v0

    .line 61
    .line 62
    .line 63
    invoke-virtual {p0, v0}, Landroid/view/View;->setEnabled(Z)V

    .line 64
    .line 65
    :cond_2
    new-instance p0, Lcom/xj/winemu/EnableLimitFPS;

    .line 66
    .line 67
    .line 68
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 69
    move-result p1

    .line 70
    .line 71
    .line 72
    invoke-direct {p0, p1}, Lcom/xj/winemu/EnableLimitFPS;-><init>(Z)V

    .line 73
    const/4 p1, 0x2

    .line 74
    .line 75
    .line 76
    invoke-static {p0, v1, p1, v1}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 77
    .line 78
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 79
    return-object p0
.end method

.method public static final e1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 2

    .line 1
    const/4 v0, 0x1

    .line 2
    .line 3
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 7
    move-result v1

    .line 8
    .line 9
    if-eqz v1, :cond_0

    .line 10
    const/4 v0, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 14
    goto :goto_0

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 18
    .line 19
    .line 20
    :goto_0
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 21
    move-result p1

    .line 22
    .line 23
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->w:Z

    .line 24
    .line 25
    new-instance p1, Lcom/xj/winemu/EnableDualBatteryMode;

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->Z0()Lcom/winemu/ui/HUDConfig;

    .line 29
    move-result-object p0

    .line 30
    .line 31
    .line 32
    invoke-direct {p1, p0}, Lcom/xj/winemu/EnableDualBatteryMode;-><init>(Lcom/winemu/ui/HUDConfig;)V

    .line 33
    const/4 p0, 0x2

    .line 34
    const/4 v0, 0x0

    .line 35
    .line 36
    .line 37
    invoke-static {p1, v0, p0, v0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 38
    .line 39
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 40
    return-object p0
.end method

.method public static final f1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 6

    .line 1
    const/4 v0, 0x1

    .line 2
    .line 3
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 7
    move-result p0

    .line 8
    .line 9
    if-eqz p0, :cond_0

    .line 10
    const/4 p0, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, p0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 14
    goto :goto_0

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 18
    .line 19
    :goto_0
    new-instance v0, Lcom/xj/winemu/UpdateReshadeConfigEnable;

    .line 20
    .line 21
    .line 22
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 23
    move-result p0

    .line 24
    .line 25
    .line 26
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 27
    move-result-object v1

    .line 28
    const/4 v4, 0x6

    .line 29
    const/4 v5, 0x0

    .line 30
    const/4 v2, 0x0

    .line 31
    const/4 v3, 0x0

    .line 32
    .line 33
    .line 34
    invoke-direct/range {v0 .. v5}, Lcom/xj/winemu/UpdateReshadeConfigEnable;-><init>(Ljava/lang/Boolean;Ljava/lang/Boolean;Ljava/lang/Boolean;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 35
    const/4 p0, 0x2

    .line 36
    const/4 p1, 0x0

    .line 37
    .line 38
    .line 39
    invoke-static {v0, p1, p0, p1}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 40
    .line 41
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 42
    return-object p0
.end method

.method public static final g1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    const-string v0, "hudOpt"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    new-instance p1, Lcom/xj/winemu/UpdateHUDConfig;

    .line 8
    const/4 v0, 0x1

    .line 9
    .line 10
    .line 11
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->Z0()Lcom/winemu/ui/HUDConfig;

    .line 12
    move-result-object p0

    .line 13
    .line 14
    .line 15
    invoke-direct {p1, v0, p0}, Lcom/xj/winemu/UpdateHUDConfig;-><init>(ZLcom/winemu/ui/HUDConfig;)V

    .line 16
    const/4 p0, 0x0

    .line 17
    const/4 v0, 0x2

    .line 18
    .line 19
    .line 20
    invoke-static {p1, p0, v0, p0}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 21
    .line 22
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 23
    return-object p0
.end method

.method public static final h1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;Lcom/drake/brv/BindingAdapter;Landroidx/recyclerview/widget/RecyclerView;)Lkotlin/Unit;
    .locals 3

    .line 1
    .line 2
    const-string v0, "$this$setup"

    .line 3
    .line 4
    .line 5
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    const-string v0, "it"

    .line 8
    .line 9
    .line 10
    invoke-static {p3, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 11
    .line 12
    sget p3, Lcom/xj/winemu/R$layout;->item_options_check:I

    .line 13
    .line 14
    const-class v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 15
    .line 16
    .line 17
    invoke-virtual {v0}, Ljava/lang/Class;->getModifiers()I

    .line 18
    move-result v1

    .line 19
    .line 20
    .line 21
    invoke-static {v1}, Ljava/lang/reflect/Modifier;->isInterface(I)Z

    .line 22
    move-result v1

    .line 23
    .line 24
    if-eqz v1, :cond_0

    .line 25
    .line 26
    .line 27
    invoke-virtual {p2}, Lcom/drake/brv/BindingAdapter;->A()Ljava/util/Map;

    .line 28
    move-result-object v1

    .line 29
    .line 30
    .line 31
    invoke-static {v0}, Lkotlin/jvm/internal/Reflection;->p(Ljava/lang/Class;)Lkotlin/reflect/KType;

    .line 32
    move-result-object v0

    .line 33
    .line 34
    new-instance v2, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$initView$lambda$24$lambda$23$$inlined$addType$1;

    .line 35
    .line 36
    .line 37
    invoke-direct {v2, p3}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$initView$lambda$24$lambda$23$$inlined$addType$1;-><init>(I)V

    .line 38
    .line 39
    .line 40
    invoke-interface {v1, v0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 41
    goto :goto_0

    .line 42
    .line 43
    .line 44
    :cond_0
    invoke-virtual {p2}, Lcom/drake/brv/BindingAdapter;->I()Ljava/util/Map;

    .line 45
    move-result-object v1

    .line 46
    .line 47
    .line 48
    invoke-static {v0}, Lkotlin/jvm/internal/Reflection;->p(Ljava/lang/Class;)Lkotlin/reflect/KType;

    .line 49
    move-result-object v0

    .line 50
    .line 51
    new-instance v2, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$initView$lambda$24$lambda$23$$inlined$addType$2;

    .line 52
    .line 53
    .line 54
    invoke-direct {v2, p3}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$initView$lambda$24$lambda$23$$inlined$addType$2;-><init>(I)V

    .line 55
    .line 56
    .line 57
    invoke-interface {v1, v0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 58
    .line 59
    :goto_0
    new-instance p3, Lcom/xj/winemu/sidebar/h0;

    .line 60
    .line 61
    .line 62
    invoke-direct {p3, p0, p1}, Lcom/xj/winemu/sidebar/h0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;)V

    .line 63
    .line 64
    .line 65
    invoke-virtual {p2, p3}, Lcom/drake/brv/BindingAdapter;->N(Lkotlin/jvm/functions/Function1;)V

    .line 66
    .line 67
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 68
    return-object p0
.end method

.method public static final i1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;Lcom/drake/brv/BindingAdapter$BindingViewHolder;)Lkotlin/Unit;
    .locals 5

    .line 1
    .line 2
    const-string v0, "$this$onBind"

    .line 3
    .line 4
    .line 5
    invoke-static {p2, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p2}, Lcom/drake/brv/BindingAdapter$BindingViewHolder;->r()Ljava/lang/Object;

    .line 9
    move-result-object v0

    .line 10
    .line 11
    check-cast v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 12
    .line 13
    .line 14
    invoke-virtual {p2}, Lcom/drake/brv/BindingAdapter$BindingViewHolder;->t()Landroidx/viewbinding/ViewBinding;

    .line 15
    move-result-object v1

    .line 16
    .line 17
    const-string v2, "null cannot be cast to non-null type com.xj.winemu.databinding.ItemOptionsCheckBinding"

    .line 18
    .line 19
    if-nez v1, :cond_1

    .line 20
    .line 21
    const-class v1, Landroid/view/View;

    .line 22
    .line 23
    .line 24
    filled-new-array {v1}, [Ljava/lang/Class;

    .line 25
    move-result-object v1

    .line 26
    .line 27
    const-class v3, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;

    .line 28
    .line 29
    const-string v4, "bind"

    .line 30
    .line 31
    .line 32
    invoke-virtual {v3, v4, v1}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    .line 33
    move-result-object v1

    .line 34
    .line 35
    iget-object v3, p2, Landroidx/recyclerview/widget/RecyclerView$ViewHolder;->itemView:Landroid/view/View;

    .line 36
    .line 37
    .line 38
    filled-new-array {v3}, [Ljava/lang/Object;

    .line 39
    move-result-object v3

    .line 40
    const/4 v4, 0x0

    .line 41
    .line 42
    .line 43
    invoke-virtual {v1, v4, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 44
    move-result-object v1

    .line 45
    .line 46
    if-eqz v1, :cond_0

    .line 47
    .line 48
    check-cast v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;

    .line 49
    .line 50
    .line 51
    invoke-virtual {p2, v1}, Lcom/drake/brv/BindingAdapter$BindingViewHolder;->v(Landroidx/viewbinding/ViewBinding;)V

    .line 52
    goto :goto_0

    .line 53
    .line 54
    :cond_0
    new-instance p0, Ljava/lang/NullPointerException;

    .line 55
    .line 56
    .line 57
    invoke-direct {p0, v2}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    .line 58
    throw p0

    .line 59
    .line 60
    .line 61
    :cond_1
    invoke-virtual {p2}, Lcom/drake/brv/BindingAdapter$BindingViewHolder;->t()Landroidx/viewbinding/ViewBinding;

    .line 62
    move-result-object p2

    .line 63
    .line 64
    if-eqz p2, :cond_3

    .line 65
    move-object v1, p2

    .line 66
    .line 67
    check-cast v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;

    .line 68
    .line 69
    :goto_0
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->tvName:Landroid/widget/TextView;

    .line 70
    .line 71
    .line 72
    invoke-virtual {v0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->b()Ljava/lang/String;

    .line 73
    move-result-object v2

    .line 74
    .line 75
    .line 76
    invoke-virtual {p2, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 77
    .line 78
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->optionsItem:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 79
    .line 80
    iget-boolean v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C:Z

    .line 81
    .line 82
    .line 83
    invoke-virtual {p2, v2}, Landroid/view/View;->setEnabled(Z)V

    .line 84
    .line 85
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->tvName:Landroid/widget/TextView;

    .line 86
    .line 87
    const-string v2, "tvName"

    .line 88
    .line 89
    .line 90
    invoke-static {p2, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 91
    .line 92
    iget-boolean v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C:Z

    .line 93
    .line 94
    .line 95
    invoke-virtual {p0, p2, v2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->Y0(Landroid/widget/TextView;Z)V

    .line 96
    .line 97
    iget-boolean p2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C:Z

    .line 98
    .line 99
    const-string v2, "ivSwitch"

    .line 100
    .line 101
    if-eqz p2, :cond_2

    .line 102
    .line 103
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->ivSwitch:Landroid/widget/ImageView;

    .line 104
    .line 105
    .line 106
    invoke-static {p2, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 107
    .line 108
    .line 109
    invoke-virtual {v0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 110
    move-result v2

    .line 111
    .line 112
    .line 113
    invoke-virtual {p0, p2, v2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y1(Landroid/widget/ImageView;Z)V

    .line 114
    goto :goto_1

    .line 115
    .line 116
    :cond_2
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->ivSwitch:Landroid/widget/ImageView;

    .line 117
    .line 118
    .line 119
    invoke-static {p2, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 120
    .line 121
    .line 122
    invoke-virtual {v0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 123
    move-result v2

    .line 124
    .line 125
    .line 126
    invoke-virtual {p0, p2, v2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->X0(Landroid/widget/ImageView;Z)V

    .line 127
    .line 128
    :goto_1
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->optionsItem:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 129
    .line 130
    new-instance v2, Lcom/xj/winemu/sidebar/k0;

    .line 131
    .line 132
    .line 133
    invoke-direct {v2, v0, p0, v1, p1}, Lcom/xj/winemu/sidebar/k0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lkotlin/jvm/functions/Function1;)V

    .line 134
    .line 135
    .line 136
    invoke-virtual {p2, v2}, Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;->setOnFocusEventListener(Lkotlin/jvm/functions/Function1;)V

    .line 137
    .line 138
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->optionsItem:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 139
    .line 140
    const-string v2, "optionsItem"

    .line 141
    .line 142
    .line 143
    invoke-static {p2, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 144
    .line 145
    .line 146
    invoke-static {p2}, Lcom/xj/common/view/focus/focus/view/FocusViewsExtKt;->b(Landroid/view/View;)V

    .line 147
    .line 148
    iget-object p2, v1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->optionsItem:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 149
    .line 150
    new-instance v2, Lcom/xj/winemu/sidebar/l0;

    .line 151
    .line 152
    .line 153
    invoke-direct {v2, p0, v1, v0, p1}, Lcom/xj/winemu/sidebar/l0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lkotlin/jvm/functions/Function1;)V

    .line 154
    .line 155
    .line 156
    invoke-virtual {p2, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 157
    .line 158
    .line 159
    invoke-virtual {v1}, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->getRoot()Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 160
    move-result-object p0

    .line 161
    .line 162
    new-instance p1, Lcom/xj/winemu/sidebar/m0;

    .line 163
    .line 164
    .line 165
    invoke-direct {p1}, Lcom/xj/winemu/sidebar/m0;-><init>()V

    .line 166
    .line 167
    .line 168
    invoke-virtual {p0, p1}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 169
    .line 170
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 171
    return-object p0

    .line 172
    .line 173
    :cond_3
    new-instance p0, Ljava/lang/NullPointerException;

    .line 174
    .line 175
    .line 176
    invoke-direct {p0, v2}, Ljava/lang/NullPointerException;-><init>(Ljava/lang/String;)V

    .line 177
    throw p0
.end method

.method public static final j1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lkotlin/jvm/functions/Function1;Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 2

    .line 1
    .line 2
    const-string v0, "event"

    .line 3
    .line 4
    .line 5
    invoke-static {p4, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p4}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 9
    move-result-object v0

    .line 10
    .line 11
    sget-object v1, Lcom/xj/common/view/focus/focus/FocusDirection;->BUTTON_A:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 12
    .line 13
    if-ne v0, v1, :cond_0

    .line 14
    .line 15
    .line 16
    invoke-virtual {p4}, Lcom/xj/common/view/focus/focus/FocusEvent;->c()I

    .line 17
    move-result p4

    .line 18
    .line 19
    if-nez p4, :cond_0

    .line 20
    .line 21
    .line 22
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 23
    move-result p4

    .line 24
    const/4 v0, 0x1

    .line 25
    xor-int/2addr p4, v0

    .line 26
    .line 27
    .line 28
    invoke-virtual {p0, p4}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->d(Z)V

    .line 29
    .line 30
    iget-object p2, p2, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->ivSwitch:Landroid/widget/ImageView;

    .line 31
    .line 32
    const-string p4, "ivSwitch"

    .line 33
    .line 34
    .line 35
    invoke-static {p2, p4}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 36
    .line 37
    .line 38
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 39
    move-result p4

    .line 40
    .line 41
    .line 42
    invoke-virtual {p1, p2, p4}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y1(Landroid/widget/ImageView;Z)V

    .line 43
    .line 44
    .line 45
    invoke-interface {p3, p0}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    .line 46
    return v0

    .line 47
    :cond_0
    const/4 p0, 0x0

    .line 48
    return p0
.end method

.method public static final k1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lkotlin/jvm/functions/Function1;Landroid/view/View;)V
    .locals 1

    .line 1
    const/4 p4, 0x1

    .line 2
    .line 3
    iput-boolean p4, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    iget-object v0, p1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->optionsItem:Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;

    .line 6
    .line 7
    .line 8
    invoke-virtual {v0}, Lcom/xj/common/view/focus/focus/view/FocusableFrameLayout;->y()V

    .line 9
    .line 10
    .line 11
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 12
    move-result v0

    .line 13
    xor-int/2addr p4, v0

    .line 14
    .line 15
    .line 16
    invoke-virtual {p2, p4}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->d(Z)V

    .line 17
    .line 18
    iget-object p1, p1, Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;->ivSwitch:Landroid/widget/ImageView;

    .line 19
    .line 20
    const-string p4, "ivSwitch"

    .line 21
    .line 22
    .line 23
    invoke-static {p1, p4}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 24
    .line 25
    .line 26
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 27
    move-result p4

    .line 28
    .line 29
    .line 30
    invoke-virtual {p0, p1, p4}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y1(Landroid/widget/ImageView;Z)V

    .line 31
    .line 32
    .line 33
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->a()I

    .line 34
    move-result p1

    .line 35
    .line 36
    .line 37
    packed-switch p1, :pswitch_data_0

    .line 38
    goto :goto_0

    .line 39
    .line 40
    .line 41
    :pswitch_0
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 42
    move-result p1

    .line 43
    .line 44
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->u:Z

    .line 45
    goto :goto_0

    .line 46
    .line 47
    .line 48
    :pswitch_1
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 49
    move-result p1

    .line 50
    .line 51
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->v:Z

    .line 52
    goto :goto_0

    .line 53
    .line 54
    .line 55
    :pswitch_2
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 56
    move-result p1

    .line 57
    .line 58
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->s:Z

    .line 59
    goto :goto_0

    .line 60
    .line 61
    .line 62
    :pswitch_3
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 63
    move-result p1

    .line 64
    .line 65
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->r:Z

    .line 66
    goto :goto_0

    .line 67
    .line 68
    .line 69
    :pswitch_4
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 70
    move-result p1

    .line 71
    .line 72
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->t:Z

    .line 73
    goto :goto_0

    .line 74
    .line 75
    .line 76
    :pswitch_5
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 77
    move-result p1

    .line 78
    .line 79
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->q:Z

    .line 80
    goto :goto_0

    .line 81
    .line 82
    .line 83
    :pswitch_6
    invoke-virtual {p2}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;->c()Z

    .line 84
    move-result p1

    .line 85
    .line 86
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->p:Z

    .line 87
    .line 88
    .line 89
    :goto_0
    invoke-interface {p3, p2}, Lkotlin/jvm/functions/Function1;->invoke(Ljava/lang/Object;)Ljava/lang/Object;

    .line 90
    return-void

    .line 91
    :pswitch_data_0
    .packed-switch 0x1
        :pswitch_6
        :pswitch_5
        :pswitch_4
        :pswitch_3
        :pswitch_2
        :pswitch_1
        :pswitch_0
    .end packed-switch
.end method

.method public static final l1(Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    if-eqz p1, :cond_0

    .line 3
    .line 4
    .line 5
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 6
    const/4 v4, 0x7

    .line 7
    const/4 v5, 0x0

    .line 8
    const/4 v1, 0x0

    .line 9
    const/4 v2, 0x0

    .line 10
    const/4 v3, 0x0

    .line 11
    move-object v0, p0

    .line 12
    .line 13
    .line 14
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 15
    return-void

    .line 16
    :cond_0
    move-object v0, p0

    .line 17
    .line 18
    .line 19
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 20
    .line 21
    .line 22
    invoke-static {v0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 23
    return-void
.end method

.method public static final m1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;IZ)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    if-eqz p2, :cond_0

    .line 3
    int-to-float p1, p1

    .line 4
    .line 5
    const/high16 p2, 0x42c80000    # 100.0f

    .line 6
    div-float/2addr p1, p2

    .line 7
    .line 8
    iget-object p0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x:Ljava/lang/String;

    .line 9
    .line 10
    .line 11
    invoke-static {p1, p0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->e(FLjava/lang/String;)V

    .line 12
    .line 13
    new-instance p0, Lcom/xj/winemu/UpdateHudBgTransparencyUi;

    .line 14
    .line 15
    .line 16
    invoke-direct {p0, p1}, Lcom/xj/winemu/UpdateHudBgTransparencyUi;-><init>(F)V

    .line 17
    const/4 p1, 0x2

    .line 18
    const/4 p2, 0x0

    .line 19
    .line 20
    .line 21
    invoke-static {p0, p2, p1, p2}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 22
    .line 23
    :cond_0
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 24
    return-object p0
.end method

.method public static final n1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusableView;)Lkotlin/Unit;
    .locals 1

    .line 1
    .line 2
    iget-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 3
    .line 4
    if-nez v0, :cond_1

    .line 5
    .line 6
    instance-of v0, p1, Landroid/view/View;

    .line 7
    .line 8
    if-eqz v0, :cond_0

    .line 9
    .line 10
    check-cast p1, Landroid/view/View;

    .line 11
    goto :goto_0

    .line 12
    :cond_0
    const/4 p1, 0x0

    .line 13
    .line 14
    :goto_0
    if-eqz p1, :cond_1

    .line 15
    .line 16
    .line 17
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 18
    move-result-object p0

    .line 19
    .line 20
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 21
    .line 22
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceNsv:Lcom/xj/common/view/focus/focus/view/FocusableNestedScrollView;

    .line 23
    .line 24
    .line 25
    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    .line 26
    move-result p1

    .line 27
    .line 28
    const/16 v0, 0x1e

    .line 29
    .line 30
    .line 31
    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 32
    move-result-object v0

    .line 33
    .line 34
    .line 35
    invoke-static {v0}, Lcom/xj/base/adaptscreen/AdaptiveSizeKt;->b(Ljava/lang/Number;)Lcom/xj/base/adaptscreen/AdaptiveSize;

    .line 36
    move-result-object v0

    .line 37
    .line 38
    .line 39
    invoke-virtual {v0}, Lcom/xj/base/adaptscreen/AdaptiveSize;->f()I

    .line 40
    move-result v0

    .line 41
    sub-int/2addr p1, v0

    .line 42
    const/4 v0, 0x0

    .line 43
    .line 44
    .line 45
    invoke-virtual {p0, v0, p1}, Landroidx/core/widget/NestedScrollView;->j0(II)V

    .line 46
    .line 47
    :cond_1
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 48
    return-object p0
.end method

.method public static final o1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 1

    .line 1
    .line 2
    const-string v0, "it"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    const/4 p1, 0x0

    .line 7
    .line 8
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 9
    return p1
.end method

.method public static final p1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;Landroid/view/MotionEvent;)Z
    .locals 0

    .line 1
    const/4 p1, 0x1

    .line 2
    .line 3
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    const/4 p0, 0x0

    .line 5
    return p0
.end method

.method public static final q1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;IIII)V
    .locals 1

    .line 1
    .line 2
    iget-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 3
    .line 4
    if-eqz p1, :cond_4

    .line 5
    .line 6
    .line 7
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 8
    move-result-object p1

    .line 9
    .line 10
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 11
    .line 12
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 13
    .line 14
    .line 15
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;->getLastFocusedView()Lcom/xj/common/view/focus/focus/FocusableView;

    .line 16
    move-result-object p1

    .line 17
    .line 18
    instance-of p2, p1, Landroid/view/View;

    .line 19
    const/4 p4, 0x0

    .line 20
    .line 21
    if-eqz p2, :cond_0

    .line 22
    .line 23
    check-cast p1, Landroid/view/View;

    .line 24
    goto :goto_0

    .line 25
    :cond_0
    move-object p1, p4

    .line 26
    .line 27
    :goto_0
    if-eqz p1, :cond_4

    .line 28
    .line 29
    .line 30
    invoke-virtual {p1}, Landroid/view/View;->getTop()I

    .line 31
    move-result p2

    .line 32
    .line 33
    .line 34
    invoke-virtual {p1}, Landroid/view/View;->getBottom()I

    .line 35
    move-result p1

    .line 36
    add-int/2addr p2, p1

    .line 37
    .line 38
    div-int/lit8 p2, p2, 0x2

    .line 39
    .line 40
    if-gt p3, p2, :cond_1

    .line 41
    .line 42
    .line 43
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 44
    move-result-object p1

    .line 45
    .line 46
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 47
    .line 48
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceNsv:Lcom/xj/common/view/focus/focus/view/FocusableNestedScrollView;

    .line 49
    .line 50
    .line 51
    invoke-virtual {p1}, Landroid/view/View;->getHeight()I

    .line 52
    move-result p1

    .line 53
    add-int/2addr p1, p3

    .line 54
    .line 55
    if-ge p1, p2, :cond_4

    .line 56
    .line 57
    .line 58
    :cond_1
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 59
    move-result-object p1

    .line 60
    .line 61
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 62
    .line 63
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 64
    .line 65
    .line 66
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;->getFocusableViews()Ljava/util/List;

    .line 67
    move-result-object p1

    .line 68
    .line 69
    .line 70
    invoke-interface {p1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 71
    move-result-object p1

    .line 72
    .line 73
    .line 74
    :cond_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 75
    move-result p2

    .line 76
    .line 77
    if-eqz p2, :cond_3

    .line 78
    .line 79
    .line 80
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 81
    move-result-object p2

    .line 82
    move-object p5, p2

    .line 83
    .line 84
    check-cast p5, Lcom/xj/common/view/focus/focus/FocusableView;

    .line 85
    .line 86
    instance-of v0, p5, Landroid/view/View;

    .line 87
    .line 88
    if-eqz v0, :cond_2

    .line 89
    .line 90
    check-cast p5, Landroid/view/View;

    .line 91
    .line 92
    .line 93
    invoke-virtual {p5}, Landroid/view/View;->getTop()I

    .line 94
    move-result v0

    .line 95
    .line 96
    if-ge p3, v0, :cond_2

    .line 97
    .line 98
    .line 99
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 100
    move-result-object v0

    .line 101
    .line 102
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 103
    .line 104
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceNsv:Lcom/xj/common/view/focus/focus/view/FocusableNestedScrollView;

    .line 105
    .line 106
    .line 107
    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    .line 108
    move-result v0

    .line 109
    add-int/2addr v0, p3

    .line 110
    .line 111
    .line 112
    invoke-virtual {p5}, Landroid/view/View;->getBottom()I

    .line 113
    move-result p5

    .line 114
    .line 115
    if-le v0, p5, :cond_2

    .line 116
    move-object p4, p2

    .line 117
    .line 118
    :cond_3
    check-cast p4, Lcom/xj/common/view/focus/focus/FocusableView;

    .line 119
    .line 120
    if-eqz p4, :cond_4

    .line 121
    .line 122
    .line 123
    invoke-interface {p4}, Lcom/xj/common/view/focus/focus/FocusableView;->y()V

    .line 124
    :cond_4
    return-void
.end method

.method public static final r1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 6

    .line 1
    const/4 v0, 0x1

    .line 2
    .line 3
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 7
    move-result p0

    .line 8
    .line 9
    if-eqz p0, :cond_0

    .line 10
    const/4 p0, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, p0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 14
    goto :goto_0

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 18
    .line 19
    :goto_0
    new-instance v0, Lcom/xj/winemu/UpdateReshadeConfigEnable;

    .line 20
    .line 21
    .line 22
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 23
    move-result p0

    .line 24
    .line 25
    .line 26
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 27
    move-result-object v3

    .line 28
    const/4 v4, 0x3

    .line 29
    const/4 v5, 0x0

    .line 30
    const/4 v1, 0x0

    .line 31
    const/4 v2, 0x0

    .line 32
    .line 33
    .line 34
    invoke-direct/range {v0 .. v5}, Lcom/xj/winemu/UpdateReshadeConfigEnable;-><init>(Ljava/lang/Boolean;Ljava/lang/Boolean;Ljava/lang/Boolean;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 35
    const/4 p0, 0x2

    .line 36
    const/4 p1, 0x0

    .line 37
    .line 38
    .line 39
    invoke-static {v0, p1, p0, p1}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 40
    .line 41
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 42
    return-object p0
.end method

.method public static final s1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)Lkotlin/Unit;
    .locals 7

    .line 1
    const/4 v0, 0x1

    .line 2
    .line 3
    iput-boolean v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 7
    move-result v1

    .line 8
    .line 9
    if-eqz v1, :cond_0

    .line 10
    const/4 v0, 0x0

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 14
    goto :goto_0

    .line 15
    .line 16
    .line 17
    :cond_0
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 18
    .line 19
    .line 20
    :goto_0
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 21
    move-result-object v0

    .line 22
    .line 23
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 24
    .line 25
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressTv:Lcom/xj/lib/shape/view/ShapeTextView;

    .line 26
    .line 27
    .line 28
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 29
    move-result v1

    .line 30
    .line 31
    .line 32
    invoke-virtual {v0, v1}, Landroid/view/View;->setSelected(Z)V

    .line 33
    .line 34
    .line 35
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 36
    move-result-object v0

    .line 37
    .line 38
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 39
    .line 40
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 41
    .line 42
    .line 43
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 44
    move-result v1

    .line 45
    .line 46
    .line 47
    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    .line 48
    .line 49
    .line 50
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 51
    move-result-object p0

    .line 52
    .line 53
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 54
    .line 55
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgress:Lcom/xj/common/view/CalliperProgress;

    .line 56
    .line 57
    .line 58
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 59
    move-result v0

    .line 60
    .line 61
    .line 62
    invoke-virtual {p0, v0}, Lcom/xj/common/view/CalliperProgress;->setDisabled(Z)V

    .line 63
    .line 64
    new-instance v1, Lcom/xj/winemu/UpdateReshadeConfigEnable;

    .line 65
    .line 66
    .line 67
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 68
    move-result p0

    .line 69
    .line 70
    .line 71
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 72
    move-result-object v3

    .line 73
    const/4 v5, 0x5

    .line 74
    const/4 v6, 0x0

    .line 75
    const/4 v2, 0x0

    .line 76
    const/4 v4, 0x0

    .line 77
    .line 78
    .line 79
    invoke-direct/range {v1 .. v6}, Lcom/xj/winemu/UpdateReshadeConfigEnable;-><init>(Ljava/lang/Boolean;Ljava/lang/Boolean;Ljava/lang/Boolean;ILkotlin/jvm/internal/DefaultConstructorMarker;)V

    .line 80
    const/4 p0, 0x2

    .line 81
    const/4 p1, 0x0

    .line 82
    .line 83
    .line 84
    invoke-static {v1, p1, p0, p1}, Lcom/drake/channel/ChannelKt;->c(Ljava/lang/Object;Ljava/lang/String;ILjava/lang/Object;)Lkotlinx/coroutines/Job;

    .line 85
    .line 86
    sget-object p0, Lkotlin/Unit;->a:Lkotlin/Unit;

    .line 87
    return-object p0
.end method

.method private static final t1(Landroid/view/View;Z)V
    .locals 6

    .line 1
    .line 2
    if-eqz p1, :cond_0

    .line 3
    .line 4
    .line 5
    invoke-static {p0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 6
    const/4 v4, 0x7

    .line 7
    const/4 v5, 0x0

    .line 8
    const/4 v1, 0x0

    .line 9
    const/4 v2, 0x0

    .line 10
    const/4 v3, 0x0

    .line 11
    move-object v0, p0

    .line 12
    .line 13
    .line 14
    invoke-static/range {v0 .. v5}, Lcom/xj/common/utils/FocusableBorderExtKt;->g(Landroid/view/View;IIIILjava/lang/Object;)V

    .line 15
    return-void

    .line 16
    :cond_0
    move-object v0, p0

    .line 17
    .line 18
    .line 19
    invoke-static {v0}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 20
    .line 21
    .line 22
    invoke-static {v0}, Lcom/xj/common/utils/FocusableBorderExtKt;->b(Landroid/view/View;)V

    .line 23
    return-void
.end method

.method public static final u1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 2

    .line 1
    .line 2
    const-string v0, "event"

    .line 3
    .line 4
    .line 5
    invoke-static {p1, v0}, Lkotlin/jvm/internal/Intrinsics;->g(Ljava/lang/Object;Ljava/lang/String;)V

    .line 6
    .line 7
    .line 8
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 9
    move-result-object v0

    .line 10
    .line 11
    sget-object v1, Lcom/xj/common/view/focus/focus/FocusDirection;->LEFT:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 12
    .line 13
    if-eq v0, v1, :cond_1

    .line 14
    .line 15
    .line 16
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->e()Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 17
    move-result-object v0

    .line 18
    .line 19
    sget-object v1, Lcom/xj/common/view/focus/focus/FocusDirection;->RIGHT:Lcom/xj/common/view/focus/focus/FocusDirection;

    .line 20
    .line 21
    if-ne v0, v1, :cond_0

    .line 22
    goto :goto_0

    .line 23
    :cond_0
    const/4 p0, 0x0

    .line 24
    return p0

    .line 25
    .line 26
    .line 27
    :cond_1
    :goto_0
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 28
    move-result-object p0

    .line 29
    .line 30
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 31
    .line 32
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgress:Lcom/xj/common/view/CalliperProgress;

    .line 33
    .line 34
    .line 35
    invoke-virtual {p1}, Lcom/xj/common/view/focus/focus/FocusEvent;->d()Landroid/view/KeyEvent;

    .line 36
    move-result-object p1

    .line 37
    .line 38
    .line 39
    invoke-virtual {p0, p1}, Lcom/xj/common/view/CalliperProgress;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    .line 40
    move-result p0

    .line 41
    return p0
.end method

.method public static final v1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Landroid/view/View;)V
    .locals 0

    .line 1
    const/4 p1, 0x1

    .line 2
    .line 3
    iput-boolean p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->y:Z

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 7
    move-result-object p0

    .line 8
    .line 9
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 10
    .line 11
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 12
    .line 13
    .line 14
    invoke-virtual {p0}, Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;->y()V

    .line 15
    return-void
.end method

.method public static synthetic x0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lkotlin/jvm/functions/Function1;Lcom/xj/common/view/focus/focus/FocusEvent;)Z
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3, p4}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->j1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/databinding/ItemOptionsCheckBinding;Lkotlin/jvm/functions/Function1;Lcom/xj/common/view/focus/focus/FocusEvent;)Z

    .line 4
    move-result p0

    .line 5
    return p0
.end method

.method public static synthetic y0(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;ILcom/xj/winemu/bean/CollapseItemMenu;)Lkotlin/Unit;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-static {p0, p1, p2, p3}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->A1(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;ILcom/xj/winemu/bean/CollapseItemMenu;)Lkotlin/Unit;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method


# virtual methods
.method public final B1()V
    .locals 4

    .line 1
    .line 2
    sget-object v0, Lcom/xj/common/config/Constants;->a:Lcom/xj/common/config/Constants;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/common/config/Constants;->c()Z

    .line 6
    move-result v0

    .line 7
    .line 8
    if-nez v0, :cond_0

    .line 9
    return-void

    .line 10
    .line 11
    .line 12
    :cond_0
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 13
    move-result-object v0

    .line 14
    .line 15
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 16
    .line 17
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->redmagicPerformanceMode:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 18
    .line 19
    const-string v1, "redmagicPerformanceMode"

    .line 20
    .line 21
    .line 22
    invoke-static {v0, v1}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 23
    .line 24
    .line 25
    invoke-static {v0}, Lcom/xj/base/ext/BaseViewExtKt;->d(Landroid/view/View;)V

    .line 26
    .line 27
    sget-object v0, Lcom/xj/winemu/bean/RedMagicPerformanceMode;->Companion:Lcom/xj/winemu/bean/RedMagicPerformanceMode$Companion;

    .line 28
    .line 29
    .line 30
    invoke-virtual {v0}, Lcom/xj/winemu/bean/RedMagicPerformanceMode$Companion;->getOptions()Ljava/util/List;

    .line 31
    move-result-object v0

    .line 32
    .line 33
    .line 34
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 35
    move-result-object v1

    .line 36
    .line 37
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 38
    .line 39
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->redmagicPerformanceMode:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 40
    .line 41
    sget v2, Lcom/xj/language/R$string;->wine_performance_mode:I

    .line 42
    .line 43
    .line 44
    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    .line 45
    move-result-object v2

    .line 46
    .line 47
    const-string v3, "getString(...)"

    .line 48
    .line 49
    .line 50
    invoke-static {v2, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 51
    .line 52
    .line 53
    invoke-virtual {v1, v2}, Lcom/xj/winemu/view/CollapseMenuSettingView;->J(Ljava/lang/String;)Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 54
    .line 55
    .line 56
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 57
    move-result-object v1

    .line 58
    .line 59
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 60
    .line 61
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->redmagicPerformanceMode:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 62
    .line 63
    new-instance v2, Lcom/xj/winemu/sidebar/j0;

    .line 64
    .line 65
    .line 66
    invoke-direct {v2, p0, v0}, Lcom/xj/winemu/sidebar/j0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;)V

    .line 67
    .line 68
    .line 69
    invoke-virtual {v1, v2}, Lcom/xj/winemu/view/CollapseMenuSettingView;->I(Lkotlin/jvm/functions/Function2;)Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 70
    .line 71
    .line 72
    invoke-virtual {p0, v0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x1(Ljava/util/List;)V

    .line 73
    return-void
.end method

.method public V()V
    .locals 0

    .line 1
    return-void
.end method

.method public final X0(Landroid/widget/ImageView;Z)V
    .locals 0

    .line 1
    .line 2
    if-eqz p2, :cond_0

    .line 3
    .line 4
    sget p0, Lcom/xj/winemu/R$drawable;->win_blue_disabled_check:I

    .line 5
    .line 6
    .line 7
    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 8
    return-void

    .line 9
    .line 10
    :cond_0
    sget p0, Lcom/xj/winemu/R$drawable;->win_blue_uncheck:I

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 14
    return-void
.end method

.method public final Y0(Landroid/widget/TextView;Z)V
    .locals 0

    .line 1
    .line 2
    if-eqz p2, :cond_0

    .line 3
    .line 4
    .line 5
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    .line 6
    move-result-object p0

    .line 7
    .line 8
    sget p2, Lcom/xj/common/R$color;->comm_white_f0f0f0:I

    .line 9
    .line 10
    .line 11
    invoke-static {p0, p2}, Landroidx/core/content/ContextCompat;->getColor(Landroid/content/Context;I)I

    .line 12
    move-result p0

    .line 13
    .line 14
    .line 15
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 16
    return-void

    .line 17
    .line 18
    .line 19
    :cond_0
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    .line 20
    move-result-object p0

    .line 21
    .line 22
    sget p2, Lcom/xj/winemu/R$color;->winemu_888E99:I

    .line 23
    .line 24
    .line 25
    invoke-static {p0, p2}, Landroidx/core/content/ContextCompat;->getColor(Landroid/content/Context;I)I

    .line 26
    move-result p0

    .line 27
    .line 28
    .line 29
    invoke-virtual {p1, p0}, Landroid/widget/TextView;->setTextColor(I)V

    .line 30
    return-void
.end method

.method public final Z0()Lcom/winemu/ui/HUDConfig;
    .locals 9

    .line 1
    .line 2
    new-instance v0, Lcom/winemu/ui/HUDConfig;

    .line 3
    .line 4
    iget-boolean v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->q:Z

    .line 5
    .line 6
    iget-boolean v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->p:Z

    .line 7
    .line 8
    iget-boolean v3, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->v:Z

    .line 9
    .line 10
    iget-boolean v4, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->t:Z

    .line 11
    .line 12
    iget-boolean v5, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->u:Z

    .line 13
    .line 14
    iget-boolean v6, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->r:Z

    .line 15
    .line 16
    iget-boolean v7, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->s:Z

    .line 17
    .line 18
    iget-boolean v8, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->w:Z

    .line 19
    .line 20
    .line 21
    invoke-direct/range {v0 .. v8}, Lcom/winemu/ui/HUDConfig;-><init>(ZZZZZZZZ)V

    .line 22
    return-object v0
.end method

.method public f()Lcom/xj/common/view/focus/focus/FocusableView;
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-super {p0}, Lcom/xj/common/view/focus/focus/app/FocusableFragment;->f()Lcom/xj/common/view/focus/focus/FocusableView;

    .line 4
    move-result-object p0

    .line 5
    return-object p0
.end method

.method public i(Z)V
    .locals 0

    .line 1
    .line 2
    .line 3
    invoke-super {p0, p1}, Lcom/xj/common/view/focus/focus/app/FocusableFragment;->i(Z)V

    .line 4
    return-void
.end method

.method public l0()V
    .locals 0

    .line 1
    return-void
.end method

.method public m0(Landroid/os/Bundle;)V
    .locals 13

    .line 1
    .line 2
    iget-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->A:Lcom/tencent/mmkv/MMKV;

    .line 3
    .line 4
    const-string v0, "curWineData"

    .line 5
    .line 6
    const-string v1, ""

    .line 7
    .line 8
    .line 9
    invoke-virtual {p1, v0, v1}, Lcom/tencent/mmkv/MMKV;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    .line 10
    move-result-object p1

    .line 11
    .line 12
    const-class v0, Lcom/xj/winemu/api/bean/WineActivityData;

    .line 13
    .line 14
    .line 15
    invoke-static {p1, v0}, Lcom/blankj/utilcode/util/GsonUtils;->d(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;

    .line 16
    move-result-object p1

    .line 17
    .line 18
    check-cast p1, Lcom/xj/winemu/api/bean/WineActivityData;

    .line 19
    .line 20
    iput-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->B:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 21
    .line 22
    .line 23
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z1()V

    .line 24
    .line 25
    .line 26
    invoke-virtual {p0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->B1()V

    .line 27
    .line 28
    iget-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->B:Lcom/xj/winemu/api/bean/WineActivityData;

    .line 29
    const/4 v0, 0x0

    .line 30
    .line 31
    if-eqz p1, :cond_0

    .line 32
    .line 33
    .line 34
    invoke-virtual {p1}, Lcom/xj/winemu/api/bean/WineActivityData;->c()Z

    .line 35
    move-result p1

    .line 36
    .line 37
    .line 38
    invoke-static {p1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 39
    move-result-object p1

    .line 40
    goto :goto_0

    .line 41
    :cond_0
    move-object p1, v0

    .line 42
    :goto_0
    const/4 v1, 0x0

    .line 43
    .line 44
    if-eqz p1, :cond_1

    .line 45
    .line 46
    .line 47
    invoke-virtual {p1}, Ljava/lang/Boolean;->booleanValue()Z

    .line 48
    move-result p1

    .line 49
    goto :goto_1

    .line 50
    :cond_1
    move p1, v1

    .line 51
    .line 52
    .line 53
    :goto_1
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 54
    move-result-object v2

    .line 55
    .line 56
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 57
    .line 58
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hdrSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 59
    .line 60
    const-string v3, "hdrSwitch"

    .line 61
    .line 62
    .line 63
    invoke-static {v2, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 64
    .line 65
    const/16 v3, 0x8

    .line 66
    .line 67
    if-nez p1, :cond_2

    .line 68
    move v4, v1

    .line 69
    goto :goto_2

    .line 70
    :cond_2
    move v4, v3

    .line 71
    .line 72
    .line 73
    :goto_2
    invoke-virtual {v2, v4}, Landroid/view/View;->setVisibility(I)V

    .line 74
    .line 75
    .line 76
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 77
    move-result-object v2

    .line 78
    .line 79
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 80
    .line 81
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->crtSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 82
    .line 83
    const-string v4, "crtSwitch"

    .line 84
    .line 85
    .line 86
    invoke-static {v2, v4}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 87
    .line 88
    if-nez p1, :cond_3

    .line 89
    move v4, v1

    .line 90
    goto :goto_3

    .line 91
    :cond_3
    move v4, v3

    .line 92
    .line 93
    .line 94
    :goto_3
    invoke-virtual {v2, v4}, Landroid/view/View;->setVisibility(I)V

    .line 95
    .line 96
    .line 97
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 98
    move-result-object v2

    .line 99
    .line 100
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 101
    .line 102
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->superResolutionSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 103
    .line 104
    const-string v4, "superResolutionSwitch"

    .line 105
    .line 106
    .line 107
    invoke-static {v2, v4}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 108
    .line 109
    if-nez p1, :cond_4

    .line 110
    move p1, v1

    .line 111
    goto :goto_4

    .line 112
    :cond_4
    move p1, v3

    .line 113
    .line 114
    .line 115
    :goto_4
    invoke-virtual {v2, p1}, Landroid/view/View;->setVisibility(I)V

    .line 116
    .line 117
    .line 118
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 119
    move-result-object p1

    .line 120
    .line 121
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 122
    .line 123
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 124
    .line 125
    const-string v2, "calliperProgressFl"

    .line 126
    .line 127
    .line 128
    invoke-static {p1, v2}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 129
    .line 130
    .line 131
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 132
    move-result-object v2

    .line 133
    .line 134
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 135
    .line 136
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->superResolutionSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 137
    .line 138
    .line 139
    invoke-static {v2, v4}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 140
    .line 141
    .line 142
    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    .line 143
    move-result v2

    .line 144
    const/4 v4, 0x1

    .line 145
    .line 146
    if-nez v2, :cond_5

    .line 147
    move v2, v4

    .line 148
    goto :goto_5

    .line 149
    :cond_5
    move v2, v1

    .line 150
    .line 151
    :goto_5
    if-eqz v2, :cond_6

    .line 152
    move v3, v1

    .line 153
    .line 154
    .line 155
    :cond_6
    invoke-virtual {p1, v3}, Landroid/view/View;->setVisibility(I)V

    .line 156
    .line 157
    .line 158
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 159
    move-result-object p1

    .line 160
    .line 161
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 162
    .line 163
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hdrSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 164
    .line 165
    iget-object v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 166
    .line 167
    const-string v3, "wineInGameSettings"

    .line 168
    .line 169
    if-nez v2, :cond_7

    .line 170
    .line 171
    .line 172
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 173
    move-object v2, v0

    .line 174
    .line 175
    .line 176
    :cond_7
    invoke-virtual {v2}, Lcom/xj/winemu/utils/WineInGameSettings;->h()Z

    .line 177
    move-result v2

    .line 178
    .line 179
    .line 180
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 181
    .line 182
    new-instance v2, Lcom/xj/winemu/sidebar/x;

    .line 183
    .line 184
    .line 185
    invoke-direct {v2, p0, p1}, Lcom/xj/winemu/sidebar/x;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V

    .line 186
    .line 187
    .line 188
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    .line 189
    .line 190
    .line 191
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 192
    move-result-object p1

    .line 193
    .line 194
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 195
    .line 196
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->crtSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 197
    .line 198
    iget-object v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 199
    .line 200
    if-nez v2, :cond_8

    .line 201
    .line 202
    .line 203
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 204
    move-object v2, v0

    .line 205
    .line 206
    .line 207
    :cond_8
    invoke-virtual {v2}, Lcom/xj/winemu/utils/WineInGameSettings;->c()Z

    .line 208
    move-result v2

    .line 209
    .line 210
    .line 211
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 212
    .line 213
    new-instance v2, Lcom/xj/winemu/sidebar/u0;

    .line 214
    .line 215
    .line 216
    invoke-direct {v2, p0, p1}, Lcom/xj/winemu/sidebar/u0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V

    .line 217
    .line 218
    .line 219
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    .line 220
    .line 221
    .line 222
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 223
    move-result-object p1

    .line 224
    .line 225
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 226
    .line 227
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->superResolutionSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 228
    .line 229
    iget-object v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 230
    .line 231
    if-nez v2, :cond_9

    .line 232
    .line 233
    .line 234
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 235
    move-object v2, v0

    .line 236
    .line 237
    .line 238
    :cond_9
    invoke-virtual {v2}, Lcom/xj/winemu/utils/WineInGameSettings;->p()Z

    .line 239
    move-result v2

    .line 240
    .line 241
    .line 242
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 243
    .line 244
    new-instance v2, Lcom/xj/winemu/sidebar/y;

    .line 245
    .line 246
    .line 247
    invoke-direct {v2, p0, p1}, Lcom/xj/winemu/sidebar/y;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V

    .line 248
    .line 249
    .line 250
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    .line 251
    .line 252
    .line 253
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 254
    move-result-object v2

    .line 255
    .line 256
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 257
    .line 258
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressTv:Lcom/xj/lib/shape/view/ShapeTextView;

    .line 259
    .line 260
    .line 261
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 262
    move-result v5

    .line 263
    .line 264
    .line 265
    invoke-virtual {v2, v5}, Landroid/view/View;->setSelected(Z)V

    .line 266
    .line 267
    .line 268
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 269
    move-result-object v2

    .line 270
    .line 271
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 272
    .line 273
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 274
    .line 275
    .line 276
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 277
    move-result v5

    .line 278
    .line 279
    .line 280
    invoke-virtual {v2, v5}, Landroid/view/View;->setEnabled(Z)V

    .line 281
    .line 282
    .line 283
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 284
    move-result-object v2

    .line 285
    .line 286
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 287
    .line 288
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgress:Lcom/xj/common/view/CalliperProgress;

    .line 289
    .line 290
    .line 291
    invoke-virtual {p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->getSwitchState()Z

    .line 292
    move-result p1

    .line 293
    .line 294
    .line 295
    invoke-virtual {v2, p1}, Lcom/xj/common/view/CalliperProgress;->setDisabled(Z)V

    .line 296
    .line 297
    .line 298
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 299
    move-result-object p1

    .line 300
    .line 301
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 302
    .line 303
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 304
    .line 305
    new-instance v2, Lcom/xj/winemu/sidebar/z;

    .line 306
    .line 307
    .line 308
    invoke-direct {v2}, Lcom/xj/winemu/sidebar/z;-><init>()V

    .line 309
    .line 310
    .line 311
    invoke-virtual {p1, v2}, Landroid/view/View;->setOnFocusChangeListener(Landroid/view/View$OnFocusChangeListener;)V

    .line 312
    .line 313
    .line 314
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 315
    move-result-object p1

    .line 316
    .line 317
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 318
    .line 319
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 320
    .line 321
    new-instance v2, Lcom/xj/winemu/sidebar/a0;

    .line 322
    .line 323
    .line 324
    invoke-direct {v2, p0}, Lcom/xj/winemu/sidebar/a0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 325
    .line 326
    .line 327
    invoke-virtual {p1, v2}, Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;->setOnFocusEventListener(Lkotlin/jvm/functions/Function1;)V

    .line 328
    .line 329
    .line 330
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 331
    move-result-object p1

    .line 332
    .line 333
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 334
    .line 335
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgressFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 336
    .line 337
    new-instance v2, Lcom/xj/winemu/sidebar/b0;

    .line 338
    .line 339
    .line 340
    invoke-direct {v2, p0}, Lcom/xj/winemu/sidebar/b0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 341
    .line 342
    .line 343
    invoke-virtual {p1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 344
    .line 345
    .line 346
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 347
    move-result-object p1

    .line 348
    .line 349
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 350
    .line 351
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgress:Lcom/xj/common/view/CalliperProgress;

    .line 352
    .line 353
    .line 354
    invoke-virtual {p1, v1}, Lcom/xj/common/view/CalliperProgress;->m(Z)V

    .line 355
    .line 356
    iget-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 357
    .line 358
    if-nez p1, :cond_a

    .line 359
    .line 360
    .line 361
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 362
    move-object p1, v0

    .line 363
    .line 364
    .line 365
    :cond_a
    invoke-virtual {p1}, Lcom/xj/winemu/utils/WineInGameSettings;->o()Lcom/xj/winemu/bean/SuperResolution;

    .line 366
    move-result-object p1

    .line 367
    .line 368
    sget-object v2, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 369
    .line 370
    .line 371
    invoke-virtual {p1}, Lcom/xj/winemu/bean/SuperResolution;->getSharpness()F

    .line 372
    move-result v5

    .line 373
    .line 374
    .line 375
    invoke-virtual {p1}, Lcom/xj/winemu/bean/SuperResolution;->getSharpness()F

    .line 376
    move-result v6

    .line 377
    .line 378
    .line 379
    const v7, 0x3e4ccccd    # 0.2f

    .line 380
    div-float/2addr v6, v7

    .line 381
    float-to-int v6, v6

    .line 382
    .line 383
    new-instance v8, Ljava/lang/StringBuilder;

    .line 384
    .line 385
    .line 386
    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    .line 387
    .line 388
    const-string v9, "\u8d85\u5206\u8fa8\u7387 "

    .line 389
    .line 390
    .line 391
    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 392
    .line 393
    .line 394
    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    .line 395
    .line 396
    const-string v5, " "

    .line 397
    .line 398
    .line 399
    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 400
    .line 401
    .line 402
    invoke-virtual {v8, v6}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 403
    .line 404
    .line 405
    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 406
    move-result-object v5

    .line 407
    .line 408
    .line 409
    invoke-virtual {v2, v5}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 410
    .line 411
    .line 412
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 413
    move-result-object v2

    .line 414
    .line 415
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 416
    .line 417
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgress:Lcom/xj/common/view/CalliperProgress;

    .line 418
    .line 419
    .line 420
    invoke-virtual {p1}, Lcom/xj/winemu/bean/SuperResolution;->getSharpness()F

    .line 421
    move-result p1

    .line 422
    div-float/2addr p1, v7

    .line 423
    float-to-int p1, p1

    .line 424
    const/4 v5, 0x5

    .line 425
    .line 426
    .line 427
    invoke-virtual {v2, v1, v5, v4, p1}, Lcom/xj/common/view/CalliperProgress;->o(IIII)V

    .line 428
    .line 429
    .line 430
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 431
    move-result-object p1

    .line 432
    .line 433
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 434
    .line 435
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->calliperProgress:Lcom/xj/common/view/CalliperProgress;

    .line 436
    .line 437
    new-instance v2, Lcom/xj/winemu/sidebar/c0;

    .line 438
    .line 439
    .line 440
    invoke-direct {v2}, Lcom/xj/winemu/sidebar/c0;-><init>()V

    .line 441
    .line 442
    .line 443
    invoke-virtual {p1, v2}, Lcom/xj/common/view/CalliperProgress;->setOnChangerListener(Lkotlin/jvm/functions/Function2;)V

    .line 444
    .line 445
    .line 446
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 447
    move-result-object p1

    .line 448
    .line 449
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 450
    .line 451
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudSwitch:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 452
    .line 453
    iget-object v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 454
    .line 455
    .line 456
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudShow()Z

    .line 457
    move-result v2

    .line 458
    .line 459
    .line 460
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 461
    .line 462
    iget-object v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 463
    .line 464
    .line 465
    invoke-virtual {v2}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudShow()Z

    .line 466
    move-result v2

    .line 467
    .line 468
    iput-boolean v2, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C:Z

    .line 469
    .line 470
    .line 471
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 472
    move-result-object v2

    .line 473
    .line 474
    check-cast v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 475
    .line 476
    iget-object v2, v2, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudOptionsRv:Lcom/xj/common/view/focus/focus/view/FocusableRecyclerView;

    .line 477
    .line 478
    iget-boolean v6, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->C:Z

    .line 479
    .line 480
    .line 481
    invoke-virtual {v2, v6}, Landroid/view/View;->setEnabled(Z)V

    .line 482
    .line 483
    new-instance v2, Lcom/xj/winemu/sidebar/d0;

    .line 484
    .line 485
    .line 486
    invoke-direct {v2, p0, p1}, Lcom/xj/winemu/sidebar/d0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V

    .line 487
    .line 488
    .line 489
    invoke-virtual {p1, v2}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    .line 490
    .line 491
    .line 492
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 493
    move-result-object p1

    .line 494
    .line 495
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 496
    .line 497
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 498
    .line 499
    .line 500
    invoke-virtual {p1, v1}, Lcom/xj/winemu/view/SidebarProgressItemView;->D(Z)V

    .line 501
    .line 502
    iget-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 503
    .line 504
    if-nez p1, :cond_b

    .line 505
    .line 506
    .line 507
    invoke-static {v3}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 508
    move-object p1, v0

    .line 509
    .line 510
    .line 511
    :cond_b
    invoke-virtual {p1}, Lcom/xj/winemu/utils/WineInGameSettings;->d()Lcom/xj/winemu/bean/FpsLimit;

    .line 512
    move-result-object p1

    .line 513
    .line 514
    .line 515
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 516
    move-result-object v1

    .line 517
    .line 518
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 519
    .line 520
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 521
    .line 522
    .line 523
    invoke-virtual {p1}, Lcom/xj/winemu/bean/FpsLimit;->getEnable()Z

    .line 524
    move-result v2

    .line 525
    xor-int/2addr v2, v4

    .line 526
    .line 527
    .line 528
    invoke-virtual {v1, v2}, Lcom/xj/winemu/view/SidebarProgressItemView;->setDisabled(Z)V

    .line 529
    .line 530
    .line 531
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 532
    move-result-object v1

    .line 533
    .line 534
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 535
    .line 536
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 537
    .line 538
    .line 539
    invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    .line 540
    move-result-object v1

    .line 541
    .line 542
    instance-of v2, v1, Landroid/view/View;

    .line 543
    .line 544
    if-eqz v2, :cond_c

    .line 545
    move-object v0, v1

    .line 546
    .line 547
    check-cast v0, Landroid/view/View;

    .line 548
    .line 549
    :cond_c
    if-eqz v0, :cond_d

    .line 550
    .line 551
    .line 552
    invoke-virtual {p1}, Lcom/xj/winemu/bean/FpsLimit;->getEnable()Z

    .line 553
    move-result v1

    .line 554
    .line 555
    .line 556
    invoke-virtual {v0, v1}, Landroid/view/View;->setEnabled(Z)V

    .line 557
    .line 558
    .line 559
    :cond_d
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 560
    move-result-object v0

    .line 561
    .line 562
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 563
    .line 564
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 565
    .line 566
    .line 567
    invoke-virtual {p1}, Lcom/xj/winemu/bean/FpsLimit;->getFpsLimit()I

    .line 568
    move-result v1

    .line 569
    .line 570
    .line 571
    invoke-virtual {v0, v1}, Lcom/xj/winemu/view/SidebarProgressItemView;->setProgress(I)V

    .line 572
    .line 573
    .line 574
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 575
    move-result-object v0

    .line 576
    .line 577
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 578
    .line 579
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->frameRateLimitProgress:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 580
    .line 581
    new-instance v1, Lcom/xj/winemu/sidebar/e0;

    .line 582
    .line 583
    .line 584
    invoke-direct {v1}, Lcom/xj/winemu/sidebar/e0;-><init>()V

    .line 585
    .line 586
    .line 587
    invoke-virtual {v0, v1}, Lcom/xj/winemu/view/SidebarProgressItemView;->setProgressListener(Lkotlin/jvm/functions/Function2;)V

    .line 588
    .line 589
    .line 590
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 591
    move-result-object v0

    .line 592
    .line 593
    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 594
    .line 595
    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->switchFrameRateLimit:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 596
    .line 597
    .line 598
    invoke-virtual {p1}, Lcom/xj/winemu/bean/FpsLimit;->getEnable()Z

    .line 599
    move-result p1

    .line 600
    .line 601
    .line 602
    invoke-virtual {v0, p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 603
    .line 604
    new-instance p1, Lcom/xj/winemu/sidebar/f0;

    .line 605
    .line 606
    .line 607
    invoke-direct {p1, p0, v0}, Lcom/xj/winemu/sidebar/f0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V

    .line 608
    .line 609
    .line 610
    invoke-virtual {v0, p1}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    .line 611
    .line 612
    .line 613
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 614
    move-result-object p1

    .line 615
    .line 616
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 617
    .line 618
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->switchDualBatteryMode:Lcom/xj/winemu/view/SidebarSwitchItemView;

    .line 619
    .line 620
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 621
    .line 622
    .line 623
    invoke-virtual {v0}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 624
    move-result-object v0

    .line 625
    .line 626
    .line 627
    invoke-virtual {v0}, Lcom/winemu/ui/HUDConfig;->a()Z

    .line 628
    move-result v0

    .line 629
    .line 630
    .line 631
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    .line 632
    .line 633
    new-instance v0, Lcom/xj/winemu/sidebar/i0;

    .line 634
    .line 635
    .line 636
    invoke-direct {v0, p0, p1}, Lcom/xj/winemu/sidebar/i0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lcom/xj/winemu/view/SidebarSwitchItemView;)V

    .line 637
    .line 638
    .line 639
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    .line 640
    .line 641
    .line 642
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 643
    move-result-object p1

    .line 644
    .line 645
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 646
    .line 647
    iget-object v6, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudOptionsRv:Lcom/xj/common/view/focus/focus/view/FocusableRecyclerView;

    .line 648
    .line 649
    new-instance p1, Ljava/util/ArrayList;

    .line 650
    .line 651
    .line 652
    invoke-direct {p1}, Ljava/util/ArrayList;-><init>()V

    .line 653
    .line 654
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 655
    .line 656
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 657
    .line 658
    .line 659
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 660
    move-result-object v1

    .line 661
    .line 662
    .line 663
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->b()Z

    .line 664
    move-result v1

    .line 665
    .line 666
    const-string v2, "CPU"

    .line 667
    .line 668
    .line 669
    invoke-direct {v0, v4, v2, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 670
    .line 671
    .line 672
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 673
    .line 674
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 675
    .line 676
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 677
    .line 678
    .line 679
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 680
    move-result-object v1

    .line 681
    .line 682
    .line 683
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->e()Z

    .line 684
    move-result v1

    .line 685
    const/4 v2, 0x2

    .line 686
    .line 687
    const-string v3, "GPU"

    .line 688
    .line 689
    .line 690
    invoke-direct {v0, v2, v3, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 691
    .line 692
    .line 693
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 694
    .line 695
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 696
    .line 697
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 698
    .line 699
    .line 700
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 701
    move-result-object v1

    .line 702
    .line 703
    .line 704
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->f()Z

    .line 705
    move-result v1

    .line 706
    const/4 v2, 0x3

    .line 707
    .line 708
    const-string v3, "Power"

    .line 709
    .line 710
    .line 711
    invoke-direct {v0, v2, v3, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 712
    .line 713
    .line 714
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 715
    .line 716
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 717
    .line 718
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 719
    .line 720
    .line 721
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 722
    move-result-object v1

    .line 723
    .line 724
    .line 725
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->c()Z

    .line 726
    move-result v1

    .line 727
    const/4 v2, 0x4

    .line 728
    .line 729
    const-string v3, "FPS"

    .line 730
    .line 731
    .line 732
    invoke-direct {v0, v2, v3, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 733
    .line 734
    .line 735
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 736
    .line 737
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 738
    .line 739
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 740
    .line 741
    .line 742
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 743
    move-result-object v1

    .line 744
    .line 745
    .line 746
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->d()Z

    .line 747
    move-result v1

    .line 748
    .line 749
    const-string v2, "Graph"

    .line 750
    .line 751
    .line 752
    invoke-direct {v0, v5, v2, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 753
    .line 754
    .line 755
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 756
    .line 757
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 758
    .line 759
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 760
    .line 761
    .line 762
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 763
    move-result-object v1

    .line 764
    .line 765
    .line 766
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->g()Z

    .line 767
    move-result v1

    .line 768
    const/4 v2, 0x6

    .line 769
    .line 770
    const-string v3, "RAM"

    .line 771
    .line 772
    .line 773
    invoke-direct {v0, v2, v3, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 774
    .line 775
    .line 776
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 777
    .line 778
    new-instance v0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;

    .line 779
    .line 780
    iget-object v1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->o:Lcom/xj/winemu/bean/PcEmuGameLocalConfig;

    .line 781
    .line 782
    .line 783
    invoke-virtual {v1}, Lcom/xj/winemu/bean/PcEmuGameLocalConfig;->getHudConfig()Lcom/winemu/ui/HUDConfig;

    .line 784
    move-result-object v1

    .line 785
    .line 786
    .line 787
    invoke-virtual {v1}, Lcom/winemu/ui/HUDConfig;->h()Z

    .line 788
    move-result v1

    .line 789
    const/4 v2, 0x7

    .line 790
    .line 791
    const-string v3, "TMP"

    .line 792
    .line 793
    .line 794
    invoke-direct {v0, v2, v3, v1}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment$RbOption;-><init>(ILjava/lang/String;Z)V

    .line 795
    .line 796
    .line 797
    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 798
    .line 799
    new-instance v0, Lcom/xj/winemu/sidebar/n0;

    .line 800
    .line 801
    .line 802
    invoke-direct {v0, p0}, Lcom/xj/winemu/sidebar/n0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 803
    .line 804
    .line 805
    invoke-static {v6}, Lkotlin/jvm/internal/Intrinsics;->d(Ljava/lang/Object;)V

    .line 806
    .line 807
    const/16 v11, 0xe

    .line 808
    const/4 v12, 0x0

    .line 809
    const/4 v7, 0x2

    .line 810
    const/4 v8, 0x0

    .line 811
    const/4 v9, 0x0

    .line 812
    const/4 v10, 0x0

    .line 813
    .line 814
    .line 815
    invoke-static/range {v6 .. v12}, Lcom/drake/brv/utils/RecyclerUtilsKt;->i(Landroidx/recyclerview/widget/RecyclerView;IIZZILjava/lang/Object;)Landroidx/recyclerview/widget/RecyclerView;

    .line 816
    .line 817
    new-instance v1, Lcom/xj/winemu/sidebar/o0;

    .line 818
    .line 819
    .line 820
    invoke-direct {v1, p0, v0}, Lcom/xj/winemu/sidebar/o0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Lkotlin/jvm/functions/Function1;)V

    .line 821
    .line 822
    .line 823
    invoke-static {v6, v1}, Lcom/drake/brv/utils/RecyclerUtilsKt;->m(Landroidx/recyclerview/widget/RecyclerView;Lkotlin/jvm/functions/Function2;)Lcom/drake/brv/BindingAdapter;

    .line 824
    move-result-object v0

    .line 825
    .line 826
    .line 827
    invoke-virtual {v0, p1}, Lcom/drake/brv/BindingAdapter;->Z(Ljava/util/List;)V

    .line 828
    .line 829
    .line 830
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 831
    move-result-object p1

    .line 832
    .line 833
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 834
    .line 835
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudBgTransparency:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 836
    .line 837
    const-string v0, "%"

    .line 838
    .line 839
    .line 840
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarProgressItemView;->setProcessTextSuffix(Ljava/lang/String;)V

    .line 841
    .line 842
    .line 843
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 844
    move-result-object p1

    .line 845
    .line 846
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 847
    .line 848
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudBgTransparency:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 849
    .line 850
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x:Ljava/lang/String;

    .line 851
    .line 852
    .line 853
    invoke-static {v0}, Lcom/xj/pcvirtualbtn/inputcontrols/InputControlsManager;->v(Ljava/lang/String;)F

    .line 854
    move-result v0

    .line 855
    .line 856
    const/16 v1, 0x64

    .line 857
    int-to-float v1, v1

    .line 858
    mul-float/2addr v0, v1

    .line 859
    float-to-int v0, v0

    .line 860
    .line 861
    .line 862
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarProgressItemView;->setProgress(I)V

    .line 863
    .line 864
    .line 865
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 866
    move-result-object p1

    .line 867
    .line 868
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 869
    .line 870
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->hudBgTransparency:Lcom/xj/winemu/view/SidebarProgressItemView;

    .line 871
    .line 872
    new-instance v0, Lcom/xj/winemu/sidebar/p0;

    .line 873
    .line 874
    .line 875
    invoke-direct {v0, p0}, Lcom/xj/winemu/sidebar/p0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 876
    .line 877
    .line 878
    invoke-virtual {p1, v0}, Lcom/xj/winemu/view/SidebarProgressItemView;->setProgressListener(Lkotlin/jvm/functions/Function2;)V

    .line 879
    .line 880
    .line 881
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 882
    move-result-object p1

    .line 883
    .line 884
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 885
    .line 886
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 887
    .line 888
    new-instance v0, Lcom/xj/winemu/sidebar/q0;

    .line 889
    .line 890
    .line 891
    invoke-direct {v0, p0}, Lcom/xj/winemu/sidebar/q0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 892
    .line 893
    .line 894
    invoke-virtual {p1, v0}, Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;->setOnFocusedChangedListener(Lkotlin/jvm/functions/Function1;)V

    .line 895
    .line 896
    .line 897
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 898
    move-result-object p1

    .line 899
    .line 900
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 901
    .line 902
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    .line 903
    .line 904
    new-instance v0, Lcom/xj/winemu/sidebar/r0;

    .line 905
    .line 906
    .line 907
    invoke-direct {v0, p0}, Lcom/xj/winemu/sidebar/r0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 908
    .line 909
    .line 910
    invoke-virtual {p1, v0}, Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;->setOnFocusEventListener(Lkotlin/jvm/functions/Function1;)V

    .line 911
    .line 912
    .line 913
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 914
    move-result-object p1

    .line 915
    .line 916
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 917
    .line 918
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceNsv:Lcom/xj/common/view/focus/focus/view/FocusableNestedScrollView;

    .line 919
    .line 920
    new-instance v0, Lcom/xj/winemu/sidebar/s0;

    .line 921
    .line 922
    .line 923
    invoke-direct {v0, p0}, Lcom/xj/winemu/sidebar/s0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 924
    .line 925
    .line 926
    invoke-virtual {p1, v0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 927
    .line 928
    .line 929
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 930
    move-result-object p1

    .line 931
    .line 932
    check-cast p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 933
    .line 934
    iget-object p1, p1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceNsv:Lcom/xj/common/view/focus/focus/view/FocusableNestedScrollView;

    .line 935
    .line 936
    new-instance v0, Lcom/xj/winemu/sidebar/t0;

    .line 937
    .line 938
    .line 939
    invoke-direct {v0, p0}, Lcom/xj/winemu/sidebar/t0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;)V

    .line 940
    .line 941
    .line 942
    invoke-virtual {p1, v0}, Landroid/view/View;->setOnScrollChangeListener(Landroid/view/View$OnScrollChangeListener;)V

    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    move-result-object v0

    check-cast v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    iget-object v0, v0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->performanceFl:Lcom/xj/common/view/focus/focus/view/FocusableLinearLayout;

    invoke-static {v0}, Lapp/revanced/extension/gamehub/ui/PerformanceMetricsHelper;->initMetrics(Landroid/view/ViewGroup;)V

    .line 943
    return-void
.end method

.method public o0()I
    .locals 0

    .line 1
    .line 2
    sget p0, Lcom/xj/winemu/R$layout;->winemu_sidebar_hub_type_fragment:I

    .line 3
    return p0
.end method

.method public onCreate(Landroid/os/Bundle;)V
    .locals 2

    .line 1
    .line 2
    .line 3
    invoke-super {p0, p1}, Landroidx/fragment/app/Fragment;->onCreate(Landroid/os/Bundle;)V

    .line 4
    .line 5
    .line 6
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getArguments()Landroid/os/Bundle;

    .line 7
    move-result-object p1

    .line 8
    .line 9
    if-eqz p1, :cond_1

    .line 10
    .line 11
    const-string v0, "gameId"

    .line 12
    .line 13
    .line 14
    invoke-virtual {p1, v0}, Landroid/os/BaseBundle;->getString(Ljava/lang/String;)Ljava/lang/String;

    .line 15
    move-result-object p1

    .line 16
    .line 17
    iput-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x:Ljava/lang/String;

    .line 18
    .line 19
    new-instance p1, Lcom/xj/winemu/utils/WineInGameSettings;

    .line 20
    .line 21
    iget-object v0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x:Ljava/lang/String;

    .line 22
    .line 23
    if-nez v0, :cond_0

    .line 24
    .line 25
    const-string v0, ""

    .line 26
    .line 27
    .line 28
    :cond_0
    invoke-direct {p1, v0}, Lcom/xj/winemu/utils/WineInGameSettings;-><init>(Ljava/lang/String;)V

    .line 29
    .line 30
    iput-object p1, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 31
    .line 32
    sget-object p1, Lcom/xj/common/utils/LogA;->a:Lcom/xj/common/utils/LogA;

    .line 33
    .line 34
    iget-object p0, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->x:Ljava/lang/String;

    .line 35
    .line 36
    new-instance v0, Ljava/lang/StringBuilder;

    .line 37
    .line 38
    .line 39
    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 40
    .line 41
    const-string v1, "\u6027\u80fd\u9875\u62ff\u5230\u4e86gameid "

    .line 42
    .line 43
    .line 44
    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 45
    .line 46
    .line 47
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 48
    .line 49
    .line 50
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    .line 51
    move-result-object p0

    .line 52
    .line 53
    .line 54
    invoke-virtual {p1, p0}, Lcom/xj/common/utils/LogA;->b(Ljava/lang/String;)V

    .line 55
    :cond_1
    return-void
.end method

.method public u0()I
    .locals 0

    .line 1
    const/4 p0, -0x1

    .line 2
    return p0
.end method

.method public final w1(Ljava/util/List;)V
    .locals 5

    .line 1
    .line 2
    new-instance v0, Ljava/util/ArrayList;

    .line 3
    .line 4
    const/16 v1, 0xa

    .line 5
    .line 6
    .line 7
    invoke-static {p1, v1}, Lkotlin/collections/CollectionsKt;->A(Ljava/lang/Iterable;I)I

    .line 8
    move-result v1

    .line 9
    .line 10
    .line 11
    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 12
    .line 13
    .line 14
    invoke-interface {p1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 15
    move-result-object p1

    .line 16
    .line 17
    .line 18
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 19
    move-result v1

    .line 20
    .line 21
    if-eqz v1, :cond_2

    .line 22
    .line 23
    .line 24
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 25
    move-result-object v1

    .line 26
    .line 27
    check-cast v1, Lcom/xj/winemu/bean/NativeRenderingMode;

    .line 28
    .line 29
    new-instance v2, Lcom/xj/winemu/bean/CollapseItemMenu;

    .line 30
    .line 31
    .line 32
    invoke-virtual {v1}, Lcom/xj/winemu/bean/NativeRenderingMode;->getModeName()Ljava/lang/String;

    .line 33
    move-result-object v3

    .line 34
    .line 35
    iget-object v4, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 36
    .line 37
    if-nez v4, :cond_0

    .line 38
    .line 39
    const-string v4, "wineInGameSettings"

    .line 40
    .line 41
    .line 42
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 43
    const/4 v4, 0x0

    .line 44
    .line 45
    .line 46
    :cond_0
    invoke-virtual {v4}, Lcom/xj/winemu/utils/WineInGameSettings;->j()Lcom/xj/winemu/bean/NativeRenderingMode;

    .line 47
    move-result-object v4

    .line 48
    .line 49
    if-ne v4, v1, :cond_1

    .line 50
    const/4 v1, 0x1

    .line 51
    goto :goto_1

    .line 52
    :cond_1
    const/4 v1, 0x0

    .line 53
    .line 54
    .line 55
    :goto_1
    invoke-direct {v2, v3, v1}, Lcom/xj/winemu/bean/CollapseItemMenu;-><init>(Ljava/lang/String;Z)V

    .line 56
    .line 57
    .line 58
    invoke-interface {v0, v2}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z

    .line 59
    goto :goto_0

    .line 60
    .line 61
    .line 62
    :cond_2
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 63
    move-result-object p0

    .line 64
    .line 65
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 66
    .line 67
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->nativeRendering:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 68
    .line 69
    .line 70
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/CollapseMenuSettingView;->H(Ljava/util/List;)Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 71
    return-void
.end method

.method public final x1(Ljava/util/List;)V
    .locals 5

    .line 1
    .line 2
    new-instance v0, Ljava/util/ArrayList;

    .line 3
    .line 4
    const/16 v1, 0xa

    .line 5
    .line 6
    .line 7
    invoke-static {p1, v1}, Lkotlin/collections/CollectionsKt;->A(Ljava/lang/Iterable;I)I

    .line 8
    move-result v1

    .line 9
    .line 10
    .line 11
    invoke-direct {v0, v1}, Ljava/util/ArrayList;-><init>(I)V

    .line 12
    .line 13
    .line 14
    invoke-interface {p1}, Ljava/lang/Iterable;->iterator()Ljava/util/Iterator;

    .line 15
    move-result-object p1

    .line 16
    .line 17
    .line 18
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 19
    move-result v1

    .line 20
    .line 21
    if-eqz v1, :cond_2

    .line 22
    .line 23
    .line 24
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 25
    move-result-object v1

    .line 26
    .line 27
    check-cast v1, Lcom/xj/winemu/bean/RedMagicPerformanceMode;

    .line 28
    .line 29
    new-instance v2, Lcom/xj/winemu/bean/CollapseItemMenu;

    .line 30
    .line 31
    .line 32
    invoke-virtual {v1}, Lcom/xj/winemu/bean/RedMagicPerformanceMode;->getModeName()Ljava/lang/String;

    .line 33
    move-result-object v3

    .line 34
    .line 35
    iget-object v4, p0, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->z:Lcom/xj/winemu/utils/WineInGameSettings;

    .line 36
    .line 37
    if-nez v4, :cond_0

    .line 38
    .line 39
    const-string v4, "wineInGameSettings"

    .line 40
    .line 41
    .line 42
    invoke-static {v4}, Lkotlin/jvm/internal/Intrinsics;->y(Ljava/lang/String;)V

    .line 43
    const/4 v4, 0x0

    .line 44
    .line 45
    .line 46
    :cond_0
    invoke-virtual {v4}, Lcom/xj/winemu/utils/WineInGameSettings;->m()Lcom/xj/winemu/bean/RedMagicPerformanceMode;

    .line 47
    move-result-object v4

    .line 48
    .line 49
    .line 50
    invoke-virtual {v4}, Lcom/xj/winemu/bean/RedMagicPerformanceMode;->getValue()I

    .line 51
    move-result v4

    .line 52
    .line 53
    .line 54
    invoke-virtual {v1}, Lcom/xj/winemu/bean/RedMagicPerformanceMode;->getValue()I

    .line 55
    move-result v1

    .line 56
    .line 57
    if-ne v4, v1, :cond_1

    .line 58
    const/4 v1, 0x1

    .line 59
    goto :goto_1

    .line 60
    :cond_1
    const/4 v1, 0x0

    .line 61
    .line 62
    .line 63
    :goto_1
    invoke-direct {v2, v3, v1}, Lcom/xj/winemu/bean/CollapseItemMenu;-><init>(Ljava/lang/String;Z)V

    .line 64
    .line 65
    .line 66
    invoke-interface {v0, v2}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z

    .line 67
    goto :goto_0

    .line 68
    .line 69
    .line 70
    :cond_2
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 71
    move-result-object p0

    .line 72
    .line 73
    check-cast p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 74
    .line 75
    iget-object p0, p0, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->redmagicPerformanceMode:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 76
    .line 77
    .line 78
    invoke-virtual {p0, v0}, Lcom/xj/winemu/view/CollapseMenuSettingView;->H(Ljava/util/List;)Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 79
    return-void
.end method

.method public final y1(Landroid/widget/ImageView;Z)V
    .locals 0

    .line 1
    .line 2
    if-eqz p2, :cond_0

    .line 3
    .line 4
    sget p0, Lcom/xj/winemu/R$drawable;->win_blue_check:I

    .line 5
    .line 6
    .line 7
    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 8
    return-void

    .line 9
    .line 10
    :cond_0
    sget p0, Lcom/xj/winemu/R$drawable;->win_blue_uncheck:I

    .line 11
    .line 12
    .line 13
    invoke-virtual {p1, p0}, Landroid/widget/ImageView;->setImageResource(I)V

    .line 14
    return-void
.end method

.method public final z1()V
    .locals 4

    .line 1
    .line 2
    sget-object v0, Lcom/xj/winemu/bean/NativeRendering;->Companion:Lcom/xj/winemu/bean/NativeRendering$Companion;

    .line 3
    .line 4
    .line 5
    invoke-virtual {v0}, Lcom/xj/winemu/bean/NativeRendering$Companion;->getOptions()Ljava/util/List;

    .line 6
    move-result-object v0

    .line 7
    .line 8
    .line 9
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 10
    move-result-object v1

    .line 11
    .line 12
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 13
    .line 14
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->nativeRendering:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 15
    .line 16
    sget v2, Lcom/xj/language/R$string;->native_rendering_plus:I

    .line 17
    .line 18
    .line 19
    invoke-virtual {p0, v2}, Landroidx/fragment/app/Fragment;->getString(I)Ljava/lang/String;

    .line 20
    move-result-object v2

    .line 21
    .line 22
    const-string v3, "getString(...)"

    .line 23
    .line 24
    .line 25
    invoke-static {v2, v3}, Lkotlin/jvm/internal/Intrinsics;->f(Ljava/lang/Object;Ljava/lang/String;)V

    .line 26
    .line 27
    .line 28
    invoke-virtual {v1, v2}, Lcom/xj/winemu/view/CollapseMenuSettingView;->J(Ljava/lang/String;)Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 29
    .line 30
    .line 31
    invoke-virtual {p0}, Lcom/xj/base/base/fragment/BaseVmFragment;->e0()Landroidx/databinding/ViewDataBinding;

    .line 32
    move-result-object v1

    .line 33
    .line 34
    check-cast v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;

    .line 35
    .line 36
    iget-object v1, v1, Lcom/xj/winemu/databinding/WinemuSidebarHubTypeFragmentBinding;->nativeRendering:Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 37
    .line 38
    new-instance v2, Lcom/xj/winemu/sidebar/g0;

    .line 39
    .line 40
    .line 41
    invoke-direct {v2, p0, v0}, Lcom/xj/winemu/sidebar/g0;-><init>(Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;Ljava/util/List;)V

    .line 42
    .line 43
    .line 44
    invoke-virtual {v1, v2}, Lcom/xj/winemu/view/CollapseMenuSettingView;->I(Lkotlin/jvm/functions/Function2;)Lcom/xj/winemu/view/CollapseMenuSettingView;

    .line 45
    .line 46
    .line 47
    invoke-virtual {p0, v0}, Lcom/xj/winemu/sidebar/SidebarPerformanceFragment;->w1(Ljava/util/List;)V

    .line 48

    # --- BannerHub: Sustained Perf + Max Adreno Clocks toggles ---
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getView()Landroid/view/View;
    move-result-object v0
    if-eqz v0, :cond_bh_perf_done

    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v1
    if-eqz v1, :cond_bh_perf_done

    const-string v2, "bh_prefs"
    const/4 v3, 0x0
    invoke-virtual {v1, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v2

    # Sustained Perf switch
    const v1, 0x7f0a0f0e
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Lcom/xj/winemu/view/SidebarSwitchItemView;
    if-eqz v1, :cond_bh_adreno

    const-string v3, "sustained_perf"
    const/4 v0, 0x0
    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    invoke-virtual {v1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    new-instance v3, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;
    invoke-direct {v3, v1}, Lcom/xj/winemu/sidebar/SustainedPerfSwitchClickListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    invoke-virtual {v1, v3}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    # Max Adreno Clocks switch
    :cond_bh_adreno
    invoke-virtual {p0}, Landroidx/fragment/app/Fragment;->getView()Landroid/view/View;
    move-result-object v0
    if-eqz v0, :cond_bh_perf_done

    const v1, 0x7f0a0f0f
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;
    move-result-object v1
    check-cast v1, Lcom/xj/winemu/view/SidebarSwitchItemView;
    if-eqz v1, :cond_bh_perf_done

    const-string v3, "max_adreno_clocks"
    const/4 v0, 0x0
    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z
    move-result v0
    invoke-virtual {v1, v0}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setSwitch(Z)V

    new-instance v3, Lcom/xj/winemu/sidebar/MaxAdrenoClickListener;
    invoke-direct {v3, v1}, Lcom/xj/winemu/sidebar/MaxAdrenoClickListener;-><init>(Lcom/xj/winemu/view/SidebarSwitchItemView;)V
    invoke-virtual {v1, v3}, Lcom/xj/winemu/view/SidebarSwitchItemView;->setClickListener(Lkotlin/jvm/functions/Function0;)V

    :cond_bh_perf_done
    # --- end BannerHub Performance toggles ---

    return-void
.end method
