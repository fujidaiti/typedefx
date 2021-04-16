import 'package:typedefx_generator/src/model/record.dart';
import 'package:typedefx_generator/src/model/cases.dart';
import 'package:typedefx_generator/src/model/composite.dart';

class GeneratedLibrary {
  final Iterable<RecordType> records;
  final Iterable<CasesType> cases;
  final Iterable<CompositeType> composites;
  final String uri;
  final String originalUri;
  final bool exportOriginalUri;

  GeneratedLibrary({
    required this.records,
    required this.cases,
    required this.composites,
    required this.uri,
    required this.originalUri,
    required this.exportOriginalUri,
  });
}
