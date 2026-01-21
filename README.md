# Конспекты лекций

LaTeX-шаблон для ведения конспектов лекций с автоматической сборкой PDF.

## Структура проекта

```
NewConspects/
├── template/              # Шаблон для новых предметов
│   ├── main.tex          # Главный файл
│   ├── style.sty         # Стили и пакеты
│   ├── preamble/
│   │   └── commands.tex  # Быстрые команды для конспектов
│   └── lectures/         # Папка для лекций
├── subjects/             # Ваши предметы (создаются скриптом)
│   └── matan/
│       ├── main.tex
│       └── lectures/
│           ├── lec-01.tex
│           └── lec-02.tex
├── scripts/
│   ├── new-subject.sh    # Создать новый предмет
│   ├── new-lecture.sh    # Создать новую лекцию
│   └── build-all.sh      # Собрать все PDF
├── output/               # Собранные PDF (локально)
└── .github/workflows/    # GitHub Actions для релизов
```

## Быстрый старт

### 1. Создание нового предмета

```bash
./scripts/new-subject.sh "Математический анализ"
# Создаст: subjects/matematicheskiy-analiz/
```

Или с коротким именем:

```bash
./scripts/new-subject.sh "Линейная алгебра" linalg
# Создаст: subjects/linalg/
```

### 2. Настройка предмета

Отредактируйте `subjects/<предмет>/main.tex`:

```latex
\setcoursename{Математический анализ}
\setstudentname{Ваше имя}
\setteachername{Преподаватель}
\setinstitution{Университет}
\setsemester{Осень 2025}
```

### 3. Добавление лекций

```bash
cd subjects/matan
../../scripts/new-lecture.sh
# Или: ../../scripts/new-lecture.sh 2 "Пределы"
```

Лекции создаются в `lectures/lec-XX.tex` и автоматически подключаются.

### 4. Компиляция

```bash
cd subjects/matan
xelatex main.tex && xelatex main.tex
```

Или собрать всё:

```bash
./scripts/build-all.sh
```

## Быстрые команды

В `preamble/commands.tex` определены удобные сокращения:

### Множества
- `\N, \Z, \Q, \R, \C` — числовые множества
- `\set{x}` — {x}
- `\setmid{x}{условие}` — {x | условие}

### Математика
- `\abs{x}`, `\norm{x}` — модуль, норма
- `\limn`, `\sumn` — пределы и суммы
- `\dd`, `\dv{y}{x}`, `\pdv{f}{x}` — дифференцирование
- `\eps`, `\vphi` — греческие буквы
- `\then`, `\iff` — стрелки

### Форматирование
- `\term{слово}` — выделение термина
- `\important{текст}` — важный блок
- `\todo{заметка}` — TODO-пометка

### Окружения
- `\begin{thm}...\end{thm}` — теорема в рамке
- `\begin{defn}...\end{defn}` — определение в рамке
- `\begin{items}...\end{items}` — компактный список
- `\pf{доказательство}` — короткое доказательство

## Код

Поддерживаются окружения для разных языков программирования:

```latex
\begin{python}
def hello():
    print("Hello, World!")
\end{python}

\begin{cpp}
int main() {
    std::cout << "Hello" << std::endl;
}
\end{cpp}
```

Доступные окружения:
- `python` — Python
- `cpp` — C/C++
- `java` — Java
- `javascript` — JavaScript/TypeScript
- `golang` — Go
- `rust` — Rust
- `sql` — SQL
- `bash` — Bash/Shell
- `haskell` — Haskell

Также есть `\code{inline}` для инлайн-кода.

## GitHub Actions

При пуше в `main`:

### Отдельное версионирование для каждого предмета
- Каждый предмет версионируется независимо
- Формат версии: `vYYYYMMDD.N`
  - `YYYYMMDD` — дата последнего изменения
  - `N` — количество коммитов для этого предмета

### Релизы
1. **latest** — общий релиз со всеми актуальными PDF
2. **{предмет}-{версия}** — отдельный релиз для каждой версии предмета

### Что происходит при пуше
1. Определяются изменённые предметы
2. Собираются только изменённые PDF (параллельно)
3. Обновляется релиз `latest`
4. Создаётся отдельный релиз для каждого обновлённого предмета
5. Обновляется файл `.versions.json` с историей версий

## Требования

- **Компилятор**: XeLaTeX или LuaLaTeX
- **Шрифты**: PT Serif, PT Sans, JetBrains Mono

### Установка шрифтов (Ubuntu/Debian)

```bash
sudo apt-get install fonts-paratype
# JetBrains Mono: скачать с https://www.jetbrains.com/lp/mono/
```

### Установка TeX Live

```bash
# Ubuntu/Debian
sudo apt-get install texlive-xetex texlive-lang-cyrillic texlive-latex-extra

# macOS
brew install --cask mactex
```
