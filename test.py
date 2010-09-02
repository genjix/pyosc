import osc
a = osc.OSC()
a.connect('localhost', 9001)
a.send('/boo', (10, 'meek', True))
a.disconnect()
