## Cache de imagens para otimizar o carregamento

- Exemplos de uso:

```dart
FadeInImage(
    placeholder: AssetImage('assets/flutterLogo.png'),
    image: ImageCacheProvider(
        url: 'https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg',
        imageDuration: const Duration(days: 5),
    ),
),


Image(
    image: ImageCacheProvider(
        url: 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
        imageDuration: const Duration(days: 5),
    ),
),
```