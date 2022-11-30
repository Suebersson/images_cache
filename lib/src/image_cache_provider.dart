import 'dart:io' show File;
import 'dart:ui' as ui;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart'
    show DiagnosticsProperty, DiagnosticsTreeStyle, SynchronousFuture;
import 'package:flutter/widgets.dart' hide Image;
import 'package:files_cache/files_cache.dart' show FilesCache;
import 'package:dart_dev_utils/dart_dev_utils.dart' show dartDevUtils;

class ImageCacheProvider extends ImageProvider<ImageCacheProvider>
    with FilesCache {
  /// Armazenar imagens hospedadas da internet na mémoria do device para otimizar
  /// o carregamento das imagens nos componentes(widgets)

  final String url;
  final double? scale;
  final Duration? imageDuration;
  final int? width;
  final int? height;
  final bool? allowUpscaling;

  ImageCacheProvider({
    required this.url,
    this.scale = 1.0,
    this.imageDuration = const Duration(days: 5),
    this.width,
    this.height,
    this.allowUpscaling = false,
  }) : assert(url.isNotEmpty, "---- Insira o enderço da URL ----");

  Future<ui.Codec> _getImageCodec() async {
    assert(
        dartDevUtils.isNetworkURL(url), 'Insira uma url válida: https, http');

    return await getBytesData(url: url, fileDurationTime: imageDuration)
        .then((uint8List) {
      //ui.ImmutableBuffer.fromUint8List(uint8List)
      return ui.instantiateImageCodec(
        uint8List,
        targetWidth: width,
        targetHeight: height,
        allowUpscaling: allowUpscaling!,
      );
    });
  }

/*
  @override
  Future<bool> evict({ImageCache? cache, ImageConfiguration configuration = ImageConfiguration.empty}) {
    return super.evict(cache: cache, configuration: configuration).whenComplete(() {
      //cache?.clear();
      //cache?.clearLiveImages();
      print('${cache?.currentSizeBytes}');
      print('${configuration.size}');
    });
  }
*/

  @override
  ImageStreamCompleter load(ImageCacheProvider key, DecoderCallback decode) {
    //ImageStreamCompleter loadBuffer(ImageCacheProvider key, DecoderBufferCallback decode) { // Flutter >= 3.0.0
    return MultiFrameImageStreamCompleter(
        codec: key._getImageCodec(),
        scale: key.scale ?? 1.0,
        informationCollector: () sync* {
          yield DiagnosticsProperty<ImageProvider>(
              'Image provider: $this \n Image key: ${key.runtimeType}', this,
              description: 'Cache de imagens',
              style: DiagnosticsTreeStyle.errorProperty);
        });
  }

  @override
  Future<ImageCacheProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ImageCacheProvider>(this);
  }

  static Future<ui.Image> image(
      {required String url, Duration? imageDuration}) async {
    assert(
        dartDevUtils.isNetworkURL(url), 'Insira uma url válida: https, http');

    return await FilesCache()
        .getBytesData(url: url, fileDurationTime: imageDuration)
        .then((uint8List) => decodeImageFromList(uint8List));
  }

  static Future<Uint8List> bytesData(
      {required String url, Duration? imageDuration}) async {
    assert(
        dartDevUtils.isNetworkURL(url), 'Insira uma url válida: https, http');

    return FilesCache().getBytesData(url: url, fileDurationTime: imageDuration);
  }

  static Future<File> file(
      {required String url, Duration? imageDuration}) async {
    assert(
        dartDevUtils.isNetworkURL(url), 'Insira uma url válida: https, http');

    return FilesCache().getFile(url: url, fileDurationTime: imageDuration);
  }
}
