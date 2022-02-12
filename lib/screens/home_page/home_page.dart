import 'package:bill_it/billing_panel.dart';
import 'package:fluent_ui/fluent_ui.dart';

class HomePage extends StatefulWidget {
  const HomePage(String s, {Key? key, this.shopName = "Navrang Hardware"})
      : super(key: key);
  final String shopName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      // header: Center(
      //     child: Text(
      //   widget.shopName,
      //   style: const TextStyle(fontSize: 24),
      // )),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Expanded(
            child: BillingPanel(),
            flex: 7,
          ),
          Expanded(
            child: Text('Item list'),
            flex: 3,
          )
        ],
      ),
    );
  }
}
