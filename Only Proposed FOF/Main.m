function friendlist = Main(index)
%% Parameters and Initialization

% Getting Raw Dataset from Input
socDataset = xlsread ('D:\Work\Thesis\payam\Dataset\soc-delicious\soc.xlsx');
tagDataset = xlsread ('D:\Work\Thesis\payam\Dataset\delicious-ut\ut.xlsx');
tagDataset = tagDataset(:,1:2);

nFOFSelected =  20;
t=cputime;



%Calculating Number of Population
numberOfpopulation = max(max(socDataset));
numberOfrows = length(socDataset);

% Create an empty Adjanceny Matrix of people relations
Adjancency =zeros(numberOfpopulation,numberOfpopulation);

empty_profile.Person = [];
empty_profile.Tags = [];

% Calculating The maximum index for tags
maximumTagNumber = max(tagDataset(:,2));

depth = 5;              %Put a maximum depth

%% Main
% Create an Adjanceny Matrix of people relations
for i=1:numberOfrows
         
        Adjancency(socDataset(i,1) ,socDataset(i,2)) = 1;
        Adjancency(socDataset(i,2) ,socDataset(i,1)) = 1;
         
end

% Creating a Graph of Friends
G = graph(Adjancency~=0);

%Show the Graph
plot(G)

%Create a Sparse Matrix
sparseMatrix = sparse (Adjancency);

%Claculating Shortest path between all nodes
[dist,path,pred] = graphshortestpath(sparseMatrix,index);

%Extracting Target Person Tags
targetPersonTags = tagDataset((tagDataset(:,1)==index),2);


% Potential Friends
[~,potentialFriends] = find( dist>1 & dist<depth);    %They are not direct friends

% Creating an empty profile for each population
profilesF = repmat(empty_profile, 1, length(potentialFriends));

for i=1:length(potentialFriends)
   
    profilesF(i).Person = potentialFriends(i);
    temp = find(tagDataset(:,1)==potentialFriends(i));
    profilesF(i).Tags = tagDataset(temp,2);
    
end

[indexOfsimilarPersons, similarityF] = CompareProfiles(profilesF,targetPersonTags, maximumTagNumber);
similarPersons = potentialFriends(indexOfsimilarPersons);
weight = (1./dist(similarPersons));
weightedsimilarPersons = weight.*similarityF;

[~,I] = sort(weightedsimilarPersons, 'descend');
similarPersonF = weightedsimilarPersons(I);
similarPersonF = I(1:nFOFSelected);


%% results

for i=1:length(similarPersonF)
   
    temp = find(tagDataset(:,1)==similarPersonF(i));
    profiles(i).Tags = tagDataset(temp,2);
    

    
end
targetPersonTags = tagDataset((tagDataset(:,1)==index),2);
[~, similarityA] = CompareProfiles(profiles,targetPersonTags, maximumTagNumber);
sum(similarityA)
mean(similarityA)
cputime-t
