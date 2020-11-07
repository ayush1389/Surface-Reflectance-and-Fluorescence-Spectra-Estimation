function fl = ReadFluorophore(filename, wave)

data = load(filename);
fl = CreateFluorophore(data.emission, data.excitation, data.name, data.solvent, data.wave);
fl = SetFluorophoreData(fl, 'wave', wave);

end