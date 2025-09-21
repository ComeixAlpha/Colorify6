![](assets/c6mask2.png)

Particle/Block Painting Generator for Minecraft BE made with Flutter.

## Supported Game Versions

Almost all modern versions of MCBE.

## Platforms

<table>
    <tr>
        <td rowspan="2">Windows</td>   
        <td>Win10+</td> 
        <td>&#10003</td> 
   </tr>
       <tr>
        <td>Other</td> 
        <td>&#10005</td> 
   </tr>
    <tr>
        <td rowspan="2">Android</td>    
  		 <td>HarmonyOS</td> 
  		 <td>&#10005</td> 
    </tr>
    <tr>
        <td>Other</td> 
        <td>&#10003</td> 
    </tr>
    <tr>
        <td>Linux</td> 
        <td colspan="2", align="right">&#10005</td> 
    </tr> 
    <tr>
        <td>iOS/MacOS</td> 
        <td colspan="2", align="right">&#10005</td> 
    </tr> 
</table>

*Netease isn't supported and won't be supported*

## Installation

- Android

Download the latest release, install and grant all permissions required.

If you don't know which file you should download, then download `app-arm64-v8a-release.apk`.

Files will be generated under `/storage/emulated/0/Download/`.

- Windows

Download release `windows.zip` and unzip it to your preferred location.

Open `colorify.exe`, files will be generated under `C:\Users\your_name\Documents\colorify`.

## Build Yourself

1. Ensure your Dart SDK and Flutter SDK.

2. Clone project to your computer

```bash
git clone https://github.com/ComeixAlpha/Colorify6.git
```

3. Get denpendencies

```bash
flutter pub get
```

4. Then, build with platform argument according to your needs

- Android

```bash
flutter build apk --split-per-abi
```

- Windows

```bash
flutter build windows
```

## Features

- Generates highly customizable particle paintings.
  - Automatically generate all particles you need with a resource pack.
  - Automatically controls dust particle with dynamic color.
- Generates highly customizable block paintings.
  - Resize with interpolation just in Colorify.
  - Dither with Floyd-Steinberg just in Colorify.
  - RGB & RGB+ color distance supported.
  - Supports all versions.
- Automatically create `.mcpack` & `.mcaddon` file.
  - Customizable pack info.
  - Beautiful hash pack icon.
  - Functions.
  - Scripts.
  - Structures.
  - Particle Json.
- WebSocket support. All kinds of generation could be send by WebSocket.
