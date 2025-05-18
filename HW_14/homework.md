## 1. Встановлення MongoDB на Ubuntu

```bash
sudo apt update
sudo apt install -y mongodb
sudo systemctl start mongodb
sudo systemctl enable mongodb
sudo systemctl status mongodb
```

## 2. Підключення до MongoDB shell

```bash
mongo
```

## 3. Створення бази та колекцій, додавання даних

```js
use gymDatabase

db.clients.insertMany([
  { client_id: 1, name: "Іван", age: 25, email: "ivan@example.com" },
  { client_id: 2, name: "Олена", age: 35, email: "olena@example.com" },
  { client_id: 3, name: "Петро", age: 40, email: "petro@example.com" }
])

db.memberships.insertMany([
  { membership_id: 1, client_id: 1, start_date: "2024-01-01", end_date: "2024-12-31", type: "standard" },
  { membership_id: 2, client_id: 2, start_date: "2024-02-01", end_date: "2024-08-01", type: "vip" }
])

db.workouts.insertMany([
  { workout_id: 1, description: "Силове тренування", difficulty: "high" },
  { workout_id: 2, description: "Кардіо", difficulty: "medium" },
  { workout_id: 3, description: "Стретчинг", difficulty: "easy" }
])

db.trainers.insertMany([
  { trainer_id: 1, name: "Максим", specialization: "Сила" },
  { trainer_id: 2, name: "Ірина", specialization: "Кардіо" }
])
```

## 4. Запити

### 1. Клієнти старше 30

```js
db.clients.find({ age: { $gt: 30 } })
```
**Результат:**  
![Клієнти старше 30](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/ff8c44c6-d30c-47d1-6fc9-f3030a312e00/public)

---

### 2. Тренування із середньою складністю

```js
db.workouts.find({ difficulty: "medium" })
```
**Результат:**  
![Тренування із середньою складністю](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/90dc2329-e476-4d1f-618e-403b711f3500/public)

---

### 3. Членство клієнта з client_id = 2

```js
db.memberships.find({ client_id: 2 })
```
**Результат:**  
![Членство клієнта з client_id = 2](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/34022ccf-3070-48d0-a38f-1a2a6ca64c00/public)