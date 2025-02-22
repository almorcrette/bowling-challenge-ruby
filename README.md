# Bowling Challenge in Ruby

This is Alexis Morcrette's partial solution to the Bowling Challenge in Ruby, Makers Academy's Week 5 Weekend Challenge.

The focus for this challenge is to write high-quality code, to deliver a bowling score program.

This project demonstrates the following skills:
* Using diagramming to plan my approach to the challenge
* TDD my code
* Focus on testing behaviour rather than state
* Committing often, with good commit messages
* Single Responsibility Principle and encapsulation
* Clear and readable code

## Note on what has not been implemented

Currently, I have a basic 10-frame basic game with no bonus scoring for strikes and spares.

Not implemented yet:
* Bonus scoring for strikes and spares
* Score updates based on bonus scoring after every roll.

Other implementation notes:
* Playing a frame is currently implemented in Game class. This leads to some limitations in the testing of edge case for playing a full game. Playing a frame would sit better in the Frame class, and permit better testing of this functionality. 

## The Task (given by Makers Academy)

Count and sum the scores of a bowling game for one player. For this challenge, you do _not_ need to build a web app with a UI, instead, just focus on the logic for bowling (you also don't need a database). Next end-of-unit challenge, you will have the chance to translate the logic to Javascript and build a user interface.

A bowling game consists of 10 frames in which the player tries to knock down the 10 pins. In every frame the player can roll one or two times. The actual number depends on strikes and spares. The score of a frame is the number of knocked down pins plus bonuses for strikes and spares. After every frame the 10 pins are reset.

## Getting started

`git clone almorcrette/bowling-challenge-ruby`

Then run: `bundle`

## Usage

`irb -r './lib/game.rb`

Then:
`Game.play`


## Running tests

`rspec`

## File manifest

See Github repo page.

## Project approach

### Analysis of game logic

![](bowling-game-logic.png)

### Functional presentation

| Class      | Variables               | Methods                    |
| -----------| ------------------------| ---------------------------|
| Game       | @scoresheet: Array      | ::play(frame_class)        |
|            |                         | #play_frame(frame)         |
| Frame      | @pins_standing: Integer | #roll                      |
|            | @frame_score: Hash      | #update_score(key, result) |
|            |                         | #strike?                   |

## Bowling — how does it work?

### Strikes

The player has a strike if he knocks down all 10 pins with the first roll in a frame. The frame ends immediately (since there are no pins left for a second roll). The bonus for that frame is the number of pins knocked down by the next two rolls. That would be the next frame, unless the player rolls another strike.

### Spares

The player has a spare if the knocks down all 10 pins with the two rolls of a frame. The bonus for that frame is the number of pins knocked down by the next roll (first roll of next frame).

### 10th frame

If the player rolls a strike or spare in the 10th frame they can roll the additional balls for the bonus. But they can never roll more than 3 balls in the 10th frame. The additional rolls only count for the bonus not for the regular frame count.

    10, 10, 10 in the 10th frame gives 30 points (10 points for the regular first strike and 20 points for the bonus).
    1, 9, 10 in the 10th frame gives 20 points (10 points for the regular spare and 10 points for the bonus).

### Gutter Game

A Gutter Game is when the player never hits a pin (20 zero scores).

### Perfect Game

A Perfect Game is when the player rolls 12 strikes (10 regular strikes and 2 strikes for the bonus in the 10th frame). The Perfect Game scores 300 points.

In the image below you can find some score examples.

More about ten pin bowling here: http://en.wikipedia.org/wiki/Ten-pin_bowling

![Ten Pin Score Example](images/example_ten_pin_scoring.png)
