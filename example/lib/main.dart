import 'dart:io' show File;
import 'dart:ui' as ui;
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';

import 'package:images_cache/images_cache.dart';

void main() => runApp(const StartApp());

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.purple[300],
        ),
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              FutureBuilder<ui.Image>(
                future: ImageCacheProvider.image(
                  url: 'https://image.freepik.com/free-photo/image-human-brain_99433-298.jpg',
                  imageDuration: const Duration(days: 5),
                ),
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.data == null) {
                    return Text('Imagem...');
                  }else{
                    return RawImage(
                      image: snapshot.data,
                    );
                  }
                }
              ),

              FutureBuilder<File>(
                future: ImageCacheProvider.file(
                  url: 'https://www.torredevigilancia.com/wp-content/uploads/2019/10/coringa-55.jpg',
                  imageDuration: const Duration(days: 5),
                ),
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('Imagem...');
                  }else{
                    return Image.file(
                      snapshot.data!,
                      height: 75,
                      width: 150,
                    );
                  }
                }
              ),

              FutureBuilder<Uint8List>(
                future: ImageCacheProvider.bytesData(
                  url: 'https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png',
                  imageDuration: const Duration(days: 5),
                ),
                builder: (context, snapshot){
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('Imagem...');
                  }else{
                    return Image.memory(snapshot.data!);
                  }
                }
              ),

              FadeInImage(
                placeholder: AssetImage('assets/flutterLogo.png'),
                image: ImageCacheProvider(
                  url: 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg',
                  imageDuration: const Duration(days: 5),
                ),
              ),

              Image.asset('assets/flutterLogo.png'),

              Image(
                image: ImageCacheProvider(
                  url: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                  imageDuration: const Duration(days: 5),
                ),
              ),

              Image(
                image: ImageCacheProvider(
                  url: 'https://i.pinimg.com/474x/a3/02/cf/a302cf677769c16544025c73772f205a.jpg',
                  imageDuration: const Duration(days: 5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


