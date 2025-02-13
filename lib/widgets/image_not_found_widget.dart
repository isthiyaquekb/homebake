import 'package:flutter/material.dart';
import 'package:home_bake/core/app_assets.dart';


class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage(
        AppAssets.imageNotFound,
      ),
      fit: BoxFit.contain,
    );
  }
}
