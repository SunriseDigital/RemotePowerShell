Add-Type -Language CSharp @"
namespace RPS
{
  public class Server{
    public string User {get; private set;}
    public string Password {get; private set;}
    public string Address {get; private set;}
    public string Name {get; private set;}
    public Server(string user, string pwd, string address, string name)
    {
      User = user;
      Password = pwd;
      Address = address;
      Name = name;
    }
  }

  public class Result{
    public Server Server {get; private set;}
    public dynamic Value {get; private set;}
    public Result(Server server, dynamic value)
    {
      Server = server;
      Value = value;
    }
  }
}
"@;
