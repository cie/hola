Feature: Drag and Drop
    In order to átrendezzem az egyenletet
    As a felhasználó
    I want to az egyenlet bizonyos elemeit áthúzni az egyenlőségjel másik oldalára

    Scenario: x+a=10 -> x=10-a
        Given az ablakban x+a=10 egyenlet van
        When kijelölöm az a-t
        And a kijelölt részt oda húzom, ahol most a 10 van
        Then x=10-a lesz az egyenlet. 

    Scenario: x+a=10 -> x=a-10
        Given az ablakban x+a=10 egyenlet van
        When kijelölöm az a-t
        And a kijelölt részt kicsit balra húzom attól, ahol most a 10 van
        Then x=a-10 lesz az egyenlet. 

    Scenario: 

