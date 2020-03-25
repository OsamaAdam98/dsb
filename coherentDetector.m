function detectedSignal = coherentDetector(modulatedSig, Fc, t)
  carrier = cos(2*pi*Fc*t);
  detectedSignal = modulatedSig .* transpose(carrier);
end