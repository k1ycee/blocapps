import 'package:flutter/material.dart';
import 'package:blocapps/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<CounterBloc>(
        create: (context) => CounterBloc(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Counter'),
      ),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count){
          return Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton(
              child: Icon(Icons.remove),
              onPressed: (){
                counterBloc.add(CounterEvent.decrement);
              }
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: (){
                  counterBloc.add(CounterEvent.increment);
                }
            ),
          ),
        ],
      )
    );
  }
}

