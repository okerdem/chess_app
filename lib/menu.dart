import 'package:flutter/material.dart';
import 'package:flutter_chess_app/game_board.dart';
import 'package:flutter_chess_app/main.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool _darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              const Spacer(),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const GameBoard();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text(
                      "Play",
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _darkTheme
                          ? MyApp.of(context).changeTheme(ThemeMode.dark)
                          : MyApp.of(context).changeTheme(ThemeMode.light);
                      _darkTheme = !_darkTheme;
                    });
                  },
                  color: !_darkTheme ? Colors.grey[400] : Colors.yellow,
                  iconSize: 40,
                  icon: !_darkTheme
                      ? const Icon(Icons.light_mode_outlined)
                      : const Icon(Icons.light_mode),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
