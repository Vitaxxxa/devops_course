1. **Створення файлу `docker-compose.yml` з конфігурацією для трьох сервісів (nginx, postgres, redis), використанням спільної мережі `appnet` та примонтованою локальною папкою `web-app`:**

```yaml
networks:
  appnet:
    driver: bridge

volumes:
  db-data:

services:
  web:
    image: nginx:latest
    ports: 
      - "8080:80" # не зрозумів чому при масштабуванні отримую помилку що порт вже зайнятий
    volumes:
      - ./web-app:/usr/share/nginx/html:ro
    networks:
      - appnet

  db:
    image: postgres:latest
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - appnet

  cache:
    image: redis:latest
    networks:
      - appnet
```

2. **Запуск контейнерів:**

```bash
docker-compose up -d
```

![docker-compose up result](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/a8254249-728a-4712-807f-2af5e6541e00/public)

3. **Перевірка роботи вебсервера через браузер на `http://localhost:8080`.**

![Відкриття вебсервера у браузері](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/5da8e683-4216-4a82-93a5-e963ac912500/public)

4. **Перевірка стану контейнерів:**

```bash
docker-compose ps
```

![Результат підключення до бази даних у контейнері](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/0f3cc1b2-ab84-419f-3ff3-6086ce2d4900/public)

5. **Перевірка мереж Docker і томів:**

```bash
docker network ls
docker volume ls
```

![Перевірка мереж і томів Docker](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/66bfbb12-0f6b-472e-ae88-669fd68c5100/public)

6. **Підключення до бази даних всередині контейнера:**

```bash
docker exec -it hw_17-db-1 psql -U user -d mydb
```

![Підключення до бази даних у контейнері](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/0f2a919f-cc0d-41bb-9c4d-4b16ca855e00/public)

7.  **Масштабування вебсервера:**

- В `docker-compose.yml` прибрано секцію `ports` для `web`.
- Запуск трьох екземплярів:

```bash
docker-compose up -d --scale web=3
```

![Результат масштабування вебсервера](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/29756257-fa51-464a-e5f0-e58ee3c85000/public)

8. **Перевірка стану після масштабування:**

```bash
docker-compose ps
```

![Стан контейнерів після масштабування](https://imagedelivery.net/ECvmHqjoZV012XN8LGonQg/30921467-cc69-4c23-be17-66f158e80000/public)


**Проблема:** При масштабуванні трьох вебсерверів з однаковим пробросом порту 8080 виникала помилка `port is already allocated`. Недо кінця зрозумів цей момент, бо якщо не прокинути порти то при мастабуванні я не маю доступу до http://localhost:8080, а якщо прокинути то при масштабуванні не усі інстанси запускаються 