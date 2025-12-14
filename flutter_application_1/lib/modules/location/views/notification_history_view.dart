import 'package:flutter/material.dart';

class NotificationHistoryView extends StatelessWidget {
  const NotificationHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Notifikasi')),
      body: const Center(child: Text('Belum ada notifikasi')),
    );
  }
}
