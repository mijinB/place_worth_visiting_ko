import 'package:flutter/material.dart';

class Item {
  String title;
  String typeId;

  Item(
    this.title,
    this.typeId,
  );
}

class ContentTypeId {
  List<DropdownMenuItem<Item>> contentTypeIds = List.empty(growable: true);

  ContentTypeId() {
    contentTypeIds.add(DropdownMenuItem(
      value: Item('관광지', '12'),
      child: const Text('관광지'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('문화시설', '14'),
      child: const Text('문화시설'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('축제/공연', '15'),
      child: const Text('축제/공연'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('여행코스', '25'),
      child: const Text('여행코스'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('레포츠', '28'),
      child: const Text('레포츠'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('숙박', '32'),
      child: const Text('숙박'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('쇼핑', '38'),
      child: const Text('쇼핑'),
    ));
    contentTypeIds.add(DropdownMenuItem(
      value: Item('음식', '39'),
      child: const Text('음식'),
    ));
  }
}
