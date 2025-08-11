import 'dart:async';
import 'package:desk_cloud/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// class ApplePayUtils {
//   StreamSubscription<List<PurchaseDetails>>? _subscription;
//   ApplePayUtils._() {
//     _subscription = InAppPurchase.instance.purchaseStream.listen(_handler);
//   }
//   Completer<PurchaseDetails>? _completer;
//   _handler(List<PurchaseDetails> list) async {
//     for (var details in list) {
//       switch (details.status) {
//         case PurchaseStatus.error:
//           _completer?.complete(details);
//           break;
//         case PurchaseStatus.canceled:
//           _completer?.complete(details);
//           break;
//         case PurchaseStatus.restored:
//           showShortToast("查询到支付票据");
//           break;
//         case PurchaseStatus.pending: //发起支付
//           break;
//         case PurchaseStatus.purchased: //完成支付
//           _completer?.complete(details);
//           break;
//       }
//       if (details.pendingCompletePurchase) {
//         InAppPurchase.instance.completePurchase(details);
//       }
//     }
//   }

//   static ApplePayUtils? _instance;

//   static ApplePayUtils _getInstance() {
//     _instance ??= ApplePayUtils._();
//     return _instance!;
//   }

//   static Future<ProductDetails?> checkProduct(String productId) async {
//     var res = await InAppPurchase.instance.queryProductDetails({productId});
//     debugPrint(res.productDetails.toString());
//     debugPrint(res.error.toString());
//     debugPrint(res.notFoundIDs.toString());
//     if (res.productDetails.isEmpty) {
//       return null;
//     } else {
//       return res.productDetails[0];
//     }
//   }

//   static Future<PurchaseDetails?> startPay(ProductDetails detail,{String? orderId}) async {

//     //发起支付
//     _getInstance()._completer = Completer();
//     final param = PurchaseParam(productDetails: detail,applicationUserName: orderId);
//     // await InAppPurchase.instance.queryPurchaseDetails(<Str'p_vip_month']);
//     // final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails({'p_vip_month'}.toSet());
//     // print(response.productDetails);
//     // // if (response.notFoundIDs.isNotEmpty)
//     // for (var element in response.productDetails) {
//     //   element.
//     //   await InAppPurchase.instance.completePurchase(element);
//     // }
//     try {
//       await InAppPurchase.instance.buyConsumable(purchaseParam: param); 
//     } catch (e) {
//       print(e.toString());
//       return null; 
//     }
//     var result = await _getInstance()._completer?.future;
//     _getInstance()._completer = null;
//     return result;
//   }

//   static release() {
//     _getInstance()._subscription?.cancel();
//     _instance = null;
//   }

// }


class ApplePayUtils {
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  ApplePayUtils._() {
    _subscription = InAppPurchase.instance.purchaseStream.listen(_handler);
  }

  static void init() {
    _getInstance(); // 确保实例化
  }

  Completer<PurchaseDetails>? _completer;

  void _handler(List<PurchaseDetails> list) async {
    for (var details in list) {
      switch (details.status) {
        case PurchaseStatus.error:
          _completer?.completeError(details);
          break;
        case PurchaseStatus.canceled:
          _completer?.completeError(details);
          showShortToast("取消支付");
          break;
        case PurchaseStatus.restored:
          showShortToast("查询到支付票据");
          break;
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          _completer?.complete(details);
          break;
      }
      if (details.pendingCompletePurchase) {
        // await InAppPurchase.instance.completePurchase(details);
        try {
          await InAppPurchase.instance.completePurchase(details);
        } catch (e) {
          showShortToast(e.toString());
        }
      }
    }
  }

  static ApplePayUtils? _instance;

  static ApplePayUtils _getInstance() {
    _instance ??= ApplePayUtils._();
    return _instance!;
  }

  static Future<ProductDetails?> checkProduct(String productId) async {
    final res = await InAppPurchase.instance.queryProductDetails({productId});
    if (res.error != null) {
      debugPrint('Error querying product details: ${res.error}');
      return null;
    }
    return res.productDetails.isNotEmpty ? res.productDetails[0] : null;
  }

  static Future<PurchaseDetails?> startPay(ProductDetails detail, {String? orderId}) async {
    _getInstance()._completer = Completer();
    final param = PurchaseParam(productDetails: detail, applicationUserName: orderId);
    try {
      await InAppPurchase.instance.buyConsumable(purchaseParam: param);
    } catch (e) {
      print('Error starting payment: ${e.toString()}');
      return null;
    }
    var result = await _getInstance()._completer?.future;
    _getInstance()._completer = null;
    return result;
  }

  static void release() {
    _getInstance()._subscription?.cancel();
    _instance = null;
  }
}
