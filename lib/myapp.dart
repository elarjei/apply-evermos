import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/favorites/providers/favorites_provider.dart';
import 'modules/pexels_photo/providers/pexels_photo_provider.dart';
import 'pages/detail_page.dart';
import 'pages/favorites_page.dart';
import 'pages/home_page.dart';
import 'pages/search_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final taps = [
    const HomePage(),
    const FavoritesPage(),
  ];

  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return PexelsPhotosProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return FavoritesProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Awesome App',
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Awesome App'),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      Navigator.pushNamed(context, SearchPage.routeName);
                    },
                  );
                },
              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.only(top: 8),
            child: taps[currentScreenIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentScreenIndex,
            onTap: (index) {
              setState(() {
                currentScreenIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: 'Favorites',
                icon: Icon(Icons.favorite),
              ),
            ],
          ),
        ),
        initialRoute: '/',
        routes: {
          SearchPage.routeName: (context) {
            return const SearchPage();
          },
          DetailPage.routeName: (context) {
            return const DetailPage();
          },
        },
      ),
    );
  }
}
