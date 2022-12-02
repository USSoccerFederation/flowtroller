using flowtroller.Controllers;
using flowtroller.Dependencies;
using Microsoft.AspNetCore.Mvc;
using NUnit.Framework;
using static NUnit.Framework.Assert;

namespace flowtroller.Test.Controllers;

[TestFixture]
public class GreetingControllerTests
{
    [Test]
    public void SayHello_ErrorsIfNotReady()
    {
        var result = CreateController(false).SayHello().Result;
        IsInstanceOf<StatusCodeResult>(result);
        AreEqual(503, ((StatusCodeResult) result!).StatusCode);
    }

    [Test]
    public void SayHello_ReturnsGreetingIfReady()
    {
        var result = CreateController(true).SayHello().Result;
        IsInstanceOf<OkObjectResult>(result);
        AreEqual("Hello, World!", ((OkObjectResult)result!).Value);
    }

    private static GreetingController CreateController(bool isReady) => new(new ConstantStartupSimulator(isReady));

    private record ConstantStartupSimulator(bool IsReady = default) : IStartupSimulator;
}