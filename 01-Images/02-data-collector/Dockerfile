FROM python:3.9-slim

WORKDIR /app

COPY app.py .
COPY templates ./templates
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

ENV INSTANCE_HOST=34.155.89.232
ENV DB_USER="cloudrun-user"
ENV DB_PASS="test"
ENV DB_NAME="measurements"
ENV DB_PORT=3306

CMD ["python", "app.py"]
