class AdminProviderRequest {
  final String id;
  final String businessName;
  final String businessType;
  final String status;
  final String submittedAt;
  final String reviewedAt;
  final String rejectionReason;
  final String businessDescription;
  final String contactNumber;
  final String email;
  final String taxNumber;
  final String registrationNumber;
  final String documentUrl;
  final String userName;
  final String userEmail;

  const AdminProviderRequest({
    required this.id,
    required this.businessName,
    required this.businessType,
    required this.status,
    required this.submittedAt,
    required this.reviewedAt,
    required this.rejectionReason,
    required this.businessDescription,
    required this.contactNumber,
    required this.email,
    required this.taxNumber,
    required this.registrationNumber,
    required this.documentUrl,
    required this.userName,
    required this.userEmail,
  });

  factory AdminProviderRequest.fromJson(Map<String, dynamic> json) {
    final user = _asMap(json['user']) ?? _asMap(json['customer']);

    return AdminProviderRequest(
      id: _readString(json, ['id', 'requestId', 'providerRequestId']),
      businessName: _readString(json, ['businessName', 'name']),
      businessType: _readString(json, ['businessType', 'type']),
      status: _readString(json, ['status']),
      submittedAt: _readString(json, ['submittedAt', 'createdAt', 'createdOn']),
      reviewedAt: _readString(json, ['reviewedAt', 'updatedAt']),
      rejectionReason: _readString(json, ['rejectionReason', 'rejectReason']),
      businessDescription: _readString(json, [
        'businessDescription',
        'description',
      ]),
      contactNumber: _readString(json, ['contactNumber', 'phoneNumber', 'phone']),
      email: _readString(json, ['email', 'businessEmail']),
      taxNumber: _readString(json, ['taxNumber']),
      registrationNumber: _readString(json, ['registrationNumber']),
      documentUrl: _readString(json, ['documentUrl', 'documentURL']),
      userName: user == null ? '' : _readString(user, ['name', 'userName']),
      userEmail: user == null ? '' : _readString(user, ['email']),
    );
  }

  bool get hasDetails {
    return businessDescription.isNotEmpty ||
        contactNumber.isNotEmpty ||
        email.isNotEmpty ||
        taxNumber.isNotEmpty ||
        registrationNumber.isNotEmpty ||
        documentUrl.isNotEmpty;
  }

  static List<AdminProviderRequest> listFromResponse(dynamic response) {
    final list = _extractList(response);
    return list
        .whereType<Map>()
        .map((item) => AdminProviderRequest.fromJson(
              item.map((key, value) => MapEntry(key.toString(), value)),
            ))
        .toList();
  }

  static AdminProviderRequest fromResponse(dynamic response) {
    final data = response is Map ? response['data'] ?? response : response;
    if (data is Map) {
      return AdminProviderRequest.fromJson(
        data.map((key, value) => MapEntry(key.toString(), value)),
      );
    }
    throw const FormatException('Invalid provider request response');
  }

  static List<dynamic> _extractList(dynamic response) {
    if (response is List) return response;
    if (response is Map) {
      final data = response['data'];
      if (data is List) return data;
      if (data is Map) {
        for (final key in ['items', 'requests', 'providerRequests', 'results']) {
          final value = data[key];
          if (value is List) return value;
        }
      }
      for (final key in ['items', 'requests', 'providerRequests', 'results']) {
        final value = response[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) {
      return value.map((key, item) => MapEntry(key.toString(), item));
    }
    return null;
  }

  static String _readString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null) return value.toString();
    }
    return '';
  }
}
