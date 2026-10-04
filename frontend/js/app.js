// Ballerina backend base address
const BACKEND_URL = "http://localhost:8088/admin/statistics";

async function fetchLiveStatistics() {
    const statusDot = document.getElementById('connection-status');
    
    try {
        const response = await fetch(BACKEND_URL);
        if (!response.ok) throw new Error("Backend response error status");
        
        const data = await response.json();
        
        // 🔮 Safely update DOM elements matching ONLY the active Ballerina fields
        if (document.getElementById('totalOrders')) {
            document.getElementById('totalOrders').innerText = data.totalOrders ?? 0;
        }
        if (document.getElementById('completedPayments')) {
            document.getElementById('completedPayments').innerText = data.completedPayments ?? 0;
        }
        if (document.getElementById('failedPayments')) {
            // ✅ Fixed singular 'failedPayment' casing from your Ballerina backend model
            document.getElementById('failedPayments').innerText = data.failedPayment ?? 0; 
        }

        // Optional Fallback Fill: Set non-existent stats to 0 so they don't show blank
        const otherIds = ['confirmedOrders', 'preparingOrders', 'readyOrders', 'cancelledOrders', 'assignedDeliveries', 'completedDeliveries'];
        otherIds.forEach(id => {
            const el = document.getElementById(id);
            if (el && el.innerText === "") el.innerText = 0;
        });
        
        // Connection Success Visual feedback
        statusDot.classList.remove('status-offline');
    } catch (error) {
        console.error("Failed fetching structural records from Ballerina application: ", error);
        statusDot.classList.add('status-offline');
    }
}

// Automatically fetch on dashboard initial load
window.addEventListener('DOMContentLoaded', fetchLiveStatistics);

// Auto refresh metrics from backend every 10 seconds
setInterval(fetchLiveStatistics, 10000);
