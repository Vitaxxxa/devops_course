## 1. Створення бази даних та таблиць

```sql
CREATE DATABASE SchoolDB CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE SchoolDB;

CREATE TABLE Institutions (
  institution_id INT AUTO_INCREMENT PRIMARY KEY,
  institution_name VARCHAR(255) NOT NULL,
  institution_type ENUM('School', 'Kindergarten') NOT NULL,
  address VARCHAR(255) NOT NULL
);

CREATE TABLE Classes (
  class_id INT AUTO_INCREMENT PRIMARY KEY,
  class_name VARCHAR(50) NOT NULL,
  institution_id INT,
  direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies') NOT NULL,
  FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id) ON DELETE CASCADE
);

CREATE TABLE Children (
  child_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  birth_date DATE NOT NULL,
  year_of_entry INT NOT NULL,
  age INT NOT NULL,
  institution_id INT,
  class_id INT,
  FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id) ON DELETE CASCADE,
  FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE SET NULL
);

CREATE TABLE Parents (
  parent_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  child_id INT,
  tuition_fee DECIMAL(10,2),
  FOREIGN KEY (child_id) REFERENCES Children(child_id) ON DELETE CASCADE
);
```

## 2. Наповнення таблиць тестовими даними

```sql
INSERT INTO Institutions (institution_name, institution_type, address) VALUES
  ('Kyiv Gymnasium No. 1', 'School', 'Kyiv, Khreshchatyk 1'),
  ('Dnipro Kindergarten "Sonechko"', 'Kindergarten', 'Dnipro, Shevchenka 5'),
  ('Lviv School No. 23', 'School', 'Lviv, Franka 10');

INSERT INTO Classes (class_name, institution_id, direction) VALUES
  ('5-A', 1, 'Mathematics'),
  ('Group "Bee"', 2, 'Language Studies'),
  ('8-B', 3, 'Biology and Chemistry');

INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id) VALUES
  ('Ivan', 'Petrenko', '2012-04-21', 2019, 12, 1, 1),
  ('Maria', 'Koval', '2018-09-14', 2023, 6, 2, 2),
  ('Oleh', 'Shevchuk', '2011-02-05', 2018, 13, 3, 3);

INSERT INTO Parents (first_name, last_name, child_id, tuition_fee) VALUES
  ('Olena', 'Petrenko', 1, 1500.00),
  ('Taras', 'Koval', 2, 1200.00),
  ('Iryna', 'Shevchuk', 3, 1600.00);
```

![SchoolDB 1](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/631d8dd9-2ec5-4ef8-e681-c23d01fb1200/public)
![SchoolDB 2](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/a6159670-bdea-4435-5baa-36319bf4bd00/public)
![SchoolDB 3](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/563849b0-84aa-4b6f-86ad-cfea4190dd00/public)
![SchoolDB 4](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/3b78d89f-3729-400d-6516-68430786da00/public)
![SchoolDB 5](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/c52579ac-302e-4c8b-2ed1-eecbab22a400/public)

## 3. Вибірки (SELECT-запити)

### 3.1 Список всіх дітей з закладом і напрямом

```sql
SELECT
  c.first_name,
  c.last_name,
  i.institution_name,
  cl.class_name,
  cl.direction
FROM
  Children c
  JOIN Institutions i ON c.institution_id = i.institution_id
  JOIN Classes cl ON c.class_id = cl.class_id;
```

![SchoolDB 6](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/76181f67-85dc-4625-8d00-c94270a16e00/public)

### 3.2 Батьки та їх діти + вартість навчання

```sql
SELECT
  p.first_name AS parent_first_name,
  p.last_name AS parent_last_name,
  ch.first_name AS child_first_name,
  ch.last_name AS child_last_name,
  p.tuition_fee
FROM
  Parents p
  JOIN Children ch ON p.child_id = ch.child_id;
```

![SchoolDB 7](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/75ca94a1-cf40-499e-ece0-efd386117600/public)

### 3.3 Заклади з адресами та кількістю дітей

```sql
SELECT
  i.institution_name,
  i.address,
  COUNT(c.child_id) AS children_count
FROM
  Institutions i
  LEFT JOIN Children c ON i.institution_id = c.institution_id
GROUP BY i.institution_id;
```

![SchoolDB 6](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/cef55160-da7d-495e-6661-a788a491c200/public)

## 4. Бекап та відновлення

- **Створення дампу:**
    ```bash
    mysqldump -u root -p SchoolDB > SchoolDB_backup.sql
    ```
- **Відновлення в нову базу:**
    ```bash
    mysql -u root -p -e "CREATE DATABASE SchoolDB_copy"
    mysql -u root -p SchoolDB_copy < SchoolDB_backup.sql
    ```