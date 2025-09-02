import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_event.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_repository.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/repetition_weight_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RepetitionWeightBloc
    extends Bloc<RepetitionWeightEvent, RepetitionWeightState> {
  final RepetitionWeightRepository repetitionWeightRepository;
  RepetitionWeightBloc(this.repetitionWeightRepository)
      : super(RepetitionWeightDefaultState()) {
    on<RepetitionWeightDefaultEvent>((event, emit) async {
      emit(RepetitionWeightDefaultState());
    });
    on<RepetitionWeightSaveEvent>((event, emit) async {
      emit(RepetitionWeightSaveState());
    });
  }
}
