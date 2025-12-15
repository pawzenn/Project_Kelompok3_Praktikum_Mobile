import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'cart_controller.dart';

class CartHistoryView extends StatelessWidget {
  const CartHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    // load history sekali saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOrderHistory();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Pesanan"),
      ),
      body: Obx(() {
        if (controller.isLoadingHistory.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.historyError.value.isNotEmpty) {
          return Center(
            child: Text(controller.historyError.value),
          );
        }

        if (controller.orderHistory.isEmpty) {
          return const Center(
            child: Text("Belum ada riwayat pesanan."),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.orderHistory.length,
          itemBuilder: (context, index) {
            final order = controller.orderHistory[index];

            final date = (order['created_at'] ?? '').toString();

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Pesanan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Tanggal: $date"),
                    ],
                  ),

                  // FIX: schema kamu pakai kolom "total"
                  Text(
                    "Rp ${(order['total'] as num).toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
