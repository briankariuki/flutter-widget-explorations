import 'dart:async';

import 'package:rxdart/rxdart.dart';

class CartController {
  final StreamController<List<CartItem>> cartItems$;
  final Function(int index) increment;
  final Function(int index) decrement;
  final Function(int index) remove;

  CartController._({
    required this.cartItems$,
    required this.increment,
    required this.decrement,
    required this.remove,
  });

  factory CartController() {
    print("cartcontroller created");

    final BehaviorSubject<List<CartItem>> _cartItems$ = BehaviorSubject();

    final PublishSubject<int> _incrementIndex = PublishSubject();
    final PublishSubject<int> _decrementIndex = PublishSubject();
    final PublishSubject<int> _removeIndex = PublishSubject();

    _incrementIndex.listen((index) {
      final _item = _cartItems$.value[index];

      final newItem = CartItem(
        product: _item.product,
        quantity: _item.quantity + 1,
      );

      final _newCartItems = _cartItems$.value;

      _newCartItems.removeAt(index);
      _newCartItems.insert(index, newItem);

      _cartItems$.add(_newCartItems);
    });

    _decrementIndex.skip(1).listen((index) {
      final _item = _cartItems$.value[index];

      final newItem = CartItem(
        product: _item.product,
        quantity: _item.quantity == 1 ? 1 : _item.quantity - 1,
      );

      final _newCartItems = _cartItems$.value;

      _newCartItems.removeAt(index);
      _newCartItems.insert(index, newItem);

      _cartItems$.add(_newCartItems);
    });

    _removeIndex.listen((index) {
      final _newCartItems = _cartItems$.value;

      _newCartItems.removeAt(index);

      _cartItems$.add(_newCartItems);
    });

    _cartItems$.add([
      CartItem(
        product: Product(
          name: 'Solar Panel',
          description: 'My solar panel. 1000 kW',
          imageUrl:
              'https://w7.pngwing.com/pngs/161/361/png-transparent-blue-and-white-solar-panel-solar-panels-solar-power-voltaic-system-solar-energy-voltaics-solar-company-business-electricity.png',
          price: 40432.00,
          inStock: false,
        ),
      ),
      CartItem(
        product: Product(
          name: 'Solar lamp',
          description: 'Solar lamp. 50 watts',
          imageUrl: 'https://totalenergies.ke/system/files/styles/large/private/atoms/image/total-solar-energy-family-sunshine.png?itok=LpbvFYCS',
          price: 1200.00,
          inStock: true,
        ),
      )
    ]);

    return CartController._(
      cartItems$: _cartItems$,
      increment: (index) => _incrementIndex.add(index),
      decrement: (index) => _decrementIndex.add(index),
      remove: (index) => _removeIndex.add(index),
    );
  }

  dispose() {
    print("cartcontroller disposed");

    cartItems$.close();
  }

  init() {}
}

class CartItem {
  Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });
}

class Product {
  String name;
  String description;
  String imageUrl;
  double price;
  bool inStock;

  Product({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.inStock = true,
  });
}
