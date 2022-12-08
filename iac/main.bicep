@allowed([
  'dev'
  'qa'
  'uat'
  'stage'
  'prod'
])
param environment string

@allowed([
  'F1'
  'D1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1v2'
  'P2v2'
  'P3v2'
  'P1v3'
  'P2v3'
  'P3v3'
])
param aspSkuName string

@allowed([
  'Free'
  'Shared'
  'Basic'
  'Standard'
  'PremiumV2'
  'PremiumV3'
])
param aspSkuTier string

param APPLICATIONINSIGHTS_CONFIGURATION_CONTENT string
param iterationId string = '001'
param location string = resourceGroup().location
param instanceCount int
param buildstamp string

module appInsights 'modules/insights.bicep' = {
  name: 'insights-${buildstamp}'
  params: {
    applicationInsightsName: 'ai-flowtroller-${environment}'
    logAnalyticsWorkspaceName: 'log-flowtroller-${environment}'
    location: location
    tags: { buildstamp: buildstamp }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'asp-flowtroller-${environment}-${iterationId}'
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: { name: aspSkuName, tier: aspSkuTier, capacity: instanceCount }
  tags: { buildstamp: buildstamp }
  location: location
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-flowtroller-${environment}-${iterationId}'
  kind: 'app'
  location: location
  properties: {
    serverFarmId: resourceId('Microsoft.Web/serverfarms', 'asp-flowtroller-${environment}-${iterationId}')
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      healthCheckPath: '/Greeting'
      webSocketsEnabled: false
      http20Enabled: true
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      loadBalancing: 'LeastRequests'
      ftpsState: 'FtpsOnly'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.outputs.instrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONFIGURATION_CONTENT'
          value: APPLICATIONINSIGHTS_CONFIGURATION_CONTENT
        }
      ]
    }
  }
  tags: { buildstamp: buildstamp }
  dependsOn: [
    appServicePlan
    appInsights
  ]
}
