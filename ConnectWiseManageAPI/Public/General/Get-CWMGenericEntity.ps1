function Get-CWMGenericEntity {
    [CmdletBinding()]
    param (
        [string]$Condition,
        [ValidatePattern('\S* (desc|asc)')]
        [string]$orderBy,
        [string]$childConditions,
        [string]$customFieldConditions,
        [int]$page,
        [int]$pageSize,
        [string[]]$fields,
        [switch]$all,
        [Parameter(Mandatory=$true)]        
        [string]$endpoint
    )

    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/$endpoint"
    if ($Condition) {
        $Condition = [System.Web.HttpUtility]::UrlEncode($Condition)
        $URI += "&conditions=$Condition"
    }

    if($childConditions) {
        $childConditions = [System.Web.HttpUtility]::UrlEncode($childConditions)
        $URI += "&childConditions=$childConditions"
    }

    if($customFieldConditions) {
        $customFieldConditions = [System.Web.HttpUtility]::UrlEncode($customFieldConditions)
        $URI += "&customFieldConditions=$customFieldConditions"
    }

    if($Fields) {
        $fields = [System.Web.HttpUtility]::UrlEncode($($Fields -join ','))
        $URI += "&fields=$fields"
    }

    if($orderBy) {
        $orderBy = [System.Web.HttpUtility]::UrlEncode($orderBy)
        $URI += "&orderBy=$orderBy"
    }

    $WebRequestArguments = @{
        Uri = $URI
        Method = 'GET'
    }

    # Unauthenticated requests
    # $Unauthenticated = $false
    # if ($Arguments.Unauthenticated) { $Unauthenticated = $true }
    # $WebRequestArguments.Unauthenticated = $Unauthenticated

    if ($all) {
        $Result = Invoke-CWMAllResult -Arguments $WebRequestArguments
    }
    else {
        if($pageSize){
            $WebRequestArguments.URI += "&pageSize=$pageSize"}
        if($page){
            $WebRequestArguments.URI += "&page=$page"
        }
        $Result = Invoke-CWMWebRequest -Arguments $WebRequestArguments
        if($Result.content){
            try{
                $Result = $Result.content | ConvertFrom-Json
            }
            catch{
                Write-Error "There was an issue converting the results from JSON."
                $_
            }
        }
    }

    return $Result
}