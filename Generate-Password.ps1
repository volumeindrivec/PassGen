<#
.SYNOPSIS
    Password generation function.
.DESCRIPTION
    Generates passwords based on the specified parameters. If specifying MaxCharacters, 6 is the minimum.
.PARAMETER Special
    Uses all special characters in the ASCII decimal character set starting from 33 and going to 126.
.PARAMETER LimitedSpecial
    Uses a limited set of special characters. Specifically avoids quote characters and other known to cause problems in passwords.
.PARAMETER NoSpecial
    Uses no special characters at all, only letters and numbers.
.PARAMETER MaxCharacters
    Max number of characters in the password. Minimum is 6.
.EXAMPLE
    Generate-Password -LimitedSpecial -MaxCharacters 12
    Generates a password with a limited special character set that is 12 characters in length.
.NOTES
    Version             :  0.1
    Author              :  @jadedtreebeard
    Disclaimer          :  If you run it, you take all responsibility for it.
    Notes               :  ASCII table - http://www.asciitable.com/
#>
Function Generate-Password{
    [cmdletbinding()]

    param(
        [Parameter(ParameterSetName='p1',Position=0)] [switch]$Special,
        [Parameter(ParameterSetName='p2',Position=0)] [switch]$LimitedSpecial,
        [Parameter(ParameterSetName='p3',Position=0)] [switch]$NoSpecial,
        [int]$MaxCharacters = 16
    )

    $SpecialCharacters = (33..47) + (58..64) + (91..96) + (123..126)

    # Sanity check.  Minimum 6 characters for password.
    if ($MaxCharacters -lt 6){
        Write-Error 'Sanity check:  Minimum of 6 characters in a password.' -ErrorAction Stop
    }


    if ($Special){
        $ContainsSpecial = $false

        while (-not $ContainsSpecial){
                    $Password = ((33..126) | ForEach-Object { [char]$_ } | Get-Random -Count $MaxCharacters) -Join ''

            $Array = $Password.GetEnumerator()

            foreach ($char in $Array) {    
                if ($SpecialCharacters -contains [int][char]$char){
                    $ContainsSpecial = $true
                }
            }
        }
            }
    elseif ($LimitedSpecial){
        $ContainsSpecial = $false

        while (-not $ContainsSpecial){
            $Password = ([array](33) + (35..38) + (45..57) + (64..90) + (97..122) | ForEach-Object { [char]$_ } | Get-Random -Count $MaxCharacters) -Join ''
            $Array = $Password.GetEnumerator()

            foreach ($char in $Array) {    
                if ($SpecialCharacters -contains [int][char]$char){
                    $ContainsSpecial = $true
                }
            }
        }
    }
    elseif ($NoSpecial){
        $Password = ((48..57) + (65..90) + (97..122) | ForEach-Object { [char]$_ } | Get-Random -Count $MaxCharacters) -Join ''
    }
    else{
        Write-Error 'Should not see this.  Major error if you do.' -ErrorAction Stop
    }

    $Properties = @{
        'Password' = $Password
    }

    $Object = New-Object -TypeName PSObject -Property $Properties
    Write-Output $Object

}