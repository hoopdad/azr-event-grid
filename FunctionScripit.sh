#!/bin/bash

# Azure Event Grid domain endpoint
eventGridDomainEndpoint="<Event_Grid_Domain_Endpoint>"

# Event Grid topic to send the event to
eventGridTopic="<Event_Grid_Topic>"

# Obtain an access token for the managed identity using the MSI_ENDPOINT and MSI_SECRET
accessToken=$(curl -H "Secret: $MSI_SECRET" "$MSI_ENDPOINT?resource=https://eventgrid.azure.net/&api-version=2017-09-01" -s | jq -r '.access_token')

# Event data
eventData='[{
  "id": "event-id",
  "eventType": "recordInserted",
  "subject": "myapp/vehicles/motorcycles",
  "eventTime": "'$(date -u '+%Y-%m-%dT%H:%M:%SZ')'",
  "data": {
    "make": "Ducati",
    "model": "Panigale V4"
  },
  "dataVersion": "1.0"
}]'

# Send the event to the Event Grid domain
curl -X POST -H "Authorization: Bearer $accessToken" -H "Content-Type: application/json" --data "$eventData" "$eventGridDomainEndpoint/api/events?topic=$eventGridTopic"
