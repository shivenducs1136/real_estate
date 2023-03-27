import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/model/property_model.dart';

class MyAgentSearchableDropdown extends StatefulWidget {
  final List<AgentModel> options;
  final String hintText;
  final String selectedItem;
  final void Function(AgentModel?) onChanged;

  const MyAgentSearchableDropdown({
    required this.options,
    required this.hintText,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  _MyAgentSearchableDropdownState createState() =>
      _MyAgentSearchableDropdownState();
}

class _MyAgentSearchableDropdownState extends State<MyAgentSearchableDropdown> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.selectedItem);
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField<AgentModel>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(),
        ),
      ),
      suggestionsCallback: (query) => widget.options
          .where((option) =>
              option.agent_name.toLowerCase().contains(query.toLowerCase()))
          .toList(),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.agent_name),
        );
      },
      onSuggestionSelected: (suggestion) {
        _controller.text = suggestion.agent_name;
        widget.onChanged(suggestion);
      },
    );
  }
}
