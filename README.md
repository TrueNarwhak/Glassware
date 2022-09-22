# Glassware
 
made with love, godot engine, and a complete lack of understanding of state machines i promise i know how to use them now okay i sw



Assets (3rd party):

Both "Her Foyer" and "Her Tapestry" from Patrica Taxxons amazing album: https://patriciataxxon.bandcamp.com/album/visiting-narcissa

"Free Bar Jazz" by Freesound Music: https://youtu.be/ojuXsaXKLPg

Lean Camera by samsface: https://youtu.be/GXBEt_QqPMs

Impact Sounds by Kenny: https://kenney.nl/assets/impact-sounds

Base Platformer Controller by Heartbeast: github.com/uheartbeast/simple--heart-platformer

# Another Dimension Update
After reaching a certain amount of rooms, you uncover a strange portal...

Entering it takes you to a new dimension, one of harder stages, ufos, and even a super cool purple background...

Let's see if you have what it takes to brave this strange new world!

TODO:
 - Program UFO behavior
   - Move left & right towards player, bobbing up and down slightly (but mostly y axis is locked)
   - When the player is reached, activate a tractor beam that sucks up the player slowly, towards the dangerous hitbox of the UFO
   - Tractor beam reduces movement drastically, and can only be escaped by attack boosting
 - Add portal spawn animation
 - Add portal functionality
 - NOTE: All new stages are stored under the intensity_one_stages array despite them actually being intensity_two
 - Make new stages
