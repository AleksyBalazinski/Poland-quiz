# Poland Quiz
## Project description
Poland Quiz in an educational application for learning about Poland's voivodeships.
### Learning
User can study Poland's geography by selecting regions on an interactive map.
Information associated with each voivodeship includes its:
* area,
* population,
* voivode seat,
* sejmik seat,
* flag.
### Testing what you'd learned
To make the learning experience more engaging, quizzes are divided into levels of increasing difficulty.
At each level the user has 3 "health points" which get reduced by one on every wrong answer. Once the number of health points hits zero, all points collected at the current level are canceled.
At each successive level, the number of questions increases by three.
To add an aspect of competition, the information about 15 users with best scores is displayed on the leaderboard.
## Optional requirements
* Supported platforms: Android, web
* Animations: when new level is unlocked a confetti animation is displayed ([confetti package](https://pub.dev/packages/confetti)).
* Tests: there is one test - infojson_test.dart verifies if the JSON file containing information about voivodeships is parsed correctly.
* Signing in process: before opening the app, the user has to sign in (Firebase authentication).
* Internationalization: the app is available in two languages: English and Polish (depending on system settings).
* Custom painting: map of Poland is implemented using custom painting.
* Offline support: the app can work in offline mode thanks to Firestore's support for offline data persistence.
Error message is displayed if the user tries to authorize with the app in offline mode (because they are using the app for the first time or have signed out deliberately).

## Test account
* username: test_usr
* email: test_usr@example.com
* password: 123456
## Firestore schema
```
"Users": {
    "<document_id>": {
        "user-name": <user name>,
        "pos-of-voivodeship-lvl": <level>,
        "voivodeship-on-map-lvl": <level>,
        "user-id": <document_id>
    },
    ...
} 
```
## Details
The map of voivodeships was downloaded as GeoJSON file from 
[GADM website](https://gadm.org/).
The amount of detail this map provides by default is overwhelming from the performance perspective, and thankfully completely excessive for our needs.
The map was simplified using the Visvalingam weighted area algorithm implemented [here](https://mapshaper.org/).<br>
The coordinates in GeoJSON format are given in WGS84 coordinate system and thus a conversion into EPSG:3857 (which is the standard "wall-map" projection most users are used to) was necessary (this is where proj4dart package came in useful).

