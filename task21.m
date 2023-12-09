distances = dictionary(...
    "Olsztyn", dictionary('Ełk', 122.33, 'Suwałki', 164.53, 'Mrągowo', 54.47, 'Łomża', 123.76, 'Ostrołęka', 105.05, 'Szczytno', 41.54, 'Augustów', 165.36),... 
    'Ełk', dictionary('Olsztyn', 122.33, 'Suwałki', 48.63, 'Mrągowo', 67.47, 'Łomża', 72.96, 'Ostrołęka', 99.26, 'Szczytno', 94.17, 'Augustów', 39.19),...
    'Suwałki', dictionary('Ełk', 48.63, 'Olsztyn', 164.53, 'Mrągowo', 109.14, 'Łomża', 118.58, 'Ostrołęka', 145.77, 'Szczytno', 140.79, 'Augustów', 29.96),...
    'Mrągowo', dictionary('Ełk', 67.47, 'Suwałki', 109.14, 'Olsztyn', 54.47, 'Łomża', 90.83, 'Ostrołęka', 87.08, 'Szczytno', 39.37, 'Augustów', 110.38),...
    'Łomża', dictionary('Ełk', 72.96, 'Suwałki', 118.58, 'Mrągowo', 90.83, 'Olsztyn', 123.76, 'Ostrołęka', 34.93, 'Szczytno', 82.65, 'Augustów', 96.38),...
    'Ostrołęka', dictionary('Ełk', 99.26, 'Suwałki', 145.77, 'Mrągowo', 87.08, 'Łomża', 34.93, 'Olsztyn', 105.05, 'Szczytno', 65.77, 'Augustów', 125.49),...
    'Szczytno', dictionary('Ełk', 94.17, 'Suwałki', 140.79, 'Mrągowo', 39.37, 'Łomża', 82.65, 'Ostrołęka', 65.77, 'Olsztyn', 41.54, 'Augustów', 135.11),...
    'Augustów', dictionary('Ełk', 39.19, 'Suwałki', 29.96, 'Mrągowo', 110.38, 'Łomża', 96.38, 'Ostrołęka', 125.49, 'Szczytno', 135.11, 'Olsztyn', 165.36));

city_from_index = dictionary(1, 'Olsztyn', 2, 'Ełk', 3, 'Suwałki', 4, 'Mrągowo', 5, 'Łomża', 6, 'Ostrołęka', 7, 'Szczytno', 8, 'Augustów');

surplus1 = dictionary('Olsztyn', 0, 'Ełk', 2, 'Suwałki', 0, 'Mrągowo', 2, 'Łomża', 4, 'Ostrołęka', 0, 'Szczytno', 1, 'Augustów', 4);
surplus2 = dictionary('Olsztyn', 0, 'Ełk', 0, 'Suwałki', 0, 'Mrągowo', 5, 'Łomża', 0, 'Ostrołęka', 6, 'Szczytno', 7, 'Augustów', 0);

shortage1 = dictionary('Olsztyn', 4, 'Ełk', 0, 'Suwałki', 3, 'Mrągowo', 0, 'Łomża', 0, 'Ostrołęka', 8, 'Szczytno', 0, 'Augustów', 0);
shortage2 = dictionary('Olsztyn', 1, 'Ełk', 4, 'Suwałki', 2, 'Mrągowo', 0, 'Łomża', 6, 'Ostrołęka', 0, 'Szczytno', 0, 'Augustów', 2);

cost_constant = 1;

f_transport = double.empty;
index = 1;
for i = 1:8
    for j = 1:8
        if i == j
            f_transport(index) = 0;
        else
            city_i = city_from_index(i);
            city_j = city_from_index(j);
            distance = distances(city_i);
            f_transport(index) =  1.6*cost_constant*distance(city_j);
        end
        index = index+1;
    end
end

for i = 1:8
    for j = 1:8
        if i == j
            f_transport(index) = 0;
        else
            city_i = city_from_index(i);
            city_j = city_from_index(j);
            distance = distances(city_i);
            f_transport(index) =  -0.6*cost_constant*distance(city_j);
        end
        index = index+1;
    end
end

A_matrix = double.empty;
b_vec = double.empty;
for i = 1:8
    index1 = 8*(i-1) + 1;
    A_matrix(i, index1+64:index1+71) = ones(1, 8);
    b_vec(i) = surplus1(city_from_index(i));
end

eq_number = 8;

for i = 1:8
    index1 = 8*(i-1) + 1;
    A_matrix(i+eq_number, index1:index1+7) = ones(1, 8);
    A_matrix(i+eq_number, index1+64:index1+71) = -1*ones(1, 8);
    b_vec(i+eq_number) = surplus2(city_from_index(i));
end

eq_number = 16;
ind_nums = [0*8, 1*8, 2*8, 3*8, 4*8, 5*8, 6*8, 7*8];
for j = 1:8
    indices = (ones(1, 8)*j) + ind_nums;
    A_matrix(j+eq_number, indices) = -1;
    b_vec(j+eq_number) = -shortage1(city_from_index(j)) - shortage2(city_from_index(j));
end

eq_number = 24;
for j = 1:8
    indices = (ones(1, 8)*j) + ind_nums;
    indices_cane_1 = (ones(1, 8)*j) + ind_nums + (ones(1, 8)*64);
    A_matrix(j+eq_number, indices) = -1;
    A_matrix(j+eq_number, indices_cane_1) = 1;
    b_vec(j+eq_number) = -shortage2(city_from_index(j));
end

eq_number = 32;
for i = 1:64
    A_matrix(i+eq_number, i) = -1;
    A_matrix(i+eq_number, i+64) = 1;
    b_vec(i+eq_number) = 0;
end

Aeq = double.empty;
beq = zeros(16, 1);
iterator = 1;
for i = 1:8
    Aeq(i, iterator) = 1;
    iterator = iterator + 9;
end

equation = 8;
iterator = 1;
for i = 1:8
    Aeq(i+equation, iterator+64) = 1;
    iterator = iterator + 9;
end

intcon_vars = 1:128;
lb = zeros(128, 1);
ub = ones(128, 1)*Inf;
x = intlinprog(transpose(f_transport), intcon_vars, A_matrix, transpose(b_vec), Aeq, beq, lb, ub);

index = 1;
output = [];
for i = 1:8
    for j = 1:8
        if x(index) ~= 0
            city_i = city_from_index(i);
            city_j = city_from_index(j);
            str_output = strcat("Transport from ", city_i, " to ", city_j, ": all cranes - ", string(x(index)), ", crane 1 - ", string(x(index+64)));
            output = [output; str_output];
        elseif x(index+64) ~= 0
            disp("FAIL!!!")
        end
        index = index+1;
    end
end
