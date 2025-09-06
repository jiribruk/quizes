# Testování ve WSL na AMD procesoru

Tento dokument popisuje, jak otestovat aplikaci ve WSL prostředí na AMD procesoru před nasazením na Raspberry Pi 5.

## Požadavky

- Windows 10/11 s WSL2
- Docker Desktop pro Windows (nebo Docker Engine ve WSL)
- AMD procesor (x86_64 architektura)

## Příprava WSL prostředí

### 1. Ověření Docker

```bash
# Ověřte, že Docker funguje
docker --version
docker-compose --version

# Ověřte, že Docker daemon běží
docker ps
```

### 2. Klonování projektu

```bash
# V WSL terminálu
cd /home/jiri/railsProjects/quizes
```

## Testování aplikace

### 1. Příprava prostředí

```bash
# Zkopírujte env soubor
cp env.example .env

# Upravte .env pro testování
nano .env
```

Doporučené nastavení pro testování:
```bash
DATABASE=quizzes_test
POSTGRES_PASSWORD=testpassword
SECRET_KEY_BASE=test_secret_key_base_for_development_only
DOMAIN=localhost
```

### 2. Spuštění s WSL kompatibilním compose

```bash
# Spuštění pro WSL/AMD testování
docker-compose -f docker-compose.wsl.yml up --build

# Nebo pro standardní testování (bez ARM64 platform)
docker-compose up --build
```

### 3. Ověření funkčnosti

```bash
# Zkontrolujte běžící kontejnery
docker-compose ps

# Zkontrolujte logy
docker-compose logs -f web
docker-compose logs -f db
docker-compose logs -f redis
docker-compose logs -f nginx
```

### 4. Testování endpointů

```bash
# Health check
curl http://localhost:8080/health

# Rails aplikace přes Nginx
curl http://localhost:8080

# Rails aplikace přímo
curl http://localhost:3001
```

## Testování s doménou

### 1. Lokální DNS override

Pro testování s doménou `smartiestapps.quizzes.com` přidejte do `/etc/hosts`:

```bash
sudo nano /etc/hosts
```

Přidejte řádek:
```
127.0.0.1 smartiestapps.quizzes.com
```

### 2. Testování s doménou

```bash
# Test s doménou
curl http://smartiestapps.quizzes.com:8080/health
```

## Očekávané chování

### ✅ Co by mělo fungovat:

1. **Docker build**: Aplikace se sestaví bez chyb
2. **Databáze**: PostgreSQL se spustí a migrace proběhnou
3. **Redis**: Redis se spustí a je dostupný
4. **Rails**: Aplikace se spustí na portu 3000 (interně)
5. **Nginx**: Proxy funguje na portu 8080
6. **Health checks**: Všechny služby projdou health check

### ⚠️ Možné problémy:

1. **ARM64 emulace**: Může být pomalejší než nativní x86_64
2. **Memory usage**: WSL může mít jiné memory limity
3. **Port conflicts**: Zkontrolujte, že porty 8080, 3001, 5433, 6380 jsou volné

## Debugging

### Časté problémy a řešení:

#### 1. Docker build selhává
```bash
# Zkontrolujte Docker daemon
sudo systemctl status docker

# Restart Docker
sudo systemctl restart docker
```

#### 2. Porty jsou obsazené
```bash
# Zkontrolujte obsazené porty
netstat -tulpn | grep :8080
netstat -tulpn | grep :3001

# Zabijte procesy na portech
sudo fuser -k 8080/tcp
sudo fuser -k 3001/tcp
```

#### 3. Databáze se nespustí
```bash
# Zkontrolujte logy databáze
docker-compose logs db

# Restart databáze
docker-compose restart db
```

#### 4. Rails aplikace se nespustí
```bash
# Zkontrolujte logy Rails
docker-compose logs web

# Připojte se do kontejneru
docker-compose exec web bash

# Spusťte Rails konzoli
docker-compose exec web bundle exec rails console
```

## Performance testování

### 1. Load testing

```bash
# Instalace Apache Bench
sudo apt-get install apache2-utils

# Test load
ab -n 100 -c 10 http://localhost:8080/
```

### 2. Memory monitoring

```bash
# Sledování využití zdrojů
docker stats

# Detailní informace o kontejneru
docker-compose exec web cat /proc/meminfo
```

## Příprava pro Raspberry Pi

Po úspěšném testování ve WSL:

1. **Commit změn**: Zavolejte všechny změny do git
2. **Uncomment ARM64**: V `docker-compose.yml` odkomentujte `platform: linux/arm64`
3. **Deploy**: Nasazení na Raspberry Pi 5

## Cleanup

```bash
# Zastavení všech služeb
docker-compose down

# Odstranění volumes (POZOR: smaže data!)
docker-compose down -v

# Odstranění images
docker system prune -a
```
