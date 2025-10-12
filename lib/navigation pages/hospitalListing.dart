import 'package:flutter/material.dart';
import 'package:signtalk/components/customAppBar.dart';
import 'package:signtalk/components/hospitalTile.dart';

class HospitalListing extends StatelessWidget {
  const HospitalListing({super.key});

  @override
  Widget build(BuildContext context) {
    final hospitals = [
      {
        "name": "KNUST Hospital",
        "location": "Kumasi, Ghana",
        "address": "University Avenue Rd, KNUST",
        "specialty": "General & Emergency Care",
        "contact": "+233 55 123 4567",
        "image":
            "https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=800&q=80",
        "lat": 6.6730,
        "lng": -1.5717,
      },
      {
        "name": "Komfo Anokye Teaching Hospital",
        "location": "Kumasi, Ghana",
        "address": "Bantama High St, Kumasi",
        "specialty": "Teaching & Specialist Care",
        "contact": "+233 54 987 6543",
        "image":
            "https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=800&q=80",
        "lat": 6.6934,
        "lng": -1.6244,
      },
      {
        "name": "HopeXchange Medical Centre",
        "location": "Kumasi, Ghana",
        "address": "Off Lake Road, near Santasi Roundabout",
        "specialty": "Research, Diagnostic & Specialist Care",
        "contact": "+233 32 209 2222",
        "image":
            "https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=800&q=80",
        "lat": 6.6671,
        "lng": -1.6482,
      },
      {
        "name": "Ashanti Mampong Government Hospital",
        "location": "Ashanti Mampong, Ghana",
        "address": "Hospital Road, Mampong-Ashanti",
        "specialty": "General Health & Maternity",
        "contact": "+233 24 456 7890",
        "image":
            "https://images.unsplash.com/photo-1579684385127-1ef15d508118?auto=format&fit=crop&w=800&q=80",
        "lat": 6.9286,
        "lng": -1.3992,
      },
      {
        "name": "Ashanti School for the Deaf (Health Unit)",
        "location": "Jamasi, Ashanti, Ghana",
        "address": "Ashanti School for the Deaf",
        "specialty": "Health & Rehabilitation Services",
        "contact": "+233 20 111 2233",
        "image":
            "https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=800&q=80",
        "lat": 6.9590,
        "lng": -1.3390,
      },
      {
        "name": "KNUST Health Center",
        "location": "Kumasi, Ghana",
        "address": "Opposite Engineering Gate, KNUST Campus",
        "specialty": "Primary Health & Student Care",
        "contact": "+233 32 206 0399",
        "image":
            "https://images.unsplash.com/photo-1526256262350-7da7584cf5eb?auto=format&fit=crop&w=800&q=80",
        "lat": 6.6739,
        "lng": -1.5702,
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 340,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: hospitals.length,
          itemBuilder: (context, index) {
            final h = hospitals[index];
            return HospitalTile(
              name: h["name"] as String,
              location: h["location"] as String,
              address: h["address"] as String,
              specialty: h["specialty"] as String,
              contact: h["contact"] as String,
              imageUrl: h["image"] as String,
              latitude: h["lat"] as double,
              longitude: h["lng"] as double,
            );
          },
        ),
      ),
    );
  }
}
