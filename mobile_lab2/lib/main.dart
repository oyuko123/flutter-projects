import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// -------------------------
// List item base + two types
// -------------------------
abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubtitle(BuildContext context);
}

class HeadingItem implements ListItem { 
  final String heading;
  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) => Text(
        heading,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

class MessageItem implements ListItem {
  final String sender;
  final String body;
  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}

// -------------------------
// Custom Widgets for Long/Spaced Lists
// -------------------------
class LongListItemWidget extends StatelessWidget {
  final int index;
  const LongListItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text('$index')),
      title: Text('Long List Item $index'),
    );
  }
}

class SpacedListItemWidget extends StatelessWidget {
  final int index;
  const SpacedListItemWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.star),
        title: Text('Spaced List Item $index'),
      ),
    );
  }
}

// -------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Mixed items list (headings + messages)
    final mixedItems = List<ListItem>.generate(
      15,
      (i) => i % 6 == 0
          ? HeadingItem('Heading $i')
          : MessageItem('Sender $i', 'Message body $i'),
    );

    // Long list items
    final longItems = List<String>.generate(10000, (i) => 'Item $i');

    return Scaffold(
      appBar: AppBar(title: const Text('Widget-only Scrollable Demo')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Vertical fixed ListTiles
                  const Padding(
                   padding: EdgeInsets.all(8.0),
                  child: Text('1. Fixed Vertical ListTiles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const ListTile(leading: Icon(Icons.map), title: Text('Map')),
                  const ListTile(leading: Icon(Icons.photo_album), title: Text('Album')),
                  const ListTile(leading: Icon(Icons.phone), title: Text('Phone')),

                  const SizedBox(height: 20),

                  // 2. Horizontal ListView
                  const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('2. Horizontal ListView', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final colors = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.orange];
                        return Container(width: 160, color: colors[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Mixed Heading + Message List
                  const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('3. Mixed Heading + Message List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Column(
                    children: mixedItems
                        .map(
                          (item) => ListTile(
                            title: item.buildTitle(context),
                            subtitle: item.buildSubtitle(context),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                // 4. Grid using fixed height
                const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('4. Grid with Fixed Height', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  ),                  SizedBox(
                    height: 200,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text('Item $index', style: Theme.of(context).textTheme.headlineSmall),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

// 5. Long List using ListView.builder with prototypeItem
  const Padding(
    padding: EdgeInsets.all(8.0),
    child: Text('5. Long List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  ),                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: longItems.length,
                      prototypeItem: ListTile(title: Text(longItems.first)),
                      itemBuilder: (context, index) => ListTile(title: Text(longItems[index])),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 6. Spaced List using ListView.builder
  const Padding(
    padding: EdgeInsets.all(8.0),
    child: Text('6. Spaced List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: 20,
                      prototypeItem: const ListTile(title: Text('Spaced Item 0')),
                      itemBuilder: (context, index) => SpacedListItemWidget(index: index),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
