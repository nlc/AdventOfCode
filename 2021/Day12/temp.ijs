edgedata =: ('-'cut ]) each cutopen fread 'sample1.txt'
nodelist =: > sort ~.,> edgedata
nodeid =: nodelist&i.
