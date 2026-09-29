# استخدم نسخة Python خفيفة
FROM python:3.11-slim

# حدد مجلد العمل
WORKDIR /app

# تثبيت الحزم الأساسية اللازمة لبناء بعض المكتبات
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libfreetype6-dev \
    libpng-dev \
    libgomp1 \
    gdal-bin \
    libgdal-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

# انسخ ملف المتطلبات
COPY requirements.txt .

# ثبت الـ dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# انسخ كل ملفات المشروع
COPY . .

# أنشئ مجلدات للرفع والتصورات
RUN mkdir -p static/uploads static/visualizations templates

# افتح البورت
EXPOSE 7860

# إعدادات البيئة
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py

# أمر التشغيل باستخدام Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:7860", "--workers", "1", "--timeout", "120", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
