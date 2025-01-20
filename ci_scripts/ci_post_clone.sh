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
# Удаляет настройку Xcode, принуждающую использовать только версии пакетов из файла Resolved
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile

# Удаляет настройку Xcode, отключающую автоматическое разрешение зависимостей
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

# Отключает валидацию отпечатков макросов Xcode для ускорения процесса сборки
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# ----------------------- 5️⃣ Подготовка к запуску Tuist -----------------------
# Переход в папку с проектом
cd /Volumes/workspace/repository/

# Подтягиваем версию Tuist и других инструментов, прописанных в mise.toml
mise install tuist

# ----------------------- 6️⃣ Запуск Tuist через mise -----------------------
tuist clean
tuist install
tuist generate --no-open
