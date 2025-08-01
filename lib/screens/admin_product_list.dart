import 'package:flutter/material.dart';
import 'package:lttbddnc/screens/admin_product_list_add.dart'; 
import 'package:lttbddnc/screens/admin_product_info';

class AdminProductListScreen extends StatefulWidget {
  const AdminProductListScreen({super.key});

  @override
  State<AdminProductListScreen> createState() => _AdminProductListScreenState();
}

class _AdminProductListScreenState extends State<AdminProductListScreen> {
  final List<Map<String, dynamic>> products = [
    {
      'name': 'Coffee',
      'image': 'https://via.placeholder.com/100',
      'selected': false,
    },
    {
      'name': 'Trà Sửa',
      'image': 'https://via.placeholder.com/100',
      'selected': false,
    },
    // Thêm nhiều sản phẩm nếu muốn
  ];

  void toggleSelectAll(bool? selected) {
    setState(() {
      for (var product in products) {
        product['selected'] = selected ?? false;
      }
    });
  }

  void deleteSelected() {
    setState(() {
      products.removeWhere((item) => item['selected'] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Sản phẩm'),
        backgroundColor: const Color(0xFFA1D683),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Thêm sản phẩm', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProductScreen()),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_download),
                  label: const Text('Tải danh mục PDF'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade100),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Nhập vào'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade300),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.file_download),
                  label: const Text('Xuất ra'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Xoá (đã chọn)'),
                  onPressed: deleteSelected,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Checkbox(
                      value: products.every((item) => item['selected'] == true),
                      onChanged: toggleSelectAll,
                    ),
                  ),
                  const DataColumn(label: Text('Inf')),
                  const DataColumn(label: Text('Hình ảnh')),
                  const DataColumn(label: Text('Tên')),
                  const DataColumn(label: Text('Sửa')),
                ],
                rows: products.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(Checkbox(
                        value: item['selected'],
                        onChanged: (value) {
                          setState(() {
                            item['selected'] = value!;
                          });
                        },
                      )),
                     DataCell(
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductInfoScreen(
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                      DataCell(Image.network(
                        item['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )),
                      DataCell(Text(item['name'])),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.indigo),
                          onPressed: () {
                            // TODO: Điều hướng đến màn hình chỉnh sửa
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
