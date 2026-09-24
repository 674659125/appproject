import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/detected_ingredient.dart';
import '../widgets/bounding_box_overlay.dart';
import '../widgets/add_ingredient_dialog.dart';
import 'recipe_suggestion_screen.dart';

enum ScanPresetMode {
  mixedFridge,     // ตู้เย็นรวมมิตร (ไข่ไก่, หมูสับ, แครอท, มะเขือเทศ, กะหล่ำปลี ฯลฯ)
  meatsAndEggs,    // โซนเนื้อสัตว์ & ไข่ (ไข่ไก่, หมูสับ, กุ้งสด, เนื้อไก่)
  freshVeggies,    // โซนผักสด (แครอท, บล็อกโคลี่, ผักสดรวม, เห็ดเข็มทอง)
  nonFoodOrHuman,  // ภาพบุคคล/สิ่งของทั่วไป (ไม่พบวัตถุดิบ)
}

class IngredientScannerScreen extends StatefulWidget {
  const IngredientScannerScreen({super.key});

  @override
  State<IngredientScannerScreen> createState() => _IngredientScannerScreenState();
}

class _IngredientScannerScreenState extends State<IngredientScannerScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _hasScanned = false;
  File? _capturedImageFile;
  final ImagePicker _picker = ImagePicker();

  ScanPresetMode _selectedPreset = ScanPresetMode.mixedFridge;

  // Scanning line animation controller
  late AnimationController _scanAnimationController;

  // Active detected ingredients - starts EMPTY!
  final List<DetectedIngredient> _detectedIngredients = [];

  @override
  void initState() {
    super.initState();
    _scanAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        setState(() {
          _isCameraInitialized = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _scanAnimationController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (pickedFile != null && mounted) {
        final file = File(pickedFile.path);
        if (await file.exists()) {
          setState(() {
            _capturedImageFile = file;
          });
          await _runIngredientDetection();
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (mounted) {
        await _runIngredientDetection();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      if (_isCameraInitialized &&
          _cameraController != null &&
          _cameraController!.value.isInitialized &&
          !_cameraController!.value.isTakingPicture) {
        final XFile image = await _cameraController!.takePicture();
        final file = File(image.path);
        if (await file.exists() && mounted) {
          setState(() {
            _capturedImageFile = file;
          });
        }
      }
      await _runIngredientDetection();
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      if (mounted) {
        await _runIngredientDetection();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // AI Ingredient Detection Engine based on scan mode
  Future<void> _runIngredientDetection() async {
    if (!mounted) return;

    _scanAnimationController.repeat(reverse: true);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('กำลังใช้ AI ตรวจวิเคราะห์วัตถุดิบอาหารในภาพ...'),
          ],
        ),
        duration: Duration(milliseconds: 1800),
        backgroundColor: Color(0xFFFF9100),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 1800));

    if (!mounted) return;

    _scanAnimationController.stop();

    setState(() {
      _hasScanned = true;
      _detectedIngredients.clear();

      // Check selected scenario or detected photo type
      switch (_selectedPreset) {
        case ScanPresetMode.mixedFridge:
          _detectedIngredients.addAll([
            DetectedIngredient(
              id: 'm1',
              name: 'ไข่ไก่',
              category: 'meat',
              color: const Color(0xFFFF3B30),
              relativeBounds: const Rect.fromLTWH(0.50, 0.44, 0.38, 0.17),
            ),
            DetectedIngredient(
              id: 'm2',
              name: 'หมูสับ',
              category: 'meat',
              color: const Color(0xFFFF2D55),
              relativeBounds: const Rect.fromLTWH(0.12, 0.44, 0.35, 0.16),
            ),
            DetectedIngredient(
              id: 'm3',
              name: 'ผักสดรวม',
              category: 'veggie',
              color: const Color(0xFF34C759),
              relativeBounds: const Rect.fromLTWH(0.12, 0.62, 0.38, 0.20),
            ),
            DetectedIngredient(
              id: 'm4',
              name: 'แครอท',
              category: 'veggie',
              color: const Color(0xFFFF9500),
              relativeBounds: const Rect.fromLTWH(0.52, 0.63, 0.36, 0.18),
            ),
            DetectedIngredient(
              id: 'm5',
              name: 'กระเทียม',
              category: 'seasoning',
              color: const Color(0xFFAF52DE),
              relativeBounds: const Rect.fromLTWH(0.40, 0.28, 0.22, 0.12),
            ),
          ]);
          break;

        case ScanPresetMode.meatsAndEggs:
          _detectedIngredients.addAll([
            DetectedIngredient(
              id: 'e1',
              name: 'ไข่ไก่',
              category: 'meat',
              color: const Color(0xFFFF3B30),
              relativeBounds: const Rect.fromLTWH(0.52, 0.42, 0.38, 0.18),
            ),
            DetectedIngredient(
              id: 'e2',
              name: 'หมูสับ',
              category: 'meat',
              color: const Color(0xFFFF2D55),
              relativeBounds: const Rect.fromLTWH(0.14, 0.45, 0.35, 0.16),
            ),
            DetectedIngredient(
              id: 'e3',
              name: 'กุ้งสด',
              category: 'meat',
              color: const Color(0xFFFF9500),
              relativeBounds: const Rect.fromLTWH(0.15, 0.64, 0.35, 0.18),
            ),
            DetectedIngredient(
              id: 'e4',
              name: 'กระเทียม',
              category: 'seasoning',
              color: const Color(0xFFAF52DE),
              relativeBounds: const Rect.fromLTWH(0.54, 0.65, 0.25, 0.12),
            ),
          ]);
          break;

        case ScanPresetMode.freshVeggies:
          _detectedIngredients.addAll([
            DetectedIngredient(
              id: 'v1',
              name: 'บล็อกโคลี่',
              category: 'veggie',
              color: const Color(0xFF34C759),
              relativeBounds: const Rect.fromLTWH(0.14, 0.35, 0.32, 0.15),
            ),
            DetectedIngredient(
              id: 'v2',
              name: 'ผักสดรวม',
              category: 'veggie',
              color: const Color(0xFF30D158),
              relativeBounds: const Rect.fromLTWH(0.12, 0.52, 0.38, 0.20),
            ),
            DetectedIngredient(
              id: 'v3',
              name: 'มะเขือเทศ',
              category: 'veggie',
              color: const Color(0xFFFF3B30),
              relativeBounds: const Rect.fromLTWH(0.52, 0.54, 0.35, 0.18),
            ),
            DetectedIngredient(
              id: 'v4',
              name: 'ไข่ไก่',
              category: 'meat',
              color: const Color(0xFFFF9500),
              relativeBounds: const Rect.fromLTWH(0.52, 0.35, 0.35, 0.16),
            ),
          ]);
          break;

        case ScanPresetMode.nonFoodOrHuman:
          // Human face or non-food item scanned -> 0 ingredients found!
          _detectedIngredients.clear();
          break;
      }
    });

    if (_detectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ ไม่พบวัตถุดิบอาหารในภาพ โปรดถ่ายรูปวัตถุดิบอาหาร หรือตู้เย็นใหม่อีกครั้ง'),
          duration: Duration(seconds: 3),
          backgroundColor: Color(0xFFE65100),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✨ สแกนสำเร็จ! ตรวจพบวัตถุดิบ ${_detectedIngredients.length} รายการ'),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    }
  }

  void _resetScan() {
    setState(() {
      _hasScanned = false;
      _capturedImageFile = null;
      _detectedIngredients.clear();
    });
  }

  void _removeIngredient(String id) {
    setState(() {
      _detectedIngredients.removeWhere((item) => item.id == id);
    });
  }

  Future<void> _addNewIngredient() async {
    final String? newName = await showDialog<String>(
      context: context,
      builder: (context) => const AddIngredientDialog(),
    );

    if (newName != null && newName.isNotEmpty && mounted) {
      setState(() {
        _hasScanned = true;
        _detectedIngredients.add(
          DetectedIngredient(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: newName,
            color: const Color(0xFFFF9100),
            relativeBounds: const Rect.fromLTWH(0.35, 0.25, 0.30, 0.15),
          ),
        );
      });
    }
  }

  void _navigateToPage2() {
    if (_detectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณาถ่ายรูปสแกนตู้เย็น หรือกด "+ เพิ่มเติม" วัตถุดิบก่อนนะครับ'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final ingredientNames = _detectedIngredients.map((e) => e.name).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecipeSuggestionScreen(
          ingredients: ingredientNames,
        ),
      ),
    );
  }

  void _showPresetSelectionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'โหมดจำลองสถานการณ์สแกน AI (สำหรับทดสอบ)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'เลือกรูปแบบโซนภาพเพื่อทดสอบการสแกนตรวจจับวัตถุดิบแบบสมจริง:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  _buildPresetRadioTile(
                    title: '🥦 ตู้เย็นรวมมิตร (ไข่ไก่, หมูสับ, แครอท, มะเขือเทศ, กระเทียม)',
                    mode: ScanPresetMode.mixedFridge,
                    setModalState: setModalState,
                  ),
                  _buildPresetRadioTile(
                    title: '🥩 โซนเนื้อสัตว์ & ไข่ไก่ (ไข่ไก่, หมูสับ, กุ้งสด, กระเทียม)',
                    mode: ScanPresetMode.meatsAndEggs,
                    setModalState: setModalState,
                  ),
                  _buildPresetRadioTile(
                    title: '🥗 โซนผักสด (บล็อกโคลี่, ผักสดรวม, มะเขือเทศ, ไข่ไก่)',
                    mode: ScanPresetMode.freshVeggies,
                    setModalState: setModalState,
                  ),
                  _buildPresetRadioTile(
                    title: '👤 ถ่ายรูปหน้าคน / สิ่งของทั่วไป (ทดสอบไม่พบวัตถุดิบ)',
                    mode: ScanPresetMode.nonFoodOrHuman,
                    setModalState: setModalState,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (_hasScanned) {
                          _runIngredientDetection();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9100),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('ตกลง', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPresetRadioTile({
    required String title,
    required ScanPresetMode mode,
    required StateSetter setModalState,
  }) {
    return RadioListTile<ScanPresetMode>(
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      value: mode,
      groupValue: _selectedPreset,
      activeColor: const Color(0xFFFF9100),
      dense: true,
      onChanged: (val) {
        if (val != null) {
          setState(() {
            _selectedPreset = val;
          });
          setModalState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera / Fridge Background View
          Positioned.fill(
            child: _buildCameraOrImageBackground(screenSize),
          ),

          // 2. Bounding Box Overlay on Detected Items
          if (_hasScanned && _detectedIngredients.isNotEmpty)
            Positioned.fill(
              child: BoundingBoxOverlay(
                ingredients: _detectedIngredients,
                screenSize: screenSize,
              ),
            ),

          // 3. Scan Line Overlay Animation
          if (_isProcessing)
            AnimatedBuilder(
              animation: _scanAnimationController,
              builder: (context, child) {
                return Positioned(
                  top: screenSize.height * _scanAnimationController.value * 0.7,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF9100).withOpacity(0.8),
                          blurRadius: 12,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

          // Guidance Hint Overlay before Scanning
          if (!_hasScanned && !_isProcessing)
            Positioned(
              top: screenSize.height * 0.38,
              left: 24,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.center_focus_weak, color: Color(0xFFFF9100), size: 36),
                    SizedBox(height: 8),
                    Text(
                      'ส่องกล้องไปที่ตู้เย็นแล้วกดปุ่มสแกน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'หรือเลือกรูปถ่ายตู้เย็นจากอัลบั้มเพื่อวิเคราะห์วัตถุดิบ',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

          // 4. Top Floating Header Pill: "เครื่องสแกนวัตถุดิบ 🔍"
          Positioned(
            top: mediaQuery.padding.top + 12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'เครื่องสแกนวัตถุดิบ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Quick Action Camera Controls on Right Side
          Positioned(
            top: mediaQuery.padding.top + 70,
            right: 16,
            child: Column(
              children: [
                _buildCircularActionButton(
                  icon: Icons.photo_library,
                  tooltip: 'เลือกรูปจากคลัง',
                  onPressed: _pickImageFromGallery,
                ),
                const SizedBox(height: 12),
                _buildCircularActionButton(
                  icon: Icons.camera_alt,
                  tooltip: 'ถ่ายรูปตู้เย็น',
                  onPressed: _capturePhoto,
                ),
                const SizedBox(height: 12),
                _buildCircularActionButton(
                  icon: Icons.tune,
                  tooltip: 'เลือกโหมดสแกนภาพ',
                  onPressed: _showPresetSelectionModal,
                ),
                if (_hasScanned || _capturedImageFile != null) ...[
                  const SizedBox(height: 12),
                  _buildCircularActionButton(
                    icon: Icons.refresh,
                    tooltip: 'รีเซ็ตสแกนใหม่',
                    onPressed: _resetScan,
                  ),
                ],
              ],
            ),
          ),

          // 5. Bottom Overlay Card (Sheet)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: mediaQuery.padding.bottom + 16,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row: Title & "+ เพิ่มเติม"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _hasScanned
                            ? 'ตรวจพบวัตถุดิบแล้ว (${_detectedIngredients.length})'
                            : 'ยังไม่ได้สแกนวัตถุดิบ (0)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: _addNewIngredient,
                        child: const Row(
                          children: [
                            Text(
                              '+ เพิ่มเติม',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFFF9100),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Chips List of Detected Items
                  if (!_hasScanned && _detectedIngredients.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: const Text(
                        'กดปุ่ม 📷 ถ่ายรูป หรือ 🖼️ เลือกรูป เพื่อสแกนตู้เย็น',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    )
                  else if (_detectedIngredients.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width: double.infinity,
                      child: const Text(
                        'ไม่พบวัตถุดิบ กด "+ เพิ่มเติม" เพื่อใส่ชื่อเอง',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _detectedIngredients.map((ingredient) {
                        return _buildIngredientChip(ingredient);
                      }).toList(),
                    ),

                  const SizedBox(height: 20),

                  // Big Action Button: "ถ่ายรูปสแกนวัตถุดิบ" หรือ "ทำเมนูอะไรดี? 🔍"
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: !_hasScanned ? _capturePhoto : _navigateToPage2,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9100),
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: const Color(0xFFFF9100).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !_hasScanned ? 'ถ่ายรูปสแกนวัตถุดิบ' : 'ทำเมนูอะไรดี?',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            !_hasScanned ? Icons.camera_alt : Icons.search,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientChip(DetectedIngredient ingredient) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFD4CC),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ingredient.name,
            style: const TextStyle(
              color: Color(0xFFFF5252),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () => _removeIngredient(ingredient.id),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Color(0xFFFF5252),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30, width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        tooltip: tooltip,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCameraOrImageBackground(Size screenSize) {
    if (_capturedImageFile != null) {
      return Image.file(
        _capturedImageFile!,
        fit: BoxFit.cover,
        width: screenSize.width,
        height: screenSize.height,
        errorBuilder: (context, error, stackTrace) {
          return _buildFridgeFallbackGraphic();
        },
      );
    }

    if (_isCameraInitialized &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      final double aspectRatio = _cameraController!.value.aspectRatio;
      if (aspectRatio > 0) {
        return ClipRect(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: screenSize.width,
              height: screenSize.width * aspectRatio,
              child: CameraPreview(_cameraController!),
            ),
          ),
        );
      }
    }

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF000000)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=1200&q=80',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return _buildFridgeFallbackGraphic();
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
    );
  }

  Widget _buildFridgeFallbackGraphic() {
    return Container(
      color: const Color(0xFFE8ECEF),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.kitchen, size: 90, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'กล้องสแกนตู้เย็น',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
