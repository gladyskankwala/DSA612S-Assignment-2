const API_URL = "http://localhost:9091/orders";

async function loadOrders() {
    const tableBody = document.getElementById("order-table-body");
    if (!tableBody) return;

    tableBody.innerHTML = `
        <tr>
            <td colspan="6" style="text-align:center;">
                Loading orders...
            </td>
        </tr>
    `;

    try {
        const response = await fetch(API_URL);

        if (!response.ok) {
            throw new Error("Failed to load orders");
        }

        const orders = await response.json();

        tableBody.innerHTML = "";

        if (!Array.isArray(orders) || orders.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" style="text-align:center;">
                        No orders available.
                    </td>
                </tr>
            `;
            return;
        }

        orders.forEach(order => {
            const orderId = order.orderId || "N/A";
            const customerId = order.customerId || "N/A";
            const restaurantId = order.restaurantId || "N/A";
            const amount = Number(order.totalAmount || 0);
            const status = String(order.status || "CREATED").toUpperCase();

            const row = document.createElement("tr");

            row.innerHTML = `
                <td>
                    <strong>${orderId}</strong>
                </td>

                <td>${customerId}</td>

                <td>${restaurantId}</td>

                <td>$${amount.toFixed(2)}</td>

                <td>
                    <select
                        class="status-select"
                        onchange="changeOrderStatus('${orderId}', this.value)"
                    >
                        <option value="CREATED" ${status === "CREATED" ? "selected" : ""}>
                            CREATED
                        </option>

                        <option value="CONFIRMED" ${status === "CONFIRMED" ? "selected" : ""}>
                            CONFIRMED
                        </option>

                        <option value="PREPARING" ${status === "PREPARING" ? "selected" : ""}>
                            PREPARING
                        </option>

                        <option value="READY" ${status === "READY" ? "selected" : ""}>
                            READY
                        </option>

                        <option value="CANCELLED" ${status === "CANCELLED" ? "selected" : ""}>
                            CANCELLED
                        </option>
                    </select>
                </td>

                <td style="text-align:right;">
                    <button
                        class="btn btn-danger"
                        onclick="removeOrder('${orderId}')"
                    >
                        Delete
                    </button>
                </td>
            `;

            tableBody.appendChild(row);
        });

    } catch (error) {
        console.error("Order API error:", error);

        tableBody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align:center; color:red;">
                    Cannot connect to Order Service on port 9091.
                </td>
            </tr>
        `;
    }
}


async function changeOrderStatus(orderId, newStatus) {
    try {
        const response = await fetch(
            `${API_URL}/${orderId}/status`,
            {
                method: "PATCH",
                headers: {
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                },
                body: JSON.stringify(newStatus)
            }
        );

        if (!response.ok) {
            const errorMessage = await response.text();
            throw new Error(errorMessage || "Status update failed");
        }

        alert(`Order ${orderId} updated to ${newStatus}`);

        await loadOrders();

    } catch (error) {
        console.error("Status update error:", error);

        alert(
            `Could not update order ${orderId}.\n\n${error.message}`
        );

        await loadOrders();
    }
}


async function removeOrder(orderId) {
    if (!confirm(`Delete order ${orderId}?`)) {
        return;
    }

    try {
        const response = await fetch(
            `${API_URL}/${orderId}`,
            {
                method: "DELETE"
            }
        );

        if (!response.ok) {
            throw new Error("Delete request failed");
        }

        alert(`Order ${orderId} deleted successfully.`);

        await loadOrders();

    } catch (error) {
        console.error("Delete error:", error);

        alert(`Could not delete order: ${error.message}`);
    }
}


window.loadOrders = loadOrders;
window.changeOrderStatus = changeOrderStatus;
window.removeOrder = removeOrder;


window.addEventListener("DOMContentLoaded", () => {

    loadOrders();

    const orderForm = document.getElementById("order-form");

    if (!orderForm) return;

    orderForm.addEventListener("submit", async (event) => {

        event.preventDefault();

        const orderId =
            document.getElementById("orderId").value.trim();

        const customerId =
            document.getElementById("customerId").value.trim();

        const restaurantId =
            document.getElementById("restaurantId").value.trim();

        const itemId =
            document.getElementById("itemId").value.trim();

        const totalAmount =
            parseFloat(
                document.getElementById("totalAmount").value
            );

        if (!orderId || !customerId || !restaurantId || !itemId) {
            alert("Please complete all required fields.");
            return;
        }

        if (isNaN(totalAmount) || totalAmount <= 0) {
            alert("Please enter a valid amount greater than 0.");
            return;
        }

        const orderPayload = {
            orderId: orderId,
            itemID: itemId,
            customerId: customerId,
            restaurantId: restaurantId,

            items: [
                {
                    menuItemId: itemId,
                    itemID: itemId,
                    name: "Manual Custom Selection Item",
                    quantity: 1,
                    price: totalAmount
                }
            ],

            totalAmount: totalAmount,
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
                throw new Error(
                    errorMessage || "Order creation failed"
                );
            }

            alert("Order created successfully!");

            orderForm.reset();

            await loadOrders();

        } catch (error) {

            console.error("Create order error:", error);

            alert(
                `Failed to create order.\n\n${error.message}`
            );
        }
    });
});
