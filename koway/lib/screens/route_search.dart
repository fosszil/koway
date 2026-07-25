import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';
import '../services/route_service.dart';
import '../screens/route_detail_screen.dart';
import '../theme/app_theme.dart';
// import '../widgets/search_field.dart';
import '../widgets/double_input_card.dart';
import '../widgets/route_card.dart';

class RouteSearchScreen extends StatefulWidget {
  const RouteSearchScreen({super.key});

  @override
  State<RouteSearchScreen> createState() => _RouteSearchScreenState();
}

class _RouteSearchScreenState extends State<RouteSearchScreen> {
  static const _floatingNavClearance = 88.0;

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destController = TextEditingController();

  List<BusRoute> _allRoutes = [];
  List<BusRoute> _filteredRoutes = [];
  bool _isLoading = true;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await RouteService.instance.fetchAllRoutes();

    final routes = await RouteService.instance.fetchAllRoutes();

    if (mounted) {
      setState(() {
        _allRoutes = routes;
        //removed this to show results only on buttonpress
        // _filteredRoutes = routes;
        _isLoading = false;
      });
    }
  }

  void _handleSearch() {
    FocusScope.of(context).unfocus();

    String origin = _originController.text.trim();
    String dest = _destController.text.trim();

    if (origin.isEmpty || dest.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both locations")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    List<String> matchingIds = RouteService.instance.findRoutesBetween(
      origin,
      dest,
    );
    debugPrint("Found IDs: $matchingIds");

    if (matchingIds.isEmpty) {
      setState(() {
        _filteredRoutes = [];
        _isLoading = false;
      });
      return;
    }

    Set<String> idSet = matchingIds.toSet();

    List<BusRoute> results = _allRoutes.where((busRoute) {
      return idSet.contains(busRoute.routeNumber.trim());
    }).toList();

    setState(() {
      _filteredRoutes = results;
      _isLoading = false;
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
              DoubleInputCard(
                originController: _originController,
                destController: _destController,
                suggestions: RouteService.instance.allStops,
                onSearch: _handleSearch,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredRoutes.isEmpty
                    ? Center(
                        child: Text(
                          _hasSearched
                              ? "No Routes Found"
                              : "Enter stops to search",
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.paddingOf(context).bottom +
                              _floatingNavClearance,
                        ),
                        itemCount: _filteredRoutes.length,
                        itemBuilder: (context, index) {
                          final route = _filteredRoutes[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.sm,
                            ),
                            child: RouteCard(
                              route: route,
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
