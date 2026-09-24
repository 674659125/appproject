import 'package:flutter/material.dart';

class Page2RecipeScreen extends StatelessWidget {
  final List<String> ingredients;

  const Page2RecipeScreen({
    super.key,
    required this.ingredients,
  });

  // Master recipe database
  static const List<Map<String, dynamic>> _masterRecipes = [
    {
      'id': 'rec_1',
      'title': 'ไข่เจียวหมูสับทรงเครื่อง',
      'category': 'เมนูทอด',
      'time': '10 นาที',
      'difficulty': 'ง่ายมาก',
      'rating': 4.9,
      'imageEmoji': '🍳🥩',
      'color': Color(0xFFFFF8E1),
      'requiredIngredients': ['ไข่ไก่'],
      'optionalIngredients': ['หมูสับ', 'แครอท', 'ต้นหอม', 'มะเขือเทศ', 'กุ้งสด'],
      'description': 'ไข่เจียวฟูหอม หอมกลิ่นกระทะ ปรุงรสกลมกล่อม ทานกับข้าวสวยร้อนๆ',
      'steps': [
        'ตอกไข่ไก่ใส่ชาม ปรุงรสด้วยซีอิ๊วขาวและน้ำปลา',
        'ใส่หมูสับและผักสับละเอียดลงไป ตีให้เข้ากันจนเกิดฟอง',
        'ตั้งกระทะใส่น้ำมัน รอจนร้อนปานกลาง',
        'เทไข่ลงไปทอดจนเหลืองกรอบทั้งสองด้าน พักให้สะเด็ดน้ำมัน พร้อมเสิร์ฟ',
      ],
    },
    {
      'id': 'rec_2',
      'title': 'ผัดผักรวมมิตรใส่ไข่',
      'category': 'เมนูผัด',
      'time': '15 นาที',
      'difficulty': 'ง่าย',
      'rating': 4.8,
      'imageEmoji': '🥗🍳',
      'color': Color(0xFFE8F5E9),
      'requiredIngredients': ['ผักสดรวม', 'ไข่ไก่'],
      'optionalIngredients': ['กระเทียม', 'หมูสับ', 'กุ้งสด'],
      'description': 'เมนูผักสดกรุบกรอบ ผัดเคลือบซอสกับไข่ไก่ รสชาติกลมกล่อม ได้สุขภาพเต็มๆ',
      'steps': [
        'เจียวกระเทียมสับในกระทะให้หอม',
        'ตอกไข่ไก่ลงไป ยีพอสุกเหลือง',
        'ใส่ผักสดรวมลงไปผัดด้วยไฟแรง',
        'ปรุงรสด้วยซอสหอยนางรม ซีอิ๊วขาว และน้ำตาลทรายเล็กน้อย',
      ],
    },
    {
      'id': 'rec_3',
      'title': 'แกงจืดเต้าหู้หมูสับ',
      'category': 'เมนูต้ม',
      'time': '20 นาที',
      'difficulty': 'ง่าย',
      'rating': 4.9,
      'imageEmoji': '🍲🍲',
      'color': Color(0xFFE1F5FE),
      'requiredIngredients': ['หมูสับ', 'เต้าหู้ไข่'],
      'optionalIngredients': ['แครอท', 'ต้นหอม', 'ผักสดรวม', 'กระเทียม'],
      'description': 'ซุปร้อนๆ น้ำซุปใสหวานธรรมชาติจากผักและหมูเด้ง ซดคล่องคอสบายท้อง',
      'steps': [
        'ตั้งน้ำซุปให้เดือด ปรุงรสด้วยซีอิ๊วขาวและผงปรุงรส',
        'ปั้นหมูสับเป็นก้อนลงไปต้มจนสุก',
        'ใส่แครอทและผักสดรวมลงไป',
        'ใส่เต้าหู้ไข่หั่นชิ้นและโรยต้นหอมก่อนปิดไฟ',
      ],
    },
    {
      'id': 'rec_4',
      'title': 'ผัดมะเขือเทศใส่ไข่สไตล์โฮมเมด',
      'category': 'เมนูผัด',
      'time': '12 นาที',
      'difficulty': 'ง่ายมาก',
      'rating': 4.7,
      'imageEmoji': '🍅🍳',
      'color': Color(0xFFFFEBEE),
      'requiredIngredients': ['มะเขือเทศ', 'ไข่ไก่'],
      'optionalIngredients': ['กระเทียม', 'ต้นหอม'],
      'description': 'รสหวานเปรี้ยวกลมกล่อมจากมะเขือเทศสด ผัดนุ่มละมุนกับไข่ไก่ทานง่าย',
      'steps': [
        'หั่นมะเขือเทศเป็นชิ้นพอดีคำ',
        'ผัดไข่ไก่ในกระทะพอสุกนุ่ม แล้วตักพักไว้',
        'ผัดกระเทียมและมะเขือเทศจนนุ่มฉ่ำน้ำ',
        'นำไข่กลับลงมาผัดรวม ปรุงรสด้วยเกลือและน้ำตาล พร้อมเสิร์ฟ',
      ],
    },
    {
      'id': 'rec_5',
      'title': 'ผัดบล็อกโคลี่กุ้งสดซอสหอยนางรม',
      'category': 'เมนูผัด',
      'time': '15 นาที',
      'difficulty': 'ง่าย',
      'rating': 4.9,
      'imageEmoji': '🥦🦐',
      'color': Color(0xFFE8F5E9),
      'requiredIngredients': ['บล็อกโคลี่'],
      'optionalIngredients': ['กุ้งสด', 'กระเทียม', 'หมูสับ', 'ไข่ไก่'],
      'description': 'บล็อกโคลี่สีเขียวสดกรุบกรอบ ผัดเข้ากันดีกับซอสหอยนางรมเข้มข้น',
      'steps': [
        'นำบล็อกโคลี่ไปลวกในน้ำเดือด 1 นาทีแล้วน็อกน้ำเย็น',
        'ตั้งกระทะเจียวกระเทียมและผัดกุ้งสดจนเริ่มสุก',
        'ใส่บล็อกโคลี่ลงไปผัดด้วยไฟแรง',
        'ปรุงรสด้วยซอสหอยนางรมและซีอิ๊วขาว',
      ],
    },
    {
      'id': 'rec_6',
      'title': 'ผัดกะเพราหมูสับพริกสด',
      'category': 'เมนูผัด',
      'time': '12 นาที',
      'difficulty': 'ง่าย',
      'rating': 5.0,
      'imageEmoji': '🌶️🥩',
      'color': Color(0xFFFFF3E0),
      'requiredIngredients': ['หมูสับ', 'กระเทียม', 'พริกขี้หนู'],
      'optionalIngredients': ['ไข่ไก่'],
      'description': 'เมนูยอดฮิตรสเผ็ดร้อน รสชาติจัดจ้านหอมกลิ่นกระเทียมพริกสด',
      'steps': [
        'โขลกกระเทียมกับพริกขี้หนูพอหยาบ',
        'นำลงผัดในน้ำมันร้อนจนหอมฟ้อง',
        'ใส่หมูสับลงไปผัดจนสุก ยี้เนื้อหมูให้กระจายตัว',
        'ปรุงรสด้วยซอสหอยนางรม ซีอิ๊วดำ และน้ำตาล',
      ],
    },
    {
      'id': 'rec_7',
      'title': 'กุ้งผัดกระเทียมพริกไทย',
      'category': 'เมนูผัด',
      'time': '10 นาที',
      'difficulty': 'ง่ายมาก',
      'rating': 4.8,
      'imageEmoji': '🦐🧄',
      'color': Color(0xFFFFF3E0),
      'requiredIngredients': ['กุ้งสด', 'กระเทียม'],
      'optionalIngredients': ['ต้นหอม'],
      'description': 'กุ้งเด้งหวานเจอกับกระเทียมเจียวกรอบหอม รสชาติเข้มข้นกลมกล่อม',
      'steps': [
        'สับกระเทียมเจียวในน้ำมันจนเหลืองกรอบ ตักพักไว้ครึ่งหนึ่ง',
        'ใส่กุ้งสดลงไปผัดด้วยไฟแรงจนสุกเด้ง',
        'ปรุงรสด้วยซอสปรุงรส พริกไทยป่น และน้ำตาลทราย',
        'โรยกระเทียมเจียวที่เหลือและต้นหอมพร้อมเสิร์ฟ',
      ],
    },
    {
      'id': 'rec_8',
      'title': 'ผัดผักบุ้งไฟแดง',
      'category': 'เมนูผัด',
      'time': '8 นาที',
      'difficulty': 'ง่ายมาก',
      'rating': 4.7,
      'imageEmoji': '🥬🔥',
      'color': Color(0xFFE8F5E9),
      'requiredIngredients': ['ผักบุ้ง', 'กระเทียม'],
      'optionalIngredients': ['พริกขี้หนู', 'หมูกรอบ'],
      'description': 'ผักบุ้งกรอบๆ หอมกลิ่นกระทะและเต้าเจี้ยว เมนูทำง่ายด่วนทันใจ',
      'steps': [
        'หั่นผักบุ้ง เตรียมกระเทียม พริก เต้าเจี้ยว และซอสหอยนางรมวางบนผัก',
        'ตั้งกระทะให้น้ำมันร้อนจัดจนมีควันขึ้นเล็กน้อย',
        'เทผักบุ้งและเครื่องปรุงลงผัดเร็วๆ 30 วินาที',
        'ตักใส่จานเสิร์ฟทานกับข้าวต้มหรือข้าวสวย',
      ],
    },
    {
      'id': 'rec_9',
      'title': 'ข้าวผัดไข่ใส่แครอททรงเครื่อง',
      'category': 'เมนูข้าวผัด',
      'time': '15 นาที',
      'difficulty': 'ง่าย',
      'rating': 4.8,
      'imageEmoji': '🍚🍳',
      'color': Color(0xFFFFF8E1),
      'requiredIngredients': ['ไข่ไก่'],
      'optionalIngredients': ['แครอท', 'หมูสับ', 'กุ้งสด', 'ต้นหอม', 'กระเทียม'],
      'description': 'ข้าวผัดเม็ดร่วนสวย หอมกลิ่นไข่ผัดกระทะ มีสีสันน่ารับประทานจากแครอท',
      'steps': [
        'ผัดกระเทียมสับและเนื้อสัตว์จนสุก',
        'ตอกไข่ไก่ลงไป ผัดให้ไข่พอเซ็ตตัว',
        'ใส่ข้าวสวยและแครอทหั่นเต๋าลงไปผัดด้วยไฟแรง',
        'ปรุงรสด้วยซอสปรุงรส พริกไทยป่น โรยต้นหอมสับ',
      ],
    },
    {
      'id': 'rec_10',
      'title': 'ผัดกะหล่ำปลีทอดน้ำปลา',
      'category': 'เมนูผัด',
      'time': '10 นาที',
      'difficulty': 'ง่ายมาก',
      'rating': 4.8,
      'imageEmoji': '🥬🍳',
      'color': Color(0xFFE8F5E9),
      'requiredIngredients': ['กะหล่ำปลี', 'กระเทียม'],
      'optionalIngredients': ['เบคอน', 'หมูกรอบ', 'ไข่ไก่'],
      'description': 'กะหล่ำปลีกรอบหวาน หอมกลิ่นน้ำปลาแท้ไหม้ขอบกระทะ',
      'steps': [
        'ฉีกกะหล่ำปลีเป็นชิ้นใหญ่ เจียวกระเทียมสับจนหอม',
        'ใส่กะหล่ำปลีลงไป ทิ้งไว้โดยยังไม่คนให้โดนความร้อน',
        'ราดน้ำปลาแท้รอบๆ ขอบกระทะให้เกิดกลิ่นหอม',
        'ผัดเคลือบให้ทั่วตักใส่จานทันที',
      ],
    },
  ];

