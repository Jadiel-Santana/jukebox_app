import 'package:intl/intl.dart';

class StringUtils {
  static const HASH_DEFAULT = '3c90ebc35bd44a64a95c6ed0de2fac33';
  static const KEY_PREFS_USERS = 'inovesoftware.meuslivros.user.prefs';
  static const KEY_PREFS_HASH = 'inovesoftware.meuslivros.hash.prefs';
  static const OK = 'OK';
  static const ERROR_SIGNUP_FAILED = 'Erro ao criar a conta.';
  static const ERROR_UPDATE_FAILED = 'Não foi possível atualizar o usuário.';
  static const ERROR_DELETE_FAILED = 'Não foi possível excluir o usuário.';
  static const ERROR_SIGNIN_FAILED = 'Não foi possível fazer o login.';
  static const ERROR_FETCH_USERS = 'Não foi possível listar os usuários.';
  static const ERROR_USER_EXISTS = 'Já existe um usuário com esse email';
  static const ERROR_USER_NOT_EXISTS = 'Usuário não encontrado';
  static const ERROR_NOT_INTERNET = 'Conecte-se à Internet.\nVocê está off-line.';


  /// Coloca todas as letras iniciais para maiúsculo.
  /// @param String str
  /// @returns String
  static String capitalize(String str) {
    var string = str.toLowerCase().split(" ");
    List<String> list = List();
    for(var i in string) {
      list.add(toBeginningOfSentenceCase(i));
    }
    return list.join(' ');
  }

  /// Remove todos os acentos das palavras.
  /// @param String str
  /// @returns String
  static String removeAccents(String text) {
    final withAccents = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    final withoutAccents = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < withAccents.length; i++)  {
      text = text.replaceAll(withAccents[i].toString(), withoutAccents[i].toString());
    }
    return text;
  }

}