import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'package:projeto_avaliativo_3/models/keyword.dart';
import 'package:projeto_avaliativo_3/services/notification_manager.dart';
import 'package:projeto_avaliativo_3/services/api_service.dart';
import 'package:projeto_avaliativo_3/services/background_tasks_service.dart';
import 'notification_settings_screen.dart';

const tarefaRecorrenteCada15Minutos = "tarefabk1";
const tarefaComProblema             = "tarefabk2";


class KeywordsListScreen extends StatefulWidget {
  const KeywordsListScreen({super.key});

  @override
  _KeywordsListScreenScreenState createState() => _KeywordsListScreenScreenState();
}

class _KeywordsListScreenScreenState extends State<KeywordsListScreen> {
  final NotificationManager _notificationManager = NotificationManager();
  final ApiService apiService = ApiService();

  final List<Keyword> _keywords = [
    Keyword(keyword: "bolsonaro", fetchActive: false),
    Keyword(keyword: "trump", fetchActive: true),
  ];

  @override
  void initState() {
    super.initState();
    _configureNotifications();
    _syncNews();
    _initializeTaskProcessing();
  }

  Future<void> _initializeTaskProcessing() async {
    await BackgroundTasksService.initialize();
    BackgroundTasksService.registerOneTimeTask(Keyword.extractKeywords(_keywords));
    await BackgroundTasksService.fetchDataAndNotify();
  }

  Future<void> _configureNotifications() async {
    await _notificationManager.configurarNotificacaoLocal();
  }
  
  Future<void> _syncNews() async {
    var activeKeywordsEntities = _keywords.where((k) => k.fetchActive);
    List<String?> activeKeywords = Keyword.extractKeywords(activeKeywordsEntities);

    try {
      //var result1 = await apiService.fetchNewsApi(activeKeywords);
      var result2 = await apiService.fetchNewsData(activeKeywords);

      _notificationManager.notificacoesLocais.show(
        0,
        'Sincronizando',
        'Buscando dados das APIs NewsApi e NewsData...',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'sync_channel', 'News Sync',
            channelDescription: 'Channel for syncing news data',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );

      // for (var result in result2) {
      //   // se encotnrar...
      // }
    } catch (e) {
      _notificationManager.notificacoesLocais.show(
        0,
        'Sincronização falhou',
        'Um erro ocorreu na sincronização das notícias',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'error_channel', 'News Sync Error',
            channelDescription: 'Channel for news sync errors',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    } finally {
      setState(() {

      });
    }
  }

  // Future<void> consultar() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   final dbHelper = BancoHelper();
  //   await dbHelper.iniciarBD();
  //   final produtosLocal = await dbHelper.buscarProdutos();
  //
  //   // Busca do banco se houver produto. Se não, busca da API
  //   if (produtosLocal.isNotEmpty) {
  //     setState(() {
  //       produtos = produtosLocal;
  //       isLoading = false;
  //     });
  //   } else if (primeiroUso) {
  //     await sincronizarDados();
  //   } else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> deletarProduto(int id) async {
  //   final dbHelper = BancoHelper();
  //   await dbHelper.deletarProduto(id);
  //   await consultar();
  // }
  //
  // Future<void> editarProduto(Produto produto) async {
  //   final dbHelper = BancoHelper();
  //   await dbHelper.upsertProduto(produto);
  //   await consultar();
  // }
  //
  // void _abrirTelaEdicao(Produto? produto) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ProdutoFormScreen(
  //         produto: produto,
  //         onSalvar: editarProduto,
  //       ),
  //     ),
  //   );
  // }

  // void _confirmarDelecao(Produto produto) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Confirmar exclusão'),
  //       content: Text('Tem certeza que deseja excluir "${produto.nome}"?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('Cancelar'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             await deletarProduto(produto.id);
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Confirmar'),
  //         ),
  //       ],
  //     ),
  //   );

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
                    if (newKeyword.isNotEmpty && !_keywords.any((x) => x.keyword == newKeyword)) {
                      setState(() => _keywords.add(Keyword(keyword: newKeyword, fetchActive: isCheckedActive)));
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
      _keywords.remove(keyword);
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
            itemCount: _keywords.length,
              itemBuilder: (context, index) {
                final keyword = _keywords[index];
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