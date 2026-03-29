import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ModuleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
