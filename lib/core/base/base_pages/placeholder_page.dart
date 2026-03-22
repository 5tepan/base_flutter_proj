import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Экран-заглушка "В разработке".
/// Используется как замена экранов, которые еще в разработке или еще не начаты.
/// Если на такие экраны есть переходы из других частей приложения.
class PlaceholderPage extends StatefulWidget {
  final VoidCallback? onTap;

  const PlaceholderPage({super.key, this.onTap});

  @override
  _PlaceholderPageState createState() => _PlaceholderPageState();
}

class _PlaceholderPageState extends State<PlaceholderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'В разработке',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            onPressed: () => widget.onTap?.call(),
          ),
        ],
        elevation: 0,
        foregroundColor: AppColors.white,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFF7A8AFF),
      body: Center(
        child: Image.asset('assets/ic_in_developing.png', fit: BoxFit.contain),
      ),
    );
  }
}
