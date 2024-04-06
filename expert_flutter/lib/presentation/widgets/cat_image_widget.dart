import 'package:expert_flutter/data/models/cat_model.dart';
import 'package:flutter/cupertino.dart';

class CatImageWidget extends StatelessWidget{
  CatImage? catImage;
   CatImageWidget({
    super.key,
    required this.catImage
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: catImage != null
          ? Image.network(catImage!.url)
          : const Text('Image not loaded yet'),
    );
  }
}