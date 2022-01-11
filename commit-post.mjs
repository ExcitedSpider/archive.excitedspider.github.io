#!/usr/bin/env zx
await $`git add .`
await $`git commit -m "submit new post"`
await $`git push origin master`