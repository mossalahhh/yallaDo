abstract class AppValidation{

  static String? validateEmail(String?value){
    var emailRegExp = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');    if(!emailRegExp.hasMatch(value??'')){
      return 'Invalid Email';
    }
    return null;
  }
  static String? validatePassword(String?value){
    if(value==null || value.isEmpty){
      return 'Password is required';
    }
    if(value.length<6){
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  static String? validateConfirmPassword(String?value,String?password){
    if(value==null || value.isEmpty){
      return 'Password is required';
    }
    if(value!=password){
      return 'Passwords do not match';
    }
    return null;
  }
  static String? validateRequired(String?value){
    if(value==null || value.isEmpty){
      return 'Field is required';
    }
    return null;
  }


}