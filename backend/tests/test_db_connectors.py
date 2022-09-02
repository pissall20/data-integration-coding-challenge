import pytest
import psycopg2

from backend.db_connectors.db_connection import get_db_connection, DB_CONFIG


def test_successful_connection():
    conn = get_db_connection()
    curs = conn.cursor()
    curs.execute('SELECT 1')


def test_invalid_connection():
    config = DB_CONFIG
    config['user'] = 'failed_user'

    with pytest.raises(psycopg2.OperationalError):
        get_db_connection(config)


if __name__ == '__main__':
    pytest.main()
