# Базовий образ Ubuntu (ARM64)
FROM ubuntu:22.04

# Вимикаємо інтерфейс запитів, оновлюємо систему та встановлюємо пакети
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y systemd systemd-sysv \
    openssh-server ufw fail2ban sudo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
# Створюємо каталог для змонтованого тому
RUN mkdir -p /mnt/volume /mnt/external

# Вказуємо Docker, що запускатися буде системний init (systemd)
ENTRYPOINT ["/sbin/init"]
