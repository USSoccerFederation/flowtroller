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

Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.Accounts -Force
Install-Module -Name Az.Websites -Force

$clientId = ($env:AZURE_CLIENTID)
$clientSecret = ($env:AZURE_CLIENTSECRET | ConvertTo-SecureString -AsPlainText -Force)
$tenantId = ($env:AZURE_TENANTID)

$credentials = New-Object System.Management.Automation.PSCredential($clientId, $clientSecret)
Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId

if (-not [string]::IsNullOrWhiteSpace($SubscriptionId)) {
    Set-AzContext -Subscription $SubscriptionId
}

if ([System.Convert]::ToBoolean($Reset) -eq $true) {
    $pub_profile = Reset-AzWebAppPublishingProfile -ResourceGroupName $ResourceGroupName -Name $AppName

    $pub_profile = $null
}
else {
    $env:AZURE_WEBAPP_PUBLISH_PROFILE = Get-AzWebAppPublishingProfile -ResourceGroupName $ResourceGroupName -Name $AppName
}

if($env:AZURE_WEBAPP_PUBLISH_PROFILE) {
    Write-Output "env variable was set"
}
else {
    Write-Output "env variable NOT set!"
}