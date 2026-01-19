# 1. صورة النظام الأساسية (بايثون + كودا)
FROM pytorch/pytorch:2.1.0-cuda12.1-cudnn8-devel

# منع الأسئلة أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# 2. تثبيت أدوات النظام الضرورية للصوت
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ffmpeg \
    libasound-dev \
    portaudio19-dev \
    libportaudio2 \
    libportaudiocpp0 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# تحديد مجلد العمل
WORKDIR /app

# 3. تحميل كود Fish Speech (النسخة 1.5 المستقرة)
RUN git clone -b v1.5.0 https://github.com/fishaudio/fish-speech.git .

# 4. تثبيت مكتبات بايثون المطلوبة
RUN pip install --no-cache-dir -r requirements.txt
# تثبيت المكتبات الناقصة + مكتبة runpod الخاصة بالسيرفرليس
RUN pip install --no-cache-dir vector-quantize-pytorch soundfile huggingface_hub runpod

# 5. الإصلاحات الجراحية (التي قمنا بها يدوياً سابقاً)
# إصلاح مشكلة الصوت
RUN sed -i "s/torchaudio.list_audio_backends()/['soundfile']/" tools/inference_engine/reference_loader.py
# إصلاح مشكلة واجهة Gradio
RUN sed -i 's/show_api=True//g' tools/run_webui.py

# 6. أمر اختبار بسيط
CMD ["python", "--version"]
