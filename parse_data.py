import sys
import json

base_labels = [
    "http1",
    "http1-cmb",
    "http1-qat",
    "http1-ecdsa",
    "http1-cmb-ecdsa",
    "http2",
    "http2-cmb",
    "http2-qat",
    "http2-ecdsa",
    "http2-cmb-ecdsa",
    "http3",
    "http3-cmb",
    "http3-qat",
    "http3-ecdsa",
    "http3-cmb-ecdsa"
]

bins = ["envoy-static-quic"]
x_axis = range(5, 85, 5)
times = 5


"""
{
  tp : {
    http1: {
        5: [
            []
            []
            []
            []
            []
        ],
        10: [
            ...
        ]
    },
    http1-cmb: [
        ...
    ]
    ...
  }
  "p99": {
    ...
  }
}
"""
results = {
    "tp": {},
    "p99": {},
    "p999": {},
    "cpu": {},
}

def get_data_path(key, base, label, bin):
    if key == "tp":
        return "./{base}/{label}/{bin}/test_throughput.result".format(base=base, label=label, bin=bin)
    elif key == "p99":
        return "./{base}/{label}/{bin}/test_99.result".format(base=base, label=label, bin=bin)
    elif key == "p999":
        return "./{base}/{label}/{bin}/test_999.result".format(base=base, label=label, bin=bin)
    elif key == "cpu":
        return "./{base}/{label}/{bin}/test_throughput.result".format(base=base, label=label, bin=bin)
    else:
        print("wrong type")
        exit(1)

def parse_data(data_path):
    # parse tp
    for l in base_labels:
        path = get_data_path("tp", data_path, l, bins[0])
        results["tp"][l] = {}
        print("start to parse: " + path)
        f = open(path)
        for line in f.readlines():
            print(line)
            cols = line.split(" ")
            print(cols)
            x = cols[0]
            data_time = int(cols[1])
            if x not in results["tp"][l].keys():
                results["tp"][l][x] = {}
                if data_time != 1:
                    print("the time is wrong")
                    exit(1)
            results["tp"][l][x][data_time] = cols[-2]

    # parse cpu
    for l in base_labels:
        path = get_data_path("cpu", data_path, l, bins[0])
        results["cpu"][l] = {}
        print("start to parse: " + path)
        f = open(path)
        for line in f.readlines():
            print(line)
            cols = line.split(" ")
            print(cols)
            x = cols[0]
            data_time = int(cols[1])
            if x not in results["cpu"][l].keys():
                results["cpu"][l][x] = {}
                if data_time != 1:
                    print("the time is wrong")
                    exit(1)
            results["cpu"][l][x][data_time] = 100 - float(cols[-1][:-2])

    # parse p99
    for l in base_labels:
        path = get_data_path("p99", data_path, l, bins[0])
        results["p99"][l] = {}
        print("start to parse: " + path)
        f = open(path)
        for line in f.readlines():
            print(line)
            cols = line.split(" ")
            print(cols)
            x = cols[0]
            data_time = int(cols[1])
            if x not in results["p99"][l].keys():
                results["p99"][l][x] = {}
                if data_time != 1:
                    print("the time is wrong")
                    exit(1)
            time_label = cols[2]
            se = int(time_label.split("s")[0])
            ms = int(time_label.split("ms")[0].split("s")[1])
            us = int(time_label.split("ms")[1][:-3])
            # print(time_label)
            # print(ms)
            # print(us)
            results["p99"][l][x][data_time] = se * 1000 * 1000 + ms * 1000 + us

    # parse p999
    for l in base_labels:
        path = get_data_path("p999", data_path, l, bins[0])
        results["p999"][l] = {}
        print("start to parse: " + path)
        f = open(path)
        for line in f.readlines():
            print(line)
            cols = line.split(" ")
            print(cols)
            x = cols[0]
            data_time = int(cols[1])
            if x not in results["p999"][l].keys():
                results["p999"][l][x] = {}
                if data_time != 1:
                    print("the time is wrong")
                    exit(1)
            time_label = cols[2]
            se = int(time_label.split("s")[0])
            ms = int(time_label.split("ms")[0].split("s")[1])
            us = int(time_label.split("ms")[1][:-3])
            print(time_label)
            print(ms)
            print(us)
            results["p999"][l][x][data_time] = se * 1000 * 1000 + ms * 1000 + us

    #print(json.dumps(results, indent=2))
            

def get_avg(data):
    ret = list(data.values())
    ret.remove(max(ret))
    ret.remove(min(ret))
    sum = 0
    for r in ret:
        sum += float(r)
    return sum / (len(data) - 2)

def write_result(all_data_path, data_sheet_path):
    f = open(all_data_path, "w+")
    f.write(json.dumps(results, indent=2))

    data_sheet = open(data_sheet_path, "w+")

    for suffix_label in ["tp", "p99", "p999", "cpu"]:
        for base_label in base_labels:
            label = base_label + "-" + suffix_label
            data_sheet.write(label)
            data_sheet.write("\t")
    data_sheet.write("\n")

    for x in x_axis:
        for suffix_label in ["tp", "p99", "p999", "cpu"]:
            for base_label in base_labels:
                avg = get_avg(results[suffix_label][base_label][str(x)])
                data_sheet.write(str(avg))
                data_sheet.write("\t")
        data_sheet.write("\n")

if __name__ == '__main__':
    if (len(sys.argv) < 2):
        print("usage: parse_data.py data_path")
        exit(1)
    print("start to parse data at " + sys.argv[1])
    parse_data(sys.argv[1])
    write_result("./all_data.json", "data.sheet")