# money_app

This app was developed using VSCode on Flutter version 2.2.2 using Dart 2.13.3

NOTE: Google AdMob only supports iOS and Android platforms. I had set up the application to run on Android devices and for web apps however the web app will not run due to implementing AdMob.

Google AdSense requires the app to be approved by them and is finicky when working with dynamic sites.

In order to run the app as a web app without ads, you must remove all the Google AdMob methods/implementations.



To run app: 
-------------------------------------------------------------------------------------------------------
If a null safety error is thrown when debugging, run app with the command: 
    
    flutter run --no-sound-null-safety

If the above command does not work, go to extension settings -> Workspace -> Dark & Flutter.
Look for Dart: Flutter Run Additional Args and click Add Item to insert "--no-sound-null-safety". Do the same for Dart: Vm Additional Args. 

If it still does not work, go to 'settings.json' file and add the following configuration:

    "dart.flutterRunAdditionalArgs": [
        "--no-sound-null-safety"
    ],
    "dart.vmAdditionalArgs": [
        "--no-sound-null-safety"
    ]


# Running integration test to test the app's UI and performance

Run the command: 
    flutter drive --driver integration_test/driver.dart --target integration_test/app_test.dart

Testing data should be shown under the 'integration_response_data.json' file



# Google AdMob

The banner ad is set to show on the home page of the app.

The interstitial ad is set to show anytime the user clicks on their profile settings.

The reward ad is set to show anytime a user sends a message.



DEPENDENCIES & PLUG-INS:
--------------------------------------------------------------------------------
In case the dependencies and plug ins do not carry over to github:

Inside pubspec.yaml:

    environment:
        sdk: ">=2.12.0 <3.0.0"

    dependencies:
    flutter:
        sdk: flutter
    firebase_core: ^1.3.0
    firebase_auth: ^1.4.1
    cloud_firestore: ^2.2.2
    flutter_signin_button: ^2.0.0
    bubble: ^1.2.1
    google_mobile_ads: ^0.13.0 


# For Google and Firebase:
Inside 'build.gradle' file under the 'android/app' folder, add these implementations in the 'dependencies {}' section:

    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    implementation 'com.android.support:multidex:1.0.3'
    implementation platform('com.google.firebase:firebase-bom:28.2.0')
    implementation 'com.google.firebase:firebase-analytics'

    implementation 'com.google.firebase:firebase-auth'

    // Also declare the dependency for the Google Play services library and specify its version
    implementation 'com.google.android.gms:play-services-auth:19.0.0'
    implementation 'com.google.android.gms:play-services-ads:20.2.0'

Also make sure to have multidex enabled and have minimum sdk version 19:

    minSdkVersion 19
    targetSdkVersion 30
    multiDexEnabled true
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName

Do the same for the other 'build.gradle' file that is inside the 'android' folder, add these implementations in the 'dependencies {}' section:

    classpath 'com.android.tools.build:gradle:4.1.0'
    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    classpath 'com.google.gms:google-services:4.3.8'


# The file 'index.html' must include the following

Inside the end of 'body' must include the following scripts for firebase/firestore:

    <script src="https://apis.google.com/js/platform.js" async defer></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.7/firebase-analytics.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.7/firebase-auth.js"></script>
    <script src="https://www.gstatic.com/firebasejs/8.6.7/firebase-firestore.js"></script>

    <script>
        // Your web app's Firebase configuration
        // For Firebase JS SDK v7.20.0 and later, measurementId is optional
        var firebaseConfig = {
        apiKey: "AIzaSyD7PgaUfCdEjHrUijw7BrsD8K9q36bGUvM",
        authDomain: "money-app-e81ba.firebaseapp.com",
        projectId: "money-app-e81ba",
        storageBucket: "money-app-e81ba.appspot.com",
        messagingSenderId: "802486791313",
        appId: "1:802486791313:web:e5dc0c4dd7ef88b9342330",
        measurementId: "G-VVFK44TTBP"
        };
        // Initialize Firebase
        firebase.initializeApp(firebaseConfig);
        firebase.analytics();
    </script>



