const API_URL = "http://localhost:8087/notification";

async function loadNotifications() {
    const list = document.getElementById("notifications-list");
    const dot = document.getElementById("service-status");

    try {
        const res = await fetch(API_URL);

        if (!res.ok) {
            throw new Error("Notification Service unavailable");
        }

        const notifications = await res.json();

        dot.classList.remove("status-offline");

        if (!notifications.length) {
            list.innerHTML = "<p>No notifications yet.</p>";
            return;
        }

        list.innerHTML = notifications.map(n => `
            <div class="notification-card">

                <h3>${n.title || "System Notification"}</h3>

                <div class="notification-message">
                    <strong>Message</strong>
                    <p>${n.message || n.body || "No message available."}</p>
                </div>

                <div class="meta-info">
                    <span>
                        Target:
                        <strong>${n.userId || n.customerId || "Global"}</strong>
                    </span>

                    <span>
                        ${n.timestamp || n.createdAt || "Just now"}
                    </span>
                </div>

            </div>
        `).join("");

    } catch (error) {
        console.error(error);

        dot.classList.add("status-offline");

        list.innerHTML = `
            <div class="notification-card">
                <h3>Notification Service Offline</h3>
                <p>Could not connect to Port 8087.</p>
            </div>
        `;
    }
}

window.addEventListener("DOMContentLoaded", () => {
    loadNotifications();
});

setInterval(loadNotifications, 8000);