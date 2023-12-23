clc
clear all

%% Problem settings
lb = [0 0 0 0 0 0 80 100 100 100 100 100];              %lower limit of search space 
ub = [4  4 5 6 9 19 150 250 250 450 450 450];           % upper limit of search space
prob = @Fitness_misfit;                          %fitness function

%% Algorithm Parameters
Np = 200;   % number of iteration samples
T = 100 ;   % number of iterations
Pc =0.7;    %crossover parameter
F = 0.9;     % mutation parameters

%% Differential Evolution

f = NaN(Np,1);
BestFitIter = NaN(T+1,1);

fu = NaN(Np,1);
BestFitIter = NaN(T+1,1);

D = length(lb);

U = NaN(Np,D);

P = repmat(lb,Np,1) + repmat((ub-lb),Np,1).*rand(Np,D);

for p =1:Np
    f(p) = prob(P(p,:));
end
BestFitIter(1) = min(f);

for t = 1:T
    
    for i = 1:Np
        %% Mutation
        
        Candidates = [1:i-1  i+1:Np];
        idx = Candidates(randperm(Np-1,3));
        
        X1 = P(idx(1),:);
        X2 = P(idx(2),:);
        X3 = P(idx(3),:);
        
        V = X1 +F*(X2-X3);
        
        %% Crossover
        
        del = randi(D,1);
        for j =1:D
            
            if (rand <= Pc) || del == j
                U(i,j) = V(j);
            else
                U(i,j) = P(i,j);
            end
        end
    end  
        %%
        
        for j = 1:Np
            
            U(j,:) = min(ub ,U(j,:));
            U(j,:) = max(lb ,U(j,:));
            
            fu(j) = prob(U(j,:));
            
            if fu(j) < f(j)
                P(j,:) = U(j,:);
                f(j) = fu(j);
            end
        end
        BestFitIter(t+1)=min(f);
    disp(['Iteration' num2str(t) ' : bestfitness = ' num2str(BestFitIter(t+1))]);
        
    end
    
[bestfitness,ind] = min(f)
bestsol = P(ind,:);
 %% 
 plot(0:T , BestFitIter);
xlabel('Iteration');
ylabel('Best Fitness Value')
title('Differential Evolution Optimisation');
set(gca,'Fontsize',16,'Fontname','Times New Roman');
set(gcf,'units','centimeters')
% pos = [2, 2, FigWidth, FigHeight]; 
% set(gcf,'Position',pos)
save Result
     

