import 'package:fluent_ui/fluent_ui.dart';
import 'navigation_pane_view.dart';
import 'home_page.dart';

class HomePageContainer extends StatefulWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  @override
  State<HomePageContainer> createState() => _MyAppState();
}

class _MyAppState extends State<HomePageContainer> {
  int index = 0;
  void onPaneChange(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Bill it!',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          accentColor: Colors.blue,
          iconTheme: const IconThemeData(size: 24)),
      home: NavigationView(
          content: NavigationBody(
            index: index,
            children: const [
              HomePage("Navrang Hardware"),
            ],
          ),
          appBar: const NavigationAppBar(
              title: Text(
            "Navrang Hardware",
            style: TextStyle(fontSize: 24.0),
          )),
          pane: NavigationPaneView(index, onPaneChange).build(context)),
    );
  }
}
