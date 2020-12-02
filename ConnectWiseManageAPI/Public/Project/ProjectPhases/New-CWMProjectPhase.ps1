function New-CWMProjectPhase {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Justification = 'Used by sub-function')]
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory=$true)]  
        [int]$ProjectID,
        [ValidateLength(1,100)]
        [Parameter(Mandatory=$true)]        
        [string] $description,
        [Hashtable] $board,
        [hashtable] $status,     
        [hashtable]$agreement,
        [hashtable] $opportunity,
        [hashtable] $parentPhase,
        [ValidateLength(0,50)]
        [string] $wbsCode,                
        [ValidateSet('Billable','DoNotBill','NoCharge','NoDefault')]        
        [string] $billTime,
        [ValidateSet('Billable','DoNotBill','NoCharge','NoDefault')]          
        [string] $billExpenses,
        [ValidateSet('Billable','DoNotBill','NoCharge','NoDefault')]        
        [string] $billProducts,
        [bool] $markAsMilestoneFlag,
        [string] $notes,
        [string] $deadlineDate,
        [bool] $billSeparatelyFlag,
        [ValidateSet('ActualRates','FixedFee','NotToExceed','OverrideRate')]
        [string] $billingMethod, #reuired if $billSeparatelyFlag is $true
        [decimal] $scheduledHours,
        [string] $scheduledEnd,
        [string] $scheduledStart,        
        [string] $actualStart,
        [string] $actualEnd,        
        [int] $actualHours,
        [decimal] $budgetHours,
        [int] $locationId,
        [int] $businessUnitId,
        [decimal] $hourlyRate,
        [string] $billingStartDate,
        [bool] $billPhaseClosedFlag,
        [bool] $billProjectClosedFlag,
        [decimal] $downpayment,
        [ValidateLength(0,25)]
        [string] $poNumber,   
        [decimal] $poAmount,
        [decimal] $estimatedTimeCost,
        [decimal] $estimatedExpenseCost,
        [decimal] $estimatedProductCost,
        [decimal] $estimatedTimeRevenue,
        [decimal] $estimatedExpenseRevenue,
        [decimal] $estimatedProductRevenue,
        [hashtable] $currency,
        [HashTable] $billToCompany,
        [Hashtable] $billToContact,
        [Hashtable] $billToSite,
        [hashtable] $shipToCompany,
        [hashtable] $shipToContact,
        [hashtable] $shipToSite,
        [hashtable] $customFields,
        [hashtable] $_info  
    )

    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/project/projects/$projectID/phases"
    return Invoke-CWMNewMaster -Arguments $PsBoundParameters -URI $URI
}
