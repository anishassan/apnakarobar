/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/login.png
  AssetGenImage get login => const AssetGenImage('assets/images/login.png');

  /// File path: assets/images/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/images/logo.png');

  /// File path: assets/images/splash.jpeg
  AssetGenImage get splash => const AssetGenImage('assets/images/splash.jpeg');

  /// List of all assets
  List<AssetGenImage> get values => [login, logo, splash];
}

class $AssetsLangGen {
  const $AssetsLangGen();

  /// File path: assets/lang/en.json
  String get en => 'assets/lang/en.json';

  /// File path: assets/lang/ur.json
  String get ur => 'assets/lang/ur.json';

  /// List of all assets
  List<String> get values => [en, ur];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/add_cart.svg
  String get addCart => 'assets/svg/add_cart.svg';

  /// File path: assets/svg/add_item.svg
  String get addItem => 'assets/svg/add_item.svg';

  /// File path: assets/svg/box.svg
  String get box => 'assets/svg/box.svg';

  /// File path: assets/svg/drop_down.svg
  String get dropDown => 'assets/svg/drop_down.svg';

  /// File path: assets/svg/inventory.svg
  String get inventory => 'assets/svg/inventory.svg';

  /// File path: assets/svg/logo.svg
  String get logo => 'assets/svg/logo.svg';

  /// File path: assets/svg/person.svg
  String get person => 'assets/svg/person.svg';

  /// File path: assets/svg/profile.svg
  String get profile => 'assets/svg/profile.svg';

  /// File path: assets/svg/purchase.svg
  String get purchase => 'assets/svg/purchase.svg';

  /// File path: assets/svg/report.svg
  String get report => 'assets/svg/report.svg';

  /// File path: assets/svg/sales.svg
  String get sales => 'assets/svg/sales.svg';

  /// List of all assets
  List<String> get values => [
        addCart,
        addItem,
        box,
        dropDown,
        inventory,
        logo,
        person,
        profile,
        purchase,
        report,
        sales
      ];
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsLangGen lang = $AssetsLangGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
