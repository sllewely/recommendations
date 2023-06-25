import 'package:flutter/material.dart';
import 'package:mobile/auth.dart';
import 'package:mobile/auth_helper.dart';
import 'package:mobile/http/test_list.dart';
import 'package:mobile/sign_in.dart';
import 'package:mobile/widgets/signed_in_wrapper.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:provider/provider.dart';

const authConfig = AuthConfig(
  signInUrl: 'http://127.0.0.1:3000/oauth/token',
  signUpUrl: 'http://127.0.0.1:3000/api/v1/users',
  tokenUrl: 'http://127.0.0.1:3000/oauth/token',
  clientId: "reSVxvuBow1vnuwt3_yd1nG-b3sOnNEb2DvEP1uaHTo",
  clientSecret: "uQ2wRf2lgFHy1SvASLIPSxyqBshexi-GTzeWbwdhw5s",
);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthHelper(authConfig),
      child: const RecApp(),
    ),
  );
}


class RecApp extends StatelessWidget {
  const RecApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recommendations',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Recommendations'),
      routes: <String, WidgetBuilder> {
        '/signin': (BuildContext context) => const SignUpPage()
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  static const List<Tab> defaultTabs = <Tab>[
    Tab(text: 'Saved'),
    Tab(text: 'Feed'),
    Tab(text: 'Popular'),
  ];

  int _counter = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late TabController _tabController;
  late Future<TestList> futureTestList;
  late Future<AccessTokenResponse> futureAccessToken;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: defaultTabs.length, vsync: this);
    futureTestList = fetchTestList();

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          bottom: TabBar(
            controller: _tabController,
            tabs: defaultTabs,
          )
      ),
      drawer: Drawer(
          child: SafeArea(child: NavigationRail(
            extended: false,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.home), label: Text('Home')),
              NavigationRailDestination(
                  icon: Icon(Icons.account_circle), label: Text('Account')),
              NavigationRailDestination(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  label: Text('Close Nav Bar'))
            ],
            selectedIndex: 0,
          ))),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SignedInWrapper(
            wrapped: Center(
              child: Consumer<AuthHelper>(
                builder: (context, authHelper, child) {
                  var firstName = authHelper.currentUser.firstName;
                  var lastName = authHelper.currentUser.lastName;
                  return Text("Hello $firstName $lastName");
                }
              ),
            ),
          ),
          Center(
              child: CounterCard(
                  counter: _counter,
                  reset: _resetCounter,
                  testText: FutureBuilder<TestList>(
                    future: futureTestList,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.testList.toString());
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    }
                  ),
              ),
          ),
          const Center(
              child: Text('RIGHT PANE!!'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.counter,
    required this.reset,
    required this.testText,
  });
  final int counter;
  final void Function() reset;
  final Widget testText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          ElevatedButton(onPressed: reset, child: const Icon(Icons.refresh)),
          testText,
        ],
      ),
    );
  }
}
