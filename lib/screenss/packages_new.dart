import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/businessQuestions.dart/question1.dart';
import 'document_upload_screen.dart'; // Document upload screen
import 'questions.dart'; // Individual filer questions screen
import 'upload_success.dart'; // Success page after all packages are processed

class PackageSelectionScreen extends StatefulWidget {
  @override
  _PackageSelectionScreenState createState() => _PackageSelectionScreenState();
}

class _PackageSelectionScreenState extends State<PackageSelectionScreen> {
  // Track selected packages
  final Set<String> _selectedPackages = {};
  String? _selectedIndividualFiler; // To ensure only one individual filer package is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Package'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Heading for Individual Filer
            Text(
              "Individual Filer",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            _buildPackageOption(
              title: "Bronze - Individual Filer",
              price: "99.99",
              description: Text.rich(
                TextSpan(
                  text: "Includes W-2, 1098, 2441, and 1095-A",
                ),
              ),
              packageKey: "Bronze - Individual Filer",
              isIndividualFiler: true,
              color: Colors.brown[100],
            ),
            SizedBox(height: 16),
            _buildPackageOption(
              title: "Silver - Individual Filer",
              price: "129.99",
              description: Text.rich(
                TextSpan(
                  text: "Everything in Bronze, plus 1099 for non-wage income",
                ),
              ),
              packageKey: "Silver - Individual Filer",
              isIndividualFiler: true,
              color: Colors.grey[200],
            ),
            SizedBox(height: 16),
            _buildPackageOption(
              title: "Gold - Individual Filer",
              price: "179.99",
              description: Text.rich(
                TextSpan(
                  text: "Everything in Silver, plus Schedule C for self-employment income",
                ),
              ),
              packageKey: "Gold - Individual Filer",
              isIndividualFiler: true,
              color: Colors.amber[100],
            ),
            SizedBox(height: 32),

            // Heading for Business Filer
            Text(
              "Business Filer",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            _buildPackageOption(
              title: "Business Filer",
              price: "395.99",
              description: Text("Fast, easy tax filing for S and C corporations or LLC."),
              packageKey: "Business Filer",
              isIndividualFiler: false,
              color: Colors.blue[100],
            ),
            SizedBox(height: 32),
            // Button to proceed with selected packages
            ElevatedButton(
              onPressed: () {
                if (_selectedPackages.isNotEmpty) {
                  _navigateToDocumentUpload(context);
                } else {
                  // Show a message if no package is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select at least one package")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Proceed with Selected Packages",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.black),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageOption({
    required String title,
    required String price,
    required Widget description,
    required String packageKey,
    required bool isIndividualFiler,
    required Color? color,
  }) {
    bool isSelected = _selectedPackages.contains(packageKey);

    return Card(
      color: isSelected ? Colors.green[100] : color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "\$$price",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            description,
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isIndividualFiler) {
                    // Only one individual filer package can be selected at a time
                    if (_selectedIndividualFiler == packageKey) {
                      _selectedPackages.remove(packageKey);
                      _selectedIndividualFiler = null;
                    } else {
                      // Remove previous individual filer selection and select the new one
                      if (_selectedIndividualFiler != null) {
                        _selectedPackages.remove(_selectedIndividualFiler);
                      }
                      _selectedPackages.add(packageKey);
                      _selectedIndividualFiler = packageKey;
                    }
                  } else {
                    // Toggle business filer package
                    if (isSelected) {
                      _selectedPackages.remove(packageKey);
                    } else {
                      _selectedPackages.add(packageKey);
                    }
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isSelected ? Colors.green : Colors.brown[300],
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Center(
                child: Text(
                  isSelected ? "Deselect" : "Select $title",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDocumentUpload(BuildContext context) {
    // Sort packages: Individual filer packages first, then Business filer
    final sortedPackagesList = _sortSelectedPackages(_selectedPackages.toList());

    if (sortedPackagesList.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentUploadScreen(
            packageName: sortedPackagesList.first,
            remainingPackages: sortedPackagesList.sublist(1),
            selectedPackages: _selectedPackages,
            onComplete: () => _handlePackageCompletion(context, sortedPackagesList),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one package.')),
      );
    }
  }

  List<String> _sortSelectedPackages(List<String> packages) {
    List<String> individualPackages = [];
    List<String> businessPackages = [];

    for (var package in packages) {
      if (package.contains('Individual Filer')) {
        individualPackages.add(package);
      } else if (package == 'Business Filer') {
        businessPackages.add(package);
      }
    }

    return individualPackages + businessPackages; // Process individual filer first
  }

  void _handlePackageCompletion(BuildContext context, List<String> remainingPackages) {
    if (remainingPackages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All packages completed!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UploadSuccessScreen()),
      );
    } else {
      _navigateToNextPackage(context, remainingPackages);
    }
  }

  void _navigateToNextPackage(BuildContext context, List<String> remainingPackages) {
    String nextPackage = remainingPackages.first;

    if (nextPackage.contains('Individual Filer')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentUploadScreen(
            packageName: nextPackage,
            remainingPackages: remainingPackages.sublist(1),
            selectedPackages: _selectedPackages,
            onComplete: () => _handlePackageCompletion(context, remainingPackages.sublist(1)),
          ),
        ),
      );
    } else if (nextPackage == "Business Filer") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentUploadScreen(
            packageName: nextPackage,
            remainingPackages: remainingPackages.sublist(1),
            selectedPackages: _selectedPackages,
            onComplete: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Question1()),
            ),
          ),
        ),
      );
    }
  }
}
