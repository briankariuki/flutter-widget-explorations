import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_programming/core/widgets/custom_scroll_behavior.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

import 'data/implementations/quotes_repository_implementation.dart';
import 'data/local/local_data_source.dart';
import 'data/local/shared_prefs.dart';
import 'domain/repositories/quotes_repository.dart';
import 'domain/usecases/quotes_use_case.dart';
import 'quotesly_controller.dart';
import 'quotesly_state.dart';
import 'widgets/widgets.dart';

class QuoteslyPage extends StatefulWidget {
  static const String routeName = '/quotes';
  const QuoteslyPage({super.key});

  @override
  State<QuoteslyPage> createState() => _QuoteslyPageState();
}

class _QuoteslyPageState extends State<QuoteslyPage> with SingleTickerProviderStateMixin {
  late LocalDataSource localDataSource;

  late QuotesRepository quotesRepository;

  late QuoteslyController quoteslyController;

  late AnimationController snackbarController;

  @override
  void initState() {
    super.initState();

    final prefs = RxSharedPreferences.getInstance();

    localDataSource = SharedPrefs(prefs);

    quotesRepository = QuotesRepositoryImpl(localDataSource);

    quoteslyController = QuoteslyController(QuotesUseCase(quotesRepository));

    Future.delayed(const Duration(milliseconds: 2), () {
      quoteslyController.fetchQuotes();
    });

    snackbarController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );

    quoteslyController.message$.listen((_) {
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
    quoteslyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
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
        body: Stack(
          alignment: Alignment.center,
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<int>(
                      stream: quoteslyController.currentTab$,
                      builder: (context, snapshot) {
                        return IndexedStack(
                          index: snapshot.data ?? 0,
                          children: [
                            AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn,
                              scale: snapshot.data == 0 ? 1.0 : 0.97,
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
                                              title: "Quotes",
                                              color: Colors.white,
                                            ),
                                            BodyMedium(
                                              title: "Today's random quotes",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(height: 24.0),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: quoteslyController.isFetching$,
                                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                                        return snapshot.data == true
                                            ? const QuotesLoadingWigdet()
                                            : StreamBuilder(
                                                stream: quoteslyController.quotes$,
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData == true
                                                      ? ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection: Axis.vertical,
                                                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                                          itemCount: snapshot.data?.length,
                                                          itemBuilder: (_, int index) {
                                                            final quote = snapshot.data![index];
                                                            return QuoteCardWidget(
                                                              quote: quote,
                                                              onBookmark: (data) => quoteslyController.bookmarkQuote(data),
                                                              onShare: (data) => {},
                                                            );
                                                          },
                                                        )
                                                      : const Center(
                                                          child: BodyMedium(
                                                            title: "Something went wrong",
                                                            color: Colors.white,
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
                            AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.fastOutSlowIn,
                              scale: snapshot.data == 1 ? 1.0 : 0.97,
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
                                              title: "Bookmarks",
                                              color: Colors.white,
                                            ),
                                            BodyMedium(
                                              title: "My Bookmarked Quotes",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(height: 24.0),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: StreamBuilder(
                                      stream: quoteslyController.bookmarkedQuotes$,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData == true && snapshot.data!.isNotEmpty
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                                itemCount: snapshot.data?.length,
                                                itemBuilder: (_, int index) {
                                                  final quote = snapshot.data![index];
                                                  return QuoteCardWidget(
                                                    quote: quote,
                                                    onBookmark: (data) => quoteslyController.bookmarkQuote(data),
                                                    onShare: (data) => {},
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child: BodyMedium(
                                                  title: "No bookmarks found.",
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                      },
                                    ),
                                  )
                                ],
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
                    32.0,
                    Curves.fastOutSlowIn.transform(
                      snackbarController.value,
                    ),
                  ),
                  left: 16.0,
                  right: 16.0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(
                        lerpDouble(
                          0.8,
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
                child: StreamBuilder<QuoteslyMessage>(
                    stream: quoteslyController.message$,
                    builder: (context, snapshot) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 16.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.black,
                          border: Border.all(
                            color: snapshot.data?.type == MessageType.error ? Colors.red : Colors.white.withOpacity(0.24),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              snapshot.data?.type == MessageType.error ? Icons.error : Icons.bookmark,
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
                      );
                    }),
              ),
            ),
            AnimatedBuilder(
              animation: snackbarController,
              builder: (context, child) {
                return Positioned(
                  bottom: lerpDouble(
                    24.0,
                    -72.0,
                    Curves.fastOutSlowIn.transform(snackbarController.value),
                  ),
                  width: 200.0,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(
                        lerpDouble(
                          1.0,
                          0.8,
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.32),
                    ),
                  ),
                  child: StreamBuilder<int>(
                    stream: quoteslyController.currentTab$,
                    builder: (context, snapshot) {
                      return Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.white.withOpacity(0.08),
                                highlightColor: Colors.white.withOpacity(0.12),
                                onTap: () => quoteslyController.setCurrentTab(0),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Icon(
                                    snapshot.data == 0 ? Icons.format_quote : Icons.format_quote_outlined,
                                    color: snapshot.data == 0 ? Colors.white : Colors.white.withOpacity(0.4),
                                    size: 36.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                              ),
                              child: InkWell(
                                splashColor: Colors.white.withOpacity(0.08),
                                highlightColor: Colors.white.withOpacity(0.12),
                                onTap: () => quoteslyController.setCurrentTab(1),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Icon(
                                    snapshot.data == 1 ? Icons.bookmark : Icons.bookmark_outline,
                                    color: snapshot.data == 1 ? Colors.white : Colors.white.withOpacity(0.4),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
