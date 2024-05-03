package com.mrjohndev.launcher1

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
   override fun onPause() {
        super.onPause()
        overridePendingTransition(R.anim.slide_from_right, R.anim.slide_to_left)
        // overridePendingTransition(0, 0)
    }

    override fun onResume() {
        super.onResume()
        overridePendingTransition(R.anim.slide_from_left, R.anim.slide_to_right)
        // overridePendingTransition(0, 0)
    }
}
