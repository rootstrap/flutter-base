
import 'package:domain/bloc/get_products/get_products_cubit.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/repositories/product_repository.dart';
import 'package:http/http.dart' as http;



@GenerateMocks(
    [
      ProductRepository,
      GetProductsCubit,
    ],
)


void main() {}


