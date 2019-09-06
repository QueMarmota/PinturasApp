library my_prj.globals;

String apiUrl =  'https://apipinturas.herokuapp.com/';
//singleton
String apiToken;

String getApiToken(){
  return apiToken;
}

setApiToken(String _apiToken){
  apiToken=_apiToken;
}