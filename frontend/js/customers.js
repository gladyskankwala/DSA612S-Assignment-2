const API_URL = "http://localhost:9091/orders";

async function loadOrders() {
    const tableBody = document.getElementById("order-table-body");
    if (!tableBody) return;
    
    tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center;">Retrieving active ecosystem orders...</td></tr>`;

    try {
        const response = await fetch(API_URL);
        if (!response.ok) throw new Error("Failed to pull order data list");
        
        const orders = await response.json();
        tableBody.innerHTML = "";

        if (!orders || orders.length === 0) {
            tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center;">No order records available.</td></tr>`;
            return;
        }

        orders.forEach(ord => {
            const resolvedOrderId = ord.orderId || ord.orderID || "N/A";
            const resolvedCustomerId = ord.customerId || ord.customerID || "N/A";
            const resolvedRestaurantId = ord.restaurantId || ord.restaurantID || "N/A";
            const resolvedAmount = parseFloat(ord.totalAmount || ord.amount || ord.price || 0);
            const currentStatus = (ord.status || "CREATED").toUpperCase();

            const row = document.createElement("tr");
            row.innerHTML = `
                <td><strong>${resolvedOrderId}</strong></td>
                <td>${resolvedCustomerId}</td>
                <td>${resolvedRestaurantId}</td>
                <td>$${resolvedAmount.toFixed(2)}</td>
                <td>
                    <select class="status-select" onchange="changeOrderStatus('${resolvedOrderId}', this.value)">
                        <option value="CREATED" ${currentStatus === 'CREATED' ? 'selected' : ''}>CREATED</option>
                        <option value="CONFIRMED" ${currentStatus === 'CONFIRMED' ? 'selected' : ''}>CONFIRMED</option>
                        <option value="PREPARING" ${currentStatus === 'PREPARING' ? 'selected' : ''}>PREPARING</option>
                        <option value="READY" ${currentStatus === 'READY' ? 'selected' : ''}>READY</option>
                        <option value="DELIVERED" ${currentStatus === 'DELIVERED' ? 'selected' : ''}>DELIVERED</option>
                        <option value="CANCELLED" ${currentStatus === 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                    </select>
                </td>
                <td>
                    <button class="btn btn-danger" onclick="removeOrder('${resolvedOrderId}')">Delete</button>
                </td>
            `;
            tableBody.appendChild(row);
        });
    } catch (error) {
        console.error("API error reading order repository: ", error);
        tableBody.innerHTML = `<tr><td colspan="6" style="text-align:center; color:red;">Failed to connect to order microservice on port 9091.</td></tr>`;
    }
}

async function changeOrderStatus(orderId, newStatus) {
    try {
        const response = await fetch(`${API_URL}/${orderId}/status`, {
            method: "PATCH",
            headers: { 
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify(newStatus) 
        });

        if (!response.ok) {
            const msg = await response.text();
            throw new Error(msg || "Invalid workflow transition");
        }
        
        alert(`Order ${orderId} updated to ${newStatus}`);
        loadOrders();
    } catch (error) {
        console.error("Status state modification drop: ", error);
        alert(`Could not transition order status: ${error.message}`);
        loadOrders(); 
    }
}

async function removeOrder(orderId) {
    if (!confirm(`Permanently remove order ${orderId}?`)) return;

    try {
        const response = await fetch(`${API_URL}/${orderId}`, {
            method: "DELETE"
        });

        if (!response.ok) throw new Error("Resource structural tracking deletion failure");

        alert("Order dropped successfully.");
        loadOrders();
    } catch (error) {
        console.error("Failed deleting data array index element: ", error);
        alert("Could not remove order from repository data collection context.");
    }
}

window.loadOrders = loadOrders;
window.changeOrderStatus = changeOrderStatus;
window.removeOrder = removeOrder;

window.addEventListener("DOMContentLoaded", () => {
    loadOrders();

    const orderForm = document.getElementById("order-form");
    if (orderForm) {
        orderForm.addEventListener("submit", async (e) => {
            e.preventDefault();

            const orderPayload = {
                orderId: document.getElementById("orderId").value.trim(),
                customerId: document.getElementById("customerId").value.trim(),
                restaurantId: document.getElementById("restaurantId").value.trim(),
                totalAmount: parseFloat(document.getElementById("totalAmount").value || 0),
                status: "CREATED"
            };

            try {
                const response = await fetch(API_URL, {
                    method: "POST",
                    headers: { 
                        "Content-Type": "application/json",
                        "Accept": "application/json"
                    },
                    body: JSON.stringify(orderPayload)
                });

                if (!response.ok) {
                    const errorMessage = await response.text();
                    throw new Error(errorMessage || "Failed to parse data");
                }

                alert("Order created successfully!");
                orderForm.reset();
                loadOrders();
            } catch (error) {
                console.error("Failed adding order resource element: ", error);
                alert(`Failed to create order: ${error.message}`);
            }
        });
    }
});
