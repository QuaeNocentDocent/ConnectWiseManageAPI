function New-CWMProject {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Used by sub-function')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [int]$id,
        [ValidateLength(1,100)]
        [Parameter(Mandatory=$true)]        
        [string] $name,
        [string] $actualEnd,
        [int] $actualHours,
        [string] $actualStart,
        [hashtable]$agreement,
        [ValidateSet('Billable','DoNotBill','NoCharge','NoDefault')]          
        [string] $billExpenses,
        [decimal] $billingAmount,
        [ValidateLength(1,50)]
        [string] $billingAttention,
        [ValidateSet('ActualRates','FixedFee','NotToExceed','OverrideRate ')]
        [string] $billingMethod,
        [ValidateSet('StaffMember','WorkRole')]
        [string] $billingRateType,
        [hashtable] $billingTerms,
        [ValidateSet('Billable','DoNotBill','NoCharge','NoDefault')]        
        [string] $billProducts,
        [bool] $billProjectAfterClosedFlag,
        [ValidateSet('Billable','DoNotBill','NoCharge','NoDefault')]        
        [string] $billTime,
        [HashTable] $billToCompany,
        [Hashtable] $billToContact,
        [Hashtable] $billToSite,
        [bool] $billUnapprovedTimeAndExpense,
        [Hashtable] $board,
        [ValidateSet('ActualHours','BillableHours')]           
        [String] $budgetAnalysis,
        [bool] $budgetFlag,
        [decimal] $budgetHours,
        [hashtable] $company,
        [hashtable] $contact,
        [ValidateLength(1,50)]
        [string] $customerPO,    
        [string] $description,
        [hashtable] $currency,
        [decimal] $downpayment,
        [string] $estimatedEnd,
        [decimal] $percentComplete,
        [decimal] $estimatedExpenseRevenue,
        [decimal] $estimatedHours,
        [decimal] $estimatedProductRevenue,
        [string] $estimatedStart,
        [hashtable] $expenseApprover,
        [bool ] $includeDependenciesFlag,
        [bool] $includeEstimatesFlag,
        [hashtable] $location,
        [hashtable] $department,
        [hashtable] $manager,
        [hashtable] $opportunity,
        [int] $projectTemplateId,
        [bool] $restrictDownPaymentFlag,
        [string] $scheduledEnd,
        [decimal] $scheduledHours,
        [string] $scheduledStart,
        [hashtable] $shipToCompany,
        [hashtable] $shipToContact,
        [hashtable] $shipToSite,
        [hashtable] $site,   
        [hashtable] $status,                                
        [bool] $closedFlag,
        [hashtable] $timeApprover,     
        [hashtable] $type,   
        [bool] $doNotDisplayInPortalFlag,
        [string] $billingStartDate,
        [decimal] $estimatedTimeCost,
        [decimal] $estimatedExpenseCost,
        [decimal] $estimatedProductCost,
        [hashtable] $taxCode,
        [hashtable] $companyLocation,        
        [hashtable] $customFields,
        [hashtable]$_info                    
    )

    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/project/projects"
    return Invoke-CWMNewMaster -Arguments $PsBoundParameters -URI $URI
}
