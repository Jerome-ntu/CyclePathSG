<h1 align="center">🚴‍♂️ CyclePathSG</h1>

<p align="center">
  <b>A Flutter-powered app for cyclists to explore and navigate Singapore’s Park Connector Network (PCN)</b>
</p>

<hr />

<h2>🗺️ Overview</h2>

<p>
  <strong>CyclePathSG</strong> helps cyclists in Singapore find, visualize, and navigate cycling routes with ease.
  It provides real-time location tracking, dynamic route generation, and Google Maps integration for seamless navigation.
</p>

<hr />

<h2>✨ Features</h2>
<ul>
  <li><strong>📍 Real-time Location Tracking</strong> — Detect and display the user's live position on the map.</li>
  <li><strong>🛣️ Suggested Routes</strong> — View nearby cycling paths categorized by area.</li>
  <li><strong>🚦 Route Navigation</strong> — Get turn-by-turn paths between origin and destination using Google Directions API.</li>
  <li><strong>🧭 Custom Map Markers</strong> — FontAwesome-based markers for origin/current locations.</li>
  <li><strong>☁️ Firebase Firestore Integration</strong> — Store and retrieve routes and user data in real time.</li>
  <li><strong>📬 Reverse Geocoding</strong> — Convert GPS coordinates into readable addresses.</li>
</ul>

<hr />

<h2>🧠 Tech Stack</h2>
<table>
  <thead>
    <tr>
      <th>Layer</th>
      <th>Technology</th>
      <th>Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><strong>Frontend</strong></td>
      <td>Flutter (Dart)</td>
      <td>UI and state management</td>
    </tr>
    <tr>
      <td><strong>Mapping</strong></td>
      <td>Google Maps Flutter, flutter_polyline_points</td>
      <td>Route visualization and navigation</td>
    </tr>
    <tr>
      <td><strong>Location Services</strong></td>
      <td>Geolocator, Geocoding</td>
      <td>GPS tracking and address lookup</td>
    </tr>
    <tr>
      <td><strong>Database</strong></td>
      <td>Firebase Firestore</td>
      <td>Data persistence and synchronization</td>
    </tr>
    <tr>
      <td><strong>UI Enhancements</strong></td>
      <td>Font Awesome, Provider</td>
      <td>Custom icons and state management</td>
    </tr>
  </tbody>
</table>

<hr />

<h2>⚙️ Setup Instructions</h2>

<h3>1️⃣ Prerequisites</h3>
<ul>
  <li>Flutter SDK (v3.0+)</li>
  <li>Dart (v2.17+)</li>
  <li>Android Studio or Xcode</li>
  <li>A valid <strong>Google Maps API Key</strong> with these APIs enabled:
    <ul>
      <li>Maps SDK for Android</li>
      <li>Maps SDK for iOS</li>
      <li>Directions API</li>
      <li>Geocoding API</li>
    </ul>
  </li>
</ul>

<h3>2️⃣ Clone Repository</h3>
<pre><code>git clone https://github.com/&lt;your-username&gt;/cyclepathsg.git
cd cyclepathsg
</code></pre>

<h3>3️⃣ Configure API Keys</h3>
<p>
  Add your Google Maps API key in the following files:
</p>
<ul>
  <li><code>android/app/src/main/AndroidManifest.xml</code></li>
  <li><code>ios/Runner/AppDelegate.swift</code> (or Info.plist)</li>
</ul>

<h3>4️⃣ Run the App</h3>
<pre><code>flutter pub get
flutter run
</code></pre>

<hr />

<h2>🧩 Main folder Structure</h2>
<pre><code>lib/
├── providers/
│   ├── current_location_provider.dart
│   └── route_provider.dart
├── models/
│   └── route_model.dart
├── screens/
│   ├── home_screen.dart
│   └── map_screen.dart
├── widgets/
│   └── suggest_route_card.dart
└── main.dart
</code></pre>

<hr />
<hr />

<h2>💡 Author</h2>
<p>
  Developed by <strong>Jerome Ke</strong><br>
  ✉️ <a href="mailto:jeromekejh@gmail.com">jeromekejh@gmail.com</a>
</p>
