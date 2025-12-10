import 'dart:io';
import 'dart:convert';

Future<Map<String, dynamic>> readJson(String filepath) async{
  var input = await File(filepath).readAsString();
  Map<String, dynamic> jsonData = jsonDecode(input);
  return jsonData;
}

Future<Map<String, List<String>>> hashRoutes(Map<String,dynamic> data) async {
  Map<String, List<String>> stopToRoutesMap = {};
  List<dynamic> routesData = data['routes'];

  for (var route in routesData){
    String routeNumber = route['routeNumber'];
    List<dynamic> stops = route['stops'];

    for (var stop in stops){
      String stopName = stop['stop_name'];
      if (stopToRoutesMap.containsKey(stopName)){
        stopToRoutesMap[stopName]!.add(routeNumber);
      } else {
        stopToRoutesMap[stopName] = [routeNumber];
      }
    }
  }
  return stopToRoutesMap;
}

Future<void> writeFormattedJson(Map<String, dynamic> data, String filePath) async {
  var jsonString = JsonEncoder.withIndent(' ').convert(data);
  await File(filePath).writeAsString(jsonString);
  print('Data written to $filePath');

}

void main() async {

  var pathToFile = 'routes.json';
  Map<String, dynamic> data = await readJson(pathToFile);
  Map<String, List<String>> routeData = await hashRoutes(data);
  

  var outputFilePath = 'hashed_routes.json';
  await writeFormattedJson(routeData, outputFilePath);

}