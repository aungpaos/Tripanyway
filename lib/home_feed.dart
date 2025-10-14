// lib/home_feed.dart
import 'package:flutter/material.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  final List<Map<String, String>> travelPosts = [
    {
      "image": "https://picsum.photos/400/600?random=1",
      "title": "เกาะหลีเป๊ะ",
      "location": "สตูล, ไทย",
      "desc":
          "เกาะหลีเป๊ะเป็นสวรรค์แห่งท้องทะเลใต้ น้ำทะเลใส หาดทรายขาว และโลกใต้ทะเลที่สวยงามมาก ๆ เหมาะสำหรับดำน้ำและพักผ่อน"
    },
    {
      "image": "https://picsum.photos/400/600?random=2",
      "title": "ซาปา",
      "location": "เวียดนาม",
      "desc":
          "ซาปาเป็นเมืองภูเขาเล็ก ๆ ทางตอนเหนือของเวียดนาม มีนาขั้นบันได วิวภูเขาสุดอลังการ และวัฒนธรรมชนเผ่าที่น่าสนใจ"
    },
    {
      "image": "https://picsum.photos/400/600?random=3",
      "title": "ฟูจิซัง",
      "location": "ญี่ปุ่น",
      "desc":
          "ภูเขาไฟฟูจิ เป็นแลนด์มาร์กสำคัญของญี่ปุ่น นักท่องเที่ยวมักเดินทางไปเพื่อชมวิวและปีนเขาในฤดูร้อน"
    },
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final filteredPosts = travelPosts
        .where((post) =>
            post["title"]!.toLowerCase().contains(query.toLowerCase()) ||
            post["location"]!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Column(
      children: [
        // 🔹 Search Bar
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: "ค้นหาสถานที่...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
          ),
        ),

        // 🔹 Feed (GridView)
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 คอลัมน์
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        imageUrl: post["image"]!,
                        title: post["title"]!,
                        location: post["location"]!,
                        desc: post["desc"]!,
                      ),
                    ),
                  );
                },
                child: TravelCard(
                  imageUrl: post["image"]!,
                  title: post["title"]!,
                  location: post["location"]!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 🔹 Card ใน Feed
class TravelCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;

  const TravelCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // รูปภาพ
          Expanded(
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // ข้อมูล
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(location,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔹 หน้า Detail (พร้อมปุ่ม Like / Save / Share)
class DetailPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String desc;

  const DetailPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.desc,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLiked = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // รูปภาพใหญ่
            Image.network(
              widget.imageUrl,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),

            // รายละเอียด
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.location,
                      style:
                          TextStyle(color: Colors.grey[700], fontSize: 16)),
                  const SizedBox(height: 16),
                  Text(widget.desc,
                      style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),

            // 🔹 ปุ่ม Like / Save / Share
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLiked = !isLiked;
                      });
                    },
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSaved = !isSaved;
                      });
                    },
                    icon: Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: isSaved ? Colors.blue : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('แชร์สถานที่เรียบร้อย!')),
                      );
                    },
                    icon: const Icon(Icons.share),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
