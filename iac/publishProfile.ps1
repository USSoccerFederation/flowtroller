Param(
    [string]
    [Parameter(Mandatory = $true)]
    $ResourceGroupName,

    [string]
    [Parameter(Mandatory = $true)]
    $AppName,

    [string]
    [Parameter(Mandatory = $false)]
    $Reset = "false",

    [string]
    [Parameter(Mandatory = $false)]
    $SubscriptionId = ""
)

Import-Module -Name Az.Accounts
Import-Module -Name Az.Websites

$clientId = ($env:AZURE_CLIENTID)
$clientSecret = ($env:AZURE_CLIENTSECRET | ConvertTo-SecureString -AsPlainText -Force)
$tenantId = ($env:AZURE_TENANTID)

$credentials = New-Object System.Management.Automation.PSCredential($clientId, $clientSecret)
Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId

if (-not [string]::IsNullOrWhiteSpace($SubscriptionId)) {
    Set-AzContext -Subscription $SubscriptionId
}

$pub_profile = $null

if ([System.Convert]::ToBoolean($Reset) -eq $true) {
    $pub_profile = Reset-AzWebAppPublishingProfile -ResourceGroupName $ResourceGroupName -Name $AppName

    $pub_profile = $null
}
else {
    $pub_profile = Get-AzWebAppPublishingProfile -ResourceGroupName $ResourceGroupName -Name $AppName

    $env:AZURE_WEBAPP_PUBLISH_PROFILE = $pub_profile
}