import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinder_clone/card_provider.dart';
import 'package:tinder_clone/tinder_card.dart';
import 'package:tinder_clone/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CardProvider(),
      child: MaterialApp(
        title: 'Tinder Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 8,
              primary: Colors.white,
              shape: const CircleBorder(),
              minimumSize: const Size.square(80),
            ),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final user = User(
    name: 'Yuki Mamiya',
    age: 31,
    urlImage: 'https://img.tv-8.com/person/wrJkw.jpg',
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade200,
              Colors.black,
            ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(),
                Expanded(
                  child: buildCards(),
                ),
                buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() => Row(
        children: const [
          Icon(
            Icons.local_fire_department_rounded,
            color: Colors.white,
            size: 36,
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            'Tinder',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      );

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;
    return users.isEmpty
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              final provider1 =
                  Provider.of<CardProvider>(context, listen: false);
              provider1.addUsers();
            },
            child: const Text(
              'Restart',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.red, Colors.white, isDislike),
                  backgroundColor:
                      getColor(Colors.white, Colors.red, isDislike),
                  side: getBorder(Colors.red, Colors.white, isDislike),
                ),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.dislike();
                },
                child: const Icon(
                  Icons.clear,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      getColor(Colors.blue, Colors.white, isSuperLike),
                  backgroundColor:
                      getColor(Colors.white, Colors.blue, isSuperLike),
                  side: getBorder(Colors.blue, Colors.white, isSuperLike),
                ),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.superLike();
                },
                child: const Icon(
                  Icons.star,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: getColor(Colors.teal, Colors.white, isLike),
                  backgroundColor: getColor(Colors.white, Colors.teal, isLike),
                  side: getBorder(Colors.teal, Colors.white, isLike),
                ),
                onPressed: () {
                  final provider =
                      Provider.of<CardProvider>(context, listen: false);
                  provider.like();
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.teal,
                  size: 24,
                ),
              ),
            ],
          );
  }

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    // final urlImages = provider.urlImages;
    final users = provider.users;
    return Stack(
      children: users
          .map((user) => TinderCard(
                user: user,
                isFront: users.last == user,
              ))
          .toList(),
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    // ignore: prefer_function_declarations_over_variables
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };
    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    // ignore: prefer_function_declarations_over_variables
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return const BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };
    return MaterialStateProperty.resolveWith(getBorder);
  }
}
