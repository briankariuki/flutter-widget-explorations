import 'package:flutter/material.dart';

import '../models/favorite_string.dart';
import 'widgets.dart';

String convertIntToString(String str) {
  var list = [
    'Zero',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
  ];
  return list[int.parse(str)];
}

class FavoriteStringTile extends StatelessWidget {
  final FavoriteString favoriteString;

  final Function() onFavorite;
  const FavoriteStringTile({
    super.key,
    required this.favoriteString,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final text = convertIntToString(favoriteString.title!);
    return ListTile(
      onTap: onFavorite,
      title: HeadlineSmall(
        title: text,
        color: Colors.black,
        fontWeight: FontWeight.w600,
        lineHeight: 1.4,
      ),
      trailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: IconButton(
          splashRadius: 20.0,
          onPressed: onFavorite,
          icon: Icon(
            favoriteString.favorited == true ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
