import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yodiyar/Provider/AuthManager.dart';
import 'package:yodiyar/Provider/NavProvider.dart';
import 'package:yodiyar/Provider/UserProvider.dart';
import 'package:yodiyar/colors_schedume.g.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();
// await AuthManager.removeUserAndToken();
final data = await AuthManager.getUserAndToken();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider(data)),
      ],
      child: const MyApp(),
    ),);
}

class Main extends StatefulWidget {
  const Main({super.key, required this.title});
  final String title;

  @override
  State<Main> createState() => _MainState();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => BannerProvider()),
        ChangeNotifierProvider(create: (context) => NavProvider()),
        // ChangeNotifierProvider(create: (context) => ProductProvider()),
        // ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        themeMode: Provider.of<UserProvider>(context).mode,
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        home: const Main(title: 'Gold Mobile'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);

    return Scaffold(
      // body: Consumer<Connection>(
      //   builder: (context, value, child) {
      //    return value.status
      //         ? navProvider.pages[navProvider.activeIndex]['page']
      //         :  Center(
      //           child:Image.asset('lib/assets/connection.png',width: 200,),
      //         );
      //   },
      // ),
      body: navProvider.pages[navProvider.activeIndex]['page'],
      bottomNavigationBar: NavigationBar(
        selectedIndex: navProvider.activeIndex,
        destinations: [
          ...navProvider.pages
              .map(
                (e) => NavigationDestination(
                  icon: Icon(e['icon']),
                  selectedIcon: Icon(e['active_icon'],
                      color: Theme.of(context).colorScheme.secondary),
                  label: e['name'],
                  tooltip: e['name'],
                ),
              )
              .toList()
        ],
        height: 65,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (value) {
          navProvider.changeIndex(value);
        },
      ),
    );
  }
}
