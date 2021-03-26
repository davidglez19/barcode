import 'package:flutter/material.dart';

class BuscarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar por nombre'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  print(value);
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Clave'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: TextField(
                keyboardType: TextInputType.text,
                onChanged: (String value) {
                  print(value);
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.search), labelText: 'Nombre'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                  onPressed: () {},
                  child: ListTile(
                    leading: Icon(
                      Icons.search_sharp,
                      color: Color(0xffffffff),
                    ),
                    title: Text(
                      'Buscar',
                      style: TextStyle(color: Color(0xffffffff)),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
