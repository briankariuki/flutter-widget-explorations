import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import '../core/widgets/widgets.dart';
import 'data/implementations/favorite_strings_repository_implementation.dart';
import 'data/local/local_data_source.dart';
import 'data/local/shared_prefs.dart';
import 'domain/repositories/favorite_strings_repository.dart';
import 'domain/usecases/favorite_strings_use_case.dart';
import 'favorite_strings_controller.dart';
import 'favorite_strings_page_state.dart';
import 'widgets/widgets.dart';

class FavoriteStringsPage extends StatefulWidget {
  static const String routeName = '/Favorite-strings';
  const FavoriteStringsPage({super.key});

  @override
  State<FavoriteStringsPage> createState() => _FavoriteStringsPageState();
}

class _FavoriteStringsPageState extends State<FavoriteStringsPage> with SingleTickerProviderStateMixin {
  late LocalDataSource localDataSource;

  late FavoriteStringsRepository favoriteStringsRepository;

  late FavoriteStringsController favoriteStringsController;

  late AnimationController snackbarController;

  @override
  void initState() {
    super.initState();

    final prefs = RxSharedPreferences.getInstance();

    localDataSource = SharedPrefs(prefs);

    favoriteStringsRepository = FavoriteStringsRepositoryImpl(localDataSource);

    favoriteStringsController = FavoriteStringsController(FavoriteStringsUseCase(favoriteStringsRepository));

    Future.delayed(const Duration(milliseconds: 2), () {
      favoriteStringsController.fetchFavoriteStrings();
    });

    snackbarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    favoriteStringsController.message$.listen((_) {
      showSnackbar();
    });
  }

  showSnackbar() {
    if (snackbarController.isCompleted) {
      snackbarController.reverse().whenComplete(
            () => snackbarController.forward().whenComplete(
                  () => Future.delayed(
                    const Duration(seconds: 3),
                    () {
                      snackbarController.reverse();
                    },
                  ),
                ),
          );
    } else {
      snackbarController.forward().whenComplete(
            () => Future.delayed(
              const Duration(seconds: 3),
              () {
                snackbarController.reverse();
              },
            ),
          );
    }
  }

  closeSnackbar() {
    snackbarController.reverse();
  }

