<#
.SYNOPSIS
    Password generation function.
.DESCRIPTION
    Generates passwords based on the specified parameters. If specifying MaxCharacters, 6 is the minimum.
.PARAMETER CharacterSet
    Specifies the character set to be used. Valid options are Special, LimitedSpecial, NoSpecial.
    Special has a full set of special characters. LimitedSpecial uses a subset of the full special
    (characters not likely to cause problems with older password inputs), and NoSpecial, for cases
    when special characters are bad.
.PARAMETER MaxCharacters
    Max number of characters in the password. Minimum is 6. Default is 16 characters.
.EXAMPLE
    Generate-Password -LimitedSpecial -MaxCharacters 12
    Generates a password with a limited special character set that is 12 characters in length.
.NOTES
    Version             :  0.1
    Author              :  @jadedtreebeard
    Disclaimer          :  If you run it, you take all responsibility for it.
    Notes               :  ASCII table - http://www.asciitable.com/
#>
Function Get-NewPassword{
    [cmdletbinding()]

    param(
        [Parameter()][ValidateSet('Special','LimitedSpecial','NoSpecial')][String]$CharacterSet = 'Special',
        [int]$MaxCharacters = 16
    )

    $SpecialCharacters = (33..47) + (58..64) + (91..96) + (123..126)

    # Sanity check.  Minimum 6 characters for password.
    if ($MaxCharacters -lt 6){
        Write-Error 'Sanity check:  Minimum of 6 characters in a password.' -ErrorAction Stop
    }


    if ($CharacterSet -like 'Special'){
        Write-Verbose 'Using Special character set.'
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
    elseif ($CharacterSet -like 'LimitedSpecial'){
        Write-Verbose 'Using LimitedSpecial character set'
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
    elseif ($CharacterSet -like 'NoSpecial'){
        Write-Verbose 'Using NoSpecial character set'
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