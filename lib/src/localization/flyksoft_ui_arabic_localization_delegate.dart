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
}
