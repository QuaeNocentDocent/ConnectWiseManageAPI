function Invoke-CWMGenericCommand {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [string]$command
    )
    # Skip common parameters

    $URI = "https://$($script:CWMServerConnection.Server)/v4_6_release/apis/3.0/$command"
    $ContentType = 'application/json; charset=utf-8'

    $WebRequestArguments = @{
        Uri = $URI
        Method = 'Post'
        ContentType = $ContentType
        Version = $Arguments.Version
    }
    if ($PSCmdlet.ShouldProcess($WebRequestArguments.URI, "Post-CWMGenericCommand:`r`n$command`r`n")) {
        $Result = Invoke-CWMWebRequest -Arguments $WebRequestArguments
        if($Result.content){
            $Result = $Result.content | ConvertFrom-Json
        }
    }
    return $Result
}