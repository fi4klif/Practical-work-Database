-- Задача 1. Створення тригирів (ексклюзивність власника контракту + контроль дат)
USE publishing;
-- ===============================
-- Triggers to enforce business rules in MySQL
-- (ексклюзивність власника контракту + контроль дат)
-- ===============================

DELIMITER $$

CREATE TRIGGER trg_contracts_bi
BEFORE INSERT ON Contracts
FOR EACH ROW
BEGIN
  -- рівно одне з AuthorID/EmployeeID має бути NOT NULL
  IF (NEW.AuthorID IS NULL AND NEW.EmployeeID IS NULL)
     OR (NEW.AuthorID IS NOT NULL AND NEW.EmployeeID IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exactly one of AuthorID or EmployeeID must be set';
  END IF;

-- ContractType має відповідати встановленому FK
  IF (NEW.AuthorID IS NOT NULL AND NEW.ContractType <> 'Author')
     OR (NEW.EmployeeID IS NOT NULL AND NEW.ContractType <> 'Employee') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ContractType must match owner (Author/Employee)';
  END IF;

  -- Перевірка дат
  IF NEW.EndDate IS NOT NULL AND NEW.EndDate < NEW.StartDate THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EndDate must be >= StartDate';
  END IF;
END$$

CREATE TRIGGER trg_contracts_bu
BEFORE UPDATE ON Contracts
FOR EACH ROW
BEGIN
  IF (NEW.AuthorID IS NULL AND NEW.EmployeeID IS NULL)
     OR (NEW.AuthorID IS NOT NULL AND NEW.EmployeeID IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exactly one of AuthorID or EmployeeID must be set';
  END IF;

  IF (NEW.AuthorID IS NOT NULL AND NEW.ContractType <> 'Author')
     OR (NEW.EmployeeID IS NOT NULL AND NEW.ContractType <> 'Employee') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ContractType must match owner (Author/Employee)';
  END IF;

  IF NEW.EndDate IS NOT NULL AND NEW.EndDate < NEW.StartDate THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'EndDate must be >= StartDate';
  END IF;
END$$

DELIMITER ;


-- Задача 2. Створіть тригери BEFORE INSERT і BEFORE UPDATE
-- (Це деталізована версія першого тригера з коментарями)

-- Змінюємо роздільник команд, щоб у тілі тригера можна було використовувати крапку з комою
DELIMITER $$

-- Створюємо тригер, який спрацьовує перед вставкою нового запису у таблицю Contracts
CREATE TRIGGER trg_contracts_bi
BEFORE INSERT ON Contracts
FOR EACH ROW
BEGIN
  -----------------------------------------------------------------
  -- 1️⃣ Перевірка власника контракту
  -----------------------------------------------------------------
  -- Контракт повинен належати або автору, або співробітнику, але не обом одночасно.
  IF (NEW.AuthorID IS NULL AND NEW.EmployeeID IS NULL)
     OR (NEW.AuthorID IS NOT NULL AND NEW.EmployeeID IS NOT NULL) THEN

    -- SIGNAL SQLSTATE '45000' — створює користувацьку помилку (зупиняє виконання INSERT)
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Exactly one of AuthorID or EmployeeID must be set';
  END IF;

  -----------------------------------------------------------------
  -- 2️⃣ Перевірка правильності типу контракту
  -----------------------------------------------------------------
  -- Якщо контракт належить автору, ContractType має бути "Author".
  -- Якщо контракт належить співробітнику, ContractType має бути "Employee".
  IF (NEW.AuthorID IS NOT NULL AND NEW.ContractType <> 'Author')
     OR (NEW.EmployeeID IS NOT NULL AND NEW.ContractType <> 'Employee') THEN

    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'ContractType must match owner (Author/Employee)';
  END IF;

  -----------------------------------------------------------------
  -- 3️⃣ Перевірка послідовності дат
  -----------------------------------------------------------------
  -- Кінцева дата (EndDate) не може бути раніше дати початку (StartDate).
  IF NEW.EndDate IS NOT NULL AND NEW.EndDate < NEW.StartDate THEN

    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'EndDate must be >= StartDate';
  END IF;

END$$

-- Повертаємо стандартний роздільник команд
DELIMITER ;


-- Задача 3. Перевірка роботи тригерів

-- коректна вставка
INSERT INTO Contracts (AuthorID, ContractType, StartDate, EndDate)
VALUES (1, 'Author', '2025-06-01', '2025-12-31');

-- помилка 1: два власники
INSERT INTO Contracts (AuthorID, EmployeeID, ContractType, StartDate)
VALUES (1, 1, 'Author', '2025-06-01');

-- помилка 2: неправильний тип
INSERT INTO Contracts (AuthorID, ContractType, StartDate)
VALUES (1, 'Employee', '2025-06-01');

-- помилка 3: неправильні дати
INSERT INTO Contracts (AuthorID, ContractType, StartDate, EndDate)
VALUES (1, 'Author', '2025-12-01', '2025-01-01');


-- Задача 4. Аналітична перевірка
-- Перевірте актуальні контракти:

SELECT ContractID, ContractType, StartDate, EndDate
FROM Contracts
ORDER BY StartDate DESC;