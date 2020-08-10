class ServicePricesModel {
  bool success;
  String code;
  Paras paras;

  ServicePricesModel({this.success, this.code, this.paras});

  ServicePricesModel.fromJson(Map<String, dynamic> json) {
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
  List<Prices> prices;
  Regular regular;
  Extra extra;

  Paras({this.prices, this.regular, this.extra});

  Paras.fromJson(Map<String, dynamic> json) {
    if (json['prices'] != null) {
      prices = new List<Prices>();
      json['prices'].forEach((v) {
        prices.add(new Prices.fromJson(v));
      });
    }
    regular =
    json['regular'] != null ? new Regular.fromJson(json['regular']) : null;
    extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.prices != null) {
      data['prices'] = this.prices.map((v) => v.toJson()).toList();
    }
    if (this.regular != null) {
      data['regular'] = this.regular.toJson();
    }
    if (this.extra != null) {
      data['extra'] = this.extra.toJson();
    }
    return data;
  }
}

class Prices {
  int svcId;
  double price;
  String currencyId;

  Prices({this.svcId, this.price, this.currencyId});

  Prices.fromJson(Map<String, dynamic> json) {
    svcId = json['svcId'];
    price = json['price'];
    currencyId = json['currencyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['svcId'] = this.svcId;
    data['price'] = this.price;
    data['currencyId'] = this.currencyId;
    return data;
  }
}

class Regular {
  double fees;
  String currency;

  Regular({this.fees, this.currency});

  Regular.fromJson(Map<String, dynamic> json) {
    fees = json['fees'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fees'] = this.fees;
    data['currency'] = this.currency;
    return data;
  }
}

class Extra {
  double fees;
  String currency;

  Extra({this.fees, this.currency});

  Extra.fromJson(Map<String, dynamic> json) {
    fees = json['fees'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fees'] = this.fees;
    data['currency'] = this.currency;
    return data;
  }
}