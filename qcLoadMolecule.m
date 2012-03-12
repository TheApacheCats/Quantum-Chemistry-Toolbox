function molecule = qcLoadMolecule
% load a gaussian log file that has been broken up into parts
num_atoms = parselink101();
molecule.num_atoms = num_atoms;
[atomic_number position] = parselink202();
molecule.atomic_number = atomic_number;
molecule.position = position;
[basis_type basis_coeff basis_num number_of_basis_functions] = parselink301;
molecule.basis_type = basis_type;
molecule.basis_coeff = basis_coeff;
molecule.basis_num = basis_num;
[MO_type MO_energy MO_coeff MO_atom] = parselink601();
molecule.MO_type = MO_type;
molecule.MO_energy = MO_energy;
molecule.MO_coeff = MO_coeff;
molecule.MO_atom = MO_atom;
% check to see if it was a vibrational calculation
if exist('716-1.txt','file');
    molecule.vib = parselink716();
end