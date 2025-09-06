// import 'package:cov_19/Utilities/state_services.dart';
// import 'package:flutter/material.dart';
//
// class CountriesListScreen extends StatefulWidget {
//   const CountriesListScreen({Key? key}) : super(key: key); // Older syntax for key initialization
//
//   @override
//   State<CountriesListScreen> createState() => _CountriesListScreenState();
// }
//
// class _CountriesListScreenState extends State<CountriesListScreen> {
//   TextEditingController searchController=TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     StateServices stateServices= StateServices();
//     return  Scaffold(
//  appBar: AppBar(
//    elevation: 0,
//    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//  ),
//       body: SafeArea(child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(controller: searchController,
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//               hintText: "Search with country name ",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(50.0)
//               )
//             ),
//             ),
//           ),
//           Expanded(child: FutureBuilder(
//             future: stateServices.countriesListApi(),
//             builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator()); // Show a loader while waiting
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}')); // Handle API error
//               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const Center(child: Text('No data found')); // Handle empty data
//               } else {
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     final countryData = snapshot.data![index];
//
//                     // Safely extract fields with fallback values
//                     final country = countryData['country'] ?? 'Unknown';
//                     final cases = countryData['cases']?.toString() ?? '0';
//                     final flag = countryData['countryInfo']?['flag'];
//
//                     return ListTile(
//                       title: Text(country),
//                       subtitle: Text('Cases: $cases'),
//                       leading: flag != null
//                           ? Image.network(flag, height: 50, width: 50)
//                           : const Icon(Icons.flag), // Fallback for missing flags
//                     );
//                   },
//                 );
//               }
//             },
//           )
//
//           )
//   ]
//       )),
//     );
//   }
// }
import 'package:cov_19/Utilities/state_services.dart'; // Ensure this is properly imported
import 'package:cov_19/view/detail_screen.dart';
import 'package:flutter/material.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> countriesList = []; // Original list of countries
  List<dynamic> filteredCountries = []; // Filtered list for search

  @override
  void initState() {
    super.initState();
    fetchCountries(); // Load countries when the screen initializes
  }

  /// Fetch countries from the API and initialize both `countriesList` and `filteredCountries`.
  Future<void> fetchCountries() async {
    try {
      StateServices stateServices = StateServices();
      List<dynamic> data = await stateServices.countriesListApi();
      setState(() {
        countriesList = data;
        filteredCountries = data; // Initially, show all countries
      });
    } catch (e) {
      print("Error fetching countries: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load countries. Please try again.')),
      );
    }
  }

  /// Filter countries based on the search query
  void filterCountries(String query) {
    if (query.isEmpty) {
      // Show all countries if the search field is empty
      setState(() {
        filteredCountries = countriesList;
      });
    } else {
      setState(() {
        filteredCountries = countriesList
            .where((country) => country['country']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  hintText: "Search with country name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                onChanged: filterCountries, // Trigger filtering as user types
              ),
            ),

            // Country List
            Expanded(
              child: filteredCountries.isEmpty
                  ? const Center(child: Text('No countries found'))
                  : ListView.builder(
                itemCount: filteredCountries.length,
                itemBuilder: (context, index) {
                  final countryData = filteredCountries[index];

                  // Safely extract fields with fallback values
                  final country = countryData['country'] ?? 'Unknown';
                  final cases = countryData['cases']?.toString() ?? '0';
                  final flag = countryData['countryInfo']?['flag'];

                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) =>DetailScreen()));
                    },
                    child: ListTile(
                      title: Text(country),
                      subtitle: Text('Cases: $cases'),
                      leading: flag != null
                          ? Image.network(
                        flag,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                      )
                          : const Icon(Icons.flag),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
