import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_new_riverpod/core/services/quote_service.dart';
import 'package:test_new_riverpod/providers/cart_provider.dart';
import 'package:test_new_riverpod/providers/quote_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// void _refresh(BuildContext context) {
//   context.refresh(quoteProvider);
//   var a = QuoteService.instance;
//   a.getQuotes();
// }

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('MVVM With Riverpod'),
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: _Quote(),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () => _refresh(context),
        onPressed: () async =>
            await context.read(cartProvider.notifier).getCart(),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _Quote extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final quoteApiProvider = watch(cartProvider);
    print(quoteApiProvider);

    if (quoteApiProvider is Loaded)
      return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(30),
        itemCount: quoteApiProvider.cart.products.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(quoteApiProvider.cart.products[index].name,
                    style: Theme.of(context).textTheme.bodyText1),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.160,
                        child: Image.network(
                          quoteApiProvider.cart.products[index].image,
                          fit: BoxFit.cover,
                        ))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlineButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () async {
                          context.read(cartProvider.notifier).changeCart(
                              quoteApiProvider.cart.products[index].productId
                                  .toString(),
                              context,
                              'https://storkstores.com/api/decreaseProductQuantity',
                              QuantityOpeartion.decrease);
                          // var a = QuoteService.instance;
                          // a.changeProduct(
                          //     quoteApiProvider.cart.products[index].productId
                          //         .toString(),
                          //     context,
                          //     'https://storkstores.com/api/decreaseProductQuantity');
                        },
                        child: Text('-')),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.blue)),
                        child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(quoteApiProvider
                                .cart.products[index].quantity
                                .toString())),
                      ),
                    ),
                    OutlineButton(
                        onPressed: () async {
                          context.read(cartProvider.notifier).changeCart(
                              quoteApiProvider.cart.products[index].productId
                                  .toString(),
                              context,
                              'https://storkstores.com/api/increaseProductQuantity',
                              QuantityOpeartion.increase);
                          // var a = QuoteService.instance;
                          // a.changeProduct(
                          //     quoteApiProvider.cart.products[index].productId
                          //         .toString(),
                          //     context,
                          //     'https://storkstores.com/api/increaseProductQuantity');
                        },
                        padding: EdgeInsets.all(0),
                        child: Text('+'))
                  ],
                )
              ],
            ),
          );
        },
      );
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.black),
    );
  }
  // error: (_, __) => ErrorScreen(),

}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Error occured"),
    );
  }
}
