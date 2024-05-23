# azr-event-grid

## Build

for the terraform, run:

```bash
terraform init
terraform plan
terraofrm apply
export STORAGE_CONN_STR=`terraform output queue_connection_string | tr -d '"'`
export Q_NAME=`terraform output queue_name | tr -d '"'`
export AEG_SAS_KEY=`terraform output domain_key | tr -d '"'`
export EVENT_GRID_ENDPOINT=`terraform output domain_endpoint | tr -d '"'`
```

You can run those env variable lines whenever you want after terraform apply as long as the .tfstate file is present.

## Validate

Make sure to set env variables as described above. These tests rely on environment variables.

- STORAGE_CONN_STR - connection string for your storage account, found under Keys in portal
- Q_NAME - what's the name of the queue? Has to match your terraform
- AEG_SAS_KEY - This is the authorization key generated from the Event Grid terraform
- EVENT_GRID_ENDPOINT - This is the endpoint generated from the Event Grid terraform

To validate:

- set up your node environment

```bash
npm install @azure/eventgrid
npm install @azure/storage-queue
npm install axios
npm install shortid
```

- Do a bunch of these:

```bash
node push.js
```

- And then this one to see them beautifully appear in Courier New

```bash
node pull.js
```
