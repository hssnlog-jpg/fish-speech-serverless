FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel

# إعدادات لمنع توقف التثبيت بسبب الأسئلة التفاعلية
ENV DEBIAN_FRONTEND=noninteractive

# 1. تثبيت حزمة "الكوماندوز" الكاملة (كل ما يحتاجه الصوت والنظام)
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ffmpeg \
    libasound2-dev \
    portaudio19-dev \
    libsndfile1 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. تحديث pip لتجنب مشاكل التوافق (خطوة احترازية مهمة)
RUN pip install --upgrade pip

# 3. نسخ وتثبيت المكتبات
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4. تحميل وتثبيت Fish Speech
RUN git clone https://github.com/fishaudio/fish-speech.git

WORKDIR /app/fish-speech
# التثبيت
RUN pip install .

# 5. العودة للمجلد الرئيسي
WORKDIR /app
