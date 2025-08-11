# Dockerfile
FROM python:3.11-slim

# 1) Dependencias del sistema (curl para el smoke test)
# --no-install-recommends para imagen más pequeña
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && rm -rf /var/lib/apt/lists/*

# 2) Config Python y directorio
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1
WORKDIR /app

# 3) Instalar deps de Python con caché eficiente
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4) Copiar el resto del código
COPY . .

# 5) (Opcional) Ejecutar como usuario no root
#    Útil si más adelante montas volúmenes o corres en k8s
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# 6) Solo informativo para orquestadores/lectores
EXPOSE 8000

# 7) Comando de arranque
CMD ["python", "app.py"]
