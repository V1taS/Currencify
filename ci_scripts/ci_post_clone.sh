#!/bin/sh

# Этот скрипт предназначен для Xcode Cloud (или любой другой CI-системы),
# где может не быть ни Tuist, ни mise.
# Запускается после клонирования репозитория и перед сборкой.

# ----------------------- 1️⃣ Установка/обновление Python и зависимостей -----------------------
python3 -m pip install --upgrade pip
pip3 install --upgrade python-telegram-bot

# ----------------------- 2️⃣ Установка Homebrew (если не установлен) -----------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew не найден. Устанавливаем Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Обновляем Homebrew
brew update

# ----------------------- 3️⃣ Установка mise через Homebrew -----------------------
# Предполагаем, что mise доступен через Homebrew.
brew install mise

# ----------------------- 4️⃣ Подготовка Xcode -----------------------
# (удаляем/устанавливаем нужные дефолты)
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile 2>/dev/null
defaults delete com.apple.dt/Xcode IDEDisableAutomaticPackageResolution 2>/dev/null
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# ----------------------- 5️⃣ Подготовка к запуску Tuist -----------------------
# Если mise.toml лежит в корне репозитория, переходим в него:
cd /Volumes/workspace/repository/ || exit 1

# Подтягиваем версию Tuist и других инструментов, прописанных в mise.toml
mise install

# ----------------------- 6️⃣ Запуск Tuist через mise -----------------------
mise run tuist clean
mise run tuist install
mise run tuist generate --no-open
