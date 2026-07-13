import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';
import '../services/route_service.dart';
import '../screens/route_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/koway_app_header.dart';
import '../widgets/search_field.dart';

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  static const _floatingNavClearance = 88.0;

  late Future<List<BusRoute>> futureRoutes;

  TextEditingController searchController = TextEditingController();

  List<BusRoute> _allRoutes = [];
  List<BusRoute> _filteredRoutes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final routes = await RouteService.instance.fetchAllRoutes();

    if (mounted) {
      setState(() {
        _allRoutes = routes;
        _filteredRoutes = routes;
        _isLoading = false;
      });
    }
  }

  void _runFilter(String inputKeyword) {
    List<BusRoute> results = [];

    if (inputKeyword.isEmpty) {
      results = _allRoutes;
    } else {
      results = _allRoutes.where((route) {
        final query = inputKeyword.toLowerCase();

        return route.routeNumber.toLowerCase().contains(query) ||
            route.origin.toLowerCase().contains(query) ||
            route.destination.toLowerCase().contains(query);
      }).toList();
    }

    setState(() {
      _filteredRoutes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.forest,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              KowayAppHeader(
                child: SearchField(
                  label: 'Search routes',
                  controller: searchController,
                  onChanged: _runFilter,
                  onClear: () => _runFilter(''),
                ),
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredRoutes.isEmpty
                    ? const Center(child: Text('No routes found'))
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.paddingOf(context).bottom +
                              _floatingNavClearance,
                        ),
                        itemCount: _filteredRoutes.length,
                        itemBuilder: (context, index) {
                          final route = _filteredRoutes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade50,
                                child: Text(
                                  route.routeNumber,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              title: Text('Route ${route.routeNumber}'),
                              subtitle: Text(
                                '${route.origin} → ${route.destination}',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RouteDetailScreen(route: route),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
