import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';

class NavigationPaneView {
  int? index;
  final void Function(int)? onPaneChange;
  NavigationPaneView(this.index, this.onPaneChange);

  NavigationPane build(BuildContext context) {
    return NavigationPane(
        selected: index,
        onChanged: onPaneChange,
        displayMode: PaneDisplayMode.compact,
        items: [
          PaneItem(
              title: const Text("Sample Page 1"),
              icon: const Icon(material.Icons.code)),
          PaneItem(
            title: const Text("Sample Page 2"),
            icon: const Icon(material.Icons.desktop_windows_outlined),
          )
        ],
        size: const NavigationPaneSize(
          openMaxWidth: 200.0,
          openWidth: 200.0,
          openMinWidth: 200.0,
        ));
  }
}
