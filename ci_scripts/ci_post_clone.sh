#!/bin/sh

# Этот скрипт предназначен для Xcode Cloud (или любой другой CI-системы),
# где может не быть ни Tuist, ни mise.
# Запускается после клонирования репозитория и перед сборкой.

# ----------------------- 1️⃣ Установка/обновление Python и зависимостей -----------------------
python3 -m pip install --upgrade pip
pip3 install --upgrade python-telegram-bot

# ----------------------- 2️⃣ Установка mise -----------------------
# С помощью официального инсталлятора mise. Он установит mise в ~/.mise/bin.
# После этого нужно добавить этот путь к $PATH.
curl -sSL https://get.mise.io | bash

# Добавляем mise в PATH текущей сессии.
export PATH="$HOME/.mise/bin:$PATH"

# ----------------------- 3️⃣ Подготовка Xcode -----------------------
# (удаляем/устанавливаем нужные дефолты)
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile 2>/dev/null
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution 2>/dev/null
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# ----------------------- 4️⃣ Подготовка к запуску Tuist -----------------------
# Если mise.toml лежит в корне репозитория, переходим в него:
cd /Volumes/workspace/repository/ || exit 1

# Подтягиваем версию Tuist и других инструментов, прописанных в mise.toml
mise install

# ----------------------- 5️⃣ Запуск Tuist через mise -----------------------
mise run tuist clean
mise run tuist install
mise run tuist generate --no-open
