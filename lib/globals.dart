library my_prj.globals;

String apiUrl =  'http://157.230.128.97/bucketapp/public/api/';
//singleton
String apiToken;

String getApiToken(){
  return apiToken;
}

setApiToken(String _apiToken){
  apiToken=_apiToken;
}