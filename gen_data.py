f = open("./iouring-rps-multi-times/envoy-iouring-static/test_99.result")

rps = "1000"
results = []
for line in f.readlines():
    next_rps = line.split()[0]
    if rps == next_rps:
        results.append(int(line.split()[2].split('ms')[1][0:3]))
        #print(results)
    else:
        #print("crps {}, rps {}".format(rps, next_rps))
        results.remove(max(results))
        results.remove(min(results))
        print("rps {}, avg {}".format(rps, sum(results)/len(results)))
        results = []
    rps = next_rps