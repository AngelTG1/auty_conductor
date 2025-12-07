import 'package:flutter/material.dart';
import '../../domain/entities/location_entity.dart';
import 'mechanic_card.dart';

class MechanicListSheet extends StatefulWidget {
  final List<LocationEntity> mecanicos;
  final VoidCallback onClose;
  final void Function(LocationEntity) onRoute;
  final void Function(LocationEntity) onRequest;
  final String Function(double) formatDistance;

  const MechanicListSheet({
    super.key,
    required this.mecanicos,
    required this.onClose,
    required this.onRoute,
    required this.onRequest,
    required this.formatDistance,
  });

  @override
  State<MechanicListSheet> createState() => _MechanicListSheetState();
}

class _MechanicListSheetState extends State<MechanicListSheet> {
  final DraggableScrollableController _dragController =
      DraggableScrollableController();

  double _currentSize = 0.33;

  @override
  void initState() {
    super.initState();
    _dragController.addListener(() {
      _currentSize = _dragController.size;
    });
  }

  void _toggleSheet() {
    final target = _currentSize < 0.6 ? 0.80 : 0.33;

    _dragController.animateTo(
      target,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _dragController,
      initialChildSize: 0.40,
      minChildSize: 0.33,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(22)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // ───────── INDICADOR SUPERIOR (ÚNICO CONTROL DE DRAG)
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  final delta = details.primaryDelta ?? 0;
                  final newSize =
                      (_currentSize - delta / 600).clamp(0.22, 0.85);

                  _dragController.jumpTo(newSize);
                },
                onTap: _toggleSheet,
                child: Container(
                  width: 50,
                  height: 6,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              // ───────── HEADER
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text(
                            "Mecánicos cercanos",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF235FE8).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              widget.mecanicos.length.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF235FE8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Botón cerrar
                    GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              const Divider(height: 10),

              // ───────── LISTA (YA NO ARRASTRA EL MODAL)
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.mecanicos.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final m = widget.mecanicos[i];
                    return MechanicCard(
                      mechanic: {
                        'uuid': m.uuid,
                        'lat': m.lat,
                        'lng': m.lng,
                        'name': m.name,
                        'distance': m.distance,
                        'address': m.address,
                      },
                      distanceText: widget.formatDistance(m.distance!),
                      onRoutePressed: () => widget.onRoute(m),
                      onRequestPressed: () => widget.onRequest(m),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
