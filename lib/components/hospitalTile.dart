import 'package:flutter/material.dart';
import 'package:signtalk/navigation%20pages/MapPage.dart';
import 'package:signtalk/utils/constants.dart';

class HospitalTile extends StatelessWidget {
  final String name;
  final String location;
  final String address;
  final String specialty;
  final String contact;
  final String imageUrl;
  final double latitude;
  final double longitude;

  const HospitalTile({
    super.key,
    required this.name,
    required this.location,
    required this.address,
    required this.specialty,
    required this.contact,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorsConstant.background,
      elevation: 4,
      shadowColor: ColorsConstant.tertiary.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Hospital Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // 📄 Hospital Details
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏥 Hospital Name
                Text(
                  name,
                  style: FontsConstant.headingMedium.copyWith(
                    color: ColorsConstant.textColor,
                    fontSize: 17,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 4),

                // 🩺 Specialty
                Text(
                  specialty,
                  style: FontsConstant.bodyMedium.copyWith(
                    color: ColorsConstant.secondary,
                    fontStyle: FontStyle.italic,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),

                // 📍 Address
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: ColorsConstant.extra,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        address,
                        style: FontsConstant.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // 🌍 Location
                Text(
                  location,
                  style: FontsConstant.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // ☎️ Contact
                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 14,
                      color: ColorsConstant.extra,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        contact,
                        style: FontsConstant.bodySmall.copyWith(
                          color: ColorsConstant.textColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 🗺️ View on Map Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => HospitalMapPage(
                                name: name,
                                latitude: latitude,
                                longitude: longitude,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsConstant.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.map, size: 18, color: Colors.white),
                    label: Text(
                      "View on Map",
                      style: FontsConstant.buttonText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
