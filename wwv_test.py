#!/usr/bin/env python

import numpy as n
import digital_rf as drf
import matplotlib.pyplot as plt
import scipy.signal as ss


def record_wwv_doppler(dirname="/dev/shm/hf25",
                       ch="cha",
                       bw=100.0,
                       L=25000000.0,
                       sample_spacing=10.0,
                       f0=2.5e6):
    
    d=drf.DigitalRFReader(dirname)
    b=d.get_bounds(ch)
    
    sr=25000000
    b2idx=sr*sample_spacing

    b0=n.ceil(b[0])/(sample_spacing*25000000)+1
    b1=n.floor(b[1])/(sample_spacing*25000000)
    next_b = b0

    lo=n.exp(-1j*2.0*n.pi*f0*n.arange(L,dtype=n.float32)/25e6)
    dec = L/bw

    
    while True:
        b=d.get_bounds(ch)
        b0=n.ceil(b[0])/(sample_spacin*25000000)+1
        b1=n.floor(b[1])/(sample_spacing*25000000)
        
        while next_b > (b1-1):
            time.sleep(1.0)
            b=d.get_bounds(ch)
            b0=n.ceil(b[0])/(sample_spacing*25000000)+1
            b1=n.floor(b[1])/(sample_spacing*25000000)

        z=d.read_vector_c81d(next_b*25000000,L,ch)*lo
        zd=ss.decimate(z,dec,ftype="fir")
        zd=zd-n.median(zd)
        plt.plot(zd.real)
        plt.plot(zd.imag)
        plt.show()

if __name__ == "__main__":
    record_wwv_doppler()

    
    
