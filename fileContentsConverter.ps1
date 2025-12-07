# Name: Matthew Gunnell

# This program can be used to convert strings of text into
# binary, octal, or hexadecimal. Either keyboard entered text or file names
# can be entered for this program.


# Defines the function runScript.
# This function is used to run the 
# program in the intended order.
# Parameters: None
# Returns: None
Function runScript {

    # Displays a description of the program.
    displayDescription
    
    
    # Sets the default input and output type.
    $inputFormNumber = 1
    $inputForm = "String"

    $outputFormNumber = 1
    $outputForm = "Binary"

    $repeat = $true

    # Repeat the program until the user wishes to stop.
    while ( $repeat -eq $true ) {

        # Displays the menu to the user.
        displayMenu $inputForm $outputForm

        # Gets the menu choice from the user.
        [int] $menuChoice = getValidInteger 4 1 "Menu Number"

        write-host ""

        # Change input type.
        if ( $menuChoice -eq 1 ) {

            write-host "Please Enter the Input Type"
            write-host "1.) String"
            write-host "2.) File`n"

            $inputFormNumber = getValidInteger 2 1 "Input Type"
            $inputForm = getInputForm $inputFormNumber

        }
        # Change output type.
        elseif ( $menuChoice -eq 2 ) {

            write-host "Please Enter the Output Type"
            write-host "1.) Binary"
            write-host "2.) Octal"
            write-host "3.) Hexadecimal`n"

            $outputFormNumber = getValidInteger 3 1 "Output Type"  
            $outputForm = getOutputForm $outputFormNumber

        }
        # Enter string or file name.
        elseif ( $menuChoice -eq 3 ) {

            # Gets the data unformatted.
            $data = getDataToConvert $inputFormNumber
            # Formats the data.
            $convertedData = convertData $outputFormNumber $data

            # Prints out the data.
            write-host "`nInputted ${inputForm} converted to ${outputForm}:`n"
            write-host $convertedData

        }
        # Exit program.
        else {
            write-host "Goodbye! Thank you, for using my program.`n"
            $repeat = $false
        }

        write-host ""

    }

}



# Defines the function getDataToConvert.
# Gets the string that the user wants to convert
# originating from either a string or a file.
# Parameter: inputType - The input type.
# Returns: enteredData - The string the user enters.
Function getDataToConvert {

    param ( $inputType )

    $valid = $false

    $enteredData = ""

    if ( $inputType -eq 1 ) {
        $enteredData = read-host -Prompt "Please enter the string you wish to convert"
        $enteredData = [system.Text.Encoding]::Default.GetBytes( $enteredData ) 

    }
    else {
        do {
            try {
                $fileName = read-host -Prompt "Please enter the file path for the file you wish to convert"
            
                $enteredData = [System.IO.File]::ReadAllBytes( $fileName )

                $valid = $true
            }
            catch {
                write-host "Error: Please check the file path and try again.`n"
            } 
        } while ( $valid -eq $false )

    }

    return $enteredData

}



# Defines the function convertData.
# Converts the data to the correct type.
# Parameter: outputType - The output type.
# Parameter: dataToConvert - The entered string to convert.
# Return: string - The data that has been converted.
Function convertData {

    param ( $outputType, $dataToConvert )

    # Convert to Binary.
    if ( $outputType -eq 1 ) {
        return convertToSpecifiedType $dataToConvert 2 8
    }
    # Convert to Octal.
    elseif ( $outputType -eq 2 ) {
        return convertToSpecifiedType $dataToConvert 8 3
    }
    # Convert to Hexadecimal.
    else {
        return convertToSpecifiedType $dataToConvert 16 2
    }

}



# Defines the function convertToSpecifiedType.
# Converts a string to the specified type.
# Parameter: dataString - The string to be converted.
# Parameter: base - The base of the number system.
# Parameter: extraPadding - The extra padding to be used. 
# Returns: binaryString - The new string.
Function convertToSpecifiedType {

    param( $dataString, $base, $extraPadding )

    $newDataString = ""

    foreach ($byte in $dataString) {
        $byte = [Convert]::ToString( $byte, $base ).PadLeft( $extraPadding, '0' )
        $newDataString = $newDataString + $byte + " "
    }

    return $newDataString

}



# Defines the function displayDescription.
# This function is user to display a description
# of the program to the user.
# Parameters: None
# Returns: None
Function displayDescription {
    write-host "`nWelcome to my text to binary converter.`n"
    write-host "This program can be used to convert strings of text to binary, octal, and hexadecimal." 
    write-host "It can also be used to convert a file into a string of binary to see what it looks like."
    write-host "It is recommended that this program is not used for very large files.`n"
}



# Defines the function displayMenu.
# Displays a menu with the available features of
# the program.
# Parameter: inputType - The current input type.
# Parameter: outputType - The current output type.
# Returns: None
Function displayMenu {

    param($inputType, $outputType)

    write-host "What would you like to do?"
    write-host "1.) Change Input Type.   Current - ${inputType}"
    write-host "2.) Change Output Type.  Current - ${outputType}"
    write-host "3.) Enter a ${inputType} in Order to Convert to ${outputType}."
    write-host "4.) Exit Program`n"

}



# Defines the function getValidInteger.
# Used to get valid integers from users.
# Parameter: UPPER_BOUNDS - The upper bounds.
# Parameter: LOWER_BOUNDS - The lower bounds.
# Parameter: purpose - The reason for the input.
# Returns: number - The integer the user enters.
Function getValidInteger {

    param( $UPPER_BOUNDS, $LOWER_BOUNDS, $purpose )

    $isValid = $false

    do {
        try {
            [Int]$number = read-host -Prompt "Please enter" 
            
            if ( $number -gt $UPPER_BOUNDS -or $number -lt $LOWER_BOUNDS  ) {
                write-host "Error: Please enter a valid ${purpose}."
                write-host "${purpose} must be from ${LOWER_BOUNDS} through ${UPPER_BOUNDS}.`n"
            }
            else {
                $isValid = $true
            }
        }
        catch {
            write-host "Error: Please enter a valid ${purpose}."
            write-host "${purpose} must be from ${LOWER_BOUNDS} through ${UPPER_BOUNDS}.`n"
        }

    } until ( $isValid -eq $true )

    return $number
    
}



# Defines the function getInputForm.
# Determines what the input should be
# based off the number the user enters.
# Parameter: inputNumber - The input number.
# Returns: string - A string representing the input type.
Function getInputForm {

    param( $inputNumber )

    if ( $inputNumber -eq 1 ) {
        return "String"
    }
    else {
        return "File"
    }

}



# Defines the function getOutputForm.
# Determines what the output should be
# based off the number the user enters.
# Parameter: outputNumber - The output number.
# Returns: string - A string representing the output type.
Function getOutputForm {

    param( $outputNumber )

    if ( $outputNumber -eq 1 ) {
        return "Binary"
    }
    elseif ( $outputNumber -eq 2 ) {
        return "Octal"
    }
    else {
        return "Hexadecimal"
    }

}



# Runs the program.
runScript