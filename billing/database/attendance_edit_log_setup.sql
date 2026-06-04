-- =====================================================
-- Attendance Edit Log Setup
-- Run this script once to enable attendance editing
-- =====================================================

-- Step 1: Add is_edited flag to attendance table
ALTER TABLE attendance
    ADD COLUMN is_edited TINYINT(1) NOT NULL DEFAULT 0;

-- Step 2: Create attendance edit log table
CREATE TABLE IF NOT EXISTS attendance_edit_log (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    attendance_date DATE        NOT NULL,
    employee_id     INT         NOT NULL,
    edited_by       INT         NOT NULL,
    old_in1         TIME        DEFAULT NULL,
    old_out1        TIME        DEFAULT NULL,
    old_in2         TIME        DEFAULT NULL,
    old_out2        TIME        DEFAULT NULL,
    old_in3         TIME        DEFAULT NULL,
    old_out3        TIME        DEFAULT NULL,
    new_in1         TIME        DEFAULT NULL,
    new_out1        TIME        DEFAULT NULL,
    new_in2         TIME        DEFAULT NULL,
    new_out2        TIME        DEFAULT NULL,
    new_in3         TIME        DEFAULT NULL,
    new_out3        TIME        DEFAULT NULL,
    remarks         VARCHAR(500) DEFAULT NULL,
    edited_at       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_att_date_emp  (attendance_date, employee_id),
    INDEX idx_edited_by     (edited_by),
    INDEX idx_edited_at     (edited_at)
);
