
# Домашнє завдання №6 — Advanced Linux

> Примітка: маю Windows на ARM-чіпі — VirtualBox не підтримується, тому попередні 2 домашки були для мене проблемні. У цій домашці буду використовувати Docker — він нормально підтримується на Windows ARM.  
> Розумію, що Docker != віртуалка і це різні речі, але щоб швидко отримати Unix-sandbox у себе на ПК, це напевно єдиний зручний варіант.

---

## Крок 0: Налаштування Docker (не без chatgpt)

- Створили 2 конфіг файли
- Підняли контейнер:
  ```
  docker run -it --privileged --name ubuntu_systemd_container ubuntu_systemd_image bash
  ```
- Чекаємо що systemd працює:
  ```
  ps -p 1 -o comm=
  ```
  (бачимо systemd)

**P.S.** Не все я розумію що тут відбувається, але працює :) Задача наша не пов'язана з Docker, тож йдемо далі.

---

## Крок 1: Залежності

- Оновлюємо залежності:
  ```
  apt update
  ```
- Інсталюємо nano для зручності:
  ```
  apt install nano
  ```
- Для роботи з PPA репозиторіями:
  ```
  apt install software-properties-common -y
  ```

---

## Крок 2: Nginx

- Додаємо репо:
  ```
  add-apt-repository ppa:ondrej/nginx
  ```
- Оновлюємо залежності:
  ```
  apt update
  ```
- Інсталюємо nginx:
  ```
  apt install nginx
  ```
- Перевіряємо:
  ```
  nginx -v
  ```
  > nginx version: nginx/1.26.3

---

## Крок 3: Створення systemd-сервісу

### 3.1 Створюємо мінімальний скрипт

- Скрипт `/usr/local/bin/time-loop.sh`
  ```bash
  #!/bin/bash
  while true; do
    echo "$(date '+%Y-%m-%d %H:%M:%S')" >> /var/log/time-logger.log
    sleep 60
  done
  ```

- Права на виконання скрипту:
  ```
  chmod +x /usr/local/bin/time-loop.sh
  ```

### 3.2 Створення юніт-файлу служби

- `nano /etc/systemd/system/time-loop.service`
  ```
  [Unit]
  Description=Loop time logger

  [Service]
  ExecStart=/usr/local/bin/time-loop.sh
  Restart=always

  [Install]
  WantedBy=multi-user.target
  ```

- Перезавантажуємо демон, щоб ще раз прочитати усі юніт-файли:
  ```
  systemctl daemon-reload
  ```

- Запускаємо свій сервіс:
  ```
  systemctl enable --now time-loop.service
  ```

- Перевіряємо роботу:
  ```
  systemctl status time-loop.service
  cat /var/log/time-logger.log
  ```

---

## Крок 4: Налаштування брандмауера UFW: дозволи і блокування для SSH

- Інсталюємо файрвол:
  ```
  apt-get install -y ufw
  ```

- Вмикаємо:
  ```
  ufw enable
  ```

- Заборонити всі вхідні за замовчуванням:
  ```
  ufw default deny incoming
  ```

- Дозволити всі вихідні:
  ```
  ufw default allow outgoing
  ```

- Дозволити SSH лише для IP 176.98.21.206:
  ```
  ufw allow from 176.98.21.206 to any port 22 proto tcp
  ```

- Заборона доступу для IP 203.0.113.100:
  ```
  ufw deny from 203.0.113.100 to any port 22 proto tcp
  ```

- Перевіряємо правила:
  ```
  ufw status verbose
  ```

---

## Крок 5: Fail2Ban та SSH

- Дозволяємо запуск SSH при старті:
  ```
  systemctl enable ssh
  ```

- Запускаємо разово:
  ```
  systemctl start ssh
  ```

- Інсталюємо fail2ban:
  ```
  apt-get install -y fail2ban
  ```

- Створюємо файл налаштувань `/etc/fail2ban/jail.local`:
  ```
  [sshd]
  enabled = true
  port    = 22
  filter  = sshd
  logpath = /var/log/auth.log
  maxretry = 5
  ```

- Запуск та увімкнення Fail2Ban:
  ```
  systemctl daemon-reload
  systemctl enable fail2ban  # дозволяємо автозапуск
  systemctl start fail2ban   # запускаємо сервіс зараз
  ```

- Перевірка сервісу:
  ```
  systemctl status fail2ban
  ```

> ⚠️ Сервіс не працює, бо як виявилось — це погана ідея робити в контейнері. Тож поки так, але шлях, сподіваюсь, правильний пройшов.

---

## Крок 6: Змонтувати диск

Схоже, теж погана ідея робити це в Docker, але:

- Створення порожнього файлу-образу розміром 50 МБ:
  ```
  dd if=/dev/zero of=/mnt/volume/virtualdisk.img bs=1M count=50
  ```

- Відформатуємо файл як ext4-розділ:
  ```
  mkfs.ext4 /mnt/volume/virtualdisk.img
  ```

- Створюємо каталог-точку монтування:
  ```
  mkdir -p /mnt/external
  ```

- Монтуємо:
  ```
  mount -o loop /mnt/volume/virtualdisk.img /mnt/external
  ```

- Перевіряємо:
  ```
  df -h | grep /mnt/external
  ```

  Очікуваний результат:
  ```
  /dev/loop2       43M   24K   40M   1% /mnt/external
  ```

- Редагуємо автоматичне монтування:
  ```
  nano /etc/fstab
  ```

  Додаємо рядок у кінець файлу:
  ```
  /mnt/volume/virtualdisk.img   /mnt/external   ext4   loop   defaults   0 0
  ```

- Перевіряємо:
  ```
  umount /mnt/external
  mount -a
  ls /mnt/external
  ```
