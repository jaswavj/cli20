-- Create incentive table for storing employee incentive records
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

-- Index for faster queries
CREATE INDEX idx_incentive_user_id ON incentive(user_id);
CREATE INDEX idx_incentive_entry_date ON incentive(entry_date);
CREATE INDEX idx_incentive_created_by ON incentive(created_by);
