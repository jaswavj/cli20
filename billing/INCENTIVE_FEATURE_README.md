# Incentive Management Feature

## Overview
Added a complete incentive management system with entry form and reporting capabilities. All database operations are handled through the `billingBean` class following proper MVC architecture.

## Architecture Changes

### Business Logic Layer (Bean Methods)
All incentive-related database operations are now in `billing.billingBean`:

**Location:** [WEB-INF/classes/billing/billingBean.java](billing/WEB-INF/classes/billing/billingBean.java)

#### Methods Added:

1. **`saveIncentive(userId, amount, reason, notes, entryDate, createdBy)`**
   - Saves a new incentive entry to the database
   - Returns: boolean (true if successful)
   - Parameters:
     - `userId` - User ID receiving the incentive
     - `amount` - Incentive amount
     - `reason` - Reason for incentive
     - `notes` - Additional notes (optional)
     - `entryDate` - Date of entry
     - `createdBy` - User ID who created the entry

2. **`getIncentiveReport(fromDate, toDate, userId)`**
   - Retrieves incentive records for reporting
   - Returns: Vector of incentive data
   - Parameters:
     - `fromDate` - Start date
     - `toDate` - End date
     - `userId` - User filter (null/"all" for all users)

3. **`getIncentiveTotal(fromDate, toDate, userId)`**
   - Calculates total incentive amount for a period
   - Returns: double (total amount)

4. **`getIncentiveCount(fromDate, toDate, userId)`**
   - Counts total incentive records for a period
   - Returns: int (record count)

## Files Created

### 1. Database Schema
**Location:** [database/create_incentive_table.sql](billing/database/create_incentive_table.sql)
- Creates `incentive` table to store incentive records
- Fields: user_id, amount, reason, notes, entry_date, created_at, created_by
- Includes proper foreign keys and indexes

### 2. Incentive Entry Form
**Location:** [admin/incentive/page.jsp](billing/admin/incentive/page.jsp)
- User-friendly form to add incentive entries
- Features:
  - Select user from dropdown
  - Enter amount, reason, notes, and date
  - Form validation
  - Success/error alerts
  - Auto-reset after successful entry

### 3. Save Incentive Backend
**Location:** [admin/incentive/saveIncentive.jsp](billing/admin/incentive/saveIncentive.jsp)
- Handles form submission
- Validates all inputs
- Saves data to database
- Returns JSON response

### 4. Incentive Report
**Location:** [attendance/incentiveReport.jsp](billing/attendance/incentiveReport.jsp)
- Comprehensive reporting interface
- Features:
  - Date range filter (from/to date)
  - User filter (specific user or all users)
  - Summary statistics (total records, total amount, average)
  - Detailed table with all incentive records
  - Export to Excel functionality
  - Responsive design

### 5. Navigation Updates
**Location:** [assets/navbar/navbar.jsp](billing/assets/navbar/navbar.jsp)
- Added "Incentive Entry" link under Admin menu (permission ID: 7)
- Added "Incentive Report" link under Attendance menu (permission ID: 13)

## Setup Instructions

### Step 1: Create Database Table
Run the SQL script to create the incentive table:
```sql
-- Execute this in your database
source billing/database/create_incentive_table.sql
```

Or manually run:
```sql
CREATE TABLE IF NOT EXISTS incentive (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reason VARCHAR(255) NOT NULL,
    notes TEXT,
    entry_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);
```

### Step 2: Access the Features

#### Incentive Entry (Admin Menu)
- Navigate to: **Admin → Incentive Entry**
- Requires permission ID: 7 (Admin permissions)
- URL: `/billing/admin/incentive/page.jsp`

#### Incentive Report (Attendance Menu)
- Navigate to: **Attendance → Incentive Report**
- Requires permission ID: 13 (Attendance permissions)
- URL: `/billing/attendance/incentiveReport.jsp`

## Features

### Incentive Entry
1. **User Selection**: Dropdown populated with all active users
2. **Amount**: Numeric input with decimal support
3. **Reason**: Text field for incentive reason (max 255 chars)
4. **Notes**: Optional textarea for additional details
5. **Date**: Date picker with today's date as default
6. **Validation**: All required fields validated before submission
7. **Feedback**: Success/error messages with auto-hide

### Incentive Report
1. **Filters**:
   - From Date / To Date range
   - User filter (all users or specific user)
   
2. **Summary Cards**:
   - Total number of records
   - Total incentive amount
   - Average incentive per record
   
3. **Data Table**:
   - Date, User, Amount, Reason, Notes
   - Created by and creation timestamp
   - Color-coded badges for better readability
   
4. **Export**:
   - Export to Excel (.xls format)
   - Includes summary data and full table

## Permissions Required

- **Incentive Entry**: Admin permission (ID: 7)
- **Incentive Report**: Attendance permission (ID: 13)

## Database Schema Details

```sql
Table: incentive
├── id (INT, AUTO_INCREMENT, PRIMARY KEY)
├── user_id (INT, FK → users.id)
├── amount (DECIMAL(10,2))
├── reason (VARCHAR(255))
├── notes (TEXT, NULLABLE)
├── entry_date (DATE)
├── created_at (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
└── created_by (INT, FK → users.id)
```

## Usage Example

### Adding an Incentive:
1. Go to Admin → Incentive Entry
2. Select employee from dropdown
3. Enter amount (e.g., 5000.00)
4. Enter reason (e.g., "Sales Target Achievement - Q2 2026")
5. Add notes if needed
6. Select date (defaults to today)
7. Click "Save Incentive"

### Viewing Report:
1. Go to Attendance → Incentive Report
2. Select date range
3. Optionally filter by specific user
4. Click "Search"
5. View summary statistics and detailed records
6. Export to Excel if needed

## Technical Notes

- **MVC Architecture**: All database operations handled in billingBean (Model layer)
- **Separation of Concerns**: JSP pages (View layer) use bean methods instead of direct JDBC
- Uses Bootstrap for responsive design
- Font Awesome icons for UI elements
- AJAX for asynchronous form submission
- Session-based authentication
- SQL injection prevention with PreparedStatements
- Proper error handling and user feedback
- Mobile-responsive design
- Connection pooling via DBConnectionManager

## Future Enhancements (Optional)

- Edit/Delete incentive records
- Approval workflow for incentives
- Email notifications
- Monthly/yearly incentive summaries
- Integration with payroll system
- Incentive types/categories
- Bulk upload via CSV/Excel
