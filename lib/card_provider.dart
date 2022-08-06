import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:tinder_clone/user_model.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  List<String> _urlImages = [];
  List<User> _users = [];
  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;

  List<String> get urlImages => _urlImages;
  List<User> get users => _users;
  bool get isDragging => _isDragging;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
    addUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;
    notifyListeners();
  }

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;
    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();
    final status = getStatus();
    // if (status != null) {
    //   Fluttertoast.cancel();
    //   Fluttertoast.showToast(
    //     msg: status.toString().split('.').last.toUpperCase(),
    //     fontSize: 36,
    //   );
    // }
    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    notifyListeners();
  }

  double getStatusOpacity() {
    const delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;
    return min(opacity, 1);
  }

  CardStatus? getStatus() {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;
    const delta = 100;
    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.dislike;
    } else if (y <= -delta / 2 && forceSuperLike) {
      return CardStatus.superLike;
    } else {
      return null;
    }
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void like() {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _nextCard();
    notifyListeners();
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (_urlImages.isEmpty) return;
    if (_users.isEmpty) return;

    await Future.delayed(const Duration(milliseconds: 200));
    _urlImages.removeLast();
    _users.removeLast();
    resetPosition();
  }

  void resetUsers() {
    _urlImages = <String>[
      'https://img.tv-8.com/person/wrJkw.jpg',
      'https://tse4.mm.bing.net/th?id=OIP.zgxjbAZ-adOlbWDmnDlI_QHaK5&pid=15.1',
      'https://www.tokyokinky.com/blog/wp-content/uploads/2013/03/mogami-yuki-mamiya-yuki-nude-hot-gravure-japanese-girl-model-3.jpg',
      'https://www.tokyokinky.com/blog/wp-content/uploads/2013/03/mogami-yuki-mamiya-yuki-nude-hot-gravure-japanese-girl-model-5.jpg',
      'https://img.tv-8.com/person/wrJkw.jpg',
    ].reversed.toList();
    notifyListeners();
  }

  void addUsers() {
    _users = <User>[
      User(
        name: 'Yuki Mamiya',
        age: 29,
        urlImage: 'https://img.tv-8.com/person/wrJkw.jpg',
      ),
      User(
        name: 'Yuki Mamiya',
        age: 31,
        urlImage:
            'https://tse4.mm.bing.net/th?id=OIP.zgxjbAZ-adOlbWDmnDlI_QHaK5&pid=15.1',
      )
    ].reversed.toList();
    notifyListeners();
    // _users.add(
    //   User(
    //     name: 'Yuki Mamiya',
    //     age: 29,
    //     urlImage: 'https://img.tv-8.com/person/wrJkw.jpg',
    //   ),
    // );
    // _users.add(
    //   User(
    //     name: 'Yuki Mamiya',
    //     age: 31,
    //     urlImage:
    //         'https://tse4.mm.bing.net/th?id=OIP.zgxjbAZ-adOlbWDmnDlI_QHaK5&pid=15.1',
    //   ),
    // );
  }
}
