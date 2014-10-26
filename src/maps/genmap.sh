sudo dumpkeys -f | grep ^keycode | sed -E "s/^keycode([ ]+)([0-9]+) = //g" > mine.map
