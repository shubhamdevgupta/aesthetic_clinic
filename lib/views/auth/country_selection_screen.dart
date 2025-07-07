import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountrySelectionScreen extends StatefulWidget {
  const CountrySelectionScreen({super.key});

  @override
  State<CountrySelectionScreen> createState() => _CountrySelectionScreenState();
}

class _CountrySelectionScreenState extends State<CountrySelectionScreen> {
  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCountries();
    _searchController.addListener(_filterCountries);
  }

  Future<void> _loadCountries() async {
    final countries = await CountryService().getAll();
    setState(() {
      _allCountries = countries;
      _filteredCountries = countries;
      _isLoading = false;
    });
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = _allCountries.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.phoneCode.contains(query) ||
            c.countryCode.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _selectCountry(Country country) {
    Navigator.pop(context, country);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Country")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search country name or code',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                return ListTile(
                  onTap: () => _selectCountry(country),
                  leading: Text(country.flagEmoji, style: const TextStyle(fontSize: 24)),
                  title: Text(country.name),
                  trailing: Text('+${country.phoneCode}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
