class QrCodeData {
  String? name;
  String? number;

  QrCodeData({this.name, this.number});

  QrCodeData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['number'] = number;
    return data;
  }
}
