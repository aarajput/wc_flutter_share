
# wc_flutter_share

A [Flutter](https://flutter.io) plugin for sharing file & text with other applications.

### Note for iOS

Your flutter's iOS code needs to be in swift. Otherwise you will get error:

  > === BUILD TARGET flutter_inappbrowser OF PROJECT Pods WITH CONFIGURATION Debug === The “Swift Language Version” (SWIFT_VERSION)
> build setting must be set to a supported value for targets which use
> Swift. Supported values are: 3.0, 4.0, 4.2. This setting can be set in
> the build settings editor.

Instead, if you have already a non-swift project, you can check this issue to solve the problem: [Friction adding swift plugin to objective-c project](https://github.com/flutter/flutter/issues/16049).

## Note for Android
Your android support libraries needs to be of androidx.
If you want to migrate your android project to androidx, can take help from [Migrating to AndroidX](https://developer.android.com/jetpack/androidx/migrate)

## Usage
### Import:

```dart
import 'package:wc_flutter_share/wc_flutter_share.dart';
```

#### Share text:

```dart
WcFlutterShare.text('This is share title', 'This is share text', 'text/plain');
```
#### Share file only:

```dart
final ByteData bytes = await rootBundle.load('assets/wisecrab.png');  
await WcFlutterShare.share(
	sharePopupTitle: 'share',  
    fileName: 'share.png',  
    mimeType: 'image/png',  
    bytesOfFile: bytes.buffer.asUint8List());
```

#### Share file, text and subject:  

```dart
final ByteData bytes = await rootBundle.load('assets/wisecrab.png');  
await WcFlutterShare.share(  
    sharePopupTitle: 'share',  
    subject: 'This is subject',  
    text: 'This is text',  
    fileName: 'share.png',  
    mimeType: 'image/png',  
    bytesOfFile: bytes.buffer.asUint8List());
```

Check out the example app in the Repository for further information.