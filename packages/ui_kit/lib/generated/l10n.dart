// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Common`
  String get settings_common {
    return Intl.message(
      'Common',
      name: 'settings_common',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Photo`
  String get photo {
    return Intl.message(
      'Photo',
      name: 'photo',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get fromAlbum {
    return Intl.message(
      'Photos',
      name: 'fromAlbum',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message(
      'Create',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// ` `
  String get split {
    return Intl.message(
      ' ',
      name: 'split',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Delete Failed`
  String get deleteFailed {
    return Intl.message(
      'Delete Failed',
      name: 'deleteFailed',
      desc: '',
      args: [],
    );
  }

  /// `Delete Successfully`
  String get deleteSuccess {
    return Intl.message(
      'Delete Successfully',
      name: 'deleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Subtitle`
  String get subtitle {
    return Intl.message(
      'Subtitle',
      name: 'subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message(
      'Full name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get content {
    return Intl.message(
      'Content',
      name: 'content',
      desc: '',
      args: [],
    );
  }

  /// `Vendor`
  String get vendor {
    return Intl.message(
      'Vendor',
      name: 'vendor',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sortingBy {
    return Intl.message(
      'Sort',
      name: 'sortingBy',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get genderMale {
    return Intl.message(
      'Male',
      name: 'genderMale',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get genderFemale {
    return Intl.message(
      'Female',
      name: 'genderFemale',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get genderOther {
    return Intl.message(
      'Other',
      name: 'genderOther',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email`
  String get invalidEmail {
    return Intl.message(
      'Invalid Email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Make phone call`
  String get makePhoneCall {
    return Intl.message(
      'Make phone call',
      name: 'makePhoneCall',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restoreSettings {
    return Intl.message(
      'Restore',
      name: 'restoreSettings',
      desc: '',
      args: [],
    );
  }

  /// `Send email`
  String get sendEmail {
    return Intl.message(
      'Send email',
      name: 'sendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Launch`
  String get launchWeb {
    return Intl.message(
      'Launch',
      name: 'launchWeb',
      desc: '',
      args: [],
    );
  }

  /// `Text message`
  String get sendTextMessage {
    return Intl.message(
      'Text message',
      name: 'sendTextMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your device not supported`
  String get deviceNotSupported {
    return Intl.message(
      'Your device not supported',
      name: 'deviceNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Sorry! cannot load image.`
  String get imageError {
    return Intl.message(
      'Sorry! cannot load image.',
      name: 'imageError',
      desc: '',
      args: [],
    );
  }

  /// `Publish time`
  String get publish_at {
    return Intl.message(
      'Publish time',
      name: 'publish_at',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get scanner {
    return Intl.message(
      'Scan',
      name: 'scanner',
      desc: '',
      args: [],
    );
  }

  /// `Lost connectivity...`
  String get lostConnectivity {
    return Intl.message(
      'Lost connectivity...',
      name: 'lostConnectivity',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Background position`
  String get backgroundPosition {
    return Intl.message(
      'Background position',
      name: 'backgroundPosition',
      desc: '',
      args: [],
    );
  }

  /// `Location Settings`
  String get locationSettings {
    return Intl.message(
      'Location Settings',
      name: 'locationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Application Settings`
  String get appSettings {
    return Intl.message(
      'Application Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select current location`
  String get selectAddress {
    return Intl.message(
      'Select current location',
      name: 'selectAddress',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastName {
    return Intl.message(
      'Last name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstName {
    return Intl.message(
      'First name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Birthday`
  String get birthday {
    return Intl.message(
      'Birthday',
      name: 'birthday',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Not decided`
  String get genderNotDecided {
    return Intl.message(
      'Not decided',
      name: 'genderNotDecided',
      desc: '',
      args: [],
    );
  }

  /// `No Data`
  String get noData {
    return Intl.message(
      'No Data',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Share file`
  String get shareFile {
    return Intl.message(
      'Share file',
      name: 'shareFile',
      desc: '',
      args: [],
    );
  }

  /// `Online`
  String get online {
    return Intl.message(
      'Online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Offline`
  String get offLine {
    return Intl.message(
      'Offline',
      name: 'offLine',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Visible`
  String get visible {
    return Intl.message(
      'Visible',
      name: 'visible',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Created time`
  String get createdAt {
    return Intl.message(
      'Created time',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Updated time`
  String get updatedAt {
    return Intl.message(
      'Updated time',
      name: 'updatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Click to select sort field`
  String get clickToSort {
    return Intl.message(
      'Click to select sort field',
      name: 'clickToSort',
      desc: '',
      args: [],
    );
  }

  /// `Click to search`
  String get clickToSearch {
    return Intl.message(
      'Click to search',
      name: 'clickToSearch',
      desc: '',
      args: [],
    );
  }

  /// `Click to change sorting direction`
  String get clickToChangeUpDown {
    return Intl.message(
      'Click to change sorting direction',
      name: 'clickToChangeUpDown',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message(
      'Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobilePhone {
    return Intl.message(
      'Mobile',
      name: 'mobilePhone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Click to input email`
  String get inputEmail {
    return Intl.message(
      'Click to input email',
      name: 'inputEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty or wrong format.`
  String get emailError {
    return Intl.message(
      'Email cannot be empty or wrong format.',
      name: 'emailError',
      desc: '',
      args: [],
    );
  }

  /// `Address1`
  String get address1 {
    return Intl.message(
      'Address1',
      name: 'address1',
      desc: '',
      args: [],
    );
  }

  /// `Address2`
  String get address2 {
    return Intl.message(
      'Address2',
      name: 'address2',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Post Code`
  String get postCode {
    return Intl.message(
      'Post Code',
      name: 'postCode',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Full name error`
  String get fullNameError {
    return Intl.message(
      'Full name error',
      name: 'fullNameError',
      desc: '',
      args: [],
    );
  }

  /// `Birthday cannot be empty`
  String get birthdayError {
    return Intl.message(
      'Birthday cannot be empty',
      name: 'birthdayError',
      desc: '',
      args: [],
    );
  }

  /// `City cannot be empty`
  String get cityError {
    return Intl.message(
      'City cannot be empty',
      name: 'cityError',
      desc: '',
      args: [],
    );
  }

  /// `Country cannot be empty`
  String get countryError {
    return Intl.message(
      'Country cannot be empty',
      name: 'countryError',
      desc: '',
      args: [],
    );
  }

  /// `State cannot be empty`
  String get stateError {
    return Intl.message(
      'State cannot be empty',
      name: 'stateError',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Restore will clean all your app settings,cashes and will restart the app.`
  String get restoreMessage {
    return Intl.message(
      'Restore will clean all your app settings,cashes and will restart the app.',
      name: 'restoreMessage',
      desc: '',
      args: [],
    );
  }

  /// `Photo Picker`
  String get photoPicker {
    return Intl.message(
      'Photo Picker',
      name: 'photoPicker',
      desc: '',
      args: [],
    );
  }

  /// `User Avatar`
  String get userAvatar {
    return Intl.message(
      'User Avatar',
      name: 'userAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Member Avatar`
  String get memberAvatar {
    return Intl.message(
      'Member Avatar',
      name: 'memberAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Billing Address`
  String get billingAddress {
    return Intl.message(
      'Billing Address',
      name: 'billingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Address`
  String get shippingAddress {
    return Intl.message(
      'Shipping Address',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please input right address`
  String get addressError {
    return Intl.message(
      'Please input right address',
      name: 'addressError',
      desc: '',
      args: [],
    );
  }

  /// `Cannot be empty`
  String get emptyError {
    return Intl.message(
      'Cannot be empty',
      name: 'emptyError',
      desc: '',
      args: [],
    );
  }

  /// `Input`
  String get input {
    return Intl.message(
      'Input',
      name: 'input',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get helper {
    return Intl.message(
      'Help',
      name: 'helper',
      desc: '',
      args: [],
    );
  }

  /// `Display`
  String get displaySettings {
    return Intl.message(
      'Display',
      name: 'displaySettings',
      desc: '',
      args: [],
    );
  }

  /// `User Settings`
  String get userSettings {
    return Intl.message(
      'User Settings',
      name: 'userSettings',
      desc: '',
      args: [],
    );
  }

  /// `System`
  String get systemSettings {
    return Intl.message(
      'System',
      name: 'systemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message(
      'Refresh',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }

  /// `LoadMore`
  String get loadMore {
    return Intl.message(
      'LoadMore',
      name: 'loadMore',
      desc: '',
      args: [],
    );
  }

  /// `Pull to refresh`
  String get pullToRefresh {
    return Intl.message(
      'Pull to refresh',
      name: 'pullToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Release to refresh`
  String get releaseToRefresh {
    return Intl.message(
      'Release to refresh',
      name: 'releaseToRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get refreshing {
    return Intl.message(
      'Refreshing...',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `Refresh completed`
  String get refreshFinish {
    return Intl.message(
      'Refresh completed',
      name: 'refreshFinish',
      desc: '',
      args: [],
    );
  }

  /// `Refresh failed`
  String get refreshFailed {
    return Intl.message(
      'Refresh failed',
      name: 'refreshFailed',
      desc: '',
      args: [],
    );
  }

  /// `Refresh completed`
  String get refreshed {
    return Intl.message(
      'Refresh completed',
      name: 'refreshed',
      desc: '',
      args: [],
    );
  }

  /// `Push to load`
  String get pushToLoad {
    return Intl.message(
      'Push to load',
      name: 'pushToLoad',
      desc: '',
      args: [],
    );
  }

  /// `Release to load`
  String get releaseToLoad {
    return Intl.message(
      'Release to load',
      name: 'releaseToLoad',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message(
      'Loading...',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Load completed`
  String get loadFinish {
    return Intl.message(
      'Load completed',
      name: 'loadFinish',
      desc: '',
      args: [],
    );
  }

  /// `Load completed`
  String get loaded {
    return Intl.message(
      'Load completed',
      name: 'loaded',
      desc: '',
      args: [],
    );
  }

  /// `Load failed`
  String get loadFailed {
    return Intl.message(
      'Load failed',
      name: 'loadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Refresh done`
  String get completeRefresh {
    return Intl.message(
      'Refresh done',
      name: 'completeRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Load done`
  String get completeLoad {
    return Intl.message(
      'Load done',
      name: 'completeLoad',
      desc: '',
      args: [],
    );
  }

  /// `No more`
  String get noMore {
    return Intl.message(
      'No more',
      name: 'noMore',
      desc: '',
      args: [],
    );
  }

  /// `Update at %T`
  String get updateAt {
    return Intl.message(
      'Update at %T',
      name: 'updateAt',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
