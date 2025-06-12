import 'package:flutter/material.dart';
import 'package:flutter_app/models/form_base.dart';

abstract class FormBaseState<W extends StatefulWidget, T>
  extends State<W>
  implements FormBase<T> {
  
}