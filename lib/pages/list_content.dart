import 'package:flutter/material.dart';
import 'about_page.dart';

class ListContent extends StatelessWidget {
  const ListContent({super.key});

  //lista
  final List<String> items = const [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Contenido'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: const Icon(Icons.star_border, color: Colors.deepPurple),
                    title: Text(items[index]),
                    subtitle: Text('Indice: $index'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      //tocar un item
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Seleccionado: ${items[index]}')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          //navegacion
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver al Home'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutPage()),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('About'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}