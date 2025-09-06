# GitHub Actions Best Practices pro Docker Compose

Tento dokument popisuje implementované best practices pro testování Docker Compose aplikací v GitHub Actions na základě aktuálních doporučení z roku 2024.

## 🎯 Implementované Best Practices

### 1. **QEMU pro ARM64 Emulaci**
```yaml
- name: Set up QEMU for ARM64 emulation
  uses: docker/setup-qemu-action@v3
  with:
    platforms: arm64
```
- **Výhoda**: Umožňuje testovat ARM64 obrazy na x86_64 runnerech
- **Použití**: Pro testování Raspberry Pi aplikací bez nutnosti ARM64 runnerů

### 2. **Docker Buildx s Cache**
```yaml
- name: Build Docker image for ARM64
  uses: docker/build-push-action@v5
  with:
    cache-from: type=gha
    cache-to: type=gha,mode=max
```
- **Výhoda**: Rychlejší buildy díky cache mezi workflow runy
- **Použití**: Optimalizace build času pro velké aplikace

### 3. **Health Checks v Docker Compose**
```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  interval: 10s
  timeout: 5s
  retries: 5
  start_period: 30s
```
- **Výhoda**: Spolehlivé čekání na připravenost služeb
- **Použití**: Zajištění, že testy běží až když jsou služby připravené

### 4. **Testovací Kontejner**
```yaml
test:
  build: context: .
  command: |
    sh -c "
      until curl -f http://web:3000/health 2>/dev/null; do sleep 2; done &&
      until curl -f http://nginx:80/health 2>/dev/null; do sleep 2; done &&
      curl -f http://nginx:80/health &&
      curl -f -I http://nginx:80/
    "
  depends_on:
    web:
      condition: service_healthy
```
- **Výhoda**: Testování uvnitř Docker sítě
- **Použití**: Spolehlivější testování než externí curl

### 5. **Proper Service Dependencies**
```yaml
depends_on:
  db:
    condition: service_healthy
  redis:
    condition: service_healthy
```
- **Výhoda**: Zajištění správného pořadí startování
- **Použití**: Aplikace se spustí až když jsou databáze a Redis připravené

### 6. **Timeout a Retry Logic**
```bash
timeout 60 bash -c 'until curl -f http://localhost:3001/health 2>/dev/null; do sleep 3; done'
```
- **Výhoda**: Robustní čekání na služby s timeoutem
- **Použití**: Zabránění nekonečnému čekání

## 🔄 Workflow Struktura

### Sekvence testů:
1. **Rubocop** - Kontrola kódu
2. **Unit Tests** - Testy s PostgreSQL a Redis
3. **Feature Tests** - End-to-end testy
4. **Docker Build** - Build ARM64 obrazu s QEMU
5. **Docker Compose Test** - Development prostředí
6. **Production Docker Test** - Produkční prostředí s testovacím kontejnerem

### Výhody této struktury:
- ✅ **Paralelní běh** - Některé testy běží současně
- ✅ **Fail Fast** - Při chybě se zastaví další kroky
- ✅ **Comprehensive** - Testuje všechny aspekty aplikace
- ✅ **Production Ready** - Ověří produkční prostředí

## 🚀 Optimalizace Performance

### 1. **Cache Strategy**
- Docker layer cache mezi buildy
- Bundle cache pro Ruby gems
- Node modules cache

### 2. **Resource Limits**
```yaml
deploy:
  resources:
    limits:
      memory: 1G
    reservations:
      memory: 512M
```
- **Výhoda**: Kontrola využití zdrojů
- **Použití**: Stabilní běh v omezeném prostředí

### 3. **Parallel Execution**
- Unit a feature testy běží paralelně
- Docker build běží nezávisle
- Production test čeká na dokončení předchozích

## 🛠️ Debugging a Monitoring

### 1. **Comprehensive Logging**
```yaml
- name: Check application logs
  if: failure()
  run: |
    docker-compose -f docker-compose.prod.yml logs web
    docker-compose -f docker-compose.prod.yml logs db
    docker-compose -f docker-compose.prod.yml logs redis
    docker-compose -f docker-compose.prod.yml logs nginx
```

### 2. **Service Status Monitoring**
```yaml
- name: Check production services status
  run: |
    docker-compose -f docker-compose.prod.yml ps
    docker-compose -f docker-compose.prod.yml exec -T db pg_isready -U postgres
    docker-compose -f docker-compose.prod.yml exec -T redis redis-cli ping
```

### 3. **Health Check Endpoints**
- `/health` endpoint pro všechny služby
- Automatické testování dostupnosti
- Graceful degradation při chybách

## 🔧 Troubleshooting

### Časté problémy a řešení:

#### 1. **ARM64 Build Failures**
```yaml
# Řešení: Přidat QEMU setup
- name: Set up QEMU for ARM64 emulation
  uses: docker/setup-qemu-action@v3
```

#### 2. **Service Not Ready**
```yaml
# Řešení: Proper health checks
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  start_period: 30s
```

#### 3. **Memory Issues**
```yaml
# Řešení: Resource limits
deploy:
  resources:
    limits:
      memory: 1G
```

#### 4. **Slow Builds**
```yaml
# Řešení: Cache strategy
cache-from: type=gha
cache-to: type=gha,mode=max
```

## 📊 Metriky a Monitoring

### Sledované metriky:
- **Build Time**: Doba sestavení Docker obrazů
- **Test Duration**: Doba běhu všech testů
- **Success Rate**: Procento úspěšných workflow runů
- **Resource Usage**: Využití CPU a paměti

### Optimalizace:
- Cache hit rate pro Docker layers
- Parallel execution efficiency
- Resource utilization patterns

## 🎯 Výsledky

Tato implementace poskytuje:
- ✅ **Spolehlivé testování** - Robustní health checks a dependencies
- ✅ **Rychlé buildy** - Optimalizované cache a paralelní běh
- ✅ **Production ready** - Testování skutečného produkčního prostředí
- ✅ **ARM64 kompatibilita** - QEMU emulace pro Raspberry Pi
- ✅ **Comprehensive coverage** - Testování všech komponent aplikace
- ✅ **Easy debugging** - Detailní logy a monitoring

Workflow je připraven pro produkční nasazení a poskytuje vysokou míru spolehlivosti při testování Docker Compose aplikací.
