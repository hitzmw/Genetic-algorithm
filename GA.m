function GA
clc;
%Initialize
px = 5;
py = 4;
pos_cros = 0.88;%Possibiity of crossover
pos_mut = 0.1;%Possibiity of mutation
species = rand(px,py).*10-5;%Range between -5 to 5

syms eval eval_table; 
syms best last_best best_one;
last_best = 0;

%Evaluation
eval = EvF(species,py);
[best,idx] = max(eval);
%fprintf('%f\n',best);
%fprintf('%f\n',abs(best-last_best));
for k=1:1000
    %(abs(best-last_best))>0.00001
    if last_best<best
        last_best = best;
        best_one = species(idx,:);
    end
    
    %Selection
    eval_table = eval./sum(eval);
    eval_table = cumsum(eval_table);
    possible = rand(px,1);
    %possible
    i=1;
    sel_species = ones(px,py);
    while i<=px
        mask = eval_table>possible(i);
        [~,id]=max(mask);
        sel_species(i,:) = species(id,:);
        i=i+1;
    end
    %sel_species
    %Crossover
    new_species = sel_species;
    for i=1:2:px-1 %The nearby chromosome will crossover if possible
        if rand<pos_cros
            point = ceil(rand*py);%The crossover position can not be 0
            new_species(i,:) = [sel_species(i,1:point),sel_species(i+1,point+1:py)];
            new_species(i+1,:) = [sel_species(i+1,1:point),sel_species(i,point+1:py)];
        else
            new_species(i,:) = sel_species(i,:);
            new_species(i+1,:) = sel_species(i+1,:);
        end
    end
    
    %mutation
    for i=1:(px*py)
        if rand<pos_mut
            new_species(i) = rand*10-5;
        end
    end
    
    %Evaluation
    species = new_species;
    eval = EvF(species,py);
    [best, idx] = max(eval);
end

%Print the answer
fprintf('The best outcome is %f\n',best);
for i=1:py
    fprintf('x%d = %f\n',i,best_one(i));
end

%Evaluate function
function f = EvF(val,col)
f = 1./(val.^2 * ones(col,1)+1);