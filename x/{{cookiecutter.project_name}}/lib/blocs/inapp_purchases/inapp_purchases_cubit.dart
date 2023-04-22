import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'inapp_purchases_state.dart';

class InappPurchasesCubit extends Cubit<InappPurchasesState> {
  InappPurchasesCubit() : super(InappPurchasesState());
}
