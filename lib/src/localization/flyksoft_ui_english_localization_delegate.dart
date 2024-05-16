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

  @override
  String get seeLess => 'See more';

  @override
  String get seeMore => 'See less';

  @override
  String get successfulOperation => 'Successful operation';

  @override
  String get unsuccessfulOperation => 'Unsuccessful operation';

  @override
  String get items => 'Items';

  @override
  String get select => 'Select';
}
