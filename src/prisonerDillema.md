# Task lists

1. Game factory

   - new game - deploy or create a new game instance

     - Can set the reward token (done)
     - Can set the game total amount (done)
     - Can set the number of rounds (done)

   - store existing games (done)

2. Game

   - User need to call join function to join the game, join function will collect 50% of the game total amount (not really done)
   - join function assign the player address (player1 or 2) (not really done)
   - roundAnswer(string answer, string password) //encrypt answer (not done)
   - revealAnswer(string password) // reveal answer is to decrypt the answers, we can reveal them after both players submited their answer.(not done)
   - finishRound() // validate user answers and calculate points (done)
   - distributeFunds() - after all rounds finished, distribute the game money to players. (done)

3. Logic - Points for each round (done)

   L/L || L/S

   S/S || S/L

   L/L = 2 / 2 = 50/50
   S/S = 5 / 5 = 50/50
   L/S = 2 / 8 = 20/80
   S/L = 8 / 2 = 80 / 20

4. Create tests for game and factory (ongoing)

5. A pool to hold players funds (not really done)
6. Validate only 2 users deposit funds to the game (done)
7.
