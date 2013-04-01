include 'core.thrift'

namespace java com.github.mistertea.html5animator.rpc

exception NotAuthorizedException {
  1: string errorMessage,
}

service AnimatorRpc
{
  i32 ping(),
  
  core.User getMyself(1:string token),
  
  bool validateToken(1:string token),

  string login(1:string token, 2:string email, 3:string password),

  string createAccount(1:string token, 2:string email, 3:string name, 4:string password),
  
  void logout(1:string token) throws (1:NotAuthorizedException e),
  
  bool changePassword(1:string token, 2:string oldPassword, 3:string newPassword) throws (1:NotAuthorizedException e),
  
  bool changeUsername(1:string token, 2:string newUsername) throws (1:NotAuthorizedException e),
  
  bool emailPassword(1:string emailAddress),
  
  core.UserData getMyData(1:string token),
  
  void sendClientError(1:core.ClientErrorInfo errorInfo),
  
  core.Movie loadMovie(1:string id),

  void saveMovie(1:core.Movie movie),
}
