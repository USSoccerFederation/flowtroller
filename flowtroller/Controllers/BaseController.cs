using flowtroller.Dependencies;
using Microsoft.AspNetCore.Mvc;

namespace flowtroller.Controllers;

public abstract class BaseController : ControllerBase
{
    private readonly IStartupSimulator _startupSimulator;

    protected BaseController(IStartupSimulator startupSimulator)
    {
        _startupSimulator = startupSimulator ?? throw new ArgumentNullException(nameof(startupSimulator));
    }

    protected IActionResult IfReady() => _startupSimulator.IsReady
        ? Ok()
        : StatusCode(503);

    protected ActionResult<T> IfReady<T>(T successCase) => _startupSimulator.IsReady
        ? Ok(successCase)
        : StatusCode(503);
}