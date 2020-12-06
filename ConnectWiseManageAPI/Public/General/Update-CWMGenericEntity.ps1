function Update-CWMGenericEntity {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [hashtable[]] $operations,
        [string]$endpoint
    )

    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/$endpoint"
#check parameters consistency and if not just throw an exception to help filling the correct parameters
    try {
        $reference=@('op','path','value')
        foreach($op in $operations) {
            $check = compare-object -ReferenceObject $reference -DifferenceObject ([array]$op.keys)
            if($check) {
                throw 'Operations parameter error. It must be an array of hashtables with the following keys op, path and value'
            }        
        }
    }
    catch {
        throw 'Operations parameter error'
    }

    $Body = ConvertTo-Json $operations -Depth 5

    $WebRequestArguments = @{
        Uri = $URI
        Method = 'Patch'
        ContentType = 'application/json; charset=utf-8'
        Body = $Body
    }
    Write-Verbose ('Update-CWMGenericEntity: {0}' -f ($WebRequestArguments | convertto-json)) -Verbose 
    if ($PSCmdlet.ShouldProcess($WebRequestArguments.URI, "Update-CWMGenericEntity, with body:`r`n$Body`r`n")) {
        $Result = Invoke-CWMWebRequest -Arguments $WebRequestArguments
        if($Result.content){
            $Result = $Result.content | ConvertFrom-Json
        }
    }
    return $Result
}
