# Input variables: set these values in the variables section of the release pipeline

# policyName - [Required] Policy definition name
# policyDisplayName - [optional] Policy definition display name
# policyDescription - [optional] Policy definition description
# subscriptionId - [optional] Id of subscription the definition will be available in
# managementGroupName - [optional] Name of management group the definition will be available in
# policyRule - [Required] Policy definition rule in JSON string format or path to a file containing JSON policy definition rule
# policyParameters - [optional] Policy parameter values in JSON string format
# policyMode - [Required] Policy mode. Possible values are 'All', 'Indexed', 'Microsoft.Kubernetes.Data'

# Notes:
# File path value for $(PolicyRule) may be a fully qualified path or a path relative to $(System.DefaultWorkingDirectory)

$policyName = "$(policyName)"
$policyDisplayName = "$(policyDisplayName)"
$policyDescription = "$(policyDescription)"
$subscriptionId = "$(subscriptionId)"
$managementGroupName = "$(managementGroupName)"
$policyRule = "$(policyRule)"
$policyParameters = "$(policyParameters)"
$policyMode = "$(policyMode)"

if (!$policyName)
{
throw "Unable to create policy definition: required input variable value `$(PolicyName) was not provided"
}

if (!$policyRule)
{
throw "Unable to create policy definition: required input variable value `$(PolicyRule) was not provided"
}

if ($subscriptionId -and $managementGroupName)
{
throw "Unable to create policy definition: `$(SubscriptionId) '$subscriptionId' and `$(ManagementGroupName) '$managementGroupName' were both provided. Either may be provided, but not both."
}

$cmdletParameters = @{Name=$policyName; Policy=$policyRule; Mode=$policyMode}
if ($policyDisplayName)
{
$cmdletParameters += @{DisplayName=$policyDisplayName}
}

if ($policyDescription)
{
$cmdletParameters += @{Description=$policyDescription}
}

if ($subscriptionId)
{
$cmdletParameters += @{SubscriptionId=$subscriptionId}
}

if ($managementGroupName)
{
$cmdletParameters += @{ManagementGroupName=$managementGroupName}
}

if ($policyParameters)
{
$cmdletParameters += @{Parameter=$policyParameters}
}

&New-AzPolicyDefinition @cmdletParameters