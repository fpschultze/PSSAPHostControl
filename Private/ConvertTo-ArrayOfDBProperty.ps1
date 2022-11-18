function ConvertTo-ArrayOfDBProperty
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $ParameterDictionary
    )

    Begin {

#        [PSSAPHostControl.Property[]]$aArguments = @()
        $aArguments = New-Object -TypeName "${PSSAPHostControlNamespace}.Property[]"0
    }

    Process {

        switch ($ParameterDictionary.Keys) {

            'DBName' {
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/Name'
                    mValue = $DBName
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/Name'
                $prop.mValue = $DBName
                $aArguments += $prop
            }

            'DBType' {
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/Type'
                    mValue = $DBType
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/Type'
                $prop.mValue = $DBType
                $aArguments += $prop
            }

            'DBInstanceName' {
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/InstanceName'
                    mValue = $DBInstanceName
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/InstanceName'
                $prop.mValue = $DBInstanceName
                $aArguments += $prop
            }

            'DBHost' {
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/Host'
                    mValue = $DBHost
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/Host'
                $prop.mValue = $DBHost
                $aArguments += $prop
            }

            'DBCredential' {
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/Username'
                    mValue = ('{0}\{1}' -f $DBCredential.GetNetworkCredential().Domain, $DBCredential.GetNetworkCredential().UserName).TrimStart('\')
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/Username'
                $prop.mValue = ('{0}\{1}' -f $DBCredential.GetNetworkCredential().Domain, $DBCredential.GetNetworkCredential().UserName).TrimStart('\')
#                $prop.mValue = $DBCredential.GetNetworkCredential().UserName
                $aArguments += $prop
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/Password'
                    mValue = $DBCredential.GetNetworkCredential().Password
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/Password'
                $prop.mValue = $DBCredential.GetNetworkCredential().Password
                $aArguments += $prop
            }

            'IncludeProperties' {
<#
                $aArguments += [PSSAPHostControl.Property]@{
                    mKey = 'Database/Properties'
                    mValue = 'true'
                }
#>
                $prop = New-Object -TypeName "${PSSAPHostControlNamespace}.Property"
                $prop.mKey = 'Database/Properties'
                $prop.mValue = 'true'
                $aArguments += $prop
            }
        }
    }

    End {

        Write-Output $aArguments
    }
}
