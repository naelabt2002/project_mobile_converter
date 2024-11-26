import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unit Converter',
      home: UnitConverterPage(),
    );
  }
}

class UnitConverterPage extends StatefulWidget {
  @override
  _UnitConverterPageState createState() => _UnitConverterPageState();
}

class _UnitConverterPageState extends State<UnitConverterPage> {
  String _selectedCategory = 'Length';
  String _fromUnit = 'Meters';
  String _toUnit = 'Kilometers';
  double? _inputValue;
  String _result = '';

  final Map<String, List<String>> _units = {
    'Length': ['Meters', 'Kilometers', 'Feet', 'Miles'],
    'Weight': ['Grams', 'Kilograms', 'Pounds', 'Ounces'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  final Map<String, Function> _conversionFunctions = {
    'Length': lengthConversion,
    'Weight': weightConversion,
    'Temperature': temperatureConversion,
  };

  void _convert() {
    if (_inputValue == null) {
      setState(() {
        _result = 'Please enter a value';
      });
      return;
    }
    double result = _conversionFunctions[_selectedCategory]!(
        _inputValue!, _fromUnit, _toUnit);
    setState(() {
      _result = result.toStringAsFixed(2);
    });
  }

  static double lengthConversion(double value, String from, String to) {
    // Convert all to meters first
    double meters;
    switch (from) {
      case 'Meters':
        meters = value;
        break;
      case 'Kilometers':
        meters = value * 1000;
        break;
      case 'Feet':
        meters = value * 0.3048;
        break;
      case 'Miles':
        meters = value * 1609.34;
        break;
      default:
        meters = value;
    }

    // Convert meters to desired unit
    switch (to) {
      case 'Meters':
        return meters;
      case 'Kilometers':
        return meters / 1000;
      case 'Feet':
        return meters / 0.3048;
      case 'Miles':
        return meters / 1609.34;
      default:
        return meters;
    }
  }

  static double weightConversion(double value, String from, String to) {
    // Convert all to grams first
    double grams;
    switch (from) {
      case 'Grams':
        grams = value;
        break;
      case 'Kilograms':
        grams = value * 1000;
        break;
      case 'Pounds':
        grams = value * 453.592;
        break;
      case 'Ounces':
        grams = value * 28.3495;
        break;
      default:
        grams = value;
    }

    // Convert grams to desired unit
    switch (to) {
      case 'Grams':
        return grams;
      case 'Kilograms':
        return grams / 1000;
      case 'Pounds':
        return grams / 453.592;
      case 'Ounces':
        return grams / 28.3495;
      default:
        return grams;
    }
  }

  static double temperatureConversion(double value, String from, String to) {
    double celsius;
    // Convert all to Celsius first
    switch (from) {
      case 'Celsius':
        celsius = value;
        break;
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert Celsius to desired unit
    switch (to) {
      case 'Celsius':
        return celsius;
      case 'Fahrenheit':
        return celsius * 9 / 5 + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> unitCategories = _units.keys.toList();
    List<String> unitList = _units[_selectedCategory]!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit Converter'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for unit category
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategory,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                    _fromUnit = _units[_selectedCategory]![0];
                    _toUnit = _units[_selectedCategory]![1];
                    _result = '';
                  });
                }
              },
              items:
                  unitCategories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Input field
            TextField(
              decoration: InputDecoration(
                labelText: 'Input Value',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (String value) {
                setState(() {
                  _inputValue = double.tryParse(value);
                });
              },
            ),
            // From unit dropdown
            DropdownButton<String>(
              isExpanded: true,
              value: _fromUnit,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    
                    _fromUnit = newValue;
                    _result = '';
                  });
                }
              },
              items: unitList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('From: $value'),
                );
              }).toList(),
            ),
            // To unit dropdown
            DropdownButton<String>(
              isExpanded: true,
              value: _toUnit,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _toUnit = newValue;
                    _result = '';
                  });
                }
              },
              items: unitList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('To: $value'),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Convert button
            ElevatedButton(
              onPressed: _convert,
              child: Text('Convert'),
            ),
            SizedBox(height: 20),
            // Result
            Text(
              _result.isEmpty ? '' : 'Result: $_result',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
