import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/entry_provider.dart';
import '../models/diary_entry.dart';
import 'package:intl/intl.dart';

class AddEditEntryPage extends StatefulWidget {
  @override
  _AddEditEntryPageState createState() => _AddEditEntryPageState();
}

class _AddEditEntryPageState extends State<AddEditEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  DateTime _date = DateTime.now();
  String _mood = 'Select Mood';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker at the top
                _buildDatePicker(),
                SizedBox(height: 20),

                // Title input
                _buildTitleInput(),
                SizedBox(height: 20),

                // Content input
                _buildContentInput(),
                SizedBox(height: 20),

                // Mood Selector
                _buildMoodSelector(),
                SizedBox(height: 20),

                // Save and Cancel Buttons
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(
        'Date: ${DateFormat('yyyy-MM-dd').format(_date)}',
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.calendar_today),
      onTap: _selectDate,
    );
  }

  Widget _buildTitleInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onSaved: (value) => _title = value!,
      validator: (value) => value!.isEmpty ? 'Title is required' : null,
    );
  }

  Widget _buildContentInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Content',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      maxLines: 8,
      onSaved: (value) => _content = value!,
      validator: (value) => value!.isEmpty ? 'Content is required' : null,
    );
  }

  Widget _buildMoodSelector() {
    return GestureDetector(
      onTap: _selectMood,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_mood, style: TextStyle(fontSize: 16)),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding:
                EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          ),
          child: Text('Save Entry'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectMood() async {
    final List<String> moods = [
      '😊 Happy',
      '😢 Sad',
      '😃 Excited',
      '😟 Anxious',
      '😌 Relaxed'
    ];
    
    String? selectedMood = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Your Mood'),
          contentPadding: EdgeInsets.all(10.0),
          content:
              Column(mainAxisSize: MainAxisSize.min, children:
              moods.map((mood) => ListTile(
                title: Text(mood),
                onTap: () {
                  Navigator.pop(context, mood);
                },
              )).toList()),
          actions:[
            TextButton(onPressed : () => Navigator.pop(context), child : Text("Cancel"))
          ]
        );
      },
    );

    if (selectedMood != null) {
      setState(() {
        _mood = selectedMood;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new entry with the provided data
      final newEntry = DiaryEntry(
        title:_title,
        content:_content,
        date:_date,
        mood:_mood, // Ensure the DiaryEntry model has a mood property
      );

      // Save the entry using the provider
      Provider.of<EntryProvider>(context, listen:false).addEntry(newEntry);
      
      // Optionally show a success message or perform additional actions here

      Navigator.pop(context);
    }
  }
}