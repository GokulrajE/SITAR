# SITAR touch-table setup for the IR frame / pegboard games.
#
# Stops Windows from hijacking multi-touch:
#   1. Three- and four-finger touch gestures  (these minimise / shrink the game)
#   2. Touch feedback circles  (the grey dots under every touch)
#   3. Edge swipes  (widgets / notification panels; needs Administrator)
#
# Run:   right-click -> Run with PowerShell   (or: powershell -ExecutionPolicy Bypass -File touch_kiosk_setup.ps1)
# Undo:  powershell -ExecutionPolicy Bypass -File touch_kiosk_setup.ps1 -Undo
# Then SIGN OUT or RESTART Windows so the changes take effect.

param([switch]$Undo)

$desk = "HKCU:\Control Panel\Desktop"
$curs = "HKCU:\Control Panel\Cursors"

# 1. Three/four-finger gestures: 0 = off, 1 = on
Set-ItemProperty -Path $desk -Name TouchGestureSetting -Value ([int]$Undo) -Type DWord

# 2. Touch feedback circles: 0 = off  (Windows defaults: 1 and 0x1F)
Set-ItemProperty -Path $curs -Name ContactVisualization -Value ($(if ($Undo) {1} else {0})) -Type DWord
Set-ItemProperty -Path $curs -Name GestureVisualization -Value ($(if ($Undo) {31} else {0})) -Type DWord

# 3. Edge swipes (machine-wide policy, needs admin)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
$edge = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EdgeUI"
if ($isAdmin) {
    if ($Undo) {
        Remove-ItemProperty -Path $edge -Name AllowEdgeSwipe -ErrorAction SilentlyContinue
    } else {
        New-Item -Path $edge -Force | Out-Null
        Set-ItemProperty -Path $edge -Name AllowEdgeSwipe -Value 0 -Type DWord
    }
    Write-Host "Edge swipes: $(if ($Undo) {'restored'} else {'disabled'})"
} else {
    Write-Host "Edge swipes: skipped (run as Administrator to change this one)"
}

Write-Host "Touch gestures and feedback: $(if ($Undo) {'restored to Windows defaults'} else {'disabled'})"
Write-Host "Now SIGN OUT or RESTART Windows."
