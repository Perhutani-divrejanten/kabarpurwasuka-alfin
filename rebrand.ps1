# Rebrand script for Kabar Purwasuka
# This script performs the rebranding from "Kabar Purwasuka" to "Kabar Purwasuka"

# Function to fix encoding issues
function Fix-Encoding {
    param([string]$content)
    $content = $content -replace '"', '"'
    $content = $content -replace '"', '"'
    $content = $content -replace "'", "'"
    $content = $content -replace "'", "'"
    $content = $content -replace '-', '-'
    $content = $content -replace '-', '-'
    $content = $content -replace ([char]0xFFFD), ' '  # U+FFFD
    $content = $content -replace ' ', ' '
    return $content
}

# Function to replace branding
function Replace-Branding {
    param([string]$content)
    # Replace names
    $content = $content -replace 'Kabar Purwasuka', 'Kabar Purwasuka'
    $content = $content -replace 'KabarPurwasuka', 'KabarPurwasuka'
    $content = $content -replace 'KabarPurwasuka', 'KabarPurwasuka'
    # Email
    $content = $content -replace 'KabarPurwasuka@gmail\.com', 'kabarpurwasuka@gmail.com'
    # Social handles
    $content = $content -replace 'twitter\.com/KabarPurwasuka', 'twitter.com/kabarpurwasuka'
    $content = $content -replace 'facebook\.com/KabarPurwasuka', 'facebook.com/kabarpurwasuka'
    $content = $content -replace 'linkedin\.com/company/KabarPurwasuka', 'linkedin.com/company/kabarpurwasuka'
    $content = $content -replace 'instagram\.com/KabarPurwasuka', 'instagram.com/kabarpurwasuka'
    $content = $content -replace 'youtube\.com/@KabarPurwasuka', 'youtube.com/@kabarpurwasuka'
    # Title suffix
    $content = $content -replace ' - Kabar Purwasuka', ' - Kabar Purwasuka'
    return $content
}

# Function to replace logo
function Replace-Logo {
    param([string]$content)
    # Replace img logo with text logo
    $logoText = '<a class="navbar-brand" href="../index.html"><span style="font-weight: bold; color: #0EA5E9;">Kabar</span><span style="color: #22C55E;">Purwasuka</span></a>'
    $content = $content -replace '<img[^>]*src="[^"]*logo\.png"[^>]*>', $logoText
    $content = $content -replace '<img[^>]*src="\.\./img/logo\.png"[^>]*>', $logoText
    # Replace text logo
    $content = $content -replace '<span style="font-weight: bold; color: #[0-9A-Fa-f]{6}; font-size: 24px; letter-spacing: -0.5px;">ARAH<span style="color: #[0-9A-Fa-f]{6}; font-weight: normal; font-size: 18px; margin-left: 2px;">BERITA</span></span>', '<span style="font-weight: bold; color: #0EA5E9; font-size: 24px; letter-spacing: -0.5px;">Kabar<span style="color: #22C55E; font-weight: normal; font-size: 18px; margin-left: 2px;">Purwasuka</span></span>'
    return $content
}

# Process all text files
Get-ChildItem -Recurse -Include *.html,*.css,*.md,*.json,*.ps1,*.yml,*.toml | ForEach-Object {
    $filePath = $_.FullName
    Write-Host "Processing $filePath"
    $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    $content = Fix-Encoding $content
    $content = Replace-Branding $content
    if ($filePath -like "*.html") {
        $content = Replace-Logo $content
    }
    [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
}

# Update package.json specifically
$packagePath = "package.json"
if (Test-Path $packagePath) {
    $content = Get-Content $packagePath -Raw | ConvertFrom-Json
    $content.name = "KabarPurwasuka"
    $content | ConvertTo-Json -Depth 10 | Set-Content $packagePath -Encoding UTF8
}

$toolsPackagePath = "tools/package.json"
if (Test-Path $toolsPackagePath) {
    $content = Get-Content $toolsPackagePath -Raw | ConvertFrom-Json
    $content.name = "KabarPurwasuka-article-generator"
    $content.description = $content.description -replace 'Kabar Purwasuka', 'Kabar Purwasuka'
    $content.author = $content.author -replace 'Kabar Purwasuka', 'Kabar Purwasuka'
    $content | ConvertTo-Json -Depth 10 | Set-Content $toolsPackagePath -Encoding UTF8
}

# Update docs
$docs = @("AUTOMATION_README.md", "GOOGLE_DRIVE_GUIDE.md", "netlify.toml")
foreach ($doc in $docs) {
    if (Test-Path $doc) {
        $content = [System.IO.File]::ReadAllText($doc, [System.Text.Encoding]::UTF8)
        $content = $content -replace 'Kabar Purwasuka', 'Kabar Purwasuka'
        $content = $content -replace 'KabarPurwasuka', 'KabarPurwasuka'
        $content = $content -replace 'KabarPurwasuka', 'KabarPurwasuka'
        [System.IO.File]::WriteAllText($doc, $content, [System.Text.Encoding]::UTF8)
    }
}

# Update workflow
$workflowPath = ".github/workflows/deploycPanel.yml"
if (Test-Path $workflowPath) {
    $content = [System.IO.File]::ReadAllText($workflowPath, [System.Text.Encoding]::UTF8)
    $content = $content -replace '/KabarPurwasuka\.wartajanten\.my\.id/', '/KabarPurwasuka.wartajanten.my.id/'
    [System.IO.File]::WriteAllText($workflowPath, $content, [System.Text.Encoding]::UTF8)
}

Write-Host "Rebrand completed."