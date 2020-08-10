class ActiveVisit {
  bool success;
  String code;
  Paras paras;

  ActiveVisit({this.success, this.code, this.paras});

  ActiveVisit.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    paras = json['paras'] != null ? new Paras.fromJson(json['paras']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    if (this.paras != null) {
      data['paras'] = this.paras.toJson();
    }
    return data;
  }
}

class Paras {
  List<Requests> requests;

  Paras({this.requests});

  Paras.fromJson(Map<String, dynamic> json) {
    if (json['requests'] != null) {
      requests = new List<Requests>();
      json['requests'].forEach((v) {
        requests.add(new Requests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requests != null) {
      data['requests'] = this.requests.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Requests {
  int id;
  String creationTime;
  String visitTime;
  int statusId;
  Address address;
  List<SvcIds> svcIds;
  Null provNo;

  Requests(
      {this.id,
      this.creationTime,
      this.visitTime,
      this.statusId,
      this.address,
      this.svcIds,
      this.provNo});

  Requests.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creationTime = json['creationTime'];
    visitTime = json['visitTime'];
    statusId = json['statusId'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    if (json['svcIds'] != null) {
      svcIds = new List<SvcIds>();
      json['svcIds'].forEach((v) {
        svcIds.add(new SvcIds.fromJson(v));
      });
    }
    provNo = json['provNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['creationTime'] = this.creationTime;
    data['visitTime'] = this.visitTime;
    data['statusId'] = this.statusId;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.svcIds != null) {
      data['svcIds'] = this.svcIds.map((v) => v.toJson()).toList();
    }
    data['provNo'] = this.provNo;
    return data;
  }
}

class Address {
  bool isDefault;
  String city;
  String countryIso;
  int id;
  String line1;
  String line2;
  Null postalcode;
  String state;
  String location;

  Address(
      {this.isDefault,
      this.city,
      this.countryIso,
      this.id,
      this.line1,
      this.line2,
      this.postalcode,
      this.state,
      this.location});

  Address.fromJson(Map<String, dynamic> json) {
    isDefault = json['isDefault'];
    city = json['city'];
    countryIso = json['countryIso'];
    id = json['id'];
    line1 = json['line1'];
    line2 = json['line2'];
    postalcode = json['postalcode'];
    state = json['state'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isDefault'] = this.isDefault;
    data['city'] = this.city;
    data['countryIso'] = this.countryIso;
    data['id'] = this.id;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
    data['postalcode'] = this.postalcode;
    data['state'] = this.state;
    data['location'] = this.location;
    return data;
  }
}

class SvcIds {
  int id;

  SvcIds({this.id});

  SvcIds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}