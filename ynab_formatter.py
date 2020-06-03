import csv
import sys
import re


class Bmo:
    def __init__(self, input_file, output_file):
        self.input_file = input_file
        self.output_file = output_file

    def run(self):
        transaction_r = re.compile('\d+')
        csv_reader = csv.reader(open(self.input_file))

        formatted_list = [["Date", "Payee", "Memo", "Amount"]]
        for row in csv_reader:
            if len(row) > 5 and transaction_r.match(row[0]):
                formatted_list.append(self.__format_row(row))

        csv_writer = csv.writer(open(self.output_file, 'w+'))
        csv_writer.writerows(formatted_list)

    def __format_amount(self, raw_amount):
        return -1 * float(raw_amount)

    def __format_date(self, raw_date):
        year = raw_date[0:4]
        month = raw_date[4:6]
        day = raw_date[6:8]
        
        return month + '/' + day + '/' + year


    def __format_row(self, raw_row):
        date = self.__format_date(raw_row[2])
        payee = raw_row[5]
        memo = ""
        amount = self.__format_amount(raw_row[4])

        return [date, payee, memo, amount]
    
class Td:
    def __init__(self, input_file, output_file):
        self.input_file = input_file
        self.output_file = output_file

    def run(self):
        csv_reader = csv.reader(open(self.input_file))
        formatted_list = [["Date", "Payee", "Memo", "Outflow", "Inflow"]]

        for row in csv_reader:
            if len(row) > 3:
                date = row[0]
                payee = row[1]
                memo = ""
                outflow = row[2]
                inflow = row[3]

                formatted_list.append([date, payee, memo, outflow, inflow])

        csv_writer = csv.writer(open(self.output_file, 'w+'))
        csv_writer.writerows(formatted_list)


if sys.argv[1] == 'td':
    td_output = "td_ynab_format.csv"
    Td(sys.argv[2], td_output).run()
    print("Wrote file: " + td_output)

elif sys.argv[1] == 'bmo':
    bmo_output = "bmo_ynab_format.csv"
    Bmo(sys.argv[2], bmo_output).run()
    print("Wrote file: " + bmo_output)

else:
    print("Incorrect args")
