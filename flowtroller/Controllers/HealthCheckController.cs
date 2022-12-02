using flowtroller.Dependencies;
using Microsoft.AspNetCore.Mvc;

using Unit = System.ValueTuple;

namespace flowtroller.Controllers;

[ApiController]
[Route("[controller]")]
public class HealthCheckController : BaseController
{
    public HealthCheckController(IStartupSimulator startupSimulator) : base(startupSimulator)
    { }

    [HttpGet]
    public IActionResult Index() => IfReady();
}