import 'package:procastiless/components/project/data/project.dart';

abstract class ProjectBaseState {}

class ProjectLoadingState extends ProjectBaseState {}

class ProjectLoadedState extends ProjectBaseState {
  List<Project?> projects;
  ProjectLoadedState(this.projects);
}

class ProjectZeroState extends ProjectBaseState {}
