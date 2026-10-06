import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mirrors_app/core/constants/app_storage_keys.dart';
import 'package:mirrors_app/data/models/order_ui_model.dart';
import 'package:mirrors_app/data/services/orders_firestore_service.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_cubit.dart';
import 'package:mirrors_app/presentation/manager/orders/orders_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockOrdersFirestoreService extends Mock
    implements OrdersFirestoreService {}

void main() {
  late MockSharedPreferences mockPrefs;
  late MockOrdersFirestoreService mockFirestoreService;

  setUpAll(() {
    registerFallbackValue(
      OrderUiModel(
        orderId: 'fallback',
        date: '',
        totalItems: 0,
        totalPrice: 0,
        status: OrderStatus.received,
      ),
    );
    registerFallbackValue(OrderStatus.cancelled);
  });

  setUp(() {
    mockPrefs = MockSharedPreferences();
    mockFirestoreService = MockOrdersFirestoreService();

    when(() => mockPrefs.getString(AppStorageKeys.savedOrders)).thenReturn(null);
    when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
    when(() => mockFirestoreService.submitOrder(any())).thenAnswer((_) async {});
    when(() => mockFirestoreService.updateOrderStatus(any(), any()))
        .thenAnswer((_) async {});
  });

  group('OrdersCubit Tests', () {
    test('initial state should have empty orders list', () {
      final cubit = OrdersCubit(mockPrefs, mockFirestoreService);
      expect(cubit.state.orders, isEmpty);
      cubit.close();
    });

    blocTest<OrdersCubit, OrdersState>(
      'placeOrder should emit new order and persist customer data',
      build: () => OrdersCubit(mockPrefs, mockFirestoreService),
      act: (cubit) async {
        await cubit.placeOrder(
          items: const [],
          totalPrice: 1000.0,
          depositAmount: 200.0,
          remainingAmount: 800.0,
          customerName: 'سارة خالد',
          phoneNumber: '01234567890',
          address: 'المهندسين',
          paymentMethod: 'vodafone_cash',
          senderWalletNumber: '01234567890',
        );
      },
      verify: (_) {
        verify(
          () => mockPrefs.setString(
            AppStorageKeys.customerPhone,
            '01234567890',
          ),
        ).called(1);
        verify(() => mockFirestoreService.submitOrder(any())).called(1);
      },
      expect: () => [
        isA<OrdersState>().having((s) => s.orders.length, 'orders length', 1),
      ],
    );
  });
}