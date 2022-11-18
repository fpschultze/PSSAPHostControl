<#
.SYNOPSIS
    Start the database specified.

.DESCRIPTION
    Start the database specified in the parameters.
    If the network service (e.g. the xserver process in case of MaxDB) should also be started use the Service switch.
    In case a pre-operation and/or post-operation hook command is to be executed use the PreHook and PostHook switch respectively.
    To specify an operation timeout set TimeoutSec.
    The operation will wait until the specified value is expired, and return the operationID.
    If the timeout value is 0 (default) the operation will be executed asynchronously.
    If the timeout value is -1 the operation will be executed synchronously.

.NOTES
    Commandline tool
    ----------------
    StartDatabase
    -dbname <DB name> -dbtype <ada|db6|mss...> [-dbhost <hostname>] [-dbinstance <instance name>] [-dbuser <DB admin username>] [-dbpass <DB admin password>] [-timeout <timeout in sec>] [-service] [-instance] [-force]

    OverloadDefinitions
    -------------------
    void StartDatabaseAsync(<Namespace>.Property[] aArguments, <Namespace>.OperationOptions aOptions)
#>
function Start-PSSAPDatabase {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Web.Services.Protocols.SoapHttpClientProtocol]
        $SapHostControlConnection,

        # Database name
        [Parameter(Mandatory = $true)]
        [string]
        $DBName,

        # Database type
        [Parameter(Mandatory = $true)]
        [ValidateSet('ada', 'syb', 'db6', 'mss', 'ora', 'hdb')]
        [string]
        $DBType,

        # Database instance name
        [Parameter()]
        [string]
        $DBInstanceName,

        # Database host
        [Parameter()]
        [string]
        $DBHost,

        # DB administration credential (mandatory for ada, sap, and db6 on Windows)
        [Parameter()]
        [pscredential]
        $DBCredential,

        # Timeout in sec
        [Parameter()]
        [long]
        $TimeoutSec,

        # If the network service should also be started 
        [switch]
        $Service,

        # In case a pre-operation hook command is to be executed 
        [switch]
        $PreHook,

        # In case a post-operation hook command is to be executed 
        [switch]
        $PostHook,

        [switch]
        $Instance,

        [switch]
        $Force
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $SourceIdentifier = 'StartDatabaseCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapHostControlConnection | Initialize-SapHostControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod


        $aArguments = $PSBoundParameters | ConvertTo-ArrayOfDBProperty

#        $aOptions = [PSSAPHostControl.OperationOptions]::new()
        $aOptions = New-Object -TypeName "${PSSAPHostControlNamespace}.OperationOptions"
        $mOptions = @()

        switch ($PSBoundParameters.Keys) {

            'TimeoutSec' {

                $aOptions.mTimeout = $TimeoutSec
            }

            'Service' {

#                $mOptions += [PSSAPHostControl.InstanceOptionsFlags]::OSERVICE
                $mOptions += $PSSAPHostControlInstanceOptionsFlags::OSERVICE
            }

            'PreHook' {

#                $mOptions += [PSSAPHostControl.InstanceOptionsFlags]::OPREHOOK
                $mOptions += $PSSAPHostControlInstanceOptionsFlags::OPREHOOK
            }

            'PostHook' {

#                $mOptions += [PSSAPHostControl.InstanceOptionsFlags]::OPOSTHOOK
                $mOptions += $PSSAPHostControlInstanceOptionsFlags::OPOSTHOOK
            }

            'Instance' {

#                $mOptions += [PSSAPHostControl.InstanceOptionsFlags]::OINSTANCE
                $mOptions += $PSSAPHostControlInstanceOptionsFlags::OINSTANCE
            }

            'Force' {

#                $mOptions += [PSSAPHostControl.InstanceOptionsFlags]::OFORCE
                $mOptions += $PSSAPHostControlInstanceOptionsFlags::OFORCE
            }
        }

        $aOptions.mOptions = $mOptions

        $SapHostControlConnection.StartDatabaseAsync($aArguments, $aOptions)


        # Wait for web service response

        $Event = Wait-SapHostControlEvent -SourceIdentifier $SourceIdentifier

        if ($Event -isnot [bool]) {

            $returnValue = $Event.Result | ConvertFrom-OperationResult
        }
        else {

            $returnValue = $Event
        }
    }
    catch {

        Write-Error $_

        $returnValue = $null
    }
    finally {

        Write-LeavingInfo -Invocation $MyInvocation -Result $returnValue

        Write-Output $returnValue
    }
}
