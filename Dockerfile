FROM python:3.13-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    ffmpeg \
    poppler-utils \
    fonts-noto-cjk \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY requirements.txt .
COPY src/ ./src/

# 安装 Python 依赖
RUN pip install --no-cache-dir -r requirements.txt

# 安装 Playwright 浏览器
RUN playwright install chromium
RUN playwright install firefox
RUN playwright install webkit

# 创建必要的目录
RUN mkdir -p config logs

# 复制示例配置文件
COPY example_config/ ./example_config/

# 设置环境变量
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1

# 暴露端口（如果需要）
EXPOSE 8080

# 启动命令
CMD ["nb", "run"]
