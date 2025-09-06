# Docker Setup pro Quizzes aplikaci

Tento projekt je připraven pro spuštění v Docker kontejnerech s PostgreSQL, Redis a Nginx, optimalizovaný pro Raspberry Pi 5.

## Požadavky

- Docker a Docker Compose
- Raspberry Pi 5 (nebo jiný ARM64 systém)
- Minimálně 2GB RAM

## Rychlé spuštění

### 1. Klonování a příprava

**Pro development:**
```bash
git clone <repository-url>
cd quizes
cp env.example .env
```

**Pro production:**
```bash
git clone <repository-url>
cd quizes
cp env.production.example .env
# Upravte .env soubor podle potřeby
```

### WSL/AMD testování

Pro testování ve WSL na AMD procesoru použijte:

```bash
# WSL kompatibilní verze
docker-compose -f docker-compose.wsl.yml up --build

# Nebo standardní verze (bez ARM64 platform)
docker-compose up --build
```

Více informací o WSL testování najdete v [WSL_TESTING.md](WSL_TESTING.md).

### 2. Úprava .env souboru

**Pro development:**
```bash
# Database configuration
DATABASE=quizzes
POSTGRES_HOST=db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password
POSTGRES_PORT=5432

# Rails configuration
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_base_here
```

**Pro production:**
```bash
# Database configuration
DATABASE=quizzes_production
POSTGRES_HOST=db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_production_password
POSTGRES_PORT=5432

# Rails configuration
RAILS_ENV=production
SECRET_KEY_BASE=your_secure_production_secret_key_base
```

**Generování SECRET_KEY_BASE:**
```bash
# Po spuštění kontejnerů
docker-compose exec web bundle exec rails secret
```

### 3. Spuštění aplikace

#### Development prostředí:
```bash
docker-compose up --build
```

#### Production prostředí:

**Pro GitHub Actions a testování (x86_64):**
```bash
docker-compose -f docker-compose.prod.yml up --build -d
```

**Pro Raspberry Pi 5 (ARM64):**
```bash
docker-compose -f docker-compose.prod.pi.yml up --build -d
```

## Porty a domény

Aplikace běží na následujících portech (optimalizováno pro sdílené prostředí):

- **Web aplikace**: http://localhost:3001
- **Nginx (HTTP)**: http://localhost:8080 nebo http://smartiestapps.quizzes.com:8080
- **Nginx (HTTPS)**: https://localhost:8443 nebo https://smartiestapps.quizzes.com:8443
- **PostgreSQL**: localhost:5433
- **Redis**: localhost:6380

### Doména

Aplikace je nakonfigurována pro doménu `smartiestapps.quizzes.com` a bude dostupná na:
- **HTTP**: http://smartiestapps.quizzes.com:8080
- **HTTPS**: https://smartiestapps.quizzes.com:8443 (po nastavení SSL certifikátů)

## Struktura služeb

### Web (Rails aplikace)
- Port: 3001 (externí) → 3000 (interní)
- Závisí na PostgreSQL a Redis
- Automatické migrace při startu

### PostgreSQL
- Port: 5433 (externí) → 5432 (interní)
- Persistentní data v `postgres_data` volume
- Health check pro spolehlivé startování

### Redis
- Port: 6380 (externí) → 6379 (interní)
- Persistentní data v `redis_data` volume
- Používá se pro Action Cable a caching

### Nginx
- Porty: 8080 (HTTP), 8443 (HTTPS)
- Proxy pro Rails aplikaci
- Statické soubory a asset pipeline
- WebSocket podpora pro Action Cable

## Užitečné příkazy

### Zobrazení logů
```bash
docker-compose logs -f web
docker-compose logs -f db
docker-compose logs -f redis
docker-compose logs -f nginx
```

### Připojení k databázi
```bash
docker-compose exec db psql -U postgres -d quizzes
```

### Připojení k Redis
```bash
docker-compose exec redis redis-cli
```

### Spuštění Rails konzole
```bash
docker-compose exec web bundle exec rails console
```

### Spuštění migrací
```bash
docker-compose exec web bundle exec rails db:migrate
```

### Restart služeb
```bash
docker-compose restart web
docker-compose restart nginx
```

## Optimalizace pro Raspberry Pi 5

- Všechny služby používají ARM64 platformu
- Memory limity pro efektivní využití RAM
- Alpine Linux images pro menší velikost
- Optimalizované porty pro sdílené prostředí

## Troubleshooting

### Problém s pamětí
Pokud máte problémy s pamětí, upravte memory limity v `docker-compose.prod.yml`:

```yaml
deploy:
  resources:
    limits:
      memory: 512M  # Snižte podle potřeby
```

### Problém s porty
Pokud porty kolidují s jinými aplikacemi, upravte je v `docker-compose.yml`:

```yaml
ports:
  - "3002:3000"  # Změňte externí port
```

### Problém s databází
Pokud se databáze nespustí, zkontrolujte:

```bash
docker-compose logs db
docker-compose exec db pg_isready -U postgres
```

## Backup a obnova

### Backup databáze
```bash
docker-compose exec db pg_dump -U postgres quizzes > backup.sql
```

### Obnova databáze
```bash
docker-compose exec -T db psql -U postgres quizzes < backup.sql
```

## Monitoring

### Health check endpointy
- Nginx: http://localhost:8080/health
- Rails: http://localhost:3001/health (pokud implementováno)

### Zobrazení využití zdrojů
```bash
docker stats
```
