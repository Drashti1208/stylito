import '../core/constants/api_constants.dart';
import '../models/inquiry_model.dart';
import 'api_service.dart';

class InquiryApiService {
  // Submit a customer direct message / inquiry to the REST API
  static Future<ApiResponse<InquiryModel>> submitInquiry({
    required String name,
    required String email,
    String? subject,
    required String message,
  }) async {
    final payload = {
      'name': name.trim(),
      'email': email.trim(),
      'subject': subject != null && subject.trim().isNotEmpty
          ? subject.trim()
          : 'Customer Direct Message',
      'message': message.trim(),
    };

    final response = await ApiService.post(
      ApiConstants.inquiries,
      body: payload,
    );

    if (response.success && response.data != null && response.data['data'] != null) {
      final model = InquiryModel.fromJson(response.data['data'] as Map<String, dynamic>);
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        message: response.message ?? 'Inquiry submitted successfully!',
        data: model,
      );
    }

    return ApiResponse(
      success: response.success,
      statusCode: response.statusCode,
      message: response.message ?? 'Failed to submit inquiry.',
      data: null,
    );
  }

  // Fetch list of inquiries
  static Future<List<InquiryModel>> fetchInquiries() async {
    final response = await ApiService.get(ApiConstants.inquiries);
    if (response.success && response.data != null) {
      final list = response.data['data'] as List?;
      if (list != null) {
        return list
            .map((item) => InquiryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}
