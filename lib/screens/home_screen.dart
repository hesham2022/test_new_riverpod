import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_new_riverpod/core/services/quote_service.dart';
import 'package:test_new_riverpod/providers/quote_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

void _refresh(BuildContext context) {
  context.refresh(quoteProvider);
  var a = QuoteService.instance;
  a.getQuotes();
}

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
        onPressed: () => _refresh(context),
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class _Quote extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final quoteApiProvider = watch(quoteProvider);
    return quoteApiProvider.when(
        data: (data) {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(30),
            itemCount: data.products!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data.products![index].name!,
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
                              data.products![index].image,
                              fit: BoxFit.cover,
                            ))),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlineButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () async {
                              var a = QuoteService.instance;
                              a.changeProduct(
                                  data.products[index].productId.toString(),
                                  context,
                                  'https://storkstores.com/api/decreaseProductQuantity');
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
                                child: Text(
                                    data.products[index].quantity.toString())),
                          ),
                        ),
                        OutlineButton(
                            onPressed: () async {
                              var a = QuoteService.instance;
                              a.changeProduct(
                                  data.products[index].productId.toString(),
                                  context,
                                  'https://storkstores.com/api/increaseProductQuantity');
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
        },
        error: (_, __) => ErrorScreen(),
        loading: () => CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black),
            ));
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Error occured"),
    );
  }
}
