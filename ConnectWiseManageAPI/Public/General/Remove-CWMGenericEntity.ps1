function Remove-CWMGenericEntity {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string]$endpoint
    )
    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/$endpoint"
    $WebRequestArguments = @{
        Uri = $URI
        Method = 'Delete'
    }
    if ($PSCmdlet.ShouldProcess($WebRequestArguments.URI, "Remove-CWMGenericEntity")) {
        $Result =  Invoke-CWMWebRequest -Arguments $WebRequestArguments
        if($Result.content){
            $Result = $Result.content | ConvertFrom-Json
        }
    }
    if ($Result.StatusCode -eq 204) {
        Write-Verbose 'Success'
        return
    }
    return $Result
}
