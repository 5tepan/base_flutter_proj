import 'package:flutter/gestures.dart';

class OnTapGestureRecognizer extends TapGestureRecognizer {
  OnTapGestureRecognizer(GestureTapCallback onTap) {
    this.onTap = onTap;
  }
}
