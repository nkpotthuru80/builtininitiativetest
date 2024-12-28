# Deploy the initiative
$initiativePath = "./Keyvaultinitiative/initiative.json"
# Import initiatie definition file
$initiativeContent = Get-Content -Path $initiativePath -Raw
$initiativeContent = $initiativeContent.Trim()
$initiativeDefinition = $initiativeContent | ConvertFrom-Json        
# Map variables to specific initiative properties and convert them
$initiativeName = "epac-Audit-KeyVault"
$policyDefinition = $initiativeDefinition.properties.policyDefinitions | ConvertTo-Json -Compress -Depth 10
$description = $initiativeDefinition.properties.description.ToString()
$displayName = $initiativeDefinition.properties.displayName.ToString()
$initiativeId = "/subscriptions/f147463c-0679-4251-8f65-6e4b481e4f07/providers/Microsoft.Authorization/policySetDefinitions/$initiativeName"

Write-Output "Deploying initiative: $initiativeName"
New-AzPolicySetDefinition `
  -Name $initiativeName `
  -PolicyDefinition $policyDefinition `
  -Description $description `
  -DisplayName $displayName `
  -SubscriptionId f147463c-0679-4251-8f65-6e4b481e4f07

# Get Initiative definition detials
$initiative = Get-AzPolicySetDefinition -Name $displayName

# Assign the initiative
Write-Output "Assigning initiative: $initiativeName"
New-AzPolicyAssignment `
  -Name "${initiativeName}-assignment" `
  -PolicyDefinition $initiative `
  -Scope "/subscriptions/f147463c-0679-4251-8f65-6e4b481e4f07"