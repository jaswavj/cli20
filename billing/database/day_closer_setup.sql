-- Day Closer table setup
CREATE TABLE IF NOT EXISTS day_closer (
    id                     INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    closer_date            DATE         NOT NULL UNIQUE,
    opening_balance        DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    closing_balance        DECIMAL(12,2) NULL,
    total_sale             DECIMAL(12,2) NULL,
    purchase               DECIMAL(12,2) NULL,
    expense                DECIMAL(12,2) NULL,
    notes                  TEXT          NULL,
    opening_bal_datetime   DATETIME      NOT NULL,
    closing_bal_datetime   DATETIME      NULL,
    opening_user_id        INT           NOT NULL,
    closing_user_id        INT           NULL,
    CONSTRAINT fk_dc_open_user  FOREIGN KEY (opening_user_id) REFERENCES users(id),
    CONSTRAINT fk_dc_close_user FOREIGN KEY (closing_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
