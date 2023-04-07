import 'package:flutter/material.dart';

class QuotesLoadingWigdet extends StatelessWidget {
  final int count;
  const QuotesLoadingWigdet({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: screenSize.height / 2.7,
          margin: const EdgeInsets.only(bottom: 16.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: Colors.white.withOpacity(0.10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Container(
                  height: 12.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white.withOpacity(0.16),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  height: 8.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white.withOpacity(0.10),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Container(
                height: 8.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        );
      },
    );
  }
}