  // Dynamic filter logic to return matching recipes strictly based on user's active ingredients!
  List<Map<String, dynamic>> _getMatchingRecipes() {
    if (ingredients.isEmpty) return [];

    final userSet = ingredients.map((e) => e.trim()).toSet();
    final List<Map<String, dynamic>> results = [];

    for (final recipe in _masterRecipes) {
      final requiredList = List<String>.from(recipe['requiredIngredients']);
      final optionalList = List<String>.from(recipe['optionalIngredients']);

      // STRICT FILTER - ALL required ingredients MUST be present in userSet!
      final bool requiredSatisfied = requiredList.every((req) => userSet.contains(req));

      if (requiredSatisfied) {
        final matchedItems = <String>[];
        final missingItems = <String>[];

        for (final req in requiredList) {
          if (userSet.contains(req)) {
            matchedItems.add(req);
          }
        }

        for (final opt in optionalList) {
          if (userSet.contains(opt)) {
            matchedItems.add(opt);
          } else {
            missingItems.add(opt);
          }
        }

        results.add({
          ...recipe,
          'matchedIngredients': matchedItems,
          'missingIngredients': missingItems,
          'matchCount': matchedItems.length,
        });
      }
    }

    // Sort by most matched ingredients count
    results.sort((a, b) => (b['matchCount'] as int).compareTo(a['matchCount'] as int));

    return results;
  }

