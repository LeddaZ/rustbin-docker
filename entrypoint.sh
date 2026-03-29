#!/bin/sh
set -e

# Default to the same path advertised in the README / compose example
DB_URL="${DATABASE_URL:-sqlite:///app/data/rustbin.db}"

# Strip the "sqlite://" prefix to get the raw filesystem path
DB_PATH="${DB_URL#sqlite://}"

DB_DIR="$(dirname "$DB_PATH")"

# Create the data directory if it doesn't exist (needed when no volume is mounted)
mkdir -p "$DB_DIR"

# Touch the database file so SQLite / sqlx can open it immediately
if [ ! -f "$DB_PATH" ]; then
    echo "Initialising database at $DB_PATH"
    sqlite3 "$DB_PATH" "PRAGMA journal_mode=WAL;"
else
    echo "Database already exists at $DB_PATH"
fi

exec "$@"
