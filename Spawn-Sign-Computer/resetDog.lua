dog = peripheral.wrap("left")

dog.setEnabled(false)
os.sleep(0.3)
dog.setEnabled(false)
--This thing does not like me

dog.setTimeout(6000)
dog.setEnabled(true)
