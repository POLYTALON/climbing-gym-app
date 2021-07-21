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
      final Widget Function(ScrollController) panelBuilder,
      final Function onPanelClosed,
      final Widget header})
      : controller = controller,
        panel = panel,
        panelBuilder = panelBuilder,
        onPanelClosed = onPanelClosed,
        header = header,
        super(key: key);
  final FlutterSlidingUpPanel.PanelController controller;
  final Widget panel;
  final Widget Function(ScrollController) panelBuilder;
  final Function onPanelClosed;
  final Widget header;

  @override
  _SlidingUpPanelState createState() => _SlidingUpPanelState(
      controller, panel, panelBuilder, onPanelClosed, header);
}

class _SlidingUpPanelState extends State<PolySlidingUpPanel> {
  final routesService = locator<RoutesService>();

  _SlidingUpPanelState(this.controller, this.panel, this.panelBuilder,
      this.onPanelClosed, this.header);
  FlutterSlidingUpPanel.PanelController controller;
  Widget panel;
  Widget Function(ScrollController) panelBuilder;
  Function onPanelClosed;
  Widget header;

  final BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0));

  final pageviewService = locator<PageViewService>();

  @override
  void didUpdateWidget(PolySlidingUpPanel oldWidget) {
    if (controller != widget.controller ||
        panel != widget.panel ||
        panelBuilder != widget.panelBuilder ||
        onPanelClosed != widget.onPanelClosed ||
        header != widget.header) {
      setState(() {
        controller = widget.controller;
        panel = widget.panel;
        panelBuilder = widget.panelBuilder;
        onPanelClosed = widget.onPanelClosed;
        header = widget.header;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSlidingUpPanel.SlidingUpPanel(
      header: header,
      minHeight: 0.0,
      borderRadius: radius,
      panelSnapping: true,
      snapPoint: 0.999,
      maxHeight: MediaQuery.of(context).size.height * 0.8,
      controller: controller,
      panel: panel,
      panelBuilder: panelBuilder,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      onPanelClosed: (() {
        FocusScope.of(context).unfocus();
        pageviewService.setSwipingAllowed(true);
        setState(() {});
        if (onPanelClosed != null) {
          onPanelClosed();
        }
      }),
      onPanelOpened: (() {
        pageviewService.setSwipingAllowed(false);
      }),
    );
  }
}
