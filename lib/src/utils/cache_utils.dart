import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CacheUtils {
  static final CacheUtils _instance = CacheUtils._();

  factory CacheUtils() => CacheUtils._instance;

  CacheUtils._();

  static const String cacheKey = 'libCachedImageData';
  static const int cacheStalePeriodInDays = 20;

  CacheManager get manager => CacheManager(
        Config(
          cacheKey,
          stalePeriod: const Duration(
            days: cacheStalePeriodInDays,
          ),
        ),
      );
}
