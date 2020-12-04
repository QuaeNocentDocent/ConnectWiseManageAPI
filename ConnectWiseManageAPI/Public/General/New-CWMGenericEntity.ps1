function New-CWMGenericEntity {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Arguments,
        [string]$endpoint,
        [string[]]$Skip
    )
    # Skip common parameters
    $Skip += 'Debug','ErrorAction','ErrorVariable','InformationAction','InformationVariable','OutVariable','OutBuffer','PipelineVariable','Verbose','WarningAction','WarningVariable','WhatIf','Confirm','Version','VersionAutomatic'
    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/$endpoint"
    if ($Arguments.Body) {
        $Body = $Arguments.Body
    } else {
        $Body = @{}
        foreach($i in $Arguments.GetEnumerator()){
            if($Skip -notcontains $i.Key){
                $Body.Add($i.Key, $i.value)
            }
        }
        $Body = ConvertTo-Json $Body -Depth 100
    }
    Write-Verbose $Body

    $ContentType = 'application/json; charset=utf-8'
    if ($Arguments.ContentType) {
        $ContentType = $Arguments.ContentType
    }

    $WebRequestArguments = @{
        Uri = $URI
        Method = 'Post'
        ContentType = $ContentType
        Body = $Body
        Version = $Arguments.Version
    }
    if ($PSCmdlet.ShouldProcess($WebRequestArguments.URI, "New-CWMGenericEntity, with body:`r`n$Body`r`n")) {
        $Result = Invoke-CWMWebRequest -Arguments $WebRequestArguments
        if($Result.content){
            $Result = $Result.content | ConvertFrom-Json
        }
    }
    return $Result
}
