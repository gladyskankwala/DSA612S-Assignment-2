const API_URL = "http://localhost:8083/restaurant";

function switchView(tab, button) {
    document.querySelectorAll(".tab-btn")
        .forEach(btn => btn.classList.remove("active-tab"));

    document.querySelectorAll(".tab-content")
        .forEach(content => content.classList.remove("show"));

    button.classList.add("active-tab");
    document.getElementById(`tab-${tab}`).classList.add("show");

    if (tab === "restaurants") loadRestaurants();
    if (tab === "menu" || tab === "inventory") loadRestaurantSelectors();
}

async function getRestaurants() {
    const res = await fetch(API_URL);

    if (!res.ok) {
        throw new Error("Restaurant Service unavailable");
    }

    return await res.json();
}

async function loadRestaurants() {
    const body = document.getElementById("restaurant-table-body");

    try {
        const restaurants = await getRestaurants();

        body.innerHTML = restaurants.map(r => `
            <tr>
                <td><strong>#${r.restaurantID}</strong></td>
                <td>${r.name}</td>
                <td>${r.address}</td>
                <td>${r.openingTime} - ${r.closingTime}</td>
                <td>
                    <strong style="color:${r.isOpen ? "#2ed573" : "#ff4757"}">
                        ${r.isOpen ? "OPEN" : "CLOSED"}
                    </strong>
                </td>
                <td>
                    <button class="btn btn-danger"
                        onclick="deleteRestaurant(${r.restaurantID})">
                        Delete
                    </button>
                </td>
            </tr>
        `).join("");

    } catch (error) {
        body.innerHTML = `
            <tr>
                <td colspan="6" style="color:red;text-align:center;">
                    Restaurant Service unavailable on Port 8083.
                </td>
            </tr>`;
    }
}

async function loadRestaurantSelectors() {
    try {
        const restaurants = await getRestaurants();

        const options = `
            <option value="">-- Choose Restaurant --</option>
            ${restaurants.map(r =>
                `<option value="${r.restaurantID}">
                    ${r.name} (ID: ${r.restaurantID})
                </option>`
            ).join("")}
        `;

        document.getElementById("menuTargetSelect").innerHTML = options;
        document.getElementById("invTargetSelect").innerHTML = options;

    } catch (error) {
        console.error(error);
    }
}

document.getElementById("restaurant-form").addEventListener("submit", async e => {
    e.preventDefault();

    const data = {
        restaurantID: Number(restId.value),
        name: restName.value.trim(),
        address: restAddress.value.trim(),
        openingTime: restOpen.value.trim(),
        closingTime: restClose.value.trim(),
        isOpen: restIsOpen.value === "true"
    };

    try {
        const res = await fetch(API_URL, {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(data)
        });

        if (!res.ok) throw new Error();

        e.target.reset();
        loadRestaurants();

    } catch {
        alert("Failed to add restaurant.");
    }
});

async function deleteRestaurant(id) {
    if (!confirm(`Delete restaurant #${id}?`)) return;

    try {
        const res = await fetch(`${API_URL}/${id}`, {
            method: "DELETE"
        });

        if (!res.ok) throw new Error();

        loadRestaurants();

    } catch {
        alert("Failed to delete restaurant.");
    }
}

async function loadMenuItems(id) {
    const body = document.getElementById("menu-table-body");

    if (!id) {
        body.innerHTML = `<tr><td colspan="6">Choose a restaurant.</td></tr>`;
        return;
    }

    try {
        const res = await fetch(`${API_URL}/${id}/menuItem`);
        const items = await res.json();

        body.innerHTML = items.length
            ? items.map(item => `
                <tr>
                    <td>${item.itemID}</td>
                    <td><strong>${item.name}</strong></td>
                    <td>$${Number(item.price).toFixed(2)}</td>
                    <td>${item.description}</td>
                    <td>${item.isAvailable ? "Yes" : "No"}</td>
                    <td>
                        <button class="btn btn-danger"
                            onclick="deleteMenuItem(${id}, ${item.itemID})">
                            Delete
                        </button>
                    </td>
                </tr>
            `).join("")
            : `<tr><td colspan="6">No menu items.</td></tr>`;

    } catch {
        body.innerHTML =
            `<tr><td colspan="6">Failed to load menu.</td></tr>`;
    }
}

document.getElementById("menu-form").addEventListener("submit", async e => {
    e.preventDefault();

    const restaurantID =
        document.getElementById("menuTargetSelect").value;

    if (!restaurantID) {
        alert("Choose a restaurant first.");
        return;
    }

    const data = {
        itemID: Number(menuItemId.value),
        restaurantID: Number(restaurantID),
        name: menuItemName.value.trim(),
        price: Number(menuItemPrice.value),
        description: menuItemDesc.value.trim(),
        isAvailable: menuItemAvail.value === "true"
    };

    try {
        const res = await fetch(
            `${API_URL}/${restaurantID}/menuItem`,
            {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: JSON.stringify(data)
            }
        );

        if (!res.ok) throw new Error();

        e.target.reset();
        loadMenuItems(restaurantID);

    } catch {
        alert("Failed to add menu item.");
    }
});

async function deleteMenuItem(restaurantID, itemID) {
    if (!confirm("Delete this menu item?")) return;

    await fetch(
        `${API_URL}/${restaurantID}/menuItem/${itemID}`,
        {method: "DELETE"}
    );

    loadMenuItems(restaurantID);
}

async function loadInventoryItems(id) {
    const body = document.getElementById("inventory-table-body");

    if (!id) {
        body.innerHTML = `<tr><td colspan="5">Choose a restaurant.</td></tr>`;
        return;
    }

    try {
        const res = await fetch(`${API_URL}/${id}/inventory`);
        const items = await res.json();

        body.innerHTML = items.length
            ? items.map(item => `
                <tr>
                    <td>#${item.inventoryID}</td>
                    <td>${item.itemID}</td>
                    <td><strong>${item.name}</strong></td>
                    <td>${item.quantity}</td>
                    <td>
                        <button class="btn btn-danger"
                            onclick="deleteInventory(${id}, ${item.itemID})">
                            Delete
                        </button>
                    </td>
                </tr>
            `).join("")
            : `<tr><td colspan="5">No inventory records.</td></tr>`;

    } catch {
        body.innerHTML =
            `<tr><td colspan="5">Failed to load inventory.</td></tr>`;
    }
}

async function deleteInventory(restaurantID, itemID) {
    if (!confirm("Delete this inventory record?")) return;

    await fetch(
        `${API_URL}/${restaurantID}/inventory/${itemID}`,
        {method: "DELETE"}
    );

    loadInventoryItems(restaurantID);
}

window.addEventListener("DOMContentLoaded", loadRestaurants);