  @override
  Widget build(BuildContext context) {
    final matchingRecipes = _getMatchingRecipes();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'ช่วยคิดเมนู (Page 2)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Ingredients Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF9100), Color(0xFFFF6D00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9100).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'วัตถุดิบที่คุณสแกนเลือกไว้ (${ingredients.length})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (ingredients.isEmpty)
                    const Text(
                      'ไม่มีวัตถุดิบเหลืออยู่ กรุณาย้อนกลับไปเพิ่มวัตถุดิบ',
                      style: TextStyle(color: Colors.white70),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ingredients.map((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.4)),
                          ),
                          child: Text(
                            '✨ $item',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'เมนูที่ทำได้จริง (${matchingRecipes.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('อัปเดตค้นหาเมนูตามวัตถุดิบล่าสุดแล้ว')),
                    );
                  },
                  icon: const Icon(Icons.refresh, size: 18, color: Color(0xFFFF9100)),
                  label: const Text(
                    'อัปเดต',
                    style: TextStyle(color: Color(0xFFFF9100), fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Recipe List / Empty State
            if (matchingRecipes.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.no_food, size: 60, color: Colors.grey),
                    const SizedBox(height: 12),
                    const Text(
                      'ไม่พบเมนูที่ตรงกับวัตถุดิบชุดนี้',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'ลองกดกดย้อนกลับแล้วกด "+ เพิ่มเติม" วัตถุดิบอย่างอื่นเพิ่ม เช่น ไข่ไก่ หรือ หมูสับ',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: matchingRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = matchingRecipes[index];
                  return _buildRecipeCard(context, recipe);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Map<String, dynamic> recipe) {
    final matchedList = recipe['matchedIngredients'] as List<String>;
    final missingList = recipe['missingIngredients'] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            _showRecipeDetailModal(context, recipe);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Container
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: recipe['color'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          recipe['imageEmoji'],
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  recipe['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${recipe['rating']}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            recipe['description'],
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildBadge(Icons.timer_outlined, recipe['time'], Colors.orange),
                              const SizedBox(width: 8),
                              _buildBadge(Icons.restaurant, recipe['category'], Colors.blue),
                              const SizedBox(width: 8),
                              _buildBadge(Icons.speed, recipe['difficulty'], Colors.green),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Matched Ingredients Pills
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    const Text(
                      'วัตถุดิบที่มี:',
                      style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    ...matchedList.map((m) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text(
                            '✓ $m',
                            style: TextStyle(fontSize: 11, color: Colors.green.shade800, fontWeight: FontWeight.bold),
                          ),
                        )),
                    if (missingList.isNotEmpty)
                      ...missingList.take(2).map((m) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '+ $m',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetailModal(BuildContext context, Map<String, dynamic> recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(recipe['imageEmoji'], style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe['title'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${recipe['category']} • ใช้เวลา ${recipe['time']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              const Text(
                'ขั้นตอนการทำประกอบอาหาร:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: (recipe['steps'] as List).length,
                  itemBuilder: (context, index) {
                    final step = recipe['steps'][index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xFFFF9100),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              step,
                              style: const TextStyle(fontSize: 14, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
