import 'package:cartzen/models/product_model.dart';
import 'package:flutter/material.dart';

// Them color

const themeColor = Color(0xFFF67952);

// Default

const double defaultRadius = 16;
const double padding = 16;

// Global Variables

bool darkMode = false;
ProductModel? currentProduct;
int previousIndex = 0;

// Heights

const kHeight = SizedBox(height: 16);
const kHeight10 = SizedBox(height: 10);
const kHeight20 = SizedBox(height: 20);
const kHeight30 = SizedBox(height: 30);
const kHeight40 = SizedBox(height: 40);
const kHeight50 = SizedBox(height: 50);

// Width

const kWidth10 = SizedBox(width: 10);
const kWidth20 = SizedBox(width: 20);

// Indexes

const int homeIndex = 0;
const int walletIndex = 1;
const int whishlistIndex = 2;
const int profileIndex = 3;
const int cartIndex = 4;
const int productDetailsIndex = 5;
const int editProfileIndex = 6;
const int ordersIndex = 7;
