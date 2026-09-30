class InquiryModel {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final String status;
  final DateTime? createdAt;

  const InquiryModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    this.status = 'New',
    this.createdAt,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'New',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'status': status,
    };
  }
}
