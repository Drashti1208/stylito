import 'package:get/get.dart';
import '../models/inquiry_model.dart';
import '../services/inquiry_api_service.dart';

class InquiryController extends GetxController {
  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingList = false.obs;
  final RxString lastSubmissionMessage = ''.obs;
  final RxList<InquiryModel> inquiries = <InquiryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInquiries();
  }

  Future<bool> submitInquiry({
    required String name,
    required String email,
    String? subject,
    required String message,
  }) async {
    isSubmitting.value = true;
    lastSubmissionMessage.value = '';

    try {
      final response = await InquiryApiService.submitInquiry(
        name: name,
        email: email,
        subject: subject,
        message: message,
      );

      if (response.success && response.data != null) {
        inquiries.insert(0, response.data!);
        lastSubmissionMessage.value = 'Thank you! Your message has been sent to our team in real-time.';
        return true;
      } else {
        lastSubmissionMessage.value = response.message ?? 'Failed to send inquiry.';
        return false;
      }
    } catch (e) {
      lastSubmissionMessage.value = 'Failed to send inquiry: $e';
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> fetchInquiries() async {
    isLoadingList.value = true;
    try {
      final list = await InquiryApiService.fetchInquiries();
      inquiries.assignAll(list);
    } catch (_) {
    } finally {
      isLoadingList.value = false;
    }
  }
}
