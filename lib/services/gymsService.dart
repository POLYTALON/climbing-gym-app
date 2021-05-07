import 'package:climbing_gym_app/models/Gym.dart';
import 'package:flutter/material.dart';

class GymsService with ChangeNotifier {
  List<Gym> gymsList = [
    Gym(
        name: "Steinbock Konstanz",
        imageUrl:
            "https://live-cdn.alpenverein.de/chameleon/mediapool/2/4b/steinbock_konstanz_2020_web_2_id90061.jpg"),
    Gym(
        name: "Boulderhaus Heidelberg",
        imageUrl:
            "https://www.vielmehr.heidelberg.de/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-26-at-11.38.38-1-343x343.jpeg"),
    Gym(
        name: "Hotzenblock Waldshut",
        imageUrl:
            "https://mein.toubiz.de/api/v1/file/621e7dcf-ba95-4e9c-b7b0-5e7cdbf980cb/preview?format=image%2Fjpeg&width=1900"),
    Gym(
        name: "Blocwald Villingen-Schwenningen",
        imageUrl:
            "https://www.schwarzwaelder-bote.de/media.media.7cef0462-e2d3-4562-a1c3-554135509902.original1024.jpg"),
    Gym(
        name: "Blöckle Ravensburg",
        imageUrl:
            "https://www.boulderhalle-ravensburg.de/wp-content/uploads/2020/05/1_Bloeckle_Halle.jpg"),
  ];
}
