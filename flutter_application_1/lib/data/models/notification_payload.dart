class NotificationPayload {
  final String type;
  final String? orderId;
  final String? promoId;

  NotificationPayload({required this.type, this.orderId, this.promoId});

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      type: json['type'],
      orderId: json['orderId'],
      promoId: json['promoId'],
    );
  }
}
