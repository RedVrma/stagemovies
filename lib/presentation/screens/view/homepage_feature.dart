import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stagemovies/presentation/screens/cubit/homepage_cubit.dart';
import 'package:stagemovies/presentation/screens/view/homepage_view.dart';

import '../../../core/injection/service_locator.dart';


class HomepageFeature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomepageCubit>()..fetchMovies(),
      child: HomepageView(),
    );
  }
}