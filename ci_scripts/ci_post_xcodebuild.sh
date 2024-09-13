#!/bin/sh
# Срабатывает после СБОРКИ проекта

# Генерация версий
MARKETING_VERSION="1.$CI_BUILD_NUMBER"
CURRENT_PROJECT_VERSION="$CI_BUILD_NUMBER"

# Переход в папку с проектом
cd /Volumes/workspace/repository/

# Определение текущей ветки из переменной окружения Xcode Cloud
current_branch=$CI_COMMIT_BRANCH

# Проверка, что не происходит Pull Request
if [ -z "$CI_PULL_REQUEST_NUMBER" ] && [ -z "$CI_PULL_REQUEST_SOURCE_BRANCH" ]; then
    # Установка токена для GitHub Actions
    git config --global user.email "github-actions[bot]@users.noreply.github.com"
    git config --global user.name "GitHub Actions Bot"
    
    # Создание и пуш git тега
    git tag $MARKETING_VERSION
    
    # Установка токена аутентификации для GitHub
    git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/V1taS/Currencify.git
    
    # Пуш тегов
    git push --tags
fi
