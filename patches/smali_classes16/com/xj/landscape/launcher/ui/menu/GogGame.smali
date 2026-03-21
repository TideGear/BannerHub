.class public Lcom/xj/landscape/launcher/ui/menu/GogGame;
.super Ljava/lang/Object;

# BannerHub: Data holder for a single GOG game parsed from
# embed.gog.com/account/getFilteredProducts API response.
# imageUrl is already prefixed with "https:".
# storeUrl is already prefixed with "https://www.gog.com".
# rating is a String integer out of 100 (GOG's internal 0-100 scale).

.field public title:Ljava/lang/String;
.field public imageUrl:Ljava/lang/String;
.field public gameId:Ljava/lang/String;
.field public storeUrl:Ljava/lang/String;
.field public category:Ljava/lang/String;
.field public rating:Ljava/lang/String;
.field public dlcCount:Ljava/lang/String;


.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
