#!/bin/bash
# =============================================================================
# Скрипт создания новой лекции
# =============================================================================
#
# Использование (из папки предмета):
#   ../../scripts/new-lecture.sh [номер] [название]
#
# Или с указанием предмета:
#   ./scripts/new-lecture.sh <предмет> [номер] [название]
#
# Примеры:
#   ./scripts/new-lecture.sh matan 2 "Пределы функций"
#   cd subjects/matan && ../../scripts/new-lecture.sh 3 "Непрерывность"
#
# =============================================================================

set -e

# Цвета
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Определение директории предмета
if [ -f "main.tex" ] && [ -d "lectures" ]; then
    # Запущено из папки предмета
    SUBJECT_DIR="$(pwd)"
    LECTURE_NUM="${1:-}"
    LECTURE_TITLE="${2:-}"
elif [ $# -ge 1 ] && [ -d "$ROOT_DIR/subjects/$1" ]; then
    # Указан slug предмета
    SUBJECT_DIR="$ROOT_DIR/subjects/$1"
    LECTURE_NUM="${2:-}"
    LECTURE_TITLE="${3:-}"
else
    echo -e "${RED}Ошибка: не удалось определить предмет${NC}"
    echo ""
    echo "Использование:"
    echo "  Из папки предмета: ../../scripts/new-lecture.sh [номер] [название]"
    echo "  Из корня: ./scripts/new-lecture.sh <предмет> [номер] [название]"
    exit 1
fi

LECTURES_DIR="$SUBJECT_DIR/lectures"

# Автоопределение номера лекции
if [ -z "$LECTURE_NUM" ]; then
    # Найти последний номер и добавить 1
    LAST_NUM=$(ls "$LECTURES_DIR"/lec-*.tex 2>/dev/null | \
        sed 's/.*lec-\([0-9]*\)\.tex/\1/' | \
        sort -n | tail -1 || echo "0")
    LECTURE_NUM=$((10#$LAST_NUM + 1))
fi

# Форматирование номера (01, 02, ..., 10, 11, ...)
LECTURE_NUM_PADDED=$(printf "%02d" "$LECTURE_NUM")

# Путь к файлу лекции
LECTURE_FILE="$LECTURES_DIR/lec-$LECTURE_NUM_PADDED.tex"

# Проверка существования
if [ -f "$LECTURE_FILE" ]; then
    echo -e "${RED}Ошибка: файл lec-$LECTURE_NUM_PADDED.tex уже существует${NC}"
    exit 1
fi

# Получение названия интерактивно если не указано
if [ -z "$LECTURE_TITLE" ]; then
    echo -e "${BLUE}Создание лекции #$LECTURE_NUM${NC}"
    read -p "Название лекции: " LECTURE_TITLE
fi

# Если название всё ещё пустое
if [ -z "$LECTURE_TITLE" ]; then
    LECTURE_TITLE="Лекция $LECTURE_NUM"
fi

# Текущая дата
CURRENT_DATE=$(date "+%-d %B %Y" | \
    sed -e 's/January/января/' -e 's/February/февраля/' -e 's/March/марта/' \
        -e 's/April/апреля/' -e 's/May/мая/' -e 's/June/июня/' \
        -e 's/July/июля/' -e 's/August/августа/' -e 's/September/сентября/' \
        -e 's/October/октября/' -e 's/November/ноября/' -e 's/December/декабря/')

# Создание файла лекции
cat > "$LECTURE_FILE" << LECTURE_EOF
% =============================================================================
% ЛЕКЦИЯ $LECTURE_NUM
% =============================================================================

\\lecture{$LECTURE_NUM}{$LECTURE_TITLE}

\\lecturedate{$CURRENT_DATE}

\\section{Раздел}

% Начните писать здесь...


LECTURE_EOF

echo -e "${GREEN}✓ Создана лекция: lec-$LECTURE_NUM_PADDED.tex${NC}"
echo -e "  Путь: ${BLUE}$LECTURE_FILE${NC}"
