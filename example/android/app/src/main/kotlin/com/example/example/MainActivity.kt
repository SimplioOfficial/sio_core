package com.example.example

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  init {
    System.loadLibrary("TrustWalletCore")
  }
}
