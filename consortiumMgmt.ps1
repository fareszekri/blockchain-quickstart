param (
    [string]$Endpoint = $( Read-Host "Input Endpoint address, please. Refer to Transaction nodes, and then select the default transaction node" ),
    [string]$memberaccountadress = $( Read-Host "Input Member account address, please. Refer to the overview page in Azure if needed" ),
    [securestring]$memberpassword = $( Read-Host -AsSecureString "Input Member account password, please. The one you used to create the blockchain service"),
    [string]$RootContract = $( Read-Host "Input RootContract address, please. Refer to the overview page in Azure if needed" ),
    [string]$subscriptionId = $( Read-Host "Input invited consortium member subscriptionId" )
    # [Parameter(Mandatory=$true)][string]$memberaccount = $( Read-Host "Input Member account address, please. Refer to the overview page in Azure if needed" ) >,
    # [Parameter(Mandatory=$true)][string]$memberaccount = $( Read-Host "Input Member account address, please. Refer to the overview page in Azure if needed" ) >,
    # [string]$password = $( Read-Host "Input password, please" ),
    # [switch]$force = $false
 )
Install-Module -Name Microsoft.AzureBlockchainService.ConsortiumManagement.PS -Scope CurrentUser
Import-Module Microsoft.AzureBlockchainService.ConsortiumManagement.PS
$InformationPreference = 'Continue'
$Connection = New-Web3Connection -RemoteRPCEndpoint $Endpoint
$MemberAccount = Import-Web3Account -ManagedAccountAddress $memberaccountadress -ManagedAccountPassword $((New-Object PSCredential "user",$memberpassword).GetNetworkCredential().Password)
$ContractConnection = Import-ConsortiumManagementContracts -RootContractAddress $RootContract -Web3Client $Connection

# Get consortium members
$ContractConnection | Get-BlockchainMember

# Create Invitation 
$ContractConnection | New-BlockchainMemberInvitation -SubscriptionId $subscriptionId -Role USER -Web3Account $MemberAccount

# Get Consortium invitations
$ContractConnection | Get-BlockchainMemberInvitation