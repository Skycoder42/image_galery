import 'dart:io';
import 'package:meta/meta.dart';
import 'package:piwigo_sync/src/page_parser.dart';

enum SyncMode {
  files,
  dirs,
}

extension _SyncModeX on SyncMode {
  String get value {
    switch (this) {
      case SyncMode.files:
        return "files";
      case SyncMode.dirs:
        return "dirs";
      default:
        return "";
    }
  }
}

enum PrivacyLevel {
  admins,
  family,
  friends,
  contacts,
  anyone,
}

extension _PrivacyLevelX on PrivacyLevel {
  int get value {
    switch (this) {
      case PrivacyLevel.admins:
        return 0x08;
      case PrivacyLevel.family:
        return 0x04;
      case PrivacyLevel.friends:
        return 0x02;
      case PrivacyLevel.contacts:
        return 0x01;
      case PrivacyLevel.anyone:
        return 0x00;
      default:
        return 0x00;
    }
  }
}

class PiwigoConnector {
  static const _parser = PageParser();

  final String _host;
  final int _port;
  final HttpClient _client;

  Cookie _pwgId;

  PiwigoConnector._(this._host, this._port, this._client, this._pwgId);

  static Future<PiwigoConnector> connect(String host, [int port = 80]) async {
    final client = HttpClient();
    try {
      final request = await client.get(host, port, "/");
      final response = await request.close();
      final pwgId = response.cookies.firstWhere((c) => c.name == "pwg_id");
      await response.drain();
      return PiwigoConnector._(host, port, client, pwgId);
    } catch (e) {
      client.close();
      rethrow;
    }
  }

  Future<void> login(String userName, String password) async {
    final response = await _post("/identification.php", {
      "username": userName,
      "password": password,
      "login": "Anmeldung",
    });
    await response.drain();
    if (response.statusCode >= 400) {
      throw "Failed to authenticate with status code ${response.statusCode}";
    }
  }

  Future<List<String>> sync({
    SyncMode syncMode = SyncMode.dirs,
    bool displayInfo = false,
    bool addToCaddie = false,
    PrivacyLevel privacyLevel = PrivacyLevel.admins,
    bool syncMeta = true,
    bool metaAll = false,
    bool metaEmptyOverrides = false,
    bool simulate = false,
    bool subcatsIncluded = true,
  }) async {
    const path = "/admin.php?page=site_update&site=1";
    final response = await _post(
      path,
      {
        "sync": syncMode.value,
        "display_info": displayInfo ? "1" : "0",
        "add_to_caddie": addToCaddie ? "1" : "0",
        "privacy_level": privacyLevel.value.toString(),
        "sync_meta": syncMeta ? "on" : "off",
        "meta_all": metaAll ? "on" : "off",
        "meta_empty_overrides": metaEmptyOverrides ? "on" : "off",
        "simulate": simulate ? "1" : "0",
        "subcats-included": subcatsIncluded ? "1" : "0",
        "submit": "Absenden"
      },
    );
    if (response.statusCode != 200) {
      throw "Failed to initiate sync with status code ${response.statusCode}";
    }

    return _parser(
      response,
      Uri(
        scheme: "http",
        host: _host,
        port: _port,
        path: path,
      ),
    );
  }

  @mustCallSuper
  void dispose() {
    _client?.close();
  }

  Future<HttpClientResponse> _post(
    String path,
    Map<String, String> params,
  ) async {
    final request = await _client.post(_host, _port, path);
    request.cookies.add(_pwgId);
    request.headers.add("Content-Type", "application/x-www-form-urlencoded");
    request.write(Uri(queryParameters: params).query);
    final response = await request.close();
    _pwgId = response.cookies.firstWhere(
      (c) => c.name == "pwg_id",
      orElse: () => _pwgId,
    );
    return response;
  }
}
