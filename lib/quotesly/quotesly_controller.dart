import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart_ext/rxdart_ext.dart';

import 'domain/usecases/quotes_use_case.dart';
import 'helpers/types.dart';
import 'models/models.dart';
import 'quotesly_state.dart';

class QuoteslyController {
  final Function0<void> fetchQuotes;
  final Function(Quote quote) bookmarkQuote;
  final Function(int value) setCurrentTab;

  final BehaviorSubject<QuoteslyErrorMessage> error$;

  final BehaviorSubject<List<Quote>> quotes$;

  final BehaviorSubject<List<Quote>> bookmarkedQuotes$;

  final BehaviorSubject<QuoteslyMessage> message$;

  final BehaviorSubject<int> currentTab$;

  final Stream<bool> isFetching$;

  QuoteslyController._({
    required this.fetchQuotes,
    required this.error$,
    required this.quotes$,
    required this.isFetching$,
    required this.bookmarkQuote,
    required this.message$,
    required this.bookmarkedQuotes$,
    required this.currentTab$,
    required this.setCurrentTab,
  });

  factory QuoteslyController(final QuotesUseCase quotesUseCase) {
    print('QuoteslyController init');

    final fetchQuotesController = PublishSubject<void>();

    final messageController = BehaviorSubject<QuoteslyMessage>();

    final bookmarkQuoteController = PublishSubject<Quote>();

    final isFetchingController = BehaviorSubject<bool>.seeded(false);

    final currentTabController = BehaviorSubject<int>.seeded(0);

    final quotesController = BehaviorSubject<List<Quote>>();

    final errorController = BehaviorSubject<QuoteslyErrorMessage>();

    final bookmarkedQuotesController = BehaviorSubject<List<Quote>>();

    quotesUseCase.quotesState$().listen((e) {
      e.fold(
        ifLeft: (_) => {},
        ifRight: (state) => {
          bookmarkedQuotesController.add(state.quotes!.toList()),
        },
      );
    });

    bookmarkQuoteController
        .throttle(
      (event) => TimerStream(
        true,
        const Duration(seconds: 1),
      ),
    )
        .listen((quote) {
      quotesUseCase.bookmarkQuote(quote: quote).listen((result) {
        result.fold(
          ifRight: (unit) {
            var _quotes = quotesController.value;

            var _index = _quotes.indexWhere((e) => e.id == unit.id);

            if (_index != -1) {
              _quotes[_index] = Quote()
                ..bookmarked = !quote.bookmarked
                ..author = unit.author
                ..content = unit.content
                ..id = unit.id
                ..authorSlug = unit.authorSlug
                ..tags = unit.tags
                ..length = unit.length;

              quotesController.add(_quotes);

              messageController.add(QuoteslyBookmarkMessage(
                quote.bookmarked ? 'Quote removed' : 'Quote saved',
                MessageType.bookmark,
              ));
            }
          },
          ifLeft: (appError) => appError.message!,
        );
      });
    });

    fetchQuotesController.listen((value) {
      quotesUseCase
          .getRandomQuotes(limit: 20)
          .doOnListen(
            () => isFetchingController.add(true),
          )
          .doOnCancel(
            () => isFetchingController.add(false),
          )
          .listen(
        (result) {
          result.fold(
            ifRight: (unit) {
              var _quotes = (unit.data as List)
                  .map(
                    (e) => Quote.fromJson(e),
                  )
                  .toList();

              if (bookmarkedQuotesController.value.isNotEmpty) {
                for (int i = 0; i < _quotes.length; i++) {
                  var _quote = _quotes[i];

                  var _bookmarkedQuotes = bookmarkedQuotesController.value;

                  var _index = _bookmarkedQuotes.indexWhere((e) => e.id == _quote.id);

                  if (_index != -1) {
                    _quotes[_index] = Quote()
                      ..bookmarked = true
                      ..author = _quote.author
                      ..content = _quote.content
                      ..id = _quote.id
                      ..authorSlug = _quote.authorSlug
                      ..tags = _quote.tags
                      ..length = _quote.length;
                  }
                }
              }

              quotesController.add(_quotes);
            },
            ifLeft: (appError) => appError.message!,
          );
        },
      );
    });

    return QuoteslyController._(
      fetchQuotes: () => fetchQuotesController.add(null),
      bookmarkQuote: (Quote quote) => bookmarkQuoteController.add(quote),
      message$: messageController,
      error$: errorController,
      quotes$: quotesController,
      isFetching$: isFetchingController,
      bookmarkedQuotes$: bookmarkedQuotesController,
      currentTab$: currentTabController,
      setCurrentTab: (int value) => currentTabController.add(value),
    );
  }

  dispose() {
    //Drain and close streams to prevent memory leaks
    error$.drain();
    quotes$.drain();
    bookmarkedQuotes$.drain();
    currentTab$.drain();
    message$.drain();
    isFetching$.drain();

    error$.close();
    quotes$.close();
    bookmarkedQuotes$.close();
    currentTab$.close();
    message$.close();

    print('QuoteslyController disposed');
  }
}
