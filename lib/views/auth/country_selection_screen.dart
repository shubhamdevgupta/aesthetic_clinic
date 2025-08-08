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
    try {
      final countries = await CountryService().getAll();
      if (mounted) {
        setState(() {
          _allCountries = countries;
          _filteredCountries = countries;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load countries. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = _allCountries;
      } else {
        _filteredCountries = _allCountries.where((c) {
          return c.name.toLowerCase().contains(query) ||
              c.phoneCode.contains(query) ||
              c.countryCode.toLowerCase().contains(query);
        }).toList();
      }
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
      appBar: AppBar(
        title: const Text("Select Country"),
        backgroundColor: const Color(0xFF660033),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF660033)),
              ),
            )
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF660033)),
                      ),
                    ),
                    autofocus: true,
                  ),
                ),
                Expanded(
                  child: _filteredCountries.isEmpty
                      ? const Center(
                          child: Text(
                            'No countries found',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredCountries.length,
                          itemBuilder: (context, index) {
                            final country = _filteredCountries[index];
                            return ListTile(
                              onTap: () => _selectCountry(country),
                              leading: Text(
                                country.flagEmoji, 
                                style: const TextStyle(fontSize: 24)
                              ),
                              title: Text(
                                country.name,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text('+${country.phoneCode}'),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
