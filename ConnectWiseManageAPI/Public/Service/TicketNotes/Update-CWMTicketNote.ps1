function Update-CWMTicketNote {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [int]$TicketID,        
        [Parameter(Mandatory=$true)]
        [int]$TicketNoteID,
        [Parameter(Mandatory=$true)]
        [validateset('add','replace','remove')]
        [string]$Operation,
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        $Value       
    )
    $URI = "https://$($CWMServerConnection.Server)/v4_6_release/apis/3.0/service/tickets/$TicketID/notes/$TicketNoteID"
    return Invoke-CWMPatchMaster -Arguments $PsBoundParameters -URI $URI
}