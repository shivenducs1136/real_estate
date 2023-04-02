import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/model/property_model.dart';

class MySearchableDropdown extends StatefulWidget {
  final List<Property> options;
  final String hintText;
  final String selectedItem;
  final void Function(Property?) onChanged;

  const MySearchableDropdown({
    required this.options,
    required this.hintText,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  _MySearchableDropdownState createState() => _MySearchableDropdownState();
}

class _MySearchableDropdownState extends State<MySearchableDropdown> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<Property>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _controller,
        onTap: () {
          _controller.text = "";
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (query) => widget.options
          .where((option) =>
              option.property_name.toLowerCase().contains(query.toLowerCase()))
          .toList(),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.property_name),
        );
      },
      onSuggestionSelected: (suggestion) {
        _controller.text = suggestion.property_name;
        widget.onChanged(suggestion);
      },
    );
  }
}
