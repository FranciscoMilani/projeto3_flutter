import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/services/api_service.dart';
import 'package:projeto_avaliativo_3/services/background_tasks_service.dart';
import 'package:projeto_avaliativo_3/util/globals.dart';
import 'notification_settings_screen.dart';

class KeywordsListScreen extends StatefulWidget {
  const KeywordsListScreen({super.key});

  @override
  _KeywordsListScreenScreenState createState() => _KeywordsListScreenScreenState();
}

class _KeywordsListScreenScreenState extends State<KeywordsListScreen> {
  final NotificationManager _notificationManager = NotificationManager();
  final BackgroundTasksService _bgTaskService = BackgroundTasksService();
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _configureNotifications();
    _initializeTaskProcessing();
  }

  Future<void> _initializeTaskProcessing() async {
    await _bgTaskService.initialize();
  }

  Future<void> _configureNotifications() async {
    await _notificationManager.configurarNotificacaoLocal();
  }

  _openKeywordDialog() {
    String newKeyword = '';
    bool isCheckedActive = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Palavra-chave'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) => newKeyword = value,
                    decoration: const InputDecoration(
                       hintText: 'digite aqui...',
                    ),
                  ),
                  Row(
                      children: [
                      const Text('Habilitar ao salvar'),
                      Checkbox(
                        value: isCheckedActive,
                        onChanged: (bool? value) {
                          setDialogState(() {
                            isCheckedActive = value ?? false;
                          });
                        }
                      ),
                    ]
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    if (newKeyword.isNotEmpty && !keywords.any((x) => x.keyword == newKeyword)) {
                      setState(() => keywords.add(Keyword(keyword: newKeyword, fetchActive: isCheckedActive)));
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      }
    );
  }

  _toggleNotificationKeyword(Keyword keyword) {
    setState(() {
      keyword.fetchActive = !keyword.fetchActive;
    });
  }

  _confirmDelete(Keyword keyword) {
    setState(() {
      keywords.remove(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Palavras-chave',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
            )
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:  ListView.builder(
            itemCount: keywords.length,
              itemBuilder: (context, index) {
                final keyword = keywords[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        keyword.keyword,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(keyword.createdDate),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: keyword.fetchActive
                              ? IconButton(
                            key: const ValueKey('1'),
                            onPressed: () => _toggleNotificationKeyword(keyword),
                            icon: const Icon(Icons.notifications_active,
                                size: 30, color: Colors.lightGreen),
                          )
                              : IconButton(
                            key: const ValueKey('0'),
                            onPressed: () => _toggleNotificationKeyword(keyword),
                            icon: const Icon(Icons.notifications_off,
                                size: 30, color: Colors.redAccent),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _confirmDelete(keyword),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openKeywordDialog();
        },
        elevation: 5.0,
        child: const Icon(Icons.create, color: Colors.white),
        backgroundColor: Colors.black54
      ),
    );
  }
}