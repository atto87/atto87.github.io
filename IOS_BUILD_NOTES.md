# iOS Build Notes

This project has an iOS target generated under `ios/`.

## Target

- App display name: はなクイズ図鑑
- Bundle identifier: `com.zareg.hanaQuizZukan`
- Minimum iOS deployment target: iOS 13.0
- Orientation: portrait only
- iPhone X / iPhone 10 class devices are supported through Flutter `SafeArea` handling.

## Build On macOS

iOS builds require macOS and Xcode.

```sh
flutter pub get
open ios/Runner.xcworkspace
```

In Xcode:

1. Select `Runner`.
2. Open `Signing & Capabilities`.
3. Select your Apple Developer Team.
4. Connect the iPhone, or choose an iPhone simulator.
5. Run from Xcode, or return to the terminal.

Terminal run:

```sh
flutter devices
flutter run -d <ios-device-id>
```

Release archive:

```sh
flutter build ipa
```

Keep `ASSET_CREDITS.md` with app distribution materials because several flower images require attribution.
