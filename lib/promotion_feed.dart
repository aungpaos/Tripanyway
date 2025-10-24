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
      title: "หมอนสามเหลี่ยม",
      description: "นอนสบาย รองรับคอได้ดี",
      price: "299",
      imageUrl: "https://dh-media.dohome.technology/article-image/products/10140375/images/191bc887-b57f-4793-af21-e978fd5adedc/10140375_bai_1200_1_3.jpg"),
  Promotion(
      title: "กางเกงช้าง",
      description: "กางเกงที่มีความเป็นไทยสูง",
      price: "259",
      imageUrl: "https://static.amarintv.com/images/upload/editor/source/France-%20Spotlight/istock-1843944148.jpg"),
  Promotion(
      title: "ยาดม",
      description: "ดมแล้วสดชื่น หายใจโล่ง",
      price: "49",
      imageUrl: "https://cr.lnwfile.com/tubkr0.jpg"),
  Promotion(
      title: "ผ้าขาวม้า",
      description: "ผ้าขาวม้า เฟี้ยวทุกโอกาส",
      price: "99",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSodzpS-iJzN-utuLNYHC-CJKdp0VzUeCMtw&s"),
  Promotion(
      title: "ทุเรียนหมอนทอง",
      description: "ทุเรียนของแท้ หอมๆ",
      price: "199",
      imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIc9igTRyLc4EApsWInzFgDPDO7FJ3NsmvIg&s"),
  Promotion(
      title: "กระเป๋าจักสาน",
      description: "งานแฮนด์เมด ของไทยดั้งเดิม",
      price: "389",
      imageUrl: "https://www.otopchiangmai.com/resize.php?src=uploads/1f9179e981a40b71f556df87baf4c6d0.jpg&w=400&h=400&os=1"),
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
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 97, 97, 97)
                        : const Color.fromARGB(255, 224, 224, 224),
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor, // ใช้สีตามธีม
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(169, 0, 0, 0).withOpacity(0.15)
                          : Colors.black.withOpacity(0.05),
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
                          Text(
                            promo.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey[800],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
