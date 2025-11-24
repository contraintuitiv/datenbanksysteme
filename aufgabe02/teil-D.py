import csv
import datetime

durations: list[datetime.timedelta]=[]

for i in range(0,30):
    print(f"\n\nStarte Durchlauf Nr. {i+1}\n\n")

    with open("crimes8m.csv") as file:
        start = datetime.datetime.now()

        result: list[dict[str, list[int,int]]] = {}
        not_arrested: list[dict[str, list[int,int]]] = {}

        # 2: occured
        # 8: arrested
        reader = csv.reader(file)

        limit = 0
        time_min = datetime.datetime(2010, 1, 1)
        time_max = datetime.datetime(2020, 1, 1)

        for row in reader:
            date = datetime.datetime.strptime(row[2], "%m/%d/%Y %l:%M:%S %p")
            if date >= time_min and date < time_max:
                day_and_hour = date.strftime("%u-%a-%H")

                if not result.get(day_and_hour):
                    result[day_and_hour]=[0,0]

                if row[8]=="true":
                    result[day_and_hour]=[result[day_and_hour][0]+1, result[day_and_hour][1]]

                else:
                    result[day_and_hour]=[result[day_and_hour][0], result[day_and_hour][1]+1]

        sorted_result = dict(sorted(result.items()))

        print (f"| hour \t\t | arr \t | not\t |")
        for key in sorted_result:
            print(f"| {key} \t | {sorted_result[key][0]}   \t | {sorted_result[key][1]}   \t |")


        end = datetime.datetime.now()

        duration = datetime.timedelta(seconds=end.timestamp() - start.timestamp())
        print(f"Dauer: {duration}")
        durations.append(duration)

print("Dauern aller Durchläufe:")
for d in durations:
    print(d)