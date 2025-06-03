import 'package:flutter/foundation.dart';

class ResimSaglayici extends ChangeNotifier {
  String? imageURL;
  bool yukleniyor = false;

  ResimSaglayici() {
    imageURL =
        'https://static.vecteezy.com/system/resources/previews/020/402/234/non_2x/library-book-reading-abstract-icon-or-emblem-vector.jpg';
  }
}
