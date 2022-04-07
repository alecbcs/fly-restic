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
   CRON_SPEC
   RESTIC_PASSWORD
   RESTIC_PRUNE_ARGS
   RCLONE_CONFIG
   RCLONE_FROM
   RCLONE_TO
   ```
   See below for examples of a `CRON_SPEC`, `RCLONE_CONFIG`, `RCLONE_FROM`, and `RCLONE_TO`.
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
5. Create a file named `entry-cron` within `restic/` that defines the cron job to be run with rclone and restic. (See below for an example of a cron definition.)
6. Run `flyctl deploy`

### Examples
#### `CRON_SPEC` or `restic/entry-cron` File.
```
0 */6 * * * restic -r rclone:$RCLONE_TO backup --verbose /data && \
            restic -r rclone:$RCLONE_TO check && \
            restic -r rclone:$RCLONE_TO forget --prune $RESTIC_PRUNE_ARGS
```
This example creates a backup snapshot of the `RCLONE_TO` data, checks previous backup integrety, and prunes old backups every 6 hours.

#### `RCLONE_CONFIG` or `rclone.conf` File.
```
[nextcloud]
type = webdav
url = https://instance.domain.tld/remote.php/dav/files/username/
vendor = nextcloud
user = username
pass = rEdAcTeD

[s3]
type = s3
provider = a-provider-or-other
access_key_id = rEdAcTeD
secret_access_key = rEdAcTeD
endpoint = s3.region.provider.tld
```
This example shows webdav and s3 providers for rclone. You can generate this file by running,
```
rclone config
```
Then copy the generated file from `$HOME/.config/rclone/rclone.conf` into `restic/rclone.conf`.

#### `RCLONE_FROM`
```
nextcloud:/
```

#### `RCLONE_TO`
```
s3:bucket-name/
```

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
