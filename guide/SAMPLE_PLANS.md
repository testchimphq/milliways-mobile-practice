# Sample user stories and scenarios

Use this document as a **starting checklist** when you create plans in the TestChimp platform. These examples are adapted from the original Milliways demo plans (the `plans/` folder is intentionally empty in this starter repo until you sync from TestChimp).

**How to use this file**

1. In TestChimp → **Plans**, create the user stories and scenarios below (or let TestChimp AI help flesh them out).
2. Connect this Git repo and map the **`plans/`** folder in **Project Settings → Integrations → GitHub**.
3. Trigger **Sync to Git Repo** to open a PR that brings the markdown plans into the codebase.
4. Review and merge the PR so agents and teammates can read plans from the repo during `/testchimp test`.

Plan format reference: [TestChimp test planning intro](https://docs.testchimp.io/test-planning/intro)

---

## Suggested folder layout (after sync)

```
plans/
  stories/
    menu/
    orders/
    navigation/
    account/
  scenarios/
    menu/
    orders/
    navigation/
    account/
  knowledge/
  events/          # TrueCoverage event definitions (added during init / test workflows)
```

---

## User stories to create

### US-100 — Place and track food orders

**Priority:** medium  
**Folder suggestion:** `plans/stories/orders/order-food.md`

**Summary:** Guests browse the menu, add items to the cart with correct pricing, place an order, and see delivery confirmation and tracking-style messaging.

**Acceptance criteria**

- User can add items from the menu and adjust quantities before checkout.
- Cart reflects line items and totals for single- and multi-item orders.
- User can submit an order and reach a delivery confirmation screen with tracking-style messaging.

---

### US-101 — Browse restaurant menu

**Priority:** high  
**Folder suggestion:** `plans/stories/menu/menu-discovery.md`

**Summary:** Guests can view main dishes and other catalog content, including legal or operational disclaimers shown on the menu screen.

**Acceptance criteria**

- Main dish items from the catalog are visible when browsing the menu.
- Shipping-related disclaimer text is visible when scrolled into view.

---

### US-103 — View account and order history

**Priority:** high  
**Folder suggestion:** `plans/stories/account/my-account.md`

**Summary:** Signed-in guests can open the account area to see profile information, loyalty tier, and past order amounts.

**Acceptance criteria**

- Profile shows identifiable user context (e.g. email) and loyalty messaging.
- Past orders are listed with amounts; aggregate spend is shown when order history exists.

---

### US-104 — Navigate app after ordering

**Priority:** high  
**Folder suggestion:** `plans/stories/navigation/app-flow.md`

**Summary:** After placing an order, the guest can dismiss the delivery flow and start a new order with a clean cart state.

**Acceptance criteria**

- Closing the delivery screen returns to the welcome experience with a clear path to order again.
- After completing an order and returning to browse, the cart is empty for a new session.

---

### US-107 — Request refund (optional stretch)

**Priority:** medium  
**Folder suggestion:** `plans/stories/orders/request-refund.md`

**Summary:** Users can request a refund on a recent order from the account screen. Refund is available only for orders less than two days old.

**Acceptance criteria**

- Refund action appears on eligible orders in account history.
- Older orders do not allow refund (button hidden or disabled).
- Successful request shows confirmation messaging and persists on the backend.

---

## Test scenarios to create and link to stories

Create each scenario in TestChimp, link it to the story ID shown, then sync to Git. When you author SmartTests later, link specs with comments such as:

```javascript
// @Scenario: #TS-100 Add menu item and change quantity before checkout
```

### TS-100 — Add menu item and change quantity before checkout

**Story:** US-100  
**Folder suggestion:** `plans/scenarios/orders/add-menu-item-change-quantity.md`

**Prerequisites:** Seeded or signed-in user; app on welcome or home flow.

**Steps**

1. Open **New Order** and reach the main menu.
2. Open an item detail, increase and decrease quantity with +/−, then add to order.
3. Open cart and verify line totals match quantity and unit price.

**Expected:** Quantities and footer/cart prices stay consistent through detail and cart views.

---

### TS-102 — Multi-item cart totals are accurate

**Story:** US-100  
**Folder suggestion:** `plans/scenarios/orders/multi-item-cart-totals.md`

**Prerequisites:** Signed-in user on menu.

**Steps**

1. Add several different menu items.
2. Verify sticky footer item count and total on the menu screen.
3. Open cart and verify the grand total matches the sum of line items.

**Expected:** Totals match the combination of item prices shown in the cart.

---

### TS-105 — Main dishes are listed on the menu

**Story:** US-101  
**Folder suggestion:** `plans/scenarios/menu/main-dishes-listed.md`

**Prerequisites:** Signed-in user; menu visible.

**Steps**

1. Navigate to the main dishes section.
2. Verify each expected main dish name appears.

**Expected:** Catalog main dishes from the backend seed are all visible.

---

### TS-110 — Past orders sum matches displayed total spent

**Story:** US-103  
**Folder suggestion:** `plans/scenarios/account/order-history-totals.md`

**Prerequisites:** Account screen with at least one past order.

**Steps**

1. Open account.
2. Sum displayed past order amounts and compare to the **Total Spent** figure.

**Expected:** Sum of history lines equals the aggregate total shown (note: the demo app may contain intentional bugs here—document what you observe).

---

### TS-112 — Cart is empty after completing an order

**Story:** US-104  
**Folder suggestion:** `plans/scenarios/navigation/cart-cleared-after-order.md`

**Prerequisites:** Completed order flow through delivery; returned to welcome.

**Steps**

1. Start **New Order** from welcome.
2. Open cart without adding items.

**Expected:** Cart shows empty state before new items are added.

---

## Coupon stories (for the PR exercise only)

Do **not** add these during the initial baseline workflow—the starter app has no coupon feature yet. Create them in TestChimp when you begin the [PR testing exercise](./TESTING_GUIDE.md#pr-testing-add-coupon-codes) and sync via PR before implementation.

### US-102 — Apply promotional coupons

**Summary:** Guests can enter coupon codes on the cart screen; valid codes adjust totals and invalid codes show a clear error.

**Suggested scenarios**

| ID (example) | Title | Brief expectation |
|--------------|-------|-------------------|
| TS-107 | Valid coupon applies configured discount | Known valid code reduces total; discount line visible |
| TS-108 | Invalid coupon code shows error message | Bad code shows error; totals unchanged |

See the PR testing chapter in [TESTING_GUIDE.md](./TESTING_GUIDE.md) for the full coupon functionality requirements.
