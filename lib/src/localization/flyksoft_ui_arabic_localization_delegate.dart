import 'flyksoft_ui_localization_delegate.dart';

class FlyksoftUIArabicLocalizationDelegate
    extends FlyksoftUILocalizationDelegate {
  const FlyksoftUIArabicLocalizationDelegate();

  @override
  String get cancel => 'يلغي';

  @override
  String get noItemFound => 'لم يتم العثور على أي عنصر';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get save => 'يحفظ';

  @override
  String get search => 'يبحث';

  @override
  String get unknownFailureMessage => 'هناك خطأ ما';

  @override
  String noItemFoundWithItemName(String itemName) =>
      'لم يتم العثور على $itemName';

  @override
  String get seeLess => 'شاهد المزيد';

  @override
  String get seeMore => 'انظر أقل';

  @override
  String get successfulOperation => 'عملية ناجحة';

  @override
  String get unsuccessfulOperation => 'عملية غير ناجحة';

  @override
  String get items => 'أغراض';

  @override
  String get select => 'يختار';
}
