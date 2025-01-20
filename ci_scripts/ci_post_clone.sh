#!/bin/sh

# Этот скрипт предназначен для Xcode Cloud (или любой другой CI-системы),
# где может не быть ни Tuist, ни mise.
# Запускается после клонирования репозитория и перед сборкой.

set -e  # Прерываем выполнение скрипта при любой ошибке

# ----------------------- 1️⃣ Установка/обновление Python и зависимостей -----------------------
echo "Обновляем pip и устанавливаем зависимости..."
python3 -m pip install --upgrade pip
pip3 install --upgrade python-telegram-bot

# ----------------------- 2️⃣ Установка Homebrew (если не установлен) -----------------------
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew не найден. Устанавливаем Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Обновляем Homebrew..."
brew update

# ----------------------- 3️⃣ Установка mise через Homebrew -----------------------
echo "Устанавливаем mise..."
brew install mise

# ----------------------- 4️⃣ Подготовка Xcode -----------------------
echo "Обновляем настройки Xcode для ускорения сборки..."
# Удаляет настройку Xcode, принуждающую использовать только версии пакетов из файла Resolved
defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile

# Удаляет настройку Xcode, отключающую автоматическое разрешение зависимостей
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution

# Отключает валидацию отпечатков макросов Xcode для ускорения процесса сборки
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# ----------------------- 5️⃣ Подготовка Tuist -----------------------
# Добавляем путь к tuist в PATH
export PATH="$HOME/.local/share/mise/plugins/tuist/bin:$PATH"

# Проверяем, что Tuist установлен
if [ ! -x "$HOME/.local/share/mise/plugins/tuist/bin/tuist" ]; then
  echo "Tuist не найден. Устанавливаем через mise..."
  mise install tuist
else
  echo "Tuist уже установлен."
fi

# ----------------------- 6️⃣ Подготовка проекта -----------------------
# Переход в папку с проектом
echo "Переходим в директорию с проектом..."
cd /Volumes/workspace/repository/

# Выполняем команды Tuist
echo "Очищаем проект с помощью Tuist..."
tuist clean

echo "Устанавливаем зависимости проекта с помощью Tuist..."
tuist install

echo "Генерируем проект с помощью Tuist..."
tuist generate --no-open

echo "Скрипт завершён успешно!"
