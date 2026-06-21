class ApiConstant {
  static const String baseUrl = 'https://tourismapi.runasp.net/api/';
  static const String signInEndPoint = 'Accounts/SignIn';
  static const String signUpEndPoint = 'Accounts/SignUp';
  static const String logoutEndPoint = 'Accounts/Logout';
  static const String getUsernameEndPoint = 'Accounts/GetUsername';
  static const String forgotPasswordEndPoint = 'Accounts/ForgotPassword';
  static const String resetPasswordEndPoint = 'Accounts/ResetPassword';
  static const String changePasswordEndPoint = 'Accounts/ChangePassword';
  static const String testAuthEndPoint = 'Accounts/TestAuth';

  static const String guidesEndPoint = 'Guides';
  static const String hotelsEndPoint = 'Hotels';
  static const String transportEndPoint = 'Transport';
  static const String programsEndPoint = 'Programs';
  static const String servicesEndPoint = 'Services';
  
  static const String myBookingsEndPoint = 'Bookings/my';
  static const String bookingsEndPoint = 'Bookings';
  static const String bookGuideEndPoint = 'Guides/{id}/book';
  static const String bookHotelEndPoint = 'Hotels/{id}/book';
  static const String bookProgramEndPoint = 'Programs/{id}/book';
  static const String bookServiceEndPoint = 'Services/{id}/book';
  static const String bookTransportEndPoint = 'Transport/{id}/book';
  
  static const String placesEndPoint = 'Places';
  static const String recommendedPlacesEndPoint = 'Places/GetRecommendedPlaces';
  static const String placesSummaryEndPoint = 'Places/summary';

  static const String providerRequestEndPoint = 'provider/request';
  static const String myProviderRequestEndPoint = 'provider/request/my';
  static const String adminProviderRequestsEndPoint = 'admin/provider-requests';
}
