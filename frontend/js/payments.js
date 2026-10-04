const API_URL = "http://localhost:8084/payments";

async function lookupPaymentRecord() {
    const searchInput = document.getElementById("search-order-id");
    const exceptionZone = document.getElementById("audit-exception-zone");
    const tableBody = document.getElementById("payment-table-body");
    
    if (!searchInput || !tableBody) return;
    
    const orderId = searchInput.value.trim();
    if (!orderId) {
        alert("Please specify a target Order ID identifier string.");
        return;
    }

    tableBody.innerHTML = `<tr><td colspan="4" style="text-align:center;">Querying global ledger registry tracking maps...</td></tr>`;
    if (exceptionZone) exceptionZone.style.display = "none";

    try {
        const response = await fetch(`${API_URL}/${orderId}`);
        if (!response.ok) throw new Error("Ledger communication failure");

        const rawText = await response.text();
        
        if (rawText === "Payment not found" || !rawText.trim()) {
            tableBody.innerHTML = `<tr><td colspan="4" style="text-align:center; color:var(--muted);">Use the terminal query system on the right to pull direct operational elements into focus logs.</td></tr>`;
            if (exceptionZone) {
                exceptionZone.innerText = `No transaction record exists on the current payment infrastructure ledger for Order ID: ${orderId}`;
                exceptionZone.style.display = "block";
            }
            return;
        }

        let paymentData;
        try {
            paymentData = JSON.parse(rawText);
        } catch (jsonErr) {
            throw new Error("Malformed transaction payload returned from register");
        }

        tableBody.innerHTML = "";
        if (exceptionZone) exceptionZone.style.display = "none";

        const resolvedPaymentId = paymentData.paymentId || paymentData.paymentID || "N/A";
        const resolvedOrderId = paymentData.orderId || paymentData.orderID || orderId;
        const resolvedAmount = parseFloat(paymentData.amount || paymentData.totalAmount || paymentData.price || 0);
        const resolvedStatus = (paymentData.status || "COMPLETED").toUpperCase();

        const row = document.createElement("tr");
        row.innerHTML = `
            <td><strong>${resolvedPaymentId}</strong></td>
            <td>${resolvedOrderId}</td>
            <td>$${resolvedAmount.toFixed(2)}</td>
            <td style="text-align: right;"><span class="badge badge-success" style="background-color:#2ed573; padding: 4px 8px; color:white; border-radius:4px; font-size:11px;">${resolvedStatus}</span></td>
        `;
        tableBody.appendChild(row);

    } catch (error) {
        console.error("API error querying ledger tracking frame: ", error);
        tableBody.innerHTML = `<tr><td colspan="4" style="text-align:center; color:red;">Failed to complete transaction audit cycle validation routines.</td></tr>`;
    }
}

window.lookupPaymentRecord = lookupPaymentRecord;

document.addEventListener("DOMContentLoaded", () => {
    const searchForm = document.getElementById("payment-search-form");
    if (searchForm) {
        searchForm.addEventListener("submit", (e) => {
            e.preventDefault();
            lookupPaymentRecord();
        });
    }
});
