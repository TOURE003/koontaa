import 'package:flutter/material.dart';

final TextEditingController searchController = TextEditingController();
PreferredSizeWidget rechercheAppBarre(context) {
  return AppBar(
    backgroundColor: Colors.deepOrange,
    automaticallyImplyLeading: false,
    title: Container(
      height: 36,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Recherche',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 4), // petit espacement
          TextButton(
            onPressed: () {
              //rétoure à la page précedente
              Navigator.pop(context);
            },
            child: Text("Annuler", style: TextStyle(color: Colors.deepOrange)),
          ),
        ],
      ),
    ),
  );
}
