import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SaleCalculatorApp());
}

class SaleCalculatorApp extends StatelessWidget {
  const SaleCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'セール計算機',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const SaleCalculatorPage(),
    );
  }
}

class SaleCalculatorPage extends StatefulWidget {
  const SaleCalculatorPage({super.key});

  @override
  State<SaleCalculatorPage> createState() => _SaleCalculatorPageState();
}

class _SaleCalculatorPageState extends State<SaleCalculatorPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController(text: '10');
  
  double _originalPrice = 0;
  double _afterDiscount = 0;
  double _finalPrice = 0;
  double _savings = 0;
  bool _showResult = false;

  final List<Map<String, String>> _ads = [
    {
      'link': 'https://px.a8.net/svt/ejp?a8mat=45FV23+BIZ66Y+4PB0+BXIYP',
      'image': 'https://www20.a8.net/svt/bgt?aid=251002875697&wid=002&eno=01&mid=s00000021942002004000&mc=1',
      'pixel': 'https://www18.a8.net/0.gif?a8mat=45FV23+BIZ66Y+4PB0+BXIYP',
    },
    {
      'link': 'https://px.a8.net/svt/ejp?a8mat=45FV23+CR18YI+42Y0+62ENL',
      'image': 'https://www20.a8.net/svt/bgt?aid=251002875771&wid=002&eno=01&mid=s00000019044001019000&mc=1',
      'pixel': 'https://www11.a8.net/0.gif?a8mat=45FV23+CR18YI+42Y0+62ENL',
    },
    {
      'link': 'https://px.a8.net/svt/ejp?a8mat=45FV23+CU0EZE+3SPO+BQU1TT',
      'image': 'https://www27.a8.net/svt/bgt?aid=251002875776&wid=002&eno=01&mid=s00000017718071020000&mc=1',
      'pixel': 'https://www12.a8.net/0.gif?a8mat=45FV23+CU0EZE+3SPO+BQU1TT',
    },
  ];

  void _calculate() {
    final price = double.tryParse(_priceController.text);
    final discount = double.tryParse(_discountController.text);
    final tax = double.tryParse(_taxController.text) ?? 0;

    if (price == null || discount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('価格と割引率を入力してください！')),
      );
      return;
    }

    if (price <= 0 || discount < 0 || discount > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('正しい値を入力してください！')),
      );
      return;
    }

    final discountAmount = price * (discount / 100);
    final afterDiscount = price - discountAmount;
    final taxAmount = afterDiscount * (tax / 100);
    final finalPrice = afterDiscount + taxAmount;

    setState(() {
      _originalPrice = price;
      _afterDiscount = afterDiscount;
      _finalPrice = finalPrice;
      _savings = discountAmount;
      _showResult = true;
    });
  }

  void _setDiscount(int value) {
    _discountController.text = value.toString();
  }

  // ⭐ 수정된 링크 열기 함수
  Future<void> _openAdLink(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('リンクを開けませんでした')),
          );
        }
      }
    } catch (e) {
      debugPrint('URL Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  child: const Column(
                    children: [
                      Text(
                        '💰 セール計算機',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '割引価格を素早く計算しましょう！',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '元の価格',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '例: 12740',
                          suffixText: '円',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        '割引率',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _discountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '例: 50',
                          suffixText: '%',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(child: _quickButton('10%', 10)),
                          const SizedBox(width: 8),
                          Expanded(child: _quickButton('20%', 20)),
                          const SizedBox(width: 8),
                          Expanded(child: _quickButton('30%', 30)),
                          const SizedBox(width: 8),
                          Expanded(child: _quickButton('50%', 50)),
                          const SizedBox(width: 8),
                          Expanded(child: _quickButton('70%', 70)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        '消費税（任意）',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _taxController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '例: 10',
                          suffixText: '%',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _calculate,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(18),
                          backgroundColor: const Color(0xFF667eea),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '💵 計算する',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      if (_showResult) ...[
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              _resultRow('元の価格', '¥${_originalPrice.toStringAsFixed(0)}'),
                              _resultRow('割引後', '¥${_afterDiscount.toStringAsFixed(0)}'),
                              _resultRow('税込', '¥${_finalPrice.toStringAsFixed(0)}'),
                              const Divider(color: Colors.white30, thickness: 2, height: 40),
                              const Text(
                                '最終価格',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '¥${_finalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 42,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  '¥${_savings.toStringAsFixed(0)} お得！',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),
                      ..._ads.map((ad) => _buildAdBanner(ad)).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdBanner(Map<String, String> ad) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _openAdLink(ad['link']!),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              ad['image']!,
              width: double.infinity,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('広告を読み込めませんでした'),
                  ),
                );
              },
            ),
          ),
        ),
        Image.network(
          ad['pixel']!,
          width: 1,
          height: 1,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _quickButton(String label, int value) {
    return OutlinedButton(
      onPressed: () => _setDiscount(value),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        side: const BorderSide(color: Color(0xFFe0e0e0), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }
}
