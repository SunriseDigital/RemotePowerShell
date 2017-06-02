Add-Type -Language CSharp @"
public class RPSServer{
    public string User {get; private set;}
    public string Password {get; private set;}
    public string Address {get; private set;}
    public string Name {get; private set;}
    public RPSServer(string user, string pwd, string address, string name)
    {
      User = user;
      Password = pwd;
      Address = address;
      Name = name;
    }
}
"@;
