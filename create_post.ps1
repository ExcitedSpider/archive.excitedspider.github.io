
param(
    [parameter(Mandatory=$true)]
    [string]$title,
    [parameter(Mandatory=$true)]
    [string]$tag
)

$dateinfo=Get-Date
$date = "{0}-{1}-{2}" -f($dateinfo.Year,$dateinfo.Month, $dateinfo.Day)
$postname="{0}-{1}" -f ($date,$title)
$title=$title.Replace("_"," ");
$yaml=@"
---
layout: post
title: "{0}"
date: {1}
excerpt: "{0}"
tags: [{2}]
comments: false
---
"@ -f ($title,$date,$tag)


$yaml | Out-File ("./_posts/{0}.md" -f ($postname)) -Encoding utf8
open ("./_posts/{0}.md" -f ($postname))