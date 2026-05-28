-- Add Shift 2 columns to attendance table
ALTER TABLE attendance
    ADD COLUMN in_time2  TIME NULL DEFAULT NULL AFTER out_time,
    ADD COLUMN out_time2 TIME NULL DEFAULT NULL AFTER in_time2;
