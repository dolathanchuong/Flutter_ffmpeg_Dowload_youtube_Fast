///
/// [BitlyModel]
///
class BitlyModel {
  String? link;
  String? id;
  String? longUrl;
  String? title;
  bool? archived;
  String? createdAt;
  String? createdBy;
  String? clientId;
  List<String>? customBitlinks;
  List<String>? tags;
  List<String>? launchpadIds;
  List<Deeplinks>? deeplinks;

  BitlyModel({
    this.link,
    this.id,
    this.longUrl,
    this.title,
    this.archived,
    this.createdAt,
    this.createdBy,
    this.clientId,
    this.customBitlinks,
    this.tags,
    this.launchpadIds,
    this.deeplinks,
  });

  BitlyModel.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    id = json['id'];
    longUrl = json['long_url'];
    title = json['title'];
    archived = json['archived'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    clientId = json['client_id'];
    customBitlinks = json['custom_bitlinks']?.cast<String>();
    tags = json['tags']?.cast<String>();
    launchpadIds = json['launchpad_ids']?.cast<String>();
    if (json['deeplinks'] != null) {
      deeplinks = <Deeplinks>[];
      json['deeplinks'].forEach((v) {
        deeplinks!.add(Deeplinks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['id'] = id;
    data['long_url'] = longUrl;
    data['title'] = title;
    data['archived'] = archived;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['client_id'] = clientId;
    data['custom_bitlinks'] = customBitlinks;
    data['tags'] = tags;
    data['launchpad_ids'] = launchpadIds;
    if (deeplinks != null) {
      data['deeplinks'] = deeplinks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Deeplinks {
  String? guid;
  String? bitlink;
  String? appUriPath;
  String? installUrl;
  String? appGuid;
  String? os;
  String? installType;
  String? created;
  String? modified;
  String? brandGuid;

  Deeplinks({
    this.guid,
    this.bitlink,
    this.appUriPath,
    this.installUrl,
    this.appGuid,
    this.os,
    this.installType,
    this.created,
    this.modified,
    this.brandGuid,
  });

  Deeplinks.fromJson(Map<String, dynamic> json) {
    guid = json['guid'];
    bitlink = json['bitlink'];
    appUriPath = json['app_uri_path'];
    installUrl = json['install_url'];
    appGuid = json['app_guid'];
    os = json['os'];
    installType = json['install_type'];
    created = json['created'];
    modified = json['modified'];
    brandGuid = json['brand_guid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['guid'] = guid;
    data['bitlink'] = bitlink;
    data['app_uri_path'] = appUriPath;
    data['install_url'] = installUrl;
    data['app_guid'] = appGuid;
    data['os'] = os;
    data['install_type'] = installType;
    data['created'] = created;
    data['modified'] = modified;
    data['brand_guid'] = brandGuid;
    return data;
  }
}
