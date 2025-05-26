import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/RepetitionWeightEvent.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/RepetitionWeightRepository.dart';
import 'package:fit_tracker/src/home/bloc/RepetitionWeightScreen/RepetitionWeightState.dart';
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
