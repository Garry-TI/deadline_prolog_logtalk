# run.ps1 — Launch Deadline (Logtalk/SWI-Prolog refactoring)
#
# Usage: .\run.ps1
#
# Loads the Logtalk integration for SWI-Prolog, then loads the game
# and starts it automatically.

$ErrorActionPreference = "Stop"

$swilgtScript = "D:\Program Files (x86)\Logtalk\integration\swilgt.ps1"

if (-not (Test-Path $swilgtScript)) {
    Write-Error "Logtalk integration script not found at: $swilgtScript"
    exit 1
}

# Change to the project root directory
Push-Location $PSScriptRoot

try {
    # Launch SWI-Prolog with Logtalk, load the game, and start it
    & "D:\Program Files\swipl\bin\swipl.exe" `
        -g "consult('D:/Program Files (x86)/Logtalk/integration/logtalk_swi.pl')" `
        -g "logtalk_load('src/loader')" `
        -g "go"
} finally {
    Pop-Location
}
