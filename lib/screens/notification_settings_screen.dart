import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool newsNotificationsEnabled = true;
  bool syncWarningsEnabled = true;
  bool issueNotificationsEnabled = true;
  int syncInterval = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações de Notificações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Notificações de Notícias'),
              subtitle: const Text('Receber notificações sobre novas notícias.'),
              value: newsNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  newsNotificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Avisos de Sincronização'),
              subtitle: const Text(
                  'Receber notificações sobre problemas na sincronização.'),
              value: syncWarningsEnabled,
              onChanged: (value) {
                setState(() {
                  syncWarningsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Notificações de Problemas'),
              subtitle:
              const Text('Receber notificações sobre problemas detectados.'),
              value: issueNotificationsEnabled,
              onChanged: (value) {
                setState(() {
                  issueNotificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Intervalo de Sincronização (minutos)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Slider(
              value: syncInterval.toDouble(),
              min: 1,
              max: 60,
              divisions: 12,
              label: '$syncInterval minutos',
              onChanged: (value) {
                setState(() {
                  syncInterval = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Salvar Configurações'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    // Save the settings in a local database or preferences.
    // Example:
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.setBool('news_notifications', newsNotificationsEnabled);
    // await prefs.setBool('sync_warnings', syncWarningsEnabled);
    // await prefs.setBool('issue_notifications', issueNotificationsEnabled);
    // await prefs.setInt('sync_interval', syncInterval);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configurações salvas com sucesso!')),
    );
  }
}