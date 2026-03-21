.class public final Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;
.super Ljava/lang/Object;

# BannerHub: Background fetch Runnable for GogGamesFragment.
# GETs embed.gog.com/account/getFilteredProducts?mediaType=1&sortBy=title
# with Bearer auth. Parses each product into a GogGame object:
#   id, title, image (https:-prefixed), url (https://www.gog.com-prefixed),
#   category, rating, dlcCount.
# Posts ArrayList<GogGame> to main thread via GogGamesFragment$2.
# On non-200 response: clears access_token from bh_gog_prefs, posts null.
# On exception: posts empty ArrayList.

.implements Ljava/lang/Runnable;

.field public final a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
.field public final b:Ljava/lang/String;  # accessToken


.method public constructor <init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/lang/String;)V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput-object p1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iput-object p2, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->b:Ljava/lang/String;

    return-void
.end method


.method public run()V
    .locals 16

    # v0 = fragment, v1 = accessToken, v2 = ArrayList<GogGame>
    iget-object v0, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->a:Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;
    iget-object v1, p0, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$1;->b:Ljava/lang/String;

    new-instance v2, Ljava/util/ArrayList;
    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    :try_start

    # Open connection
    new-instance v3, Ljava/net/URL;
    const-string v4, "https://embed.gog.com/account/getFilteredProducts?mediaType=1&sortBy=title"
    invoke-direct {v3, v4}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;
    move-result-object v3
    check-cast v3, Ljava/net/HttpURLConnection;

    # Timeouts: 15 s
    const/16 v4, 0x3a98
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V
    invoke-virtual {v3, v4}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    # Authorization: Bearer <token>
    const-string v4, "Authorization"
    new-instance v5, Ljava/lang/StringBuilder;
    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V
    const-string v6, "Bearer "
    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v5
    invoke-virtual {v3, v4, v5}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    # Check HTTP response code
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getResponseCode()I
    move-result v4
    const/16 v5, 0xC8  # 200
    if-eq v4, v5, :ok_200

    # Non-200 (e.g. 401 expired): clear token, post null
    invoke-virtual {v0}, Landroidx/fragment/app/Fragment;->getContext()Landroid/content/Context;
    move-result-object v4
    if-eqz v4, :expired_disconnect
    const-string v5, "bh_gog_prefs"
    const/4 v6, 0x0
    invoke-virtual {v4, v5, v6}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    const-string v6, "access_token"
    invoke-interface {v5, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;
    move-result-object v5
    invoke-interface {v5}, Landroid/content/SharedPreferences$Editor;->apply()V
    :expired_disconnect
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    const/4 v2, 0x0
    goto :post_ui

    :ok_200
    # Read response body into v7 (JSON string)
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;
    move-result-object v4
    new-instance v5, Ljava/io/InputStreamReader;
    const-string v6, "UTF-8"
    invoke-direct {v5, v4, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V
    new-instance v6, Ljava/io/BufferedReader;
    invoke-direct {v6, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    new-instance v7, Ljava/lang/StringBuilder;
    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    :read_loop
    invoke-virtual {v6}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;
    move-result-object v8
    if-eqz v8, :read_done
    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    goto :read_loop

    :read_done
    invoke-virtual {v6}, Ljava/io/BufferedReader;->close()V
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V
    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v7  # v7 = full JSON string

    # --- Parse products ---
    # v8  = current GogGame being built
    # v9  = scan position (advances monotonically through JSON)
    # v10 = indexOf result / value start
    # v11 = key length / comma end
    # v12 = search key string / brace end
    # v13 = extracted value string
    # v14 = StringBuilder for URL prefixing / second end candidate
    # v15 = -1 (not-found sentinel)

    const/4 v9, 0x0
    const/4 v15, -0x1

    :parse_loop

    # 1. "id":N  (integer — no quotes)
    const-string v12, "\"id\":"
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11          # v10 = first digit of id
    const-string v12, ","
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    const-string v12, "}"
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v14
    if-ge v11, v14, :id_brace
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    move v9, v11
    goto :id_done
    :id_brace
    invoke-virtual {v7, v10, v14}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    move v9, v14
    :id_done

    new-instance v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;
    invoke-direct {v8}, Lcom/xj/landscape/launcher/ui/menu/GogGame;-><init>()V
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->gameId:Ljava/lang/String;

    # 2. "title":"VALUE"
    const-string v12, "\"title\":\""
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11
    const-string v12, "\""
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    if-eq v11, v15, :parse_done
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->title:Ljava/lang/String;
    add-int/lit8 v9, v11, 0x1

    # 3. "image":"VALUE"  -> prepend "https:"
    const-string v12, "\"image\":\""
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11
    const-string v12, "\""
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    if-eq v11, v15, :parse_done
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V
    const-string v12, "https:"
    invoke-virtual {v14, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v13
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->imageUrl:Ljava/lang/String;
    add-int/lit8 v9, v11, 0x1

    # 4. "url":"VALUE"  -> prepend "https://www.gog.com"
    const-string v12, "\"url\":\""
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11
    const-string v12, "\""
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    if-eq v11, v15, :parse_done
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    new-instance v14, Ljava/lang/StringBuilder;
    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V
    const-string v12, "https://www.gog.com"
    invoke-virtual {v14, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    move-result-object v13
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->storeUrl:Ljava/lang/String;
    add-int/lit8 v9, v11, 0x1

    # 5. "category":"VALUE"
    const-string v12, "\"category\":\""
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11
    const-string v12, "\""
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    if-eq v11, v15, :parse_done
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->category:Ljava/lang/String;
    add-int/lit8 v9, v11, 0x1

    # 6. "rating":N  (integer)
    const-string v12, "\"rating\":"
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11
    const-string v12, ","
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    const-string v12, "}"
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v14
    if-ge v11, v14, :rating_brace
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    move v9, v11
    goto :rating_done
    :rating_brace
    invoke-virtual {v7, v10, v14}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    move v9, v14
    :rating_done
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->rating:Ljava/lang/String;

    # 7. "dlcCount":N  (integer)
    const-string v12, "\"dlcCount\":"
    invoke-virtual {v7, v12, v9}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v10
    if-eq v10, v15, :parse_done
    invoke-virtual {v12}, Ljava/lang/String;->length()I
    move-result v11
    add-int v10, v10, v11
    const-string v12, ","
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v11
    const-string v12, "}"
    invoke-virtual {v7, v12, v10}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I
    move-result v14
    if-ge v11, v14, :dlc_brace
    invoke-virtual {v7, v10, v11}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    move v9, v11
    goto :dlc_done
    :dlc_brace
    invoke-virtual {v7, v10, v14}, Ljava/lang/String;->substring(II)Ljava/lang/String;
    move-result-object v13
    move v9, v14
    :dlc_done
    iput-object v13, v8, Lcom/xj/landscape/launcher/ui/menu/GogGame;->dlcCount:Ljava/lang/String;

    invoke-virtual {v2, v8}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z
    goto :parse_loop

    :parse_done

    :try_end

    :post_ui
    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;
    move-result-object v3

    new-instance v4, Landroid/os/Handler;
    invoke-direct {v4, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;
    invoke-direct {v3, v0, v2}, Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment$2;-><init>(Lcom/xj/landscape/launcher/ui/menu/GogGamesFragment;Ljava/util/ArrayList;)V

    invoke-virtual {v4, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    .catch Ljava/lang/Exception; {:try_start .. :try_end} :catch_all

    :catch_all
    goto :post_ui

.end method
