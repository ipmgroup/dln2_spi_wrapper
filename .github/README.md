# GitHub Actions Workflows

## Publish Workflow (`publish.yml`)

Автоматически публикует пакет на PyPI при создании релизов или тэгов.

### Триггеры

- **Push тэга `v*`** → публикация на TestPyPI для тестирования
- **GitHub Release** → публикация на production PyPI

### Настройка секретов

Добавьте в Settings → Secrets and variables → Actions:

1. `PYPI_API_TOKEN` - токен для production PyPI
2. `TEST_PYPI_API_TOKEN` - токен для TestPyPI

### Использование

#### Публикация на TestPyPI
```bash
git tag v0.1.1-test
git push origin v0.1.1-test
```

#### Публикация на PyPI
1. Создайте релиз на GitHub
2. Workflow автоматически опубликует пакет

### Локальная публикация

Также доступны локальные команды:
```bash
make upload-test    # TestPyPI
make upload-pypi    # PyPI
./publish.sh        # интерактивный режим
```
