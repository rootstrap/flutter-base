import 'package:domain/services/ProductService.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  ProductService productService;
  MockProductRepository mockProductRepository;
  MockGetProductsCubit mockGetProductsCubit;
  
  setUp(() {
    mockProductRepository = MockProductRepository();
    mockGetProductsCubit = MockGetProductsCubit();
    productService = ProductService(mockProductRepository, mockGetProductsCubit);
  });

  // test(
  //     // 'should get data from repo',
  //     //     () async {
  //     //       when(
  //     //           mockProductRepository.getProducts(),
  //     //       ).thenAnswer((_) async => );
  //     //
  //     //     },
  // );

}
