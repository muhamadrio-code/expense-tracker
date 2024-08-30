import 'package:flutter/material.dart';
import 'models/models.dart';

final expenseCategory = <CategoryData>[
  CategoryData(
    name: "Makanan",
    iconData: Icons.food_bank_outlined,
    type: CategoryType.expense,
  ),
  CategoryData(
    name: "Perumahan",
    iconData: Icons.house_outlined,
    type: CategoryType.expense,
  ),
  CategoryData(
    name: "Listrik",
    iconData: Icons.electric_bolt,
    type: CategoryType.expense,
  ),
  CategoryData(
    name: "Elektronik",
    iconData: Icons.phone_android_outlined,
    type: CategoryType.expense,
  ),
  CategoryData(
    name: "Internet",
    iconData: Icons.wifi_outlined,
    type: CategoryType.expense,
  ),
  CategoryData(
    name: "Liburan",
    iconData: Icons.directions_subway_filled_outlined,
    type: CategoryType.expense,
  ),
];

final incomeCategory = <CategoryData>[
  CategoryData(
    name: "Gaji",
    iconData: Icons.money,
    type: CategoryType.income,
  ),
  CategoryData(
    name: "Investasi",
    iconData: Icons.trending_up,
    type: CategoryType.income,
  ),
  CategoryData(
    name: "Hadiah",
    iconData: Icons.wallet_giftcard,
    type: CategoryType.income,
  ),
];
