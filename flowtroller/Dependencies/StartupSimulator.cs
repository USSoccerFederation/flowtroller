namespace flowtroller.Dependencies;

public interface IStartupSimulator
{
    bool IsReady { get; }
}

public class StartupSimulator : IStartupSimulator
{
    private static readonly DateTimeOffset Epoc = DateTimeOffset.UtcNow;
    private static readonly TimeSpan StartupDelay = TimeSpan.FromSeconds(10);

    public bool IsReady => DateTimeOffset.UtcNow - Epoc > StartupDelay;
}