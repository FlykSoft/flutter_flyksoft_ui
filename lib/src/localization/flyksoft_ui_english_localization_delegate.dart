import 'flyksoft_ui_localization_delegate.dart';

class FlyksoftUIEnglishLocalizationDelegate
    extends FlyksoftUILocalizationDelegate {
  const FlyksoftUIEnglishLocalizationDelegate();

  @override
  String get cancel => 'Cancel';

  @override
  String get noItemFound => 'No item found';

  @override
  String get retry => 'Retry';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String get unknownFailureMessage => 'Something went wrong';

  @override
  String noItemFoundWithItemName(String itemName) =>
      'No ${itemName.toLowerCase()} found';
}
