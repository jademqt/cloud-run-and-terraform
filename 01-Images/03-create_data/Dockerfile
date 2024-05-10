FROM python:3.9-slim

WORKDIR /app

COPY create_data.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV CR_URL="http://localhost:8080/"

CMD ["python3", "create_data.py"]
