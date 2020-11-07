function fl = CreateFluorophore(emission, excitation, name, solvent, wave)

fl.wave = wave(:);
fl = SetFluorophoreData(fl,'emission',emission);
fl = SetFluorophoreData(fl,'excitation',excitation);
fl = SetFluorophoreData(fl,'name',name);
fl = SetFluorophoreData(fl,'solvent',solvent);

end