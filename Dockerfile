FROM python:3.13-slim

ENV HOME=/tmp \
    ATMOS_DRIVER_CACHE=/tmp/driver-cache \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app
COPY requirements-runtime.txt .
RUN pip install --no-cache-dir -r requirements-runtime.txt
COPY . .

WORKDIR /tmp
ENTRYPOINT ["python3"]
CMD ["/app/dolby_to_easyeffects.py", "--help"]
