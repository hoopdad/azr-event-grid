

const { QueueServiceClient } = require("@azure/storage-queue");

async function main() {
    const connectionString = process.env.STORAGE_CONN_STR;
    const queueName = process.env.Q_NAME; 

    const queueServiceClient = QueueServiceClient.fromConnectionString(connectionString);
    const queueClient = queueServiceClient.getQueueClient(queueName);

    let messages;
    do {
        messages = await queueClient.receiveMessages({ maxMessages: 32 });
        for (const message of messages.receivedMessageItems) {
            const decodedMessage = Buffer.from(message.messageText, "base64").toString("utf-8");
            console.log(`${decodedMessage}`);
        }
    } while (messages.receivedMessageItems.length > 0);
}

main().catch((error) => {
    console.error("Error occurred:", error);
});
