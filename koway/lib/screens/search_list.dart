import 'package:flutter/material.dart';


class SearchList extends StatefulWidget {
  const SearchList({super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SearchAnchor(
          builder: (BuildContext context,SearchController controller){
            return SearchBar(
              controller: controller,
              padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)
              ),
              onTap: ,
            )
          }, 
          suggestionsBuilder: suggestionsBuilder)
        
        ),
    )
  }
}
