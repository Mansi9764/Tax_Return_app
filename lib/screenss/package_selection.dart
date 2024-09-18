import 'package:flutter/material.dart';
import 'package:retail_tax_filing_app/screenss/document_upload_screen.dart';

class PackageSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),  // Adds space below the text
        child: Text(
          'Select Your Package',
          style: TextStyle(color: Colors.white),  // Set text color to white
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 4, 3, 3),  // Dark background color
    ),
   
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bronze Package Card
            SizedBox(height: 16),
            PackageCard(
              packageName: 'Bronze',
              price: '\$49.99',
              features: [
                'Basic tax filing',
                'Email support',
                'Access to basic features',
              ],
              icon: Icons.star_border,
              backgroundColor: Color.fromARGB(255, 240, 205, 169),  // Bronze color
              iconColor: Colors.brown[800],  // Matching dark brown for icon
            ),
            SizedBox(height: 6),

            // Gold Package Card
            PackageCard(
              packageName: 'Gold',
              price: '\$99.99',
              features: [
                'Premium tax filing',
                'Priority email support',
                'Access to premium features',
                'One-on-one consultation',
              ],
              icon: Icons.star_half,
              backgroundColor: Color.fromARGB(255, 244, 229, 147),  // Gold color
              iconColor: Colors.amber[800],  // Dark gold for icon
            ),
            SizedBox(height: 6),

            // Platinum Package Card
            PackageCard(
              packageName: 'Platinum',
              price: '\$199.99',
              features: [
                'All-inclusive tax filing',
                '24/7 phone support',
                'Dedicated tax advisor',
                'Access to all features',
              ],
              icon: Icons.star,
              backgroundColor: Color(0xFFE5E4E2),  // Platinum color
              iconColor: Colors.grey[800],  // Dark grey for icon
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for Package Card
class PackageCard extends StatelessWidget {
  final String packageName;
  final String price;
  final List<String> features;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;  // New parameter for icon color

  PackageCard({
    required this.packageName,
    required this.price,
    required this.features,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: iconColor,  // Set icon color here
                    size: 24,
                  ),
                  SizedBox(width: 4),
                  Text(
                    packageName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: iconColor,  // Match text color with icon color
                    ),
                  ),
                ],
              ),
              Divider(color: iconColor, thickness: 1),  // Match divider color
              SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  color: iconColor,  // Match price color
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Row(
                          children: [
                            Icon(Icons.check, color: iconColor, size: 14),  // Match feature icon color
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: iconColor,  // Match feature text color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DocumentUploadScreen(packageName: packageName),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: iconColor,  // Match button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    textStyle: TextStyle(fontSize: 12),
                  ),
                  child: Text(
                    'Select $packageName',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
