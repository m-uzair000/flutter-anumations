import 'package:flutter/material.dart';
import 'package:flutter_animations/two_animated_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animations Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final size =MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Animations Demo"),),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: ListView(
          padding: const EdgeInsets.only(top: 15,left: 15,right: 15),
          children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>const TwoAnimatedListDemo()));
            }, child: const Text("Two Animated List"),)
          ],
        ),
      ),
    );
  }
}


