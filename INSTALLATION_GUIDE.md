# PersonaSphere — Mobile Installation Guide

**Release Date:** April 17, 2026  
**Version:** 1.0.0 (Build 1)  
**Application ID:** `com.personasphere.quizapp`

---

## 📱 Installation Methods

### **Option 1: Direct APK Installation (Easiest for Testing)**

#### For Android Physical Device:

1. **Enable Developer Mode**:
   - Go to **Settings** → **About Phone**
   - Tap **Build Number** 7 times until "Developer mode enabled" message appears

2. **Enable USB Debugging**:
   - Go to **Settings** → **Developer Options** (visible after step 1)
   - Toggle **USB Debugging** ON

3. **Connect Phone to Computer**:
   - Use a USB cable to connect your Android phone
   - Allow USB debugging permission when prompted on phone
   - Windows will install ADB drivers (may take a moment)

4. **Install APK via ADB**:
   ```bash
   cd "c:\Users\gps\Desktop\Mobile Applictaions\Personality Quiz App"
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```
   - Wait for "Success" message
   - App will appear on your home screen

#### For Android Emulator:

1. **Open Android Emulator** (Android Studio):
   - Launch **Android Studio**
   - Click **Tools** → **Device Manager**
   - Start an emulator (e.g., Pixel 7 API 34)

2. **Install APK**:
   ```bash
   cd "c:\Users\gps\Desktop\Mobile Applictaions\Personality Quiz App"
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

3. **Launch App**:
   - Emulator will show the app in the app drawer
   - Tap to launch

---

### **Option 2: Via Firebase App Distribution (For Beta Testing)**

1. **Setup Firebase Project**:
   ```bash
   npm install -g firebase-tools
   firebase login
   firebase projects:list
   ```

2. **Upload APK to Firebase**:
   ```bash
   firebase appdistribution:distribute \
     build/app/outputs/flutter-apk/app-release.apk \
     --app=1:your-project-id:android:your-app-id \
     --release-notes="Initial release" \
     --testers="your-email@example.com"
   ```

3. **Testers install via email link** (automatic on their device)

---

### **Option 3: Google Play Store Upload (For Public Release)**

Already covered in [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md) — requires keystore signing first.

---

## ✅ Troubleshooting

| Issue | Solution |
|-------|----------|
| **"adb: command not found"** | Android SDK not in PATH. See [Android SDK Setup](https://developer.android.com/studio/command-line/adb) |
| **"USB Debugging not available"** | Tap Build Number 7 times in About Phone to enable Developer Mode |
| **"Installation failed. Unknown failure"** | Device storage full; clear cache or uninstall older version first |
| **"App crashes on launch"** | Check logcat: `adb logcat \| grep flutter` for error messages |
| **"Permission denied (publickey)"** | Revoke USB debugging and reconnect phone, then authorize again |

---

## 🚀 Quick Commands

### Install Release APK:
```bash
adb install "c:\Users\gps\Desktop\Mobile Applictaions\Personality Quiz App\build\app\outputs\flutter-apk\app-release.apk"
```

### Uninstall App:
```bash
adb uninstall com.personasphere.quizapp
```

### View Device Logs:
```bash
adb logcat | findstr flutter
```

### Check Connected Devices:
```bash
adb devices
```

### Grant Permissions (if needed):
```bash
adb shell pm grant com.personasphere.quizapp android.permission.VIBRATE
```

---

## 📋 Pre-Installation Checklist

- [ ] Android device or emulator ready
- [ ] USB debugging enabled (physical device only)
- [ ] USB cable connected (physical device only)
- [ ] At least 100 MB free storage on device
- [ ] ADB installed and in PATH
- [ ] APK file exists at `build/app/outputs/flutter-apk/app-release.apk`

---

## 🎯 Post-Installation Testing

1. **Launch App**:
   - Tap PersonaSphere icon
   - Confirm splash screen loads
   - Confirm onboarding appears (first time only)

2. **Test Core Flows**:
   - [ ] Browse quizzes on home screen
   - [ ] Select a quiz and answer all questions
   - [ ] View results with stats and confetti
   - [ ] Share result card via system share sheet
   - [ ] Toggle light/dark mode in settings

3. **Test Data Persistence**:
   - [ ] Complete a quiz, mark as favorite
   - [ ] Close app completely
   - [ ] Reopen app → confirm quiz progress saved
   - [ ] Confirm favorite still marked

4. **Offline Verification**:
   - [ ] Turn off WiFi and mobile data
   - [ ] Reopen app → confirm works perfectly
   - [ ] Clear app cache (`adb shell pm clear com.personasphere.quizapp`)
   - [ ] Reopen → onboarding appears again (expected)

---

## 📞 Support

- **ADB not found?** Install Android SDK Platform Tools from [Android Developers](https://developer.android.com/studio/releases/platform-tools)
- **Device not recognized?** Try: `adb kill-server` then `adb start-server`
- **App crashes?** Check app logs: `adb logcat | grep "E.flutter"`

---

**Ready to install?** Connect your device and run the install command above! 🚀
