import os
import requests
import json

def get_managed_identity_token():
    msi_endpoint = os.environ.get("MSI_ENDPOINT")
    msi_secret = os.environ.get("MSI_SECRET")

    if msi_endpoint and msi_secret:
        token_url = f"{msi_endpoint}?resource=https://management.azure.com&api-version=2017-09-01"
        headers = {"Secret": msi_secret}
        response = requests.get(token_url, headers=headers)
        if response.status_code == 200:
            return response.json().get("access_token")
        else:
            raise Exception(f"Failed to obtain managed identity token. Status code: {response.status_code}")
    else:
        raise Exception("MSI_ENDPOINT or MSI_SECRET environment variables are not set.")

def build_sample_event_data():
    # Customize your event data here
    event_data = {
        "eventType": "MyCustomEvent",
        "subject": "my/resource/path",
        "data": {
            "key1": "value1",
            "key2": "value2"
        }
    }
    return json.dumps(event_data)

def send_event_to_event_grid(event_data):
    event_grid_endpoint = "https://<your-event-grid-domain>.eventgrid.azure.net/api/events"
    access_token = get_managed_identity_token()

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {access_token}"
    }

    response = requests.post(event_grid_endpoint, data=event_data, headers=headers)
    if response.status_code == 200:
        print("Event sent successfully!")
    else:
        print(f"Failed to send event. Status code: {response.status_code}")

if __name__ == "__main__":
    event_data = build_sample_event_data()
    send_event_to_event_grid(event_data)
