import 'package:flutter/material.dart';
import '../models/motorcycle.dart';

class MotorcycleDetailPage extends StatelessWidget {
  const MotorcycleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Motorcycle m = ModalRoute.of(context)!.settings.arguments as Motorcycle;

    final entries = {
      "Make": m.make,
      "Model": m.model,
      "Year": m.year,
      "Type": m.type,
      "Displacement": m.displacement,
      "Engine": m.engine,
      "Power": m.power,
      "Torque": m.torque,
      "Compression": m.compression,
      "Bore Stroke": m.boreStroke,
      "Valves per Cylinder": m.valvesPerCylinder,
      "Fuel System": m.fuelSystem,
      "Fuel Control": m.fuelControl,
      "Ignition": m.ignition,
      "Lubrication": m.lubrication,
      "Cooling": m.cooling,
      "Gearbox": m.gearbox,
      "Transmission": m.transmission,
      "Clutch": m.clutch,
      "Frame": m.frame,
      "Front Suspension": m.frontSuspension,
      "Front Wheel Travel": m.frontWheelTravel,
      "Rear Suspension": m.rearSuspension,
      "Rear Wheel Travel": m.rearWheelTravel,
      "Front Tire": m.frontTire,
      "Rear Tire": m.rearTire,
      "Front Brakes": m.frontBrakes,
      "Rear Brakes": m.rearBrakes,
      "Total Weight": m.totalWeight,
      "Seat Height": m.seatHeight,
      "Total Height": m.totalHeight,
      "Total Length": m.totalLength,
      "Total Width": m.totalWidth,
      "Ground Clearance": m.groundClearance,
      "Wheelbase": m.wheelbase,
      "Fuel Capacity": m.fuelCapacity,
      "Starter": m.starter,
    };

    return Scaffold(
      appBar: AppBar(title: Text('${m.make} ${m.model}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: entries.entries
              .where((e) => e.value.isNotEmpty)
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 130, child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold))),
                        const SizedBox(width: 10),
                        Expanded(child: Text(e.value)),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
