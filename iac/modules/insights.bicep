@description('Name of the Application Insights')
param applicationInsightsName string

param logAnalyticsWorkspaceName string

@description('Application Insight Location.')
param location string = resourceGroup().location

@description('Tags.')
param tags object

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags:tags
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
    WorkspaceResourceId: logAnalytics.id
  }
  tags:tags
}
output instrumentationKey string = appInsights.properties.InstrumentationKey
