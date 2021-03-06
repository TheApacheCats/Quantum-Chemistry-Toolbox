function atomic_mass = qcAtomicMass(AN)
masses = [1     4 ...
    7 9     11 12.011 14 16 19 20 ...
    23 24   27 28 31 32 35 40 ...
    39 40   45 48 51 52 55 56 59 59 63.546 65.38];
atomic_mass = masses(AN);