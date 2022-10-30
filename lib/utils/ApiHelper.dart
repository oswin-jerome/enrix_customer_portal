import 'package:dio/dio.dart';
import 'package:customer_portal/interceptors/cache_interceptor.dart';
import 'package:customer_portal/pages/auth/loginPage.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ApiHelper {
  late Dio dio;
  ApiHelper() {
    var storeBox = Hive.box("store");

    String? _token = storeBox.get("token");
    dio = new Dio();
    dio.options.baseUrl = Base.baseUrl;
    // dio.interceptors.add(
    //   CacheInterceptor(
    //     cacheDuration: Duration(days: 1),
    //     isForcedRefresh: false,
    //   ),
    // );
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      if (_token != null) {
        options.headers.addEntries([
          MapEntry("Authorization", "Bearer " + _token),
          MapEntry("Accept", "application/json"),
          MapEntry("Content-Type", "application/json"),
        ]);
      } else {
        options.headers.addEntries([
          // MapEntry("Authorization", "Bearer " + _token ?? ""),
          MapEntry("Accept", "application/json"),
          MapEntry("Content-Type", "application/json"),
        ]);
      }
      return handler.next(options);
    }, onError: (DioError err, handler) {
      print("DIO===========================");
      if (err.response?.statusCode == 401) {
        print("Not authorized");
        storeBox.clear();
        Get.off(LoginPage());
        return;
      }

      print(err);

      // if (err.response.statusCode >= 500) {
      //   print("Server errors");
      //   Get.snackbar("", "Something went wrong");
      //   print(err.response);
      //   return;
      // }

      return handler.next(err);
    }));
  }
}
