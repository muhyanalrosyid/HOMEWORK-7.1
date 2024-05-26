import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_food_app/app/data/food.dart';
import 'package:firebase_food_app/app/routes/app_pages.dart';
import 'package:firebase_food_app/app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  CollectionReference ref = FirebaseFirestore.instance.collection('Food');
  //Membuat referensi ke collection Food

  final buttonText = [
    "All",
    "Makanan",
    "Kuah",
    "Minuman",
  ]; //variable untuk menampung data button

  final IconButton = [
    "assets/images/ic_makanan.png",
    "assets/images/ic_makanan.png",
    "assets/images/ic_kuah.png",
    "assets/images/ic_minuman.png"
  ]; //variable untuk menampung data icon button

  final selectedValueIndex =
      0.obs; //variable untuk menampung data index button yang dipilih

  Stream<List<Food>> readRecipe(String jenis) {
    if (jenis != "All") {
      return FirebaseFirestore.instance
          .collection('Food')
          .where('jenis', isEqualTo: jenis)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
    } else {
      return FirebaseFirestore.instance.collection('Food').snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
    }
  }

  Stream<List<Food>> searchFood(String search) {
    return FirebaseFirestore.instance
        .collection('Food')
        .where('nama', isGreaterThanOrEqualTo: search)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Food.fromJson(doc.data())).toList());
  }
}

class HomeSearchDelegate extends SearchDelegate {
  HomeSearchDelegate(this.controller);
  final HomeController controller;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<List<Food>>(
      stream: controller.searchFood(query),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (contex, index) {
                  var data = snapshot.data;
                  if (data == null) {
                    return const SizedBox();
                  } else if (data[index].nama.toLowerCase().contains(
                        query.toLowerCase(),
                      )) {
                    return Card(
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Get.toNamed(Routes.DETAIL_FOOD,
                              arguments: data[index]);
                        },
                        title: Text(
                          " ${snapshot.data?[index].nama}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ).paddingAll(5.r),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.r,
                                    vertical: 5.r,
                                  ),
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.r),
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        color: Colors.white,
                                        size: 10.r,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        "${snapshot.data?[index].waktuPembuatan.toString()} minutes",
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.horizontalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.r,
                                    vertical: 5.r,
                                  ),
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.r),
                                      ),
                                      color: getColor(
                                          snapshot.data?[index].jenis ?? "")),
                                  child: Text(
                                    "${snapshot.data?[index].jenis}",
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            5.verticalSpace,
                          ],
                        ).paddingAll(5.r),
                        trailing: Image(
                          image: CachedNetworkImageProvider(
                            snapshot.data?[index].images ?? "",
                          ),
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<Food>>(
      stream: controller.searchFood(query),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data;
                  if (data == null) {
                    return const SizedBox();
                  } else if (data[index].nama.toLowerCase().contains(
                        query.toLowerCase(),
                      )) {
                    return Card(
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 10.w,
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Get.toNamed(Routes.DETAIL_FOOD,
                              arguments: data[index]);
                        },
                        title: Text(
                          "${snapshot.data?[index].nama}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ).paddingAll(5.r),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.r,
                                    vertical: 5.r,
                                  ),
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.r),
                                    ),
                                    color: Colors.green,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.alarm,
                                        color: Colors.white,
                                        size: 10.r,
                                      ),
                                      5.horizontalSpace,
                                      Text(
                                        "${snapshot.data?[index].waktuPembuatan.toString()} minutes",
                                        style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                10.horizontalSpace,
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.r,
                                    vertical: 5.r,
                                  ),
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.r),
                                      ),
                                      color: getColor(
                                          snapshot.data?[index].jenis ?? "")),
                                  child: Text(
                                    "${snapshot.data?[index].jenis}",
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            5.verticalSpace,
                          ],
                        ).paddingAll(5.r),
                        trailing: Image(
                          image: CachedNetworkImageProvider(
                            snapshot.data?[index].images ?? "",
                          ),
                          height: 50,
                          width: 50,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, StackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
      },
    );
  }
}
