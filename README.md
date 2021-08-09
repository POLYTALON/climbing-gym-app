# GripGuide

[![Flutter Android Build](https://github.com/POLYTALON/climbing-gym-app/actions/workflows/flutter-android-build.yml/badge.svg)](https://github.com/POLYTALON/climbing-gym-app/actions/workflows/flutter-android-build.yml)

<p align="center">
  <img src="https://user-images.githubusercontent.com/35730788/118404186-15035900-b672-11eb-92ca-1f5e7d62a452.PNG">
</p>

An idea by [Polytalon](https://polytalon.com/?lang=en), designed and built by students of the [HTWG Konstanz](https://www.htwg-konstanz.de/).

GripGuide is an app designed for climbing gyms and climbers alike.
It provides gyms with the opportunity to publish routes and news, while climbers can track their progress and give feedback to the gym.

## Feature overview

Generally, the app allows registering as a user and choosing your current gym.
After registering, users can use the gym's routes to track their progress and get an overview of their current performance.

Gym owners and route setters can add, remove and edit routes.
Additionally, gym owners can publish news, to be displayed for every gym-user of their gym.

All of these features, including editing routes and gyms, can be used from withing the app and without manually editing the configuration in the backend.
Gyms, their owner and global news can only be added by an operator, while a gym owner can add route setters and local news to their gym.

## Technology

To build the user-interface, we use [Flutter](https://flutter.dev/), which compiles down to native iOS and Android apps.
The backend is build using [Firebase](https://firebase.google.com/), as it provides an easy Flutter integration.

We test and deploy our code using automated [GitHub Actions](https://github.com/POLYTALON/climbing-gym-app/actions) that ran on different points during the development process.
Our GitHub Actions include automatic testing of builds for iOS and Android.

The project can also be compiled as a Web-App, but is currently not actively maintained, as it isn't part of our current scope.

## Development Team

- [Andreas Ly](https://github.com/hyerex)
- [Bernhard Gundel](https://github.com/BernhardGundel)
- [Julian Sabo](https://github.com/Juelsen)
- [Nail Özmen](https://github.com/nailomat)
- [Sascha Villing](https://github.com/v1lling)
- [Sebastian Voigt](https://github.com/VoigtSebastian)
- [Timmy Pfau](https://github.com/LugsoIn2)
