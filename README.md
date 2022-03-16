# fly-restic
Backup Any Rclone Remote to Another Using Restic on Fly.io Topics

## Table of Contents

- [Introduction](#introduction)
- [Getting Started](#getting-started)
  - [Deploying Fly-Restic](#deploying-fly-restic)
    - [GitHub Workflow (Recommended)](#github-workflow-recommended)
    - [Manual](#manual)

## Introduction

Use [Fly.io](https://fly.io) to periodically backup one Rclone provider to another using Restic.

## Getting Started
### Making an Account on Fly.io
If you haven't already, you'll need to sign up for Fly and install the `flyctl` application by heading over to [fly.io](https://fly.io/docs/hands-on/start/). After you've completed Step 3 you may come back to this guide. To see your `FLY_API_TOKEN` run the following command and save the output for later.

```
flyctl auth token
```

### Deploying Fly-Restic
#### GitHub Workflow (Recommended)

1. Fork this repository (click fork in the top right)
2. Go to your new repository's settings >> secrets >> action's secrets
3. Create new secrets for each of the following,
   ```
   FLY_API_TOKEN
   FLY_ORG
   FLY_APP_NAME
   FLY_APP_REGION
   RESTIC_PASSWORD
   RESTIC_PRUNE_ARGS
   RCLONE_CONFIG
   RCLONE_FROM
   RCLONE_TO
   ```
4. Now go to your repositories "Actions" tab. You should see one action, (re)deploy restic.
5. Click on (re)deploy & enable the workflow for your fork.
6. Now manually run your workflow by clicking "Run Workflow" on the right of the screen. Your workflow should now begin and automatically deploy your Restic app.

#### Manual
1. Clone this repository
2. Run the following commands, replacing `{{ VALUE }}` with your specifc values.
   ```
   flyctl launch --name {{ YOUR-APP-NAME }}
   rm fly.toml
   
   cd restic
   
   sed -i "s\%fly_app_name%\{{ YOUR APP NAME }}\g" fly.toml
   sed -i "s\%rclone_from%\{{ RCLONE_FROM }}\g" fly.toml
   sed -i "s\%rclone_to%\{{ RCLONE_TO }}\g" fly.toml
   sed -i "s\%restic_password%\{{ RESTIC_PASSWORD }}\g" fly.toml
   sed -i "s\%restic_prune_args%\{{ RESTIC_PRUNE_ARGS }}\g" fly.toml
   ```
4. Copy your rclone.conf to this `restic/`.
5. Edit the `entry-cron` file to fit your specific needs.
6. Run `flyctl deploy`

## License

Copyright 2022 Alec Scott hi@alecbcs.com

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
