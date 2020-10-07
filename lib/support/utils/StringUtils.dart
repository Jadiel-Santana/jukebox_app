import 'package:intl/intl.dart';

class StringUtils {
  StringUtils._();

  static StringUtils _instance;
  static const KEY_PREFS_USERS = 'inovesoftware.meuslivros.user.prefs';
  static const OK = 'OK';
  static const ERROR_SIGNUP_FAILED = 'Erro ao criar a conta.\nVerifique sua conexão e tente novamente.';
  static const ERROR_UPDATE_FAILED = 'Não foi possível atualizar.\nVerifique sua conexão e tente novamente.';
  static const ERROR_USER_EXISTS = 'Já existe um usuário com esse email';
  static const ERROR_SIGNIN_FAILED = 'Não foi possível fazer o login.\nVerifique sua conexão e tente novamente.';
  static const ERROR_USER_NOT_EXISTS = 'Usuário não encontrado';
  static const ERROR_NOT_INTERNET = 'Conecte-se à Internet.\nVocê está off-line.';
  static const ERROR_NOT_SAVE_BOOK = 'Não foi possível realizar a operação.\nVerifique sua conexão e tente novamente.';


  static StringUtils get instance {
    return _instance ??= StringUtils._();
  }

  /// Coloca todas as letras iniciais para maiúsculo.
  /// @param String str
  /// @returns String
  String capitalize(String str) {
    var string = str.toLowerCase().split(" ");
    List<String> list = List();
    for(var i in string) {
      list.add(toBeginningOfSentenceCase(i));
    }
    return list.join(' ');
  }

  /// Retorna o primeiro nome dos acompanhantes do hóspedes.
  /// @param List<String> names
  /// @returns List<String>
  List<String> getFirstName(List<String> names) {
    List<String> namesReturn = List();
    for(var name in names) {
      List<String> namesTemp = name.split(' ').toList();
      String firstName = namesTemp.first;
      namesReturn.add(capitalize(firstName));
      namesTemp.remove(0);
    }
    return namesReturn;
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