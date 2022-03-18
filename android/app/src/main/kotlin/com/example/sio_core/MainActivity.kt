package com.example.sio_core

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
  init {
    System.loadLibrary("TrustWalletCore")
  }
}
