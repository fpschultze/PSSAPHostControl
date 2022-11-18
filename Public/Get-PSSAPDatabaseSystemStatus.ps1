<#
.SYNOPSIS
    Get the status of the database system specified.

.DESCRIPTION
    Get the status of the database system specified in parameters.
    The database system must be specified by the mandatory params DBName and DBType.
    Optional properties are DBInstanceName, DBCredential (DB administration user), and DBHost.
    On success <response>.mStatus contains the overall status of the database system.
    <response>.mInstances contains all DatabaseSystemInstance(s).
    <DatabaseSystemInstance>.mStatus contains the instance status.
    <DatabaseSystemInstance>.mInstance contains properties that specify the instance.
    The <DatabaseSystemInstance>.mComponents contains the instance components. These components depend on the database type. Refer to Get-PSSAPDatabaseStatus for a general description of components.
    <result>.mSharedComponents contains the components shared between all instances (if available). Shared components depened on the database type.
    <result>.mReplicatedSystems contains the information about the replicated systems (if available).
    If the IncludeProperties switch is provided <result>.mProperties contains the properties of the database system and <result>.mInstances[].mProperties contains the properties of the database system instances

.NOTES
    OverloadDefinitions
    -------------------
    void GetDatabaseSystemStatusAsync(<Namespace>.Property[] aArguments)
#>
function Get-PSSAPDatabaseSystemStatus {

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

        [switch]
        $IncludeProperties
    )

    Write-EnteringInfo -Invocation $MyInvocation -BoundParameters $PSBoundParameters


    $SourceIdentifier = 'GetDatabaseSystemStatusCompleted'


    $ErrorActionPreference = 'Stop'

    try {

        # Subscribe to web service response event

        $SapHostControlConnection | Initialize-SapHostControlEvent -SourceIdentifier $SourceIdentifier


        # Call WebMethod

#        [PSSAPHostControl.Property[]]$aArguments = $PSBoundParameters | ConvertTo-ArrayOfDBProperty
        $aArguments = $PSBoundParameters | ConvertTo-ArrayOfDBProperty

        $SapHostControlConnection.GetDatabaseSystemStatusAsync($aArguments)


        # Wait for web service response

        $Event = Wait-SapHostControlEvent -SourceIdentifier $SourceIdentifier

        if ($Event -isnot [bool]) {

            $returnValue = $Event.Result #| ConvertFrom-...
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
