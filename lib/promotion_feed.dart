import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      imageUrl: "https://inwfile.com/s-fr/qcuogp.jpg"),
];

class PromoFeedPage extends StatefulWidget {
  const PromoFeedPage({super.key});

  @override
  State<PromoFeedPage> createState() => _PromoFeedPageState();
}

class _PromoFeedPageState extends State<PromoFeedPage> {
  late TextEditingController _searchController;
  List<Promotion> _filteredPromotions = [];
  Set<String> _purchased = {};
  int coins = 0;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredPromotions = List<Promotion>.from(_promotions);
    _searchController.addListener(_onSearchChanged);
    _loadPurchased();
    _loadCoins();
  }

  Future<void> _loadPurchased() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _purchased = (prefs.getStringList('purchased_promotions') ?? []).toSet();
    });
  }

  Future<void> _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
    });
  }

  Future<void> _buyPromotion(Promotion promo) async {
    final priceBaht = int.tryParse(promo.price) ?? 0;
    final priceCoin = priceBaht * 75; // 1 บาท = 75 TTcoin
    if (_purchased.contains(promo.title)) return;
    if (coins < priceCoin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('TTcoin ไม่พอสำหรับการซื้อ')),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    // หัก coin ตามราคาสินค้า
    await prefs.setInt('coins', coins - priceCoin);
    // เพิ่มชื่อสินค้าที่ซื้อแล้ว
    final purchased = (prefs.getStringList('purchased_promotions') ?? []);
    purchased.add(promo.title);
    await prefs.setStringList('purchased_promotions', purchased);
    // เพิ่มแจ้งเตือน
    final notiList = prefs.getStringList('notifications') ?? [];
    notiList.add('คุณได้ซื้อ "${promo.title}" แล้ว');
    await prefs.setStringList('notifications', notiList);

    // รีเฟรช coins จาก SharedPreferences
    await _loadCoins();

    setState(() {
      _purchased.add(promo.title);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('ซื้อ "${promo.title}" สำเร็จ!')),
    );
  }

  Future<void> _confirmBuyPromotion(Promotion promo) async {
    final priceBaht = int.tryParse(promo.price) ?? 0;
    final priceCoin = priceBaht * 75;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการซื้อ'),
        content: Text('คุณต้องการซื้อ "${promo.title}" ในราคา ${promo.price} บาท หรือไม่?'),
        actions: [
          TextButton(
            child: const Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('ยืนยัน'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (result == true) {
      await _buyPromotion(promo);
    }
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
    // คำนวณจำนวนเงินบาทจาก TTcoin
    final int baht = (coins / 75).floor();

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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Image.asset('assets/images/coin.png', width: 24, height: 24),
              const SizedBox(width: 8),
              Text('ยอดเงินของคุณ: $baht บาท', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredPromotions.length,
            itemBuilder: (context, index) {
              final promo = _filteredPromotions[index];
              final isPurchased = _purchased.contains(promo.title);
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
                  color: Theme.of(context).cardColor,
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
                          isPurchased
                              ? const Text("ซื้อแล้ว",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold))
                              : Text("ราคา: ${promo.price} บาท",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    if (!isPurchased)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          onPressed: () => _confirmBuyPromotion(promo),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 131, 176, 125),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('ซื้อ'),
                        ),
                      ),
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