import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/model/ride/locations.dart';

class LocationPickerTile extends StatelessWidget {
  const LocationPickerTile({
    super.key,
    required this.location,
    this.showHistoryIcon = false,
    this.onTap,
  });

  final Location location;
  final bool showHistoryIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: showHistoryIcon ? Icon(Icons.history, color: Colors.grey) : null,
      title: Text(location.name),
      subtitle: Text(location.country.name.toUpperCase()),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap ??
          () {
            // Default behavior: return the selected location
            Navigator.pop(context, location);
          },
    );
  }
}
