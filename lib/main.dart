import 'package:flutter/material.dart';
import 'services/api_services.dart';
import 'models/joke.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Jokes App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: JokeTypesScreen(),
    );
  }
}

class JokeTypesScreen extends StatefulWidget {
  @override
  _JokeTypesScreenState createState() => _JokeTypesScreenState();
}

class _JokeTypesScreenState extends State<JokeTypesScreen> {
  List<String> jokeTypes = [];

  @override
  void initState() {
    super.initState();
    fetchJokeTypes();
  }

  void fetchJokeTypes() async {
    List<String> types = await ApiService.getJokeTypes();
    setState(() {
      jokeTypes = types;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.lightbulb),
            onPressed: () async {
              Joke randomJoke = await ApiService.getRandomJoke();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RandomJokeScreen(joke: randomJoke),
                ),
              );
            },
          ),
        ],
      ),
      body: jokeTypes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: jokeTypes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(jokeTypes[index]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JokesListScreen(type: jokeTypes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class JokesListScreen extends StatefulWidget {
  final String type;

  JokesListScreen({required this.type});

  @override
  _JokesListScreenState createState() => _JokesListScreenState();
}

class _JokesListScreenState extends State<JokesListScreen> {
  List<Joke> jokes = [];

  @override
  void initState() {
    super.initState();
    fetchJokesByType();
  }

  void fetchJokesByType() async {
    List<Joke> fetchedJokes = await ApiService.getJokesByType(widget.type);
    setState(() {
      jokes = fetchedJokes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.type} Jokes')),
      body: jokes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(jokes[index].setup),
              subtitle: Text(jokes[index].punchline),
            ),
          );
        },
      ),
    );
  }
}

class RandomJokeScreen extends StatelessWidget {
  final Joke joke;

  RandomJokeScreen({required this.joke});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Joke')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(joke.setup, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(joke.punchline, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
