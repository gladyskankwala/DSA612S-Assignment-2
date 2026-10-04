const API_URL = "http://localhost:8085/delivery";

const NEXT = {
    ASSIGNED: "PICKED_UP",
    PICKED_UP: "IN_TRANSIT",
    IN_TRANSIT: "DELIVERED"
};

async function loadDeliveries() {
    const body = document.getElementById("delivery-table-body");

    try {
        const res = await fetch(`${API_URL}/deliveries`);
        const data = await res.json();

        body.innerHTML = "";

        data.forEach(d => {
            const next = NEXT[d.status];

            body.innerHTML += `
                <tr>
                    <td><strong>${d.orderId}</strong></td>
                    <td>${d.driverId || "Unassigned"}</td>
                    <td>
                        <span class="status-badge status-${d.status.toLowerCase()}">
                            ${d.status.replace("_", " ")}
                        </span>
                    </td>
                    <td>${d.updatedAt || "N/A"}</td>
                    <td>
                        ${
                            next
                            ? `<button class="btn btn-sm"
                                onclick="advanceStatus('${d.orderId}','${next}')">
                                ${next.replace("_", " ")}
                              </button>`
                            : "✓ Delivered"
                        }
                    </td>
                </tr>
            `;
        });

    } catch (e) {
        body.innerHTML = `
            <tr>
                <td colspan="5">Failed to load deliveries.</td>
            </tr>
        `;
    }
}
async function loadDrivers() {
    const list = document.getElementById("driver-list");

    try {
        const res = await fetch(`${API_URL}/drivers`);
        const drivers = await res.json();

        list.innerHTML = drivers.map(d => `
            <div class="driver-list-item">
                <div style="font-size:17px;font-weight:700;margin-bottom:5px;">
                    ${d.name || "Unknown Driver"}
                </div>

                <div style="font-size:13px;color:#777;">
                    Driver ID: ${d.driverId || "N/A"}
                </div>

                <div style="font-size:13px;margin-top:5px;">
                    📍 ${d.latitude ?? "N/A"}, ${d.longitude ?? "N/A"}
                    &nbsp; | &nbsp;
                    <strong>${d.available ? "Available" : "On Delivery"}</strong>
                </div>
            </div>
        `).join("");

    } catch (e) {
        list.innerHTML = "Failed to load drivers.";
    }
}


async function advanceStatus(orderId, status) {
    try {
        const res = await fetch(
            `${API_URL}/deliveries/${orderId}/status`,
            {
                method: "PUT",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify({status})
            }
        );

        if (!res.ok) throw new Error(await res.text());

        loadDeliveries();
        loadDrivers();

    } catch (e) {
        alert(`Update failed: ${e.message}`);
    }
}

document.getElementById("driver-form").addEventListener("submit", async e => {
    e.preventDefault();

    const data = {
        name: driverName.value.trim(),
        latitude: Number(latitude.value),
        longitude: Number(longitude.value)
    };

    try {
        const res = await fetch(`${API_URL}/drivers`, {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(data)
        });

        if (!res.ok) throw new Error(await res.text());

        e.target.reset();
        loadDrivers();

    } catch (err) {
        alert(`Driver registration failed: ${err.message}`);
    }
});

window.advanceStatus = advanceStatus;

window.addEventListener("DOMContentLoaded", () => {
    loadDeliveries();
    loadDrivers();
});
