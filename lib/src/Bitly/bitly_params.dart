///
/// https://dev.bitly.com/api-reference#createFullBitlink
///
class BitlyParams {
  String? longUrl;
  String? domain;
  String? groupId;
  String? title;
  List<String>? tags;
  List<DeeplinkParams>? deeplinks;

  BitlyParams({
    this.longUrl,
    this.domain,
    this.groupId,
    this.title,
    this.tags,
    this.deeplinks,
  });

  BitlyParams.fromJson(Map<String, dynamic> json) {
    longUrl = json['long_url'];
    domain = json['domain'];
    groupId = json['group_guid'];
    title = json['title'];
    tags = json['tags']?.cast<String>();
    if (json['deeplinks'] != null) {
      deeplinks = <DeeplinkParams>[];
      json['deeplinks'].forEach((v) {
        deeplinks!.add(DeeplinkParams.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long_url'] = longUrl;
    data['domain'] = domain;
    data['group_guid'] = groupId;
    data['title'] = title;
    data['tags'] = tags;
    if (deeplinks != null) {
      data['deeplinks'] = deeplinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

///
/// https://dev.bitly.com/api-reference#createFullBitlink
///
class DeeplinkParams {
  String? appId;
  String? appUriPath;
  String? installUrl;
  String? installType;

  DeeplinkParams({
    this.appId,
    this.appUriPath,
    this.installUrl,
    this.installType,
  });

  DeeplinkParams.fromJson(Map<String, dynamic> json) {
    appId = json['app_id'];
    appUriPath = json['app_uri_path'];
    installUrl = json['install_url'];
    installType = json['install_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_id'] = appId;
    data['app_uri_path'] = appUriPath;
    data['install_url'] = installUrl;
    data['install_type'] = installType;
    return data;
  }
}
