import 'package:expert_flutter/presentation/widgets/cat_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cat_notifier.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<CatNotifier>(
          builder: (context, notifier, child) {
            final catImage = notifier.image;
            return CatImageWidget(catImage: catImage);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () async {
          Provider.of<CatNotifier>(context, listen: false).getCatImage();
        },
      ),
    );
  }
}