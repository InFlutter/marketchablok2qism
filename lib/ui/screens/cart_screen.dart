import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_simple_online_shop_cubit/data/models/product.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/cart/cart_bloc.dart';
import 'package:very_simple_online_shop_cubit/logic/blocs/order/order_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CartBloc cartBloc = context.read<CartBloc>();
    final OrderBloc orderBloc = context.read<OrderBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart screen'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
          if (state is LoadedCartState) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: state.cart.products.length,
              itemBuilder: (BuildContext context, int index) {
                final Product product = state.cart.products[index];
                return Dismissible(
                  key: ValueKey(product.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    cartBloc.add(DeleteProductFromCartEvent(id: product.id));
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.title),
                      Image.network(
                        product.imageUrl,
                        height: 80,
                        width: 100,
                      ),
                      Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Add product'));
        },
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () {
          orderBloc.add(AddOrderEvent(cart: cartBloc.cart));
          cartBloc.add(MakeOrderEvent());
        },
        label: const Text('Order'),
        icon: const Icon(Icons.shopping_cart_rounded),
      ),
    );
  }
}
