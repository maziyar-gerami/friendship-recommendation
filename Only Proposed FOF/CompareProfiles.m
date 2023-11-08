function [ indexOfsimilarPersons, Similarity ] = CompareProfiles( profiles, targetPersonTags, maximumTagNumber)
%COMPAREPROFILES is a function for compare two profiles
% it gets number of potential friends
Thershold = 0.0;
numberOfPotentialFriends = length(profiles);
similarity = zeros(0,numberOfPotentialFriends);
targetTagVector = zeros (1, maximumTagNumber);
targetTagVector(targetPersonTags)=1;

for i=1: numberOfPotentialFriends
    
    potentialFriendTagVector = zeros (1, maximumTagNumber);
    temp = (profiles(i).Tags);
    potentialFriendTagVector(temp)=1;
    
    similarity(i) = sum(targetTagVector .* potentialFriendTagVector)/...
        ((sum(targetTagVector.^2))*(sum(potentialFriendTagVector.^2)));
    
end

indexOfsimilarPersons = similarity>Thershold;
Similarity = find (similarity>Thershold);
Similarity = similarity(Similarity);

