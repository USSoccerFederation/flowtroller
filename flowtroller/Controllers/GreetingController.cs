using flowtroller.Dependencies;
using Microsoft.AspNetCore.Mvc;

namespace flowtroller.Controllers;

[ApiController]
[Route("[controller]")]
public class GreetingController : BaseController
{
    public GreetingController(IStartupSimulator startupSimulator) : base(startupSimulator)
    { }
    
    [HttpGet(Name = "GetGreeting")]
    public ActionResult<string> SayHello() => IfReady("Hello, World!");
}