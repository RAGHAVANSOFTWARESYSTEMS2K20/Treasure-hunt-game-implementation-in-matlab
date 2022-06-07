function treasure_hunt(n, treasures)
%A game of treasure humt
%n: number of cells one each side of playing field
%treasures: m by 2 cell array containing m number of treasures
%the first column contains the names of the treasures in a string
%the second column contains the sizes of the treasures
%e.g. treasures= {'treasure', 5; 'gems', 4; 'jewels', 3;
%'coins', 3; 'old wine', 2};
%the above inputs the treasures and their corresponding sizes as per the
%assignment handout

close all
clear all
figure
axis equal off
hold on
running= 1; % true if game is running, false otherwise

%%%%%%%%%note %%%%%%%%%%%
%%%%%%%%% These are prefixed parameters for testing purposes %%%%%%
% 1 - treasure (5 squares)
% 2 - gems (4 squares)
% 3 - jewels (3 squares)
% 4 - coins (3 squares)
% 5 - old wine (2 squares)
n= 10; %size of grid is n x n
% treasures array: keeps track of treasure name and value sorted according
% to treasure
% index
treasures= {'treasure', 5; 'gems', 4; 'jewels', 3; 'coins', 3; 'old wine', 2};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Draw grid
for i=0:n-1
    for j=0:n-1
        % Draw tile (i,j)
        fill([i i+1 i+1 i i],[j j j+1 j+1 j],'b')
    end
end

% matrix that keeps track if square is occupied, and if so, by which treasure
% 0 means square is not occupied by part of a treasure
% if occupied, fill matrix with index of treasure
occ= zeros(10);

%Place treasures
orientation = ceil(rand*2); %1 means vertical, 2 means horizontal
[numTreasures d] = size(treasures);
for treasureIndex= 1:numTreasures %i.e. for all indices that represent all treasures
    treasureSize= treasures{treasureIndex,2};
   
    %generate valid position
    valid = 0;
    while valid == 0
        if orientation == 2
            x= ceil(rand*(n-treasureSize)); %generate random x position subtracting treasureSize to
            %account for the treasure occupying spaces beyond the boundaries of the
            %grid
            y= ceil(rand*n); %generate random y position
            if sum(occ(x:x+treasureSize-1,y)~=0) == 0 %if entire length of squares is 0
                valid = 1;
            end
        elseif orientation == 1
            x= ceil(rand*n); %generate random x position subtracting treasureSize to
            %account for the treasure occupying spaces beyond the boundaries of the
            %grid
            y= ceil(rand*(n-treasureSize)); %generate random y position
            if sum(occ(x,y:y+treasureSize-1)~=0) == 0 %if entire length of squares is 0
                valid = 1;
            end
        end
    end
   
    %now with valid position, place treasure
    if orientation == 2
        for rem2=0:treasureSize-1 %remaining squares of the treasure
            occ(x+rem2,y) = treasureIndex;
        end
    elseif orientation == 1
        for rem2=0:treasureSize-1 %remaining squares of the treasure
            occ(x,y+rem2) = treasureIndex;
        end
    end
end

squares= zeros(n); % 0 means covered, 1 means uncovered
movesMade = 0; %initialise number of moves to be 0

titleText='Welcome to TREASURE HUNT';
movesMadeText= sprintf('Number of Place visited: %d',movesMade);
while running== 1

    title({titleText, movesMadeText}, 'FontSize', 14');
    [x,y] = ginput(1); % cet g]cursor position
    X= ceil(x);
    Y= n-ceil(y)+1;
    % user clicks on a square
    if X<=n && Y <=n && X>=1 && Y>=1 % ensures user clicks within playing field
        if squares(X,Y)==0 % square is covered, then uncover it
            squares(X,Y)= 1;
            movesMade = movesMade + 1;
            if occ(X,Y)~=0 % if square contains part of a treasure
                titleText= 'Great! keep going';
                movesMadeText= sprintf('Number of Place visited: %d',movesMade);
                treasures{occ(X,Y),2}= treasures{occ(X,Y),2} - 1; %decrease life of treasure by 1
                fill ([X-1 X X X-1 X-1],[n-Y n-Y n-Y+1 n-Y+1 n-Y],'y');
            else % if square does not contain part of a treasure
                titleText= 'Empty...! Try again';
                movesMadeText= sprintf('Number of Place visited: %d',movesMade);
                fill ([X-1 X X X-1 X-1],[n-Y n-Y n-Y+1 n-Y+1 n-Y],'w');
            end
        elseif squares(X,Y)==1 % square is already uncovered, ask player to choose again
            titleText='Place already visited. Try again.';
            movesMadeText= sprintf('Number of Place visited: %d',movesMade);
        end
    end
        %check if any treasure has been captured%
    sumS= 0;
    for treasureIndex= 1:numTreasures
        if treasures{treasureIndex,2}==0 
            treasures{treasureIndex,2} =-1 ;%means that treasure has been captured
            treasureName= treasures{treasureIndex,1};
            titleText= sprintf('You captured a %s',treasureName);
            movesMadeText= sprintf('Number of Place visited: %d',movesMade);
        end
        sumS= sumS + treasures{treasureIndex,2};
        if sumS== -1 * numTreasures %all treasures have been captured
            titleText= 'YOU WIN!';
            title({titleText, movesMadeText}, 'FontSize', 14');
            running = 0;
        end
    end
end
end