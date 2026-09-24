import 'package:flutter/material.dart';

class AddIngredientDialog extends StatefulWidget {
  const AddIngredientDialog({super.key});

  @override
  State<AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _quickSuggestions = const [
    'ไข่ไก่',
    'ผักกาดขาว',
    'หมูสับ',
    'แครอท',
    'กระเทียม',
    'มะเขือเทศ',
    'นมสด',
    'เนย',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String name) {
    if (name.trim().isNotEmpty) {
      Navigator.of(context).pop(name.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.add_circle_outline, color: Color(0xFFFF9100)),
          SizedBox(width: 8),
          Text(
            'เพิ่มวัตถุดิบเพิ่มเติม',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'พิมพ์ชื่อวัตถุดิบ... (เช่น แครอท)',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: _submit,
            ),
            const SizedBox(height: 16),
            const Text(
              'หรือเลือกจากรายการยอดฮิต:',
              style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _quickSuggestions.map((suggestion) {
                return ActionChip(
                  label: Text(suggestion),
                  backgroundColor: const Color(0xFFFFF3E0),
                  labelStyle: const TextStyle(
                    color: Color(0xFFE65100),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () => _submit(suggestion),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () => _submit(_controller.text),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('เพิ่ม', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
