import 'package:flutter/material.dart';

class Promotion {
  final String title;
  final String description;
  final String price;
  final String imageUrl;

  Promotion({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

// ตัวอย่าง Promotion
final List<Promotion> _promotions = [
  Promotion(
      title: "รองเท้าผ้าใบสุดเท่",
      description: "ดีไซน์ใหม่ล่าสุด ใส่สบายทุกก้าว",
      price: "1,290",
      imageUrl: "https://picsum.photos/id/1021/960/540"),
  Promotion(
      title: "หูฟังบลูทูธไร้สาย",
      description: "เสียงคมชัด แบตอึดทนฟังได้ทั้งวัน",
      price: "890",
      imageUrl: "https://picsum.photos/id/1031/960/540"),
  Promotion(
      title: "เสื้อยืดคอตตอนพรีเมียม",
      description: "เนื้อผ้านุ่ม ใส่สบายทุกโอกาส",
      price: "350",
      imageUrl: "https://picsum.photos/id/1041/960/540"),
];

class PromoFeedPage extends StatefulWidget {
  const PromoFeedPage({super.key});

  @override
  State<PromoFeedPage> createState() => _PromoFeedPageState();
}

class _PromoFeedPageState extends State<PromoFeedPage> {
  late TextEditingController _searchController;
  List<Promotion> _filteredPromotions = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredPromotions = List<Promotion>.from(_promotions);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterPromotions(_searchController.text);
  }

  void _filterPromotions(String query) {
    if (query.isEmpty) {
      setState(() => _filteredPromotions = List<Promotion>.from(_promotions));
      return;
    }
    final String lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredPromotions = _promotions.where((p) {
        return p.title.toLowerCase().contains(lowerCaseQuery) ||
            p.description.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "ค้นหาโปรโมชั่น...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredPromotions.length,
            itemBuilder: (context, index) {
              final promo = _filteredPromotions[index];
              return Container(
                height: 120,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(promo.imageUrl),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(promo.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(promo.description,
                              style: const TextStyle(fontSize: 13, color: Colors.black54),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Text("ราคา: ${promo.price} บาท",
                              style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
