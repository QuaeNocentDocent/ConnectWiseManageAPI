function New-CWMProjectTicket {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Used by sub-function')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory=$true)]
        [int]$ProjectID,
        [Parameter(Mandatory=$true)]
        [int]$PhaseID,        
        [int]$id,
        [ValidateLength(1,100)]
        [Parameter(Mandatory=$true)]
        [string]$summary,     
        [boolean]$isIssueFlag,   
        [hashtable]$board,
        [hashtable]$status,      
        [hashtable]$workRole,         
        [hashtable]$workType, 
        [ValidateLength(1,50)]
        [string]$wbsCode,  
        [hashtable] $company,
        [hashtable] $site,
        [ValidateLength(1,50)]
        [string]$siteName,             
        [ValidateLength(1,50)]
        [string]$addressLine1,                     
        [ValidateLength(1,50)]
        [string]$addressLine2,     
        [ValidateLength(1,50)]
        [string]$city,    
        [ValidateLength(1,50)]
        [string]$stateIdentifier,                         
        [ValidateLength(1,12)]
        [string]$zip,      
        [hashtable] $contact,
        [ValidateLength(1,62)]
        [string]$contactName, 
        [ValidateLength(1,20)]
        [string]$contactPhoneNumber,         
        [ValidateLength(1,15)]
        [string]$contactPhoneExtension, 
        [ValidateLength(1,250)]
        [string]$contactEmailAddress, 
        [hashtable] $type,
        [hashtable] $subType,
        [hashtable] $item,
        [hashtable] $owner,
        [hashtable] $priority,
        [hashtable] $serviceLocation,
        [hashtable] $source,
        [string] $requiredDate,
        [decimal]$budgetHours,
        [hashtable] $opportunity,
        [hashtable] $agreement,
        [int] $knowledgeBaseCategoryId,
        [int] $knowledgeBaseSubCategoryId,
        [int] $knowledgeBaseLinkId,
        [ValidateSet('Activity', 'ProjectIssue', 'KnowledgeBaseArticle','ProjectTicket','ServiceTicket','Time')]
        [string] $knowledgeBaseLinkType,
        [bool] $allowAllClientsPortalView,
        [bool] $customerUpdatedFlag,
        [bool] $automaticEmailContactFlag,
        [bool] $automaticEmailResourceFlag,        
        [bool] $automaticEmailCcFlag,                        
        [ValidateLength(1,1000)]
        [string]$automaticEmailCc, 
        [string] $closedDate,
        [string] $closedBy,
        [bool] $closedFlag,             
        [decimal] $actualHours,
        [bool] $approved,    
        [ValidateSet('ActualRates', 'FixedFee', 'NotToExceed','OverrideRate')]
        [string] $subBillingMethod,
        [decimal] $subBillingAmount,
        [string] $subDateAccepted,
        [string] $resources,        
        [ValidateSet('Billable', 'DoNotBill', 'NoCharge','NoDefault ')]
        [string] $billTime,
        [ValidateSet('Billable', 'DoNotBill', 'NoCharge','NoDefault ')]
        [string] $billExpenses,        
        [ValidateSet('Billable', 'DoNotBill', 'NoCharge','NoDefault ')]
        [string] $billProducts,             
        [ValidateSet('Ticket', 'Phase ')]
        [string] $predecessorType,          
        [int] $predecessorId,
        [bool] $predecessorClosedFlag,
        [int] $lagDays,
        [bool] $lagNonworkingDaysFlag,        
        [string] $estimatedStartDate,
        [hashtable] $location,
        [hashtable] $department,
        [int] $duration,
        [string] $mobileGuid,
        [hashtable] $currency,
        $_info,
        [string] $initialDescription,
        [string] $initialInternalAnalysis,
        [string] $initialResolution,        
        [string] $contactEmailLookup,
        [bool] $processNotifications,
        [bool] $skipCallback,
        [hashtable[]] $customFields
    )

    $PsBoundParameters.Add('project', @{id=$projectID})
    $PsBoundParameters.Add('phase', @{id=$phaseID})
    $PsBoundParameters.Remove('projectID')
    $PsBoundParameters.Remove('phaseID')
    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/project/tickets"
    return Invoke-CWMNewMaster -Arguments $PsBoundParameters -URI $URI
}
