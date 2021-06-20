import 'package:climbing_gym_app/services/pageviewService.dart';
import 'package:flutter/material.dart';
import 'package:climbing_gym_app/locator.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart'
    as FlutterSlidingUpPanel;

class PolySlidingUpPanel extends StatefulWidget {
  PolySlidingUpPanel(
      {Key key,
      final FlutterSlidingUpPanel.PanelController controller,
      final Widget panel,
      final Widget Function(ScrollController) panelBuilder})
      : controller = controller,
        panel = panel,
        panelBuilder = panelBuilder,
        super(key: key);
  final FlutterSlidingUpPanel.PanelController controller;
  final Widget panel;
  final Widget Function(ScrollController) panelBuilder;

  @override
  _SlidingUpPanelState createState() =>
      _SlidingUpPanelState(controller, panel, panelBuilder);
}

class _SlidingUpPanelState extends State<PolySlidingUpPanel> {
  final routesService = locator<RoutesService>();

  _SlidingUpPanelState(this.controller, this.panel, this.panelBuilder);
  final FlutterSlidingUpPanel.PanelController controller;
  final Widget panel;
  final Widget Function(ScrollController) panelBuilder;

  final BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

  final pageviewService = locator<PageViewService>();
  @override
  Widget build(BuildContext context) {
    return FlutterSlidingUpPanel.SlidingUpPanel(
      minHeight: 0.0,
      borderRadius: radius,
      controller: controller,
      panel: panel,
      panelBuilder: panelBuilder,
      onPanelClosed: (() {
        pageviewService.setSwipingAllowed(true);
        setState(() {});
      }),
      onPanelOpened: (() {
        pageviewService.setSwipingAllowed(false);
      }),
    );
  }
}
