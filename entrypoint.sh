# Wait until Postgres is ready
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
    echo "$(data) - waiting for database to start"
    sleep 2
done

# Create, migrate, and seed db if it doesn't exist
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
    echo "Database $PGDATABASE does not exist. Creating..."
    createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
    mix ecto.migrate
    echo "Database $PGDATABASE created."
fi

exec mix phx.server