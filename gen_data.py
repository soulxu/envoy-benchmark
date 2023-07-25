import sys


print(sys.argv)

f = open(sys.argv[1])


if sys.argv[2] == "fortio":
    results = []
    for line in f.readlines():
        conns = int(line.split()[0])
        times = int(line.split()[1])
        rps = float(line.split()[2])
        results.append(rps)
        if times == 10:
            results.remove(max(results))
            results.remove(min(results))
            print("{} {}".format(conns, sum(results)/len(results)))
            results = []
elif sys.argv[2] == "ngavg":
    results = []
    for line in f.readlines():
        rps = int(line.split()[0])
        times = int(line.split()[1])
        latency_us = int(line.split('ms')[1].lstrip(' ')[0:3])
        latency_ms = int(line.split('ms')[0].split('s')[1].lstrip(' '))
        latecy = latency_ms * 1000 + latency_us
        results.append(latecy)
        if times == 10:
            results.remove(max(results))
            results.remove(min(results))
            print("{} {}".format(rps, sum(results)/len(results)))
            results = []
elif sys.argv[2] == "ngp99":
    results = []
    for line in f.readlines():
        rps = int(line.split()[0])
        times = int(line.split()[1])
        latency_us = int(line.split('ms')[1].lstrip(' ')[0:3])
        latency_ms = int(line.split('ms')[0].split('s')[1].lstrip(' '))
        latecy = latency_ms * 1000 + latency_us
        results.append(latecy)
        if times == 10:
            results.remove(max(results))
            results.remove(min(results))
            print("{} {}".format(rps, sum(results)/len(results)))
            results = []
# results = []
# for line in f.readlines():
#     next_rps = line.split()[0]
#     ms = int(line.split('ms')[0].split('s')[1]) * 1000
#     us = int(line.split('ms')[1][0:4])
#     print("{} {}".format(next_rps, ms + us))

# if sys.argv[2] == "p99":
#     rps = "1000"
#     results = []
#     for line in f.readlines():
#         next_rps = line.split()[0]
#         if rps == next_rps:
#             ms = int(line.split('ms')[0].split('s')[1]) * 1000
#             us = int(line.split('ms')[1][0:4])
#             results.append(ms + us)
#             #print(results)
#         else:
#             #print("crps {}, rps {}".format(rps, next_rps))
#             results.remove(max(results))
#             results.remove(min(results))
#             print("{} {}".format(rps, sum(results)/len(results)))
#             results = []
#         rps = next_rps
# else:
#     rps = "1000"
#     results = []
#     for line in f.readlines():
#         next_rps = line.split()[0]
#         if rps == next_rps:
#             print(line.split('ms'))
#             ms = int(line.split('ms')[0].split('s')[1]) * 1000
#             us = int(line.split('ms')[1][0:3])
#             results.append(ms + us)
#             print(results)
#         else:
#             #print("crps {}, rps {}".format(rps, next_rps))
#             results.remove(max(results))
#             results.remove(min(results))
#             print("{} {}".format(rps, sum(results)/len(results)))

#             results = []
#         rps = next_rps