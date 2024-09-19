import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koi_detection_flutter_app/AWS/s3bucket.dart';
import 'package:koi_detection_flutter_app/authentication/auth_service.dart';
import 'package:koi_detection_flutter_app/authentication/login.dart';
import 'package:koi_detection_flutter_app/pages/profile/result_screen.dart';
import 'package:koi_detection_flutter_app/pages/profile/statistic.dart';
import 'package:koi_detection_flutter_app/utility/constant.dart';
import 'package:koi_detection_flutter_app/utility/koi_decription.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<dynamic>> koiImages;
  late List<dynamic> koiList;
  bool loading = false;
  String order = 'ascending';
  Map<String, int> koiTypeOrder = {
    "Asagi": 0,
    "Bekko": 1,
    "Hikarimoyomono": 2,
    "Hikarimuji": 3,
    "Koromo": 4,
    "Kohaku": 5,
    "Sanke": 6,
    "Showa": 7,
    "Shusui": 8,
    "Tancho": 9,
    "Utsurimono": 10,
    "other": 11
  };

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    refreshScreen();
  }

  Future<void> refreshScreen() async {
    setState(() {
      loading = true;
      koiImages = S3Bucket.getImageUrlsFromLambda(user?.email);
    });
    koiImages.then((value) {
      setState(() {
        koiList = value;
        sortList();
      });
      loading = false;
    });
  }

  void sortList() {
    setState(() {
      if (order == "ascending") {
        koiList.sort((a, b) => a['koi_type'].compareTo(b['koi_type']));
      } else {
        koiList.sort((a, b) => b['koi_type'].compareTo(a['koi_type']));
      }
    });
  }

  void toggleOrder() {
    setState(() {
      order = (order == "ascending") ? "descending" : "ascending";
      sortList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: bgColor,
              title: Column(
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () async {
                            await AuthService().signOut();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          style: const ButtonStyle(
                              padding: WidgetStatePropertyAll(EdgeInsets.zero),
                              backgroundColor: WidgetStatePropertyAll(
                                  Color.fromARGB(255, 52, 52, 52))),
                          child: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/asset/images/others/koi_icon1.png',
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text('Your Collection',
                            style: GoogleFonts.maShanZheng(
                                color: Colors.white, fontSize: 50)),
                      ),
                      Image.asset('lib/asset/images/others/koi_icon.png',
                          height: 60, fit: BoxFit.cover),
                    ],
                  ),
                ],
              ),
              toolbarHeight:
                  kToolbarHeight + 80, // Adjust the 50 to fit your title size
            ),
            body: Container(
              color: Colors.black,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 52, 52, 52)),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Statistic(
                                      koiList: koiList,
                                    )),
                          );
                        },
                        icon: const Icon(
                          // <-- Icon
                          Icons.bar_chart_rounded,
                          size: 24.0,
                        ),
                        label: const Text('Statistic'), // <-- Text
                      ),
                      ElevatedButton.icon(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 52, 52, 52)),
                            foregroundColor:
                                WidgetStatePropertyAll(Colors.white)),
                        onPressed: toggleOrder,
                        icon: const RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.compare_arrows_outlined,
                            size: 24.0,
                          ),
                        ),
                        label: Text(order),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      color: bgColor,
                      child: koiList.isEmpty
                          ? const Center(
                              child: Center(
                              child: Text(
                                "Nothing",
                                style: TextStyle(color: Colors.white),
                              ),
                            ))
                          : Container(
                              padding: const EdgeInsets.all(30),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10.0,
                                  crossAxisSpacing: 15.0,
                                ),
                                itemCount: koiList.length,
                                itemBuilder: (context, index) {
                                  final item = koiList[index];

                                  var filename = koiList
                                      .map((item) => item['filename'] as String)
                                      .toList();

                                  void deleteImage(int index) async {
                                    // After deleting the image, remove it from the list and refresh the UI
                                    await S3Bucket.deleteImageFromS3Bucket(
                                        filename[index], user?.email);
                                    await refreshScreen();
                                    // Optionally, you might want to show a success message
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Image deleted successfully'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              ResultScreen(
                                            img: item['url'],
                                            koiType: item['koi_type'],
                                            title: Dummy.koiType[koiTypeOrder[
                                                    item['koi_type']] ??
                                                0]["title"],
                                            description: Dummy.koiType[
                                                koiTypeOrder[
                                                        item['koi_type']] ??
                                                    0]["description"],
                                            priceRange: item['koi_price'],
                                            creationDate:
                                                item['current_datetime'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          elevation: 5,
                                          child: SizedBox(
                                            width: 300,
                                            height: 180,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(15.0),
                                                      topRight:
                                                          Radius.circular(15.0),
                                                    ),
                                                    child: Image.network(
                                                      item['url'],
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      item['koi_type'],
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 79, 79, 79)),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Delete Image'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this image?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () {
                                                        // Add your logic to delete the image here
                                                        print(
                                                            'Delete image at index $index');
                                                        deleteImage(index);

                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
