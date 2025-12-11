from datetime import date
import pandas as pd

df = pd.read_csv('C:/Users/17274/Documents/HairColorNY/list_from_grok_CLEANED.csv')
df['Date'] = pd.to_datetime(df['Date'])
today = date.today()

print(f'Today: {today}')
print(f'Total records: {len(df)}')
print(f'Records with date <= today: {len(df[df["Date"].dt.date <= today])}')
print(f'Records with date == today: {len(df[df["Date"].dt.date == today])}')
print(f'Records with date < today: {len(df[df["Date"].dt.date < today])}')
