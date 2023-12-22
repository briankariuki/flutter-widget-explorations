import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FancyEditCardPage extends StatefulWidget {
  static const String routeName = '/fancy-edit-card';

  const FancyEditCardPage({super.key});

  @override
  State<FancyEditCardPage> createState() => _FancyEditCardPageState();
}

class _FancyEditCardPageState extends State<FancyEditCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const Column(
        children: [
          FancyCard(),
        ],
      ),
    );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
