from machine import Pin
import time
dht_pin=2
bitstream=[0]*40

def DHTread():
    #set variales to zero initially, as we perform logical OR operation on them.
    hum_hob=0  #higher order bytes of humidity
    hum_lob=0  # lower order bytes of humidity
    temp_hob=0
    temp_lob=0
    checksum=0 
    global humidity,temperature,DataError
    lastreadtime=0   #used to calculate bit period
    bitstream=[0]*40 #array to hold bit period
      
    # Trigger Sensor to begin communication
    #Send a low pulse of 1.1ms duration. Datasheet specifies atleast 1ms
    dht=Pin(dht_pin, Pin.OUT)
    dht.low()          
    time.sleep_us(1100)
    #send a high pulse of 40us duration
    dht.high()
    time.sleep_us(40)
    #set pin as pullup and wait for signal from DHT
    dht=Pin(dht_pin, Pin.IN, Pin.PULL_UP)
    
    #acknowledgment from DHT
    while (dht.value()==0):
        pass #wait while dht pulls pin low for 80us
    while (dht.value()==1):
        pass #wait while dht pulls pin high for 80us
    
    #Loop to get bit period of bitstream. DHT send 40 bits of data starting from MSB
    for i in range (0,40):
        lastreadtime=time.ticks_us()
        while (dht.value()==0):
            pass #wait while dht pulls pin low
        while (dht.value()==1):
            pass #wait while dht pulls pin high
        bitstream[i]=time.ticks_us()-lastreadtime #stores bit period of a single bit.
    
    #Convert bit period to binary data.
    #A bit is sent in the form of LOW pulse followed by a HIGH pulse.All low pulses
    # are 50us in duration. If the HIGH pulse following the LOW pulse
    # is 24us-28us in duration, the bit is 0. If the HIGH pulse following the LOW pulse
    # is 70us in duration, the bit is 1.
    # So if bit period(HIGH pulse+LOW pulse) is less than 100us, then the bit is 0, else 1. 
    for i in range (0,40):
        if(bitstream[i] < 100):
            bitstream[i]=0
        else:
            bitstream[i]=1
    #First 16 bit contains humidity data, next 16 bit contains temperature data.
    # Last 8 bits gives checksum.
    #Seperate the 40 bit data to 5 8-bit banks.
    for i in range (8,0,-1):
        if(bitstream[8-i]==1):
            hum_hob|=1<<(i-1)
    for i in range (8,0,-1):
        if(bitstream[16-i]==1):
            hum_lob|=1<<i-1
    for i in range (8,0,-1):
        if(bitstream[24-i]==1):
            temp_hob|=1<<i-1
    for i in range (8,0,-1):
        if(bitstream[32-i]==1):
            temp_lob|=1<<i-1
    for i in range (8,0,-1):
        if(bitstream[40-i]==1):
            checksum|=1<<i-1

    if (checksum==(hum_hob+hum_lob+temp_hob+temp_lob)&0x00ff):
        DataError=False
    else:
        DataError=True

    #Bitwise shifting and OR operation to convert raw data. The raw data is 10 times more than real values.    
    humidity=((hum_hob)<<8)|hum_lob;
    humidity*=0.1;
    temperature=((temp_hob&0x7f)<<8)|temp_lob;
    temperature*=0.1;

while True:
    time.sleep(2)
    DHTread()
    if (DataError==False):
        print("Temp: {} °C".format(temperature))
        print("Humidity: {} %".format(humidity))
    else:
        print("Checksum Error")
لغة الكود:  بايثون  ( بيثون )
