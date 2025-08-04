import 'package:flutter/material.dart';

class AdminAddProductScreen extends StatelessWidget {
  const AdminAddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sản Phẩm', style: TextStyle(color: Colors.black)),
        backgroundColor: const Color(0xFFA1D683),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade700),
                  const SizedBox(height: 8),
                  const Text(
                    'Thêm hình ảnh',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'PNG, JPG hoặc GIF (tối thiểu 500x500px)',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const _LabeledTextField(label: 'Tên sản phẩm'),
            const SizedBox(height: 16),
            const _LabeledTextField(label: 'Giá'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Tình trạng kho',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'in_stock', child: Text('Còn hàng', style: TextStyle(color: Colors.black))),
                      DropdownMenuItem(value: 'out_of_stock', child: Text('Hết hàng', style: TextStyle(color: Colors.black))),
                    ],
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(width: 16),
                const Text('Không giới hạn', style: TextStyle(color: Colors.black)),
                Switch(value: true, onChanged: (_) {}),
              ],
            ),

            const SizedBox(height: 16),
            const _LabeledTextField(label: 'Bộ sưu tập'),
            const SizedBox(height: 16),
            const _LabeledTextField(label: 'Thương hiệu'),
            const SizedBox(height: 16),
            const _LabeledTextField(label: 'Mô tả', maxLines: 3),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Lưu', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  final String label;
  final int maxLines;

  const _LabeledTextField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
