FROM python:alpine AS api
WORKDIR /app
RUN pip install --no-cache-dir --upgrade pip
COPY requirements.txt .
RUN pip install --no-cache-dir --only-binary=:all: -r requirements.txt
COPY src ./src
EXPOSE 8081
EXPOSE 5432
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8081"]