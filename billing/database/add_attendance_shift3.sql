-- Add Shift 3 columns to attendance table
ALTER TABLE attendance
    ADD COLUMN in_time3  TIME NULL DEFAULT NULL AFTER out_time2,
    ADD COLUMN out_time3 TIME NULL DEFAULT NULL AFTER in_time3;
