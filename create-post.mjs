#!/usr/bin/env zx
$.verbose = true;

const title = await question('Whats the title of the post? ')
const tag = await question('Whats the tag of the post? ')
const excerpt = await question('(Optional) Whats the excerpt of the post? ')

const now = new Date();

const dateString = `${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}`

const fileName = `${dateString}-${title}.md`

const postMetaData = `---
layout: post
title: "${title}"
date: ${dateString}
excerpt: "${excerpt}"
tags: [${tag}]
comments: false
---
`

const filePath = path.resolve('./_posts', fileName);

try {
  await $`touch ${filePath}`
  await $`echo ${postMetaData} >> ${filePath}`
  await $`open ${filePath}`
  console.log(chalk.green(`Successfuly created a new post at ${filePath}`))
}catch(error){
  console.error(chalk.red('Occurred an error while creating a new post.'), error)
}
