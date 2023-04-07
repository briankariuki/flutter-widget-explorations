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

  final BehaviorSubject<QuoteslyErrorMessage> error$;

  final BehaviorSubject<List<Quote>> quotes$;
  final BehaviorSubject<QuotePage> quotePage$;
  final BehaviorSubject<QuoteslyMessage> message$;

  final Stream<bool> isFetching$;

  QuoteslyController._({
    required this.fetchQuotes,
    required this.error$,
    required this.quotePage$,
    required this.quotes$,
    required this.isFetching$,
    required this.bookmarkQuote,
    required this.message$,
  });

  factory QuoteslyController(final QuotesUseCase quotesUseCase) {
    print('QuoteslyController init');

    final fetchQuotesController = PublishSubject<void>();
    final messageController = BehaviorSubject<QuoteslyMessage>();
    final bookmarkQuoteController = PublishSubject<Quote>();
    final isFetchingController = BehaviorSubject<bool>.seeded(false);

    final quotesController = BehaviorSubject<List<Quote>>();
    final quotePageController = BehaviorSubject<QuotePage>();
    final errorController = BehaviorSubject<QuoteslyErrorMessage>();

    bookmarkQuoteController
        .throttle(
      (event) => TimerStream(
        true,
        const Duration(seconds: 1),
      ),
    )
        .listen((quote) {
      quotesUseCase
          .bookmarkQuote(quote: quote)
          .doOnCancel(
            () => {},
          )
          .listen((result) {
        result.fold(
          ifRight: (unit) {
            // var _quotesPage = (unit.data as List)
            //     .map(
            //       (e) => Quote.fromJson(e),
            //     )
            //     .toList();

            // quotesController.add(_quotesPage);
            //We have data
          },
          ifLeft: (appError) => appError.message!,
        );
      });
    });

    fetchQuotesController.listen((value) {
      quotesUseCase
          .getRandomQuotes()
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
              var _quotesPage = (unit.data as List)
                  .map(
                    (e) => Quote.fromJson(e),
                  )
                  .toList();

              quotesController.add(_quotesPage);
              //We have data
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
      quotePage$: quotePageController,
      quotes$: quotesController,
      isFetching$: isFetchingController,
    );
  }

  dispose() {
    error$.drain();
    quotes$.drain();
    quotePage$.drain();

    error$.close();
    quotes$.close();
    quotePage$.close();

    print('QuoteslyController disposed');
  }
}
