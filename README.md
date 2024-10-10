# Colorify

Particle/Block Painting Generator for Minecraft BE

## Usage

- Android

Download the latest release, install and grant its io permission

If you don't know which file you should download, then download `app-arm64-v8a-release.apk`

Files will be generated under `/storage/emulated/0/Download/`

- Windows

Download release `windows.zip` and unzip it to your preferred location

Open `colorify.exe`, files will be generated under `C:\Users\your_name\Documents\colorify`

## Build

Clone project to your computer

```
git clone https://github.com/ComeixAlpha/Colorify6.git
```

Before building, you need to install project dependencies, try

```
flutter pub get
```

Then, build with platform argument according to your needs

- Android

```
flutter build apk --split-per-abi
```

- Windows

```
flutter build windows
```

- iOS/MacOS

Not supported

- Linux

Not supported

Actually, Flutter supports almost all platforms, but I do not have any Apple/Linux device, so I cannot promise the compatibility.

## Features

- Generates particle paintings from images with arguments
- Generates block paintings from images with arguments
- Automatically create `.mcpack` & `.mcaddon` file for conveniently importing
- Generates scripts for conveniently invoking
- WebSocket support
