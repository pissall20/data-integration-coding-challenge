import psycopg2
import psycopg2.extras

from typing import Dict, Optional

DB_CONFIG = dict(
    database='postgres',
    user='postgres',
    password='postgres',
    host='postgres',
    port=5432,
)


def get_db_connection(
        config: Optional[Dict] = None,
) -> psycopg2.extras.RealDictConnection:
    """
    Connect to database via psycopg2.

    Args:
        config: Optional configuration to connect do database.
                Defaults to testing database.

    Usage:
    conn = get_db_connection()
    curs = conn.cursor()

    curs.execute('SELECT 1')
    conn.commit()
    """
    db_configuration = config or DB_CONFIG

    return psycopg2.connect(
        **db_configuration,
        connection_factory=psycopg2.extras.RealDictConnection,
        cursor_factory=psycopg2.extras.RealDictCursor,
    )
