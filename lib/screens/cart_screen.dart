import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Consumer<Cart>(
                      builder: (_, cartData, _2) => Text(
                        '\$${cartData.totalAmount}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('ORDER NOW!'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<Cart>(
              builder: (_, cartData, _2) => ListView.builder(
                itemBuilder: (ctx, i) {
                  return CartItem(
                    cartData.items.values.toList()[i].id,
                    cartData.items.keys.toList()[i],
                    cartData.items.values.toList()[i].price,
                    cartData.items.values.toList()[i].quantity,
                    cartData.items.values.toList()[i].title,
                  );
                },
                itemCount: cartData.items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
