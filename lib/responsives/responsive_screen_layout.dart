import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utiles/global_veriable.dart';
import 'package:provider/provider.dart';

class ResponsiveScreenLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveScreenLayout(
      {super.key,
      required this.mobileScreenLayout,
      required this.webScreenLayout});

  @override
  State<ResponsiveScreenLayout> createState() => _ResponsiveScreenLayoutState();
}

class _ResponsiveScreenLayoutState extends State<ResponsiveScreenLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > webScreenSize) {
        return widget.webScreenLayout;
      } else {
        // mobile screen
        return widget.mobileScreenLayout;
      }
    });
  }
}
