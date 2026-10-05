const BACKEND_URL = "http://localhost:8088/admin/statistics";

async function fetchLiveStatistics() {
    const statusDot = document.getElementById("connection-status");

    try {
        const response = await fetch(BACKEND_URL);

        if (!response.ok) {
            throw new Error(`Backend returned HTTP ${response.status}`);
        }

        const data = await response.json();

        console.log("Admin statistics:", data);

        updateElement("totalOrders", data.totalOrders);
        updateElement("confirmedOrders", data.confirmedOrders);
        updateElement("preparingOrders", data.preparingOrders);
        updateElement("readyOrders", data.readyOrders);
        updateElement("cancelledOrders", data.cancelledOrders);

   
        updateElement("completedPayments", data.completedPayments);
        updateElement("failedPayments", data.failedPayments);

  
        updateElement("assignedDeliveries", data.assignedDeliveries);
        updateElement("completedDeliveries", data.completedDeliveries);

        if (statusDot) {
            statusDot.classList.remove("status-offline");
            statusDot.classList.add("status-online");
        }

    } catch (error) {

        console.error(
            "Failed to fetch Admin statistics:",
            error
        );


        const statisticIds = [
            "totalOrders",
            "confirmedOrders",
            "preparingOrders",
            "readyOrders",
            "cancelledOrders",
            "completedPayments",
            "failedPayments",
            "assignedDeliveries",
            "completedDeliveries"
        ];

        statisticIds.forEach(id => {
            const element = document.getElementById(id);

            if (element) {
                element.innerText = "0";
            }
        });

        if (statusDot) {
            statusDot.classList.remove("status-online");
            statusDot.classList.add("status-offline");
        }
    }
}


function updateElement(id, value) {
    const element = document.getElementById(id);

    if (!element) {
        console.warn(`Element #${id} was not found in the HTML.`);
        return;
    }

    element.innerText = value ?? 0;
}



window.addEventListener("DOMContentLoaded", () => {
    fetchLiveStatistics();
});


setInterval(fetchLiveStatistics, 10000);