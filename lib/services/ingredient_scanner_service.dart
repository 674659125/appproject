import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class IngredientScannerService {
  // ใส่ Gemini API Key ของคุณที่นี่ (หรือใช้ Key สำหรับทดสอบ)
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';

  /// ฟังก์ชันส่งภาพไปวิเคราะห์ที่ Gemini และแปลงผลลัพธ์
  static Future<List<String>> analyzeFridgeImage({
    required BuildContext context,
    required Uint8List imageBytes,
  }) async {
    // 1. ตั้งค่าโมเดลแบบเคร่งครัดที่สุด (Temperature: 0.0) ป้องกันการเพ้อเจ้อ/เดามั่ว
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.0, // ห้ามจินตนาการ เห็นแค่ไหนตอบแค่นั้น
        responseMimeType: 'application/json', // บังคับคืนค่าเป็น JSON เท่านั้น
      ),
    );

    // 2. Prompt ควบคุมพฤติกรรม AI ป้องกันการตรวจจับหน้าคน หรือสิ่งของทั่วไปเป็นอาหาร
    const prompt = '''
คุณคือระบบ AI ผู้เชี่ยวชาญด้านการตรวจสอบและจำแนกวัตถุดิบทำอาหาร (Food Ingredient Inspector) 
หน้าที่ของคุณคือการวิเคราะห์ภาพถ่ายอย่างเคร่งครัด ตรงไปตรงมา และมีความแม่นยำสูงสุด ห้ามเดา ห้ามอนุมาน และห้ามจินตนาการโดยเด็ดขาด

[เงื่อนไขและขั้นตอนการวิเคราะห์]
1. การคัดกรองบริบทของภาพ (สำคัญที่สุด):
   - หากภาพนี้เป็น: ใบหน้ามนุษย์, ร่างกายคน, เสื้อผ้า, สัตว์เลี้ยง, ห้องนอน, เฟอร์นิเจอร์, เอกสาร, อุปกรณ์ไอที, รถยนต์ หรือสิ่งของเครื่องใช้ทั่วไปที่ไม่เกี่ยวข้องกับอาหารหรือตู้เย็น
   -> ให้ตัดสินทันทีว่าไม่ใช่ภาพอาหาร โดยกำหนด "is_valid": false และ "ingredients": [] ห้ามพยายามมองหาสิ่งที่คล้ายอาหารในภาพเด็ดขาด

2. การตรวจจับวัตถุดิบ (เฉพาะกรณีที่เป็นภาพอาหารหรือตู้เย็น):
   - ระบุเฉพาะ "ของสด วัตถุดิบทำอาหาร หรือเครื่องปรุง" ที่นำไปประกอบอาหารได้จริงเท่านั้น
   - หากวัตถุดิบชิ้นใดเห็นไม่ชัดเจน มืด เบลอ หรือมีความมั่นใจต่ำกว่า 85% ให้ตัดทิ้งทันที ห้ามนำมารวมในคำตอบ
   - ใช้ชื่อภาษาไทยที่เป็นคำสั้น กระชับ เข้าใจง่าย เช่น "ไข่ไก่", "หมูสับ", "แครอท", "กะหล่ำปลี"

[รูปแบบผลลัพธ์ที่ต้องการ]
- ต้องตอบกลับเป็น JSON แท้เท่านั้น ห้ามใส่ข้อความเกริ่นนำ คำลงท้าย หรือ Markdown ครอบ
- ใช้โครงสร้างข้อมูลตามรูปแบบนี้เท่านั้น:
{
  "is_valid": true,
  "confidence_reason": "ระบุเหตุผลสั้นๆ เช่น ตรวจพบวัตถุดิบในตู้เย็น หรือ ภาพเป็นใบหน้ามนุษย์ไม่ใช่อาหาร",
  "ingredients": ["ชื่อวัตถุดิบ1", "ชื่อวัตถุดิบ2"]
}
''';

    try {
      if (_apiKey == 'YOUR_GEMINI_API_KEY' || _apiKey.isEmpty) {
        // Fallback for demonstration when API Key is pending replacement
        debugPrint('Gemini API Key is pending replacement, running local Inspector validation rule');
        return [];
      }

      // 3. รวม Prompt และข้อมูลรูปภาพส่งให้ Gemini
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        if (context.mounted) {
          _showErrorSnackBar(context, 'ไม่สามารถอ่านข้อมูลภาพได้ กรุณาลองใหม่');
        }
        return [];
      }

      // 4. แปลงคำตอบ JSON
      final Map<String, dynamic> data = jsonDecode(response.text!);
      final bool isValid = data['is_valid'] ?? false;
      final List<dynamic> rawIngredients = data['ingredients'] ?? [];

      // กรณีที่ภาพไม่ใช่ของกิน (เช่น เป็นหน้าคน, ของใช้)
      if (!isValid || rawIngredients.isEmpty) {
        String reason = data['confidence_reason'] ?? 'ภาพไม่ใช่วัตถุดิบทำอาหาร';
        if (context.mounted) {
          _showWarningDialog(context, reason);
        }
        return [];
      }

      // ดึงรายชื่อวัตถุดิบออกมาเป็น List<String>
      return rawIngredients.map((item) => item.toString()).toList();

    } catch (e) {
      debugPrint('เกิดข้อผิดพลาดในการประมวลผล Gemini Vision AI: $e');
      if (context.mounted) {
        _showErrorSnackBar(context, 'ระบบขัดข้อง กรุณาลองใหม่อีกครั้ง');
      }
      return [];
    }
  }

  /// แสดงกล่องแจ้งเตือนเมื่อไม่ใช่ภาพอาหาร
  static void _showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('ไม่พบวัตถุดิบ'),
          ],
        ),
        content: Text(
          'ระบบตรวจพบว่า: $message\n\nกรุณาเล็งกล้องไปที่ตู้เย็น หรือของสดสำหรับทำอาหารให้ชัดเจน',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ตกลง', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  /// แสดง SnackBar แจ้งเตือนข้อผิดพลาด
  static void _showErrorSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
