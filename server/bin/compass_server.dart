// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:compass_server/middleware/auth.dart';
import 'package:compass_server/routes/booking.dart';
import 'package:compass_server/routes/continent.dart';
import 'package:compass_server/routes/destination.dart';
import 'package:compass_server/routes/login.dart';
import 'package:compass_server/routes/user.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  // Gunakan IP apa saja yang tersedia
  final ip = InternetAddress.anyIPv4;

  // Buat router utama
  final router = Router()
    ..get('/continent', continentHandler)
    ..mount('/destination/', DestinationApi().router)
    ..mount('/booking/', BookingApi().router)
    ..mount('/user/', UserApi().router)
    ..mount('/login/', LoginApi().router);

  // Pipeline middleware
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(authRequests()) // Pastikan authRequests mengembalikan Middleware
      .addHandler(router);

  // Port fallback 8080
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Jalankan server
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
