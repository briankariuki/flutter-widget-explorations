import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/assets.dart';
import 'package:flutter_reactive_programming/core/widgets/widgets.dart';
import 'package:flutter_reactive_programming/routes/routes.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Widget \nExplorations',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Tap on a link to view the widget',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: routes.length,
                  itemBuilder: (BuildContext context, int index) {
                    final route = routes[index];
                    return Material(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          if (index == 0)
                            Divider(
                              height: 1.0,
                              thickness: 0.8,
                              color: Colors.white.withOpacity(0.16),
                            ),
                          if ((kDebugMode && !route.isUnfinished) || (kReleaseMode && route.isUnfinished))
                            ListTile(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) => route.widget,
                                ),
                              ),
                              leading: Text(
                                "#${index + 1}",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                              ),
                              title: Text(
                                route.title,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                              ),
                              trailing: const Icon(
                                size: 20.0,
                                Icons.open_in_new,
                                color: Colors.white60,
                              ),
                            ),
                          Divider(
                            height: 1.0,
                            thickness: 0.8,
                            color: Colors.white.withOpacity(0.16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 0.8,
              color: Colors.white.withOpacity(0.16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  onTap: () => {},
                  leading: CircleAvatar(
                    radius: 16.0,
                    child: Image.asset(
                      Assets.brianImage,
                    ),
                  ),
                  title: Text(
                    '©${DateTime.now().year}  | briankariuki',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
