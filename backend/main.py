from db_connectors.db_connection import *
import pandas as pd
import psycopg2.extras as extras


def insert_df_to_db(conn, df, table):
    tuples = [tuple(x) for x in df.to_numpy()]

    cols = ','.join(list(df.columns))
    # SQL query to execute
    query = "INSERT INTO %s(%s) VALUES %%s" % (table, cols)
    cursor = conn.cursor()
    try:
        extras.execute_values(cursor, query, tuples)
        conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print("Error: %s" % error)
        conn.rollback()
        cursor.close()
        return 1
    print("the dataframe is inserted")
    cursor.close()


def standardize_peak_power_to_kwh(consumption, aec_unit):
    if aec_unit == "MWh":
        consumption = consumption / 1000.0
    return consumption


def generate_id(s):
    return abs(hash(s)) % (10 ** 10)


def main_import_customer_data(data_file):
    customers = pd.read_csv(data_file)

    customers = customers.dropna(axis=0,
                                 subset=['annual_energy_consumption', 'aec_unit', 'peak_power', 'accounting_year'],
                                 how="all")
    customers['annual_energy_consumption'] = customers['annual_energy_consumption'].fillna(
        customers['annual_energy_consumption'].median())
    customers["aec_unit"] = customers["aec_unit"].fillna(customers['peak_power'].str.split(" ")[0][1] + "h")

    customers['annual_energy_kWh'] = customers.apply(
        lambda x: standardize_peak_power_to_kwh(x["annual_energy_consumption"], x['aec_unit']), axis=1)

    # customers["customer_id"] = customers["name"].map(generate_id)
    customers["customer_id"] = customers.index
    customers['peak_power'] = customers['peak_power'].str.extract('(\d+)').astype(float)
    conn = get_db_connection()

    electricity_query = "select * from app.electricity_cost"
    electricity = pd.read_sql(electricity_query, conn)
    electricity = electricity.rename(columns={"year": "accounting_year"})

    df = pd.merge(customers, electricity, on=["city", "accounting_year"], how="inner")

    df['total_cost'] = df['annual_energy_kWh'] * df['cent_per_kwh']
    df = df.dropna(how="all", axis=1).dropna(how="all", axis=0)

    required_cols = ['customer_id', 'name', 'city', 'street_hn', 'annual_energy_consumption', 'peak_power',
                     'accounting_year', 'total_cost']
    insert_df_to_db(conn, df[required_cols], 'app.customers')


if __name__ == '__main__':
    file_path = "source_data/customer_data.csv"
    main_import_customer_data(file_path)
