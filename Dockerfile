FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel

# 1. تثبيت أدوات النظام الضرورية (ffmpeg للصوت و git للتحميل)
# هذا الجزء ضروري جداً لتشغيل Fish Speech
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ffmpeg \
    libasound2-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2. نسخ وتثبيت المكتبات (هذا هو تعديلك الرائع) ✅
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 3. تحميل كود Fish Speech (أعدنا هذه الخطوة لأننا نحتاج المحرك)
RUN git clone https://github.com/fishaudio/fish-speech.git

# 4. الدخول لمجلد المشروع وتثبيته
WORKDIR /app/fish-speech
RUN pip install .

# 5. العودة للمجلد الرئيسي
WORKDIR /app
