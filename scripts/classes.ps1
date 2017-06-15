Add-Type -Language CSharp @"
namespace RPS
{
  public class Server
  {
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

  public class Result
  {
    public string ServerName {get; private set;}

    //Please set a human friendly name at the dump display.
    public string Name {get; private set;}

    public Server Server {get; private set;}
    public object Value {get; private set;}
    //Short hand for filter
    public object v
    {
      get
      {
        return Value;
      }
    }
    public Result(Server server, object value, string name)
    {
      Server = server;
      Value = value;
      Name = name;
      ServerName = Server.Name;
    }
  }

  public class Website : Result
  {
    public Website(Server server, object value, string name): base(server, value, name){}
  }

  public class WebApplication : Result
  {
    public WebApplication(Server server, object value, string name): base(server, value, name){}
  }

  public class WebAppPool : Result
  {
    public WebAppPool(Server server, object value, string name): base(server, value, name){}
  }

  public class FirewallRule : Result
  {
    public FirewallRule(Server server, object value, string name): base(server, value, name){}
  }

  public class FirewallPortFilter : Result
  {
    public FirewallPortFilter(Server server, object value, string name): base(server, value, name){}
  }

  public class FirewallAddressFilter : Result
  {
    public FirewallAddressFilter(Server server, object value, string name): base(server, value, name){}
  }

  public class FirewallApplicationFilter : Result
  {
    public FirewallApplicationFilter(Server server, object value, string name): base(server, value, name){}
  }
}
"@;

Update-FormatData "${PSScriptRoot}\format.ps1xml"
