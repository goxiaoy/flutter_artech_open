import 'package:artech_core/app_module_base.dart';
import 'package:artech_core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class ModuleVisualization extends StatefulWidget {
  const ModuleVisualization({Key? key, required this.mainModule})
      : super(key: key);
  final AppMainModuleBase mainModule;
  @override
  State<StatefulWidget> createState() => _ModuleVisualizationState();
}

class _ModuleVisualizationState extends State<ModuleVisualization> {
  AppMainModuleBase get mainModule => widget.mainModule;
  SugiyamaConfiguration builder = SugiyamaConfiguration();

  late Graph g;
  @override
  void initState() {
    super.initState();
    g = _buildGraph();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Wrap(
          children: [
            Container(
              width: 100,
              child: TextFormField(
                initialValue: builder.nodeSeparation.toString(),
                decoration: const InputDecoration(labelText: "Node Separation"),
                onChanged: (text) {
                  builder.nodeSeparation = int.tryParse(text) ?? 100;
                  setState(() {});
                },
              ),
            ),
            Container(
              width: 100,
              child: TextFormField(
                initialValue: builder.levelSeparation.toString(),
                decoration:
                    const InputDecoration(labelText: "Level Separation"),
                onChanged: (text) {
                  builder.levelSeparation = int.tryParse(text) ?? 100;
                  setState(() {});
                },
              ),
            ),
            Container(
              width: 100,
              child: TextFormField(
                initialValue: builder.orientation.toString(),
                decoration: const InputDecoration(labelText: "Orientation"),
                onChanged: (text) {
                  builder.orientation = int.tryParse(text) ?? 100;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: InteractiveViewer(
              constrained: false,
              boundaryMargin: const EdgeInsets.all(100),
              minScale: 0.0001,
              maxScale: 10.6,
              child: GraphView(
                graph: g,
                algorithm: SugiyamaAlgorithm(builder),
                paint: Paint()
                  ..color = Colors.green
                  ..strokeWidth = 1
                  ..style = PaintingStyle.stroke,
              )),
        ),
      ],
    )));
  }

  Widget _getNodeText(Type t) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
          ],
        ),
        child: Text(t.toString()));
  }

  Graph _buildGraph() {
    final res = Graph();
    final Map<Type, Node> allNodes = <Type, Node>{};
    dfs<AppModuleMixin, Type>(
        mainModule, (n) => n.runtimeType, (n) => n.dependentOn,
        (node, parents) {
      final uiNode = Node(_getNodeText(node.runtimeType));
      allNodes[node.runtimeType] = uiNode;
      //add edge
      if (node.dependentOn.isNotEmpty) {
        for (final c in node.dependentOn) {
          res.addEdge(uiNode, allNodes[c.runtimeType]);
        }
      }
    });
    return res;
  }
}
