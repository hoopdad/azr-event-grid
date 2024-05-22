const axios = require("axios");

async function sendEventToEventGrid() {
    const domainEndpoint = process.env.EVENT_GRID_ENDPOINT;

    const shortid = require('shortid');
    const shortUniqueId = shortid.generate();
    const currentDate = new Date();
    const formattedTimestamp = currentDate.toISOString();
    const eventData = [
        {
            id: shortUniqueId,
            topic: "my-eventgrid-domain-topic",
            eventType: "your-event-type", // must match subscription details from terraform
            subject: "HELLLLOOOOOOOO ",
            eventTime: formattedTimestamp,
            data: {
                "your-data-field": "your-data-value"
            },
            dataVersion: "1.0"
        }
    ];

    try {
        const response = await axios.post(domainEndpoint, eventData, {
            headers: {
                "Content-Type": "application/json",
                "aeg-sas-key": process.env.AEG_SAS_KEY
            }
        });

        console.log("Event sent successfully:", response.status);
    } catch (error) {
        console.error("Error sending event:", error.message);
    }
}

sendEventToEventGrid();
