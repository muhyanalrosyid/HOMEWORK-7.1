import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_food_app/app/data/food.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailFoodController extends GetxController with StateMixin {
  CollectionReference ref = FirebaseFirestore.instance.collection('Food');
  Color dominantColor = Colors.red;
  var food = Get.arguments as Food;

  Stream<Food> getFood(String id) {
    return FirebaseFirestore.instance
        .collection('Food')
        .doc(id)
        .snapshots()
        .map((event) => Food.fromJson(event.data()!));
  }

  Future<void> deleteMenu(String id) async {
    final refDoc = ref.doc(id);
    refDoc.delete();
  }

  Future<void> updateMenu(String id, String nama, int waktuPembuatan,
      String deskripsi, String jenis, String image, String resep) async {
    change(null, status: RxStatus.loading());
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "waktu_pembuatan": waktuPembuatan,
      "deskripsi": deskripsi,
      "jenis": jenis,
      "images": image,
      "resep": resep,
    };
    refDoc
        .set(data)
        .then((value) => change(null, status: RxStatus.success()))
        .onError((error, stackTrace) =>
            change(null, status: RxStatus.error(error.toString())));
  }

  Future<String> uploadFile(File image) async {
    final storageReference =
        FirebaseStorage.instance.ref().child('Menus/${image.path}');
    await storageReference.putFile(image);
    String returnURL = "";
    await storageReference.getDownloadURL().then(
      (fileURL) {
        returnURL = fileURL;
      },
    );
    return returnURL;
  }

  Future<void> updateMenuWithImage(
    String id,
    String nama,
    int waktuPembuatan,
    String deskripsi,
    String jenis,
    File images,
    String resep,
  ) async {
    change(null, status: RxStatus.loading());
    String imageURL = await uploadFile(images);
    final refDoc = ref.doc(id);
    final data = {
      "id": id,
      "nama": nama,
      "waktu_pembuatan": waktuPembuatan,
      "deskripsi": deskripsi,
      "jenis": jenis,
      "images": imageURL,
      "resep": resep,
    };
    refDoc
        .set(data)
        .then((value) => change(null, status: RxStatus.success()))
        .onError((error, stackTrace) =>
            change(null, status: RxStatus.error(error.toString())));
  }

  Future<Color> updatePaletteGenerator(String path) async {
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      NetworkImage(path),
    );
    return paletteGenerator.dominantColor!.color;
  }

  @override
  void onInit() async {
    super.onInit();

    change(null, status: RxStatus.empty());
    await updatePaletteGenerator(food.images).then(
      (value) {
        dominantColor = value;
      },
    );
  }
}
