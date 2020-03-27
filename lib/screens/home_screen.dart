import 'package:scoped_model/scoped_model.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/screens/challenge.dart';
import 'package:xocorona/screens/home_out.dart';
import 'package:xocorona/screens/home_tab.dart';
import 'package:xocorona/screens/profile.dart';
import 'package:xocorona/screens/top10.dart';
import 'package:xocorona/themes/theme.dart';
import 'package:xocorona/widgets/custom_bottomMenu.dart';
import 'package:flutter/material.dart';

import 'feed.dart';

class HomeScreen extends StatelessWidget {
  final int tab;
  HomeScreen(this.tab);

  Widget pageTab = Feed();

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case 1:
        {
          pageTab = HomeTab();
        }
        break;
      case 2:
        {
          pageTab = Challenge();
        }
        break;
      case 3:
        {
          pageTab = Feed();
        }
        break;
      case 4:
        {
          pageTab = Top10();
        }
        break;
      case 5:
        {
          pageTab = ProfileUser();
        }
        break;
      default:
        {
          pageTab = ProfileUser();
        }
        break;
    }
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return Scaffold(
          body: pageTab,
          bottomNavigationBar: CustomBottomMenu(),
        );
      }),
    );
    /*
      Scaffold(
      body: pageTab,
      bottomNavigationBar: CustomBottomMenu(),
    );*/
  }
}
