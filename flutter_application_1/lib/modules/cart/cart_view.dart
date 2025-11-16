import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return const Center(child: Text('Keranjang masih kosong'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final line = controller.items[index];
                  final p = line.product;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: p.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                p.imageUrl!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.fastfood),
                      title: Text(p.name),
                      subtitle: Text('Rp ${p.price.toStringAsFixed(0)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => controller.decrement(line),
                          ),
                          Text('${line.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => controller.increment(line),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: Rp ${controller.totalPrice.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => controller.checkout(),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
