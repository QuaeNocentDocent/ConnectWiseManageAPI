function Invoke-CWMWebRequest {
    [CmdletBinding()]
    param(
        $Arguments,
        [int]$MaxRetry = 5
    )

    # Check that we have cached connection info
    if(!$script:CWMServerConnection){
        $ErrorMessage = @()
        $ErrorMessage += "Not connected to a Manage server."
        $ErrorMessage += '--> $CWMServerConnection variable not found.'
        $ErrorMessage += "----> Run 'Connect-CWM' to initialize the connection before issuing other CWM cmdlets."
        throw ($ErrorMessage)
    }

    # Add default set of arguments
    foreach($Key in $script:CWMServerConnection.Headers.Keys){
        if($Arguments.Headers.Keys -notcontains $Key){
            # Set version
            if ($Key -eq 'Accept' -and $Arguments.Version -and $Arguments.Version -ne $script:CWMServerConnection.Version) {
                $Arguments.Headers.Accept = "application/vnd.connectwise.com+json; version=$($Arguments.Version)"
                Write-Verbose "Version Passed: $($Arguments.Version)"
            } else {
                $Arguments.Headers += @{$Key = $script:CWMServerConnection.Headers.$Key}
            }
        }
    }
    $Arguments.Remove('Version')

    if(!$Arguments.SessionVariable){ $Arguments.WebSession = $script:CWMServerConnection.Session }

    # Check URI format
    if($Arguments.URI -notlike '*`?*' -and $Arguments.URI -like '*`&*') {
        $Arguments.URI = $Arguments.URI -replace '(.*?)&(.*)', '$1?$2'
    }

    Write-Debug "Arguments: $($Arguments | ConvertTo-Json)"
    $httpCodes2Retry=@(408,409,421,423,425,429)
    #https://docs.microsoft.com/en-us/dotnet/api/system.net.sockets.socketerror?view=net-5.0
    $socketCodes2Retry=@(10061,10053,10054,10064,10004,10050,10052,10091,10060,11002)
    # Issue request
    $retry=0    
    do {
        try {
            $requestError=$false
            $socketErrorCode = 0             
            $Result = Invoke-WebRequest @Arguments -UseBasicParsing
        }
        catch {
            $requestError=$true
            $ErrorMessage=''
            if($_.Exception.Response){
                try {
                    # Read exception response
                    #this can fail with some type of exceptions
                    $ErrorStream = $_.Exception.Response.GetResponseStream()
                    $Reader = New-Object System.IO.StreamReader($ErrorStream)
                    $ErrBody = $Reader.ReadToEnd() | ConvertFrom-Json
                }
                catch {
                    $ErrBody = $_.Exception.Response.Content + "" + $_.ErrorDetails.Message
                }
                if($ErrBody.code){
                    $ErrorMessage += "An exception has been thrown."
                    $ErrorMessage += "`n--> $($ErrBody.code)"
                    if($ErrBody.code -eq 'Unauthorized'){
                        $ErrorMessage += "`n-----> $($ErrBody.message)"
                        $ErrorMessage += "`n-----> Use 'Disconnect-CWM' or 'Connect-CWM -Force' to set new authentication."
                    }
                    else {
                        $ErrorMessage += "`n-----> $($ErrBody.code): $($ErrBody.message)"
                        $ErrorMessage += "`n-----> ^ Error has not been documented please report. ^"
                    }
                } elseif ($_.Exception.message) {
                    $ErrorMessage += "An exception has been thrown."
                    $ErrorMessage += "`n--> $($_.Exception.message)"
                }
            }

            if ($_.ErrorDetails) {
                $ErrorMessage += "`nAn error has been thrown."
                $ErrDetails = $_.ErrorDetails
                $ErrorMessage += "`n--> $($ErrDetails.code)"
                $ErrorMessage += "`n--> $($ErrDetails.message)"
                if($ErrDetails.errors.message){
                    $ErrorMessage += "-----> $($ErrDetails.errors.message)"
                }
            }
            if($_.Exception.InnerException.Source -ieq 'System.Net.Sockets') {
                $socketErrorCode = $_.Exception.InnerException.ErrorCode
            }
            if ([String]::IsNullOrEmpty($ErrorMessage)){ $ErrorMessage = $_ }
            else { $ErrorMessage += "`n"; $ErrorMessage += $_.ScriptStackTrace }
        }
        #let's check if we must report an error or a warning. If $result is $null $mustRetry is always false        
        $mustRetry = ($Result.StatusCode -ge 500 -or $Result.StatusCode -in $httpCodes2Retry -or $socketErrorCode -in $socketCodes2Retry)
        if($requestError -and $mustRetry) {Write-Warning $ErrorMessage}       
        if($mustRetry) {
            $Retry++
            # ConnectWise Manage recommended wait time
            $Wait = $([math]::pow( 2, $Retry))*10
            Write-Warning "Issue with request, status: $($Result.StatusCode) $($Result.StatusDescription)"
            Write-Warning "$($Retry)/$($MaxRetry) retries, waiting $($Wait)ms."
            Start-Sleep -Milliseconds $Wait 
        }       
    } while ($Retry -lt $MaxRetry -and $mustRetry)

    if ($mustRetry -or $requestError) {
        $ErrorMessage = ($Arguments | Out-String) + "`n" + $ErrorMessage
        write-error $ErrorMessage
        throw $ErrorMessage
    }

    # Save current version
    if (!$script:CWMServerConnection.'api-current-version') {
        $script:CWMServerConnection.'api-current-version' = $Result.Headers.'api-current-version'
    }

    return $Result
}