import 'package:flutter/material.dart';
import 'Emergency_result_screen.dart';

class EmergencyUserInputPage extends StatefulWidget {
  const EmergencyUserInputPage({Key? key}) : super(key: key);

  @override
  _EmergencyUserInputPageState createState() => _EmergencyUserInputPageState();
}

class _EmergencyUserInputPageState extends State<EmergencyUserInputPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _incidentLocationController =
      TextEditingController();
  final TextEditingController _incidentDescriptionController =
      TextEditingController();
  String? _selectedIncidentType;
  String? _selectedEmergencyLevel;
  DateTime _selectedTime = DateTime.now();

  final Map<String, String> fieldLabels = {
    'incidentType': 'Incident Type',
    'incidentLocation': 'Incident Location',
    'incidentDescription': 'Incident Description',
    'emergencyLevel': 'Emergency Level',
    'incidentTime': 'Incident Time',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color(0xFF4CAF50),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Emergency Input',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Enter Incident Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildCustomDropdown(
                  'incidentType',
                  ['Accident', 'Fire', 'Medical', 'Crime'],
                  (value) => setState(() => _selectedIncidentType = value),
                ),
                const SizedBox(height: 20),
                _buildTextField('incidentLocation', _incidentLocationController,
                    TextInputType.text, 'Please enter incident location'),
                const SizedBox(height: 20),
                _buildTextField(
                    'incidentDescription',
                    _incidentDescriptionController,
                    TextInputType.text,
                    'Please enter incident description'),
                const SizedBox(height: 20),
                _buildCustomDropdown(
                  'emergencyLevel',
                  ['Low', 'Medium', 'High', 'Critical'],
                  (value) => setState(() => _selectedEmergencyLevel = value),
                ),
                const SizedBox(height: 20),
                _buildTimePicker(),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                      backgroundColor: Color(0xFF4CAF50),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String fieldName, TextEditingController controller,
      TextInputType inputType, String validationMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldLabels[fieldName]!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[700],
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter ${fieldLabels[fieldName]}',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          keyboardType: inputType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCustomDropdown(
      String fieldName, List<String> items, Function(String?) onChanged) {
    return CustomDropdown(
      label: fieldLabels[fieldName]!,
      items: items,
      value: _getSelectedValueForField(fieldName),
      onChanged: onChanged,
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldLabels['incidentTime']!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[700],
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            TimeOfDay? time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(_selectedTime),
            );
            if (time != null) {
              setState(() {
                _selectedTime = DateTime(
                  _selectedTime.year,
                  _selectedTime.month,
                  _selectedTime.day,
                  time.hour,
                  time.minute,
                );
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String? _getSelectedValueForField(String fieldName) {
    switch (fieldName) {
      case 'incidentType':
        return _selectedIncidentType;
      case 'emergencyLevel':
        return _selectedEmergencyLevel;
      default:
        return null;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect the input data
      final incidentType = _selectedIncidentType;
      final incidentLocation = _incidentLocationController.text;
      final incidentDescription = _incidentDescriptionController.text;
      final emergencyLevel = _selectedEmergencyLevel;
      final incidentTime = _selectedTime.toString();

      // Navigate to the result screen and pass data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmergencyResultPage(
            predictedResponseTime:
                10.0, // This should be calculated based on the input
            isHighPriority:
                emergencyLevel == 'High' || emergencyLevel == 'Critical',
            recommendedActions:
                'Stay calm and wait for emergency services.', // This should be determined based on the input
            weatherConditions:
                'Sunny', // This should be fetched from a weather service
            userInputData: {
              'incidentType': incidentType,
              'incidentLocation': incidentLocation,
              'incidentDescription': incidentDescription,
              'emergencyLevel': emergencyLevel,
              'incidentTime': incidentTime,
            },
          ),
        ),
      );
    }
  }
}

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.value ?? 'Select ${widget.label}',
                  style: const TextStyle(fontSize: 16),
                ),
                Icon(_isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.items.map((item) {
                return GestureDetector(
                  onTap: () {
                    widget.onChanged(item);
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
