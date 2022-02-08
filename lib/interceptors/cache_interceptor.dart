import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class CacheInterceptor extends Interceptor {
  bool isForcedRefresh;
  Duration cacheDuration;
  CacheInterceptor({
    this.isForcedRefresh = true,
    this.cacheDuration = const Duration(days: 1),
  });

  final _cache = <Uri, Response>{};
  var storeBox = Hive.box("cache_store");

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    DateTime now = DateTime.now();

    DateTime cacheTime =
        storeBox.get(options.uri.toString() + "_max_time") != null
            ? DateTime.tryParse(
                    storeBox.get(options.uri.toString() + "_max_time")) ??
                now
            : now;
    var response = Response(
        requestOptions: options,
        data: storeBox.get(options.uri.toString() + "_data"),
        statusCode: 200);

    if (isForcedRefresh == true || options.extra["canCache"] != true) {
      print('${options.uri}: force refresh, ignore cache! \n');
      return handler.next(options);
    } else if (response.data != null) {
      if (now.difference(cacheTime).inSeconds > cacheDuration.inSeconds) {
        print('${options.uri}: cache expired, ignore cache! \n');
        return handler.next(options);
      }
      print('cache hit: ${options.uri} \n');
      return handler.resolve(response);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // _cache[response.requestOptions.uri] = response;
    storeBox.put(
        response.requestOptions.uri.toString() + "_data", response.data);
    storeBox.put(response.requestOptions.uri.toString() + "_max_time",
        DateTime.now().toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('onError: $err');
    super.onError(err, handler);
  }
}
