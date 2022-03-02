import 'dart:io';
import 'package:bill_it/screens/home_page/home_page_container.dart';
import 'package:bill_it/shared/db/db.dart';
import 'package:window_size/window_size.dart';
import 'package:fluent_ui/fluent_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
    setWindowTitle('Bill it');
    setWindowMinSize(const Size(1160, 820));
    setWindowMaxSize(Size.infinite);
    setWindowFrame(const Rect.fromLTRB(0, 50, 1920, 1024));
  }
  await AppDB().doSomeWork();
  runApp(const HomePageContainer());
}
