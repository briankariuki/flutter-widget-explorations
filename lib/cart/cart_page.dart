import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/cart/cart_controller.dart';
import 'package:flutter_reactive_programming/quotesly/widgets/typography.dart';
import 'package:flutter_reactive_programming/util/image.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  static const String routeName = '/cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartController = Provider.of<CartController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                HeadlineMedium(
                  title: 'Cart',
                  color: Colors.black,
                ),
                BodyMedium(
                  title: 'View and edit cart items',
                  color: Colors.black45,
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: cartController.cartItems$.stream,
              builder: (_, snapshot) {
                return snapshot.hasData && snapshot.data!.isNotEmpty
                    ? ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = snapshot.data![index];
                          return CartItemWidget(
                            cartItem: item,
                            increment: () => cartController.increment(index),
                            decrement: () => cartController.decrement(index),
                            remove: () => cartController.remove(index),
                          );
                        },
                      )
                    : const Center(
                        child: BodyMedium(title: 'No cart items found', color: Colors.black54),
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final Function() increment;
  final Function() decrement;
  final Function() remove;
  final CartItem cartItem;
  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.increment,
    required this.decrement,
    required this.remove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.0),
        color: const Color.fromRGBO(248, 249, 251, 1.0),
        border: Border.all(
          color: Colors.black.withOpacity(0.04),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: NewtworkImageWrapper(
                    height: 120.0,
                    imageUrl: cartItem.product.imageUrl,
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: TitleMedium(
                                  title: cartItem.product.name,
                                  color: Colors.black,
                                  maxLines: 1,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Flexible(
                                child: Small(
                                  title: 'Kes',
                                  color: Colors.black54,
                                  lineHeight: 1.6,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Flexible(
                                child: TitleMedium(
                                  title: "${cartItem.product.price * cartItem.quantity}",
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Flexible(
                                child: Small(
                                  title: "/ ${cartItem.quantity} items",
                                  color: Colors.black54,
                                  lineHeight: 1.7,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24.0,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          cartItem.product.inStock == true
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: const BodyMedium(title: 'In Stock', color: Colors.green),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.info,
                                        color: Colors.red,
                                        size: 16.0,
                                      ),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      BodyMedium(title: 'This seller is out of stock', color: Colors.red),
                                    ],
                                  ),
                                )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: decrement,
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              color: const Color.fromRGBO(240, 240, 240, 1.0),
                              child: const Center(
                                child: Small(
                                  title: "-",
                                  color: Colors.black,
                                  lineHeight: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 48.0,
                          height: 32.0,
                          color: Colors.white,
                          child: Center(
                            child: TitleSmall(
                              title: "${cartItem.quantity}",
                              color: Colors.black,
                              lineHeight: 1.0,
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: increment,
                            child: Container(
                              width: 32.0,
                              height: 32.0,
                              color: const Color.fromRGBO(240, 240, 240, 1.0),
                              child: const Center(
                                child: Small(
                                  title: "+",
                                  color: Colors.black,
                                  lineHeight: 1.0,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        minimumSize: const Size(100.0, 44.0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.black.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => {},
                      child: cartItem.product.inStock == true
                          ? const BodyMedium(
                              title: 'Add to save items',
                              color: Colors.black,
                              lineHeight: 1.0,
                            )
                          : const BodyMedium(
                              title: 'Buy from other vendors',
                              color: Colors.black,
                              lineHeight: 1.0,
                            ),
                    )
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: remove,
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Center(
          //   child: BodyMedium(
          //     title: cartItem.product.name,
          //     color: Colors.black54,
          //   ),
          // ),
        ],
      ),
    );
  }
}
