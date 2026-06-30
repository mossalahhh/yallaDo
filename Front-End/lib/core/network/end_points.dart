/// Centralized API configuration for the YallaDo backend.
///
/// All network routing flows through these constants. The production base URL
/// and the custom authorization scheme live here so they can be changed in one
/// place.
class EndPoints {
  
  static const String baseURL = 'https://yalla-do.vercel.app/';

  static const String tokenPrefix = 'yallaDo_grad_';

  // ---------------------------------------------------------------------------
  // Auth (Module 1)
  // ---------------------------------------------------------------------------
  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String verifyEmail = 'auth/verify-email';
  static const String resendCode = 'auth/resend-code';
  static const String forgetPassword = 'auth/forget-password';
  static const String resetPassword = 'auth/reset-password';
  static const String logout = 'auth/logout';

  // ---------------------------------------------------------------------------
  // User profile (Module 2)
  // ---------------------------------------------------------------------------
  static const String myProfile = 'user/me';
}
