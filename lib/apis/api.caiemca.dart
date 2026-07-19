
import 'package:dio/dio.dart';

const String kDomainDebug = 'http://161.35.58.1:8080';
const String kDomainRelease = 'https://api.caiemca.do';
const kDomainBase = 'http://161.35.58.1:8080';
Dio apiCaiemca = Dio(
  BaseOptions(
    baseUrl: kDomainBase
  )
);


