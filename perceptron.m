%%%%%%%%%%%%%%%%%%%%%%%%
% Αναστάσιου Δαχή 2022 %
%%%%%%%%%%%%%%%%%%%%%%%%

% Καθαριζουμε μεταβλητες και command window
clc; clear; close all;

% Το ονομα του αρχειου που θα ανοιξουμε
filename='dataset2D.csv';

% Φτιαχνουμε εναν πινακα Table με το
% filename = 'dataset2D.csv'
% Η δευτερη μεταβλητη ειναι σχετικη με το διαβασμα του αρχειου και
% την ονομασια των στηλων του πινακα
Table = readtable(filename,'ReadVariableNames',false);

% Βαζει τυχαια τις τιμες στον πινακα
Table = Table(randperm(size(Table,1)),:);

% Εποχες = epoch (κυκλοι της μαθησης)
% Μεγιστος κυκλος εποχων = max_epoch
cur_epoch=0;max_epoch=10;

%   Διαστασεις του πινακα
Dimentions=size(Table,2)-1;

% Αν οι διαστασεις του πινακα ειναι 2 θα ειναι ενα 2D διαγραμμα
% Αλλιως αν ειναι 3 θα ειναι ενα 3D
if Dimentions==2
    % Βαζει στο x πινακα τις τιμες της δευτερης και της τριτης στιλης του
    % πινακα Table
    % Μετατρεπω τους πινακες σε διανυσματα
    x_table = table2array(Table(:,1:2));
    y_cell = table2cell(Table(:,3));
    
    % Εδω φτιαχνω ενα διανυσμα που μεσα θα εχει 1 σαν τιμη για να βαλω
    % μεσα την κλαση 1 ή -1 .
    y_class = ones(length(y_cell),1); 
    
    for i = 1:length(y_cell)
        if strcmp(y_cell{i}, 'C1')
            y_class(i) = 1;
        else
            y_class(i) = -1;
        end
    end
    
    figure;
    
    % Βημα εκπαιδευσης
    learning_rate = 0.5;
    
    % Τυχαια νουμερα στα βαρυ απο -1 μεχρι 1
    wmin=-1; wmax=1;
    w1=wmin+rand(1)*(wmax-wmin);
    w2=wmin+rand(1)*(wmax-wmin);
    
    weights  = [w1,w2]';
    bias=1;
    x1 = linspace(0.2,1.1,10);
    
    % Η εκπαιδευση
    while cur_epoch <=max_epoch
        miss=0;
        for i = 1 : size(x_table,1)
            x=x_table(i,:);
            d=y_class(i);
            
            % Αν η τιμη διεγερσης ειναι >0 η εξοδος θα ειναι 1 αλλιως -1
            u=x*weights+bias;
            if (u>0)
                y=1;
            else
                y=-1;
            end
            
            % Αν η εξοδος y δεν ταιριαζει με το επιθυμητο που μας δωθηκε
            % Κανουμε ενημερωση βαρων και bias .
            % Επισης κραταω τα miss ωστε αν δεν υπαρχουν να "κοψω" την
            % επαναληψη
            if(y ~= d)
                weights = weights + learning_rate*(d-y)*transpose(x);
                bias =  bias + learning_rate * (d-y);
                miss=miss+1;
            end
        end
        
        x2 = -(weights(1)/weights(2))*x1 - bias/weights(2);
        gscatter(x_table(:,1),x_table(:,2),y_cell)
        hold on;
        plot(x1,x2)
        
        pause(0.5);
        
        if (miss==0)
            break
        end
        
        cur_epoch=cur_epoch+1;
    end
    pause(5);
    hold off
    
    figure;
    gscatter(x_table(:,1),x_table(:,2),y_cell)
    hold on;
    plot(x1,x2)
    disp('finished');
    pause;
    
end

% Αλλιως αν ειναι 3 θα ειναι ενα 3D 
if Dimentions==3
    cur_epoch = 0;
    % Βαζει στο x πινακα τις τιμες της δευτερης και της τριτης στιλης του
    % πινακα Table
    % Μετατρεπω τους πινακες σε διανυσματα 
    x_table = table2array(Table(:,1:3));
    y_cell = table2cell(Table(:,4));
    
    up = [];
    down = [];
    
    for i = 1 : size(y_cell)
        if strcmp(y_cell{i}, 'C1')
            up(end+1,:) = x_table(i,:);
        else
            down(end+1,:) = x_table(i,:);
        end
    end
    
    % Εδω φτιαχνω ενα διανυσμα που μεσα θα εχει 1 σαν τιμη για να βαλω
    % μεσα την κλαση 1 ή -1
     y_class = ones(length(y_cell),1); 
    
    for i = 1:length(y_cell)
        if strcmp(y_cell{i}, 'C1')
            y_class(i) = 1;
        else
            y_class(i) = -1;
        end
    end
    
    figure(1);
    
    % Βημα εκπαιδευσης
    learning_rate = 0.5;
    
    % Τυχαια νουμερα στα βαρυ απο -1 μεχρι 1
    wmin=-1; wmax=1;
    w1=wmin+rand(1)*(wmax-wmin);
    w2=wmin+rand(1)*(wmax-wmin);
    w3=wmin+rand(1)*(wmax-wmin);
    
    weights  = [w1,w2,w3]';
    bias=1;
    x1 = linspace(-2,4);
    x2 = linspace(-2,4);
    [x1,x2] = meshgrid(x1,x2);
    % Αρχικοποιηση του χ3 ωστε να γινει το χ2
    % x3 = linspace(0,4);
    % Η εκπαιδευση
    while cur_epoch <=max_epoch
        miss=0;
        for i = 1 : size(x_table,1)
            x=x_table(i,:);
            d=y_class(i);
            
            % Αν η τιμη διεγερσης ειναι >0 η εξοδος θα ειναι 1 αλλιως -1
            u=x*weights+bias;
            if (u>0)
                y=1;
            else
                y=-1;
            end
            
            % Αν η εξοδος y δεν ταιριαζει με το επιθυμητο που μας δωθηκε
            % Κανουμε ενημερωση βαρων και bias .
            % Επισης κραταω τα miss ωστε αν δεν υπαρχουν να "κοψω" την
            % επαναληψη
            if(y ~= d)
                weights = weights + learning_rate*(d-y)*transpose(x);
                bias =  bias + learning_rate * (d-y);
                miss=miss+1;
            end
        end
        
	%Απο τον τυπο γραμμης w1*x1+w2*x2+w3*x3+bias=0
        x3 = -(weights(1)/weights(3))*x1 -(weights(2)/weights(3))*x2 - bias/weights(3);
        scatter3(up(:,1),up(:,2),up(:,3),'g','filled')
        hold on
        
        scatter3(down(:,1),down(:,2),down(:,3),'m','filled')
        hold on
        grid on
        legend('C1', 'C2')
        hold on;
        
        mesh(x1,x2,x3)
        pause(0.5);
        
        if (miss==0)
            break
        end
        
        cur_epoch=cur_epoch+1;
    end
    pause(5);
    hold off
    
    figure(2);
    scatter3(up(:,1),up(:,2),up(:,3),'g','filled')
    hold on
    
    scatter3(down(:,1),down(:,2),down(:,3),'m','filled')
    hold on
    grid on
    legend('C1', 'C2')
    hold on;
    mesh(x1,x2,x3)
    disp('finished');
    pause;
    
end

