
const API_URL = "http://localhost:9091/orders";

const tableBody = document.getElementById("order-table-body");
const orderForm = document.getElementById("order-form");
const refreshButton = document.getElementById("refresh-orders");
const message = document.getElementById("orders-message");

const allowedStatuses = [
    "CREATED",
    "CONFIRMED",
    "PREPARING",
    "READY",
    "CANCELLED"
];

function showMessage(text, isError = false) {
    if (!message) return;

    message.textContent = text;
    message.style.color = isError ? "#dc2626" : "#16a34a";
}

function escapeHTML(value) {
    return String(value ?? "").replace(/[&<>"']/g, character => ({
        "&": "&amp;",
        "<": "&lt;",
        ">": "&gt;",
        '"': "&quot;",
        "'": "&#039;"
    })[character]);
}

async function loadOrders() {
    if (!tableBody) return;

    tableBody.innerHTML = `
        <tr>
            <td colspan="6" style="text-align:center;">
                Loading orders...
            </td>
        </tr>
    `;

    if (refreshButton) {
        refreshButton.disabled = true;
        refreshButton.textContent = "Loading...";
    }

    try {
        const response = await fetch(API_URL);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}`);
        }

        const orders = await response.json();

        if (!Array.isArray(orders)) {
            throw new Error("Invalid orders response.");
        }

        if (orders.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="6" style="text-align:center;">
                        No orders available.
                    </td>
                </tr>
            `;
            showMessage("No orders found.");
            return;
        }

        tableBody.innerHTML = orders.map(order => {
            const orderId = String(order.orderId ?? "");
            const status = String(order.status ?? "CREATED").toUpperCase();
            const amount = Number(order.totalAmount ?? 0);

            const options = allowedStatuses.map(item => `
                <option
                    value="${item}"
                    ${item === status ? "selected" : ""}
                >
                    ${item}
                </option>
            `).join("");

            const statusSelect = allowedStatuses.includes(status)
                ? `
                    <select
                        class="status-select"
                        aria-label="Status for ${escapeHTML(orderId)}"
                        onchange="changeOrderStatus(
                            '${escapeHTML(orderId)}',
                            this.value
                        )"
                    >
                        ${options}
                    </select>
                `
                : escapeHTML(status);

            return `
                <tr>
                    <td><strong>${escapeHTML(orderId || "N/A")}</strong></td>
                    <td>${escapeHTML(order.customerId ?? "N/A")}</td>
                    <td>${escapeHTML(order.restaurantId ?? "N/A")}</td>
                    <td>$${Number.isFinite(amount) ? amount.toFixed(2) : "0.00"}</td>
                    <td>${statusSelect}</td>
                    <td>
                        <button
                            type="button"
                            class="btn btn-danger"
                            onclick="removeOrder('${escapeHTML(orderId)}')"
                        >
                            Delete
                        </button>
                    </td>
                </tr>
            `;
        }).join("");

        showMessage(`${orders.length} order(s) loaded successfully.`);

    } catch (error) {
        console.error("Order API error:", error);

        tableBody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align:center;color:red;">
                    Cannot connect to Order Service on port 9091.
                </td>
            </tr>
        `;

        showMessage("Failed to load orders.", true);

    } finally {
        if (refreshButton) {
            refreshButton.disabled = false;
            refreshButton.textContent = "Refresh Orders";
        }
    }
}

async function changeOrderStatus(orderId, newStatus) {
    if (!allowedStatuses.includes(newStatus)) {
        showMessage("Invalid order status.", true);
        await loadOrders();
        return;
    }

    try {
        const response = await fetch(
            `${API_URL}/${encodeURIComponent(orderId)}/status`,
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
            throw new Error(await response.text() || "Status update failed.");
        }

        showMessage(`Order ${orderId} updated to ${newStatus}.`);
        await loadOrders();

    } catch (error) {
        console.error("Status update error:", error);
        showMessage(`Could not update order: ${error.message}`, true);
        await loadOrders();
    }
}

async function removeOrder(orderId) {
    if (!confirm(`Delete order ${orderId}?`)) {
        return;
    }

    try {
        const response = await fetch(
            `${API_URL}/${encodeURIComponent(orderId)}`,
            {
                method: "DELETE"
            }
        );

        if (!response.ok) {
            throw new Error(await response.text() || "Delete failed.");
        }

        showMessage(`Order ${orderId} deleted successfully.`);
        await loadOrders();

    } catch (error) {
        console.error("Delete error:", error);
        showMessage(`Could not delete order: ${error.message}`, true);
    }
}

async function createOrder(event) {
    event.preventDefault();

    const orderId = document.getElementById("orderId").value.trim();
    const customerId = document.getElementById("customerId").value.trim();
    const restaurantId = document.getElementById("restaurantId").value.trim();
    const itemId = document.getElementById("itemId").value.trim();
    const totalAmount = Number(
        document.getElementById("totalAmount").value
    );

    if (!orderId || !customerId || !restaurantId || !itemId) {
        showMessage("Please complete all required fields.", true);
        return;
    }

    if (!Number.isFinite(totalAmount) || totalAmount <= 0) {
        showMessage("Enter a valid amount greater than zero.", true);
        return;
    }

    const orderPayload = {
        orderId,
        itemID: itemId,
        customerId,
        restaurantId,
        items: [
            {
                menuItemId: itemId,
                itemID: itemId,
                name: "Manual Custom Selection Item",
                quantity: 1,
                price: totalAmount
            }
        ],
        totalAmount,
        status: "CREATED"
    };

    const submitButton = orderForm.querySelector('button[type="submit"]');
    submitButton.disabled = true;
    submitButton.textContent = "Creating...";

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
            throw new Error(await response.text() || "Order creation failed.");
        }

        orderForm.reset();
        showMessage(`Order ${orderId} created successfully.`);
        await loadOrders();

    } catch (error) {
        console.error("Create order error:", error);
        showMessage(`Failed to create order: ${error.message}`, true);

    } finally {
        submitButton.disabled = false;
        submitButton.textContent = "Create Order";
    }
}

window.changeOrderStatus = changeOrderStatus;
window.removeOrder = removeOrder;
window.loadOrders = loadOrders;

window.addEventListener("DOMContentLoaded", () => {
    loadOrders();

    if (refreshButton) {
        refreshButton.addEventListener("click", loadOrders);
    }

    if (orderForm) {
        orderForm.addEventListener("submit", createOrder);
    }
});