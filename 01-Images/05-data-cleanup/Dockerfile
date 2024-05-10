FROM python:3.9-slim

WORKDIR /app

COPY clean-up-data.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV INSTANCE_HOST=34.155.89.232
ENV DB_USER="cloudrun-user"
ENV DB_PASS="test"
ENV DB_NAME="measurements"
ENV DB_PORT=3306
ENV CO2_MAX=430
ENV PEM25_MAX=18
ENV OZONE_MAX=105
ENV CO2_MIN=360
ENV PEM25_MIN=8
ENV OZONE_MIN=80

CMD ["python3", "clean-up-data.py"]
