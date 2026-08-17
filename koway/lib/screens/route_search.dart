import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';
import '../services/route_service.dart';
import '../screens/route_detail_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/indirect_route_card.dart';
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
  IndirectRoute? _indirectRoute;

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
      _indirectRoute = null;
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

  void _handleIndirectSearch() {
    final origin = _originController.text.trim();
    final destination = _destController.text.trim();

    if (origin.isEmpty || destination.isEmpty) {
      return;
    }

    final result = RouteService.instance.findRoutesViaGandhipuram(
      origin,
      destination,
    );

    setState(() {
      _indirectRoute = result;
    });
  }

  void _swapStops() {
    setState(() {
      final origin = _originController.text;
      _originController.text = _destController.text;
      _destController.text = origin;
    });
  }

  Widget _buildNoDirectRouteState() {
    if (!_hasSearched) {
      return _popularRoutes();
    }

    final indirectRoute = _indirectRoute;

    if (indirectRoute == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("No Routes Found"),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _handleIndirectSearch,
              child: const Text("Search Routes via Gandhipuram"),
            ),
          ],
        ),
      );
    }

    if (indirectRoute.firstLeg.isEmpty) {
      return const Center(
        child: Text("No route found from the origin to Gandhipuram"),
      );
    }

    if (indirectRoute.secondLeg.isEmpty) {
      return const Center(
        child: Text("No route found from Gandhipuram to the destination"),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        MediaQuery.paddingOf(context).bottom + _floatingNavClearance,
      ),
      child: IndirectRouteCard(
        origin: _originController.text.trim(),
        destination: _destController.text.trim(),
        transferStop: indirectRoute.transferStop,
        firstLegRoutes: indirectRoute.firstLeg,
        secondLegRoutes: indirectRoute.secondLeg,
      ),
    );
  }

  Widget _popularRoutes() {
    final colors = Theme.of(context).colorScheme;

    final List<Map<String, String>> _routesPopular = [
      {'origin': "Railway Station", 'destination': "Gandhipuram"},
      {'origin': "Ukkadam", 'destination': "Railway Station"},
    ];

    return ListView(
      padding:
          EdgeInsets.all(16) +
          EdgeInsets.only(
            bottom:
                MediaQuery.paddingOf(context).bottom + _floatingNavClearance,
          ),
      children: [
        Text(
          "Popular Routes",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "Most common routes around Coimbatore",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 10),
        for (final trip in _routesPopular)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: colors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: colors.outlineVariant),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.route_rounded),
                ),
                title: Text(
                  trip['origin']!,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '→ ${trip['destination']!}',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  setState(() {
                    _originController.text = trip['origin']!;
                    _destController.text = trip['destination']!;
                  });
                },
              ),
            ),
          ),
      ],
    );
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
                onSwap: _swapStops,
                onSearch: _handleSearch,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredRoutes.isEmpty
                    ? _buildNoDirectRouteState()
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
