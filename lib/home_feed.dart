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
"image": "https://dmc.tatdataapi.io/assets/ce8c9dea-87a3-49b5-924d-9e75e4617421.jpeg",
      "title": "วัดไชยวัฒนาราม",
      "location": "หมู่ 9 พระนครศรีอยุธยา, พระนครศรีอยุธยา, ภาคกลาง, ไทย",
      "desc":
          "ตั้งอยู่ริมแม่น้ำเจ้าพระยาฝั่งตะวันตก นอกเกาะเมือง เป็นวัดที่พระเจ้าปราสาททอง กษัตริย์กรุงศรีอยุธยาองค์ที่ 24 ( พ.ศ. 2173-2198) โปรดให้สร้างขึ้นเมื่อ พ.ศ. 2173 ได้ชื่อว่าเป็นวัดที่มีความงดงามมากแห่งหนึ่งในกรุงศรีอยุธยา"
    },
{
"image": "https://movenpickhuahin.com/wp-content/uploads/2023/10/Hua-Hin-Beach-1.jpg",
      "title": "ชายหาดหัวหิน",
      "location": "ทางทิศตะวันออกของจังหวัดประจวบคีรีขันธ์ติดกับทะเลอ่าวไทย, ภาคกลาง, ไทย",
      "desc":
          "สถานที่ยอดนิยมตลอดกาลของ หัวหินนั่นก็คือชายหาดหัวหิน ซึ่งตั้งอยู่ทางด้านทิศตะวันออกของตัวเมือง มีทางลงหาดอยู่ที่ถนนดำเนินเกษม  ระหว่างสองข้างทางลงหาดมีโรงแรม และร้านจำหน่ายสินค้าที่ระลึก หาดหัวหินมีความยาวประมาณ 5 กิโลเมตร ทรายขาวละเอียด เหมาะสำหรับเล่นน้ำทะเล"
    },
{
"image": "https://dmc.tatdataapi.io/assets/fa7cd6c8-8c61-48f1-937d-651d76c257c0.jpg",
      "title": "วัดพระแก้ว",
      "location": "ตั้งอยู่ในอำเภอเมือง จังหวัดเชียงราย, ภาคกลาง, ไทย",
      "desc":
          "วัดพระแก้ว ตั้งอยู่ถนนไตรรัตน์ ตำบลเวียง เป็นวัดที่ค้นพบพระแก้วมรกต หรือพระพุทธมหามณีรัตนปฏิมากร ซึ่งปัจจุบันประดิษฐานอยู่ที่วัดพระศรีรัตนศาสดาราม กรุงเทพมหานคร"
    },

{
"image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRM5EI2ALFVXj8BK7vt4uHnW6vactOaD1czIA&s",
      "title": "ภูชี้ฟ้า",
      "location": "จังหวัด เชียงราย อำเภอ อำเภอเทิง ตำบล ตับเต่า 57160, ภาคเหนือ, ไทย",
      "desc":
          " เป็นจุกชมวิวที่สวยที่สุด ในช่วงเดือน ตุลาคม-กุมภาพันธ์ จะมีทิวทัศน์ที่สวยงามเป็นพิเศษ สามารถชมพระอาทิตย์ขึ้น พระอาทิตย์ตก และทะเลหมอกที่สวยงาม และในช่วงเดือนกุมภาพันธ์ ต้นเสี้ยวดอกขาวรอบภูชี้ฟ้า จะออกดอกบานเต็มเชิงเชา และมีเทศกาลวันดอกเสี้ยวบานระหว่าง วันที่ 13-15 กุมภาพันธ์ ของทุกปี "
    },
{
"image": "https://s359.kapook.com/pagebuilder/2d9f0847-67a1-4b30-ba7a-3ffd1a3964f8.jpg",
      "title": "ดอยแม่สลอง",
      "location": " ตั้งอยู่ที่ตำบลแม่สลองนอก อำเภอแม่ฟ้าหลวง จังหวัดเชียงราย, ภาคเหนือ, ไทย",
      "desc":
          " ปัจจุบันเป็นแหล่งท่องเที่ยวแห่งหนึ่งของจังหวัดเชียงราย ที่เป็นพื้นที่ที่มีการปลูกชาที่ดีที่สุดของประเทศและมีซากุระหรือนางพญาเสือโคร่งมีดอกช่วงช่วงต้นเดือนมกราคมจนถึงปลายเดือนมีนาคม"
    },
{
"image": "https://s359.thaicdn.net//pagebuilder/8db7fbcf-55cf-4de1-9582-67d3e417a5f9.jpg",
      "title": "วัดร่องขุ่น",
      "location": "ตำบลป่าอ้อดอนชัย อำเภอเมือง, ภาคเหนือ, ไทย",
      "desc":
          "เป็นศาสนสถานที่สวยงามด้วยสถาปัตยกรรมและงานศิลปะเต็มไปด้วยลวดลายอ่อนช้อยประณีตดึงดูดนักท่องเที่ยวให้มาเยี่ยมชมวัดนี้อย่างคับคั่งตลอดปี อุโบสถของวัดร่องขุ่นมีสีขาวบริสุทธิ์สะอาดซึ่งได้กลายเป็นเอกลักษณ์เป็นที่จดจำของนักท่องเที่ยวชาวต่างชาติซึ่งพากันเรียกวัดร่องขุ่นว่าวัดขาว"
    },

{
"image": "https://cms.dmpcdn.com/travel/2020/09/15/07be82a0-f733-11ea-b67c-0189c2acc7e7_original.JPG",
      "title": "เกาะสิมิลัน",
      "location":"ตั้งอยู่ในท้องทะเลอันดามัน  จังหวัดพังงา, ภาคใต้, ไทย",
      "desc":
          " หมู่เกาะสิมิลัน เป็นหนึ่งใน หมู่เกาะที่งดงาม ที่สุดในประเทศไทย เนื่องจากมีทัศนียภาพที่สวยงาม ทำให้ เกาะสิมิลัน เป็นจุดหมายปลายทางยอดนิยม สำหรับนักเดินทางจากทั่วมุมโลก เกาะสิมิลัน มีกิจกรรมทางน้ำที่มากมาย และเป็น สถานที่ยอดนิยมสำหรับการดำน้ำ เนื่องจากความอุดมสมบูรณ์ใต้ท้องทะเล ทิวทัศน์ธรรมชาติอันน่าทึ่ง และสัตว์น้อยใหญ่ที่อาศัยอยู่ในเกาะสิมิลัน  "
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
