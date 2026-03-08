
class FallEvent {
  final String id;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String note;

  FallEvent({
    required this.id,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.note = '',
  });
}