  @override
  void dispose() {
    favoriteStringsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: favoriteStringsController.currentTab$,
                      builder: (_, AsyncSnapshot snapshot) {
                        return IndexedStack(
                          index: snapshot.data ?? 0,
                          children: [
                            AnimatedScale(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.fastOutSlowIn,
                              scale: snapshot.data == 0 ? 1.0 : 1.1,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                                opacity: snapshot.data == 0 ? 1.0 : 0.1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              HeadlineMedium(
                                                title: "🤩",
                                                color: Colors.black,
                                              ),
                                              BodyMedium(
                                                title: "Favorite Strings",
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(height: 24.0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: StreamBuilder(
                                        stream: favoriteStringsController.isFetching$,
                                        builder: (_, AsyncSnapshot snapshot) {
                                          return snapshot.data == true
                                              ? const Center(
                                                  child: BodyMedium(
                                                    title: "Fetching",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              : StreamBuilder(
                                                  stream: favoriteStringsController.favoriteStrings$,
                                                  builder: (_, snapshot) {
                                                    return snapshot.hasData == true
                                                        ? ListView.builder(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            itemCount: snapshot.data?.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              final favoriteString = snapshot.data![index];

                                                              return FavoriteStringTile(
                                                                onFavorite: () => favoriteStringsController.favoriteString(favoriteString),
                                                                favoriteString: favoriteString,
                                                              );
                                                            },
                                                          )
                                                        : const Center(
                                                            child: BodyMedium(
                                                              title: "Something went wrong",
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          );
                                                  },
                                                );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            AnimatedScale(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.fastOutSlowIn,
                              scale: snapshot.data == 1 ? 1.0 : 1.1,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeIn,
                                opacity: snapshot.data == 1 ? 1.0 : 0.1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              HeadlineMedium(
                                                title: "💟",
                                                color: Colors.black,
                                              ),
                                              BodyMedium(
                                                title: "Favorited Strings",
                                                color: Colors.black87,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              SizedBox(height: 24.0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: StreamBuilder(
                                        stream: favoriteStringsController.isFetching$,
                                        builder: (_, AsyncSnapshot snapshot) {
                                          return snapshot.data == true
                                              ? const Center(
                                                  child: BodyMedium(
                                                    title: "Fetching",
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )
                                              : StreamBuilder(
                                                  stream: favoriteStringsController.favoritedStrings$,
                                                  builder: (_, snapshot) {
                                                    return snapshot.hasData == true && snapshot.data!.isNotEmpty
                                                        ? ListView.builder(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            itemCount: snapshot.data?.length,
                                                            itemBuilder: (BuildContext context, int index) {
                                                              final favoriteString = snapshot.data![index];

                                                              return FavoriteStringTile(
                                                                onFavorite: () => favoriteStringsController.favoriteString(favoriteString),
                                                                favoriteString: favoriteString,
                                                              );
                                                            },
                                                          )
                                                        : const Center(
                                                            child: BodyMedium(
                                                              title: "No favorites found",
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          );
                                                  },
                                                );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            AnimatedBuilder(
              animation: snackbarController,
              builder: (context, child) {
                return Positioned(
                  bottom: lerpDouble(
                    -60.0,
                    16.0,
                    Curves.fastOutSlowIn.transform(snackbarController.value),
                  ),
                  left: 16.0,
                  right: 16.0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(
                        lerpDouble(
                          0.9,
                          1.0,
                          Curves.fastOutSlowIn.transform(snackbarController.value),
                        ),
                      ),
                    child: child!,
                  ),
                );
              },
              child: PhysicalModel(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(8.0),
                elevation: 16.0,
                color: Colors.transparent,
                shadowColor: Colors.black.withOpacity(0.8),
                child: StreamBuilder<FavoriteStringsMessage>(
                  stream: favoriteStringsController.message$,
                  builder: (context, snapshot) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.black,
                        border: Border.all(
                          color: snapshot.data?.type == MessageType.error ? Colors.red : Colors.white.withOpacity(0.24),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  snapshot.data?.type == MessageType.error ? Icons.error : Icons.favorite,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 16.0,
                                ),
                                BodyMedium(
                                  title: snapshot.data?.message ?? "Something went wrong. Try again",
                                  color: Colors.white,
                                  lineHeight: 1.0,
                                ),
                              ],
                            ),
                          ),
                          if (snapshot.data?.type == MessageType.favorite) ...[
                            const Spacer(),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.white.withOpacity(0.08),
                                highlightColor: Colors.white.withOpacity(0.16),
                                onTap: () => favoriteStringsController.favoriteString(
                                  (snapshot.data as FavoriteStringsFavoriteMessage).favoriteString,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 16.0,
                                  ),
                                  child: BodyMedium(
                                    title: "Undo",
                                    color: Colors.blue,
                                    lineHeight: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0)
                          ]
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: PhysicalModel(
          clipBehavior: Clip.antiAlias,
          elevation: 16.0,
          color: Colors.transparent,
          shadowColor: Colors.white.withOpacity(0.8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withOpacity(0.16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<int>(
                  stream: favoriteStringsController.currentTab$,
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.02),
                              highlightColor: Colors.black.withOpacity(0.06),
                              onTap: () => favoriteStringsController.setCurrentTab(0),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                child: Icon(
                                  snapshot.data == 0 ? Icons.menu : Icons.menu_outlined,
                                  color: snapshot.data == 0 ? Colors.black : Colors.black.withOpacity(0.4),
                                  size: 32.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.black.withOpacity(0.02),
                              highlightColor: Colors.black.withOpacity(0.06),
                              onTap: () => favoriteStringsController.setCurrentTab(1),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                child: Icon(
                                  snapshot.data == 1 ? Icons.favorite : Icons.favorite_outline,
                                  color: snapshot.data == 1 ? Colors.black : Colors.black.withOpacity(0.4),
                                  size: 32.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
