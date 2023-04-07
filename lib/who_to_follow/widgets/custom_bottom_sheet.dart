import 'package:flutter/material.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({super.key});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  Tween<Offset> offset = Tween(
    begin: const Offset(0, 1),
    end: const Offset(0, 0),
  );

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.8,
      minChildSize: 0.4,
      initialChildSize: 0.4,
      builder: (_, scrollController) {
        return SlideTransition(
          position: offset.chain(CurveTween(curve: Curves.easeIn)).animate(controller),
          child: Container(
            color: Colors.red,
            height: 49.0,
            child: ListView.builder(
              controller: scrollController,
              itemCount: 200,
              itemBuilder: (BuildContext context, int index) {
                return Text('$index');
              },
            ),
          ),
        );
      },
    );
  }
}
