import 'package:flutter_test/flutter_test.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';

void main() {
  group('OrderUiModel Unit Tests', () {
    test('should parse json correctly with all fields and compute totals', () {
      final json = {
        'orderId': 'ORD-9988',
        'date': '2026-10-06',
        'totalItems': 2,
        'totalPrice': 1000.0,
        'depositAmount': 200.0,
        'remainingAmount': 800.0,
        'status': 'depositConfirmed',
        'customerName': 'أحمد محمد',
        'phoneNumber': '01012345678',
        'address': 'القاهرة',
        'paymentMethod': 'vodafone_cash',
        'senderWalletNumber': '01099887766',
        'items': [],
      };

      final order = OrderUiModel.fromJson(json);

      expect(order.orderId, 'ORD-9988');
      expect(order.status, OrderStatus.depositConfirmed);
      expect(order.depositAmount, 200.0);
      expect(order.remainingAmount, 800.0);
      expect(order.totalPrice - order.depositAmount, order.remainingAmount);
      expect(order.customerName, 'أحمد محمد');
    });

    test('should fallback to OrderStatus.received when unknown status in json', () {
      final status = OrderStatus.fromJson('invalid_status_xyz');
      expect(status, OrderStatus.received);
    });

    test('toJson should correctly serialize status name', () {
      const status = OrderStatus.depositConfirmed;
      expect(status.toJson(), 'depositConfirmed');
    });

    test('copyWith should only update specified properties', () {
      final initialOrder = OrderUiModel(
        orderId: 'ORD-1',
        date: '2026-10-06',
        totalItems: 1,
        totalPrice: 400.0,
        depositAmount: 100.0,
        remainingAmount: 300.0,
        status: OrderStatus.received,
      );

      final updated = initialOrder.copyWith(status: OrderStatus.preparing);

      expect(updated.status, OrderStatus.preparing);
      expect(updated.orderId, 'ORD-1');
      expect(updated.totalPrice, 400.0);
    });
  });
}