import 'dart:io' show File;
import 'dart:ui' show Codec, Image;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart'
    show DiagnosticsProperty, DiagnosticsTreeStyle, SynchronousFuture;
import 'package:flutter/widgets.dart' hide Image;
import 'package:files_cache/files_cache.dart' show FilesCache;
import 'package:dart_dev_utils/dart_dev_utils.dart' show Functions;

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

  Future<Codec> _getImageCodec() async {
    assert(Functions.i.isNetworkURL(url: url),
        'Insira uma url válida: https, http');
    return await getBytesData(url: url, fileDurationTime: imageDuration)
        .then((uint8List) {
      return PaintingBinding.instance!.instantiateImageCodec(
        uint8List,
        cacheWidth: width,
        cacheHeight: height,
        allowUpscaling: allowUpscaling!,
      );
    }); /*.whenComplete(() {
      //PaintingBinding.instance!.imageCache?.clear();
      //PaintingBinding.instance!.imageCache?.clearLiveImages();//limpar imagens em cache sendo exibidas
      print('Imagens em cache sendo exibidas: ${PaintingBinding.instance?.imageCache?.liveImageCount}');
    });*/
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

  static Future<Image> image(
      {required String url, Duration? imageDuration}) async {
    assert(Functions.i.isNetworkURL(url: url),
        'Insira uma url válida: https, http');

    return await FilesCache()
        .getBytesData(url: url, fileDurationTime: imageDuration)
        .then((uint8List) => decodeImageFromList(uint8List));
  }

  static Future<Uint8List> bytesData(
      {required String url, Duration? imageDuration}) async {
    assert(Functions.i.isNetworkURL(url: url),
        'Insira uma url válida: https, http');

    return FilesCache().getBytesData(url: url, fileDurationTime: imageDuration);
  }

  static Future<File> file(
      {required String url, Duration? imageDuration}) async {
    assert(Functions.i.isNetworkURL(url: url),
        'Insira uma url válida: https, http');

    return FilesCache().getFile(url: url, fileDurationTime: imageDuration);
  }
}
