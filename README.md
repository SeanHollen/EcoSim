**What the heck is this?** 

This is an ecology simulator. I have legitimately wanted to make something like this since I was 12 years old. I am very inspired by the idea of emergence, in Conway's Game of Life for example. In my primitive ecology sim, I personally find it quite fascinating to see all the parts interact. 

In its current form, you will see three types of animals: carnivores (distinguished by red heads), herbivores (brown heads), and plants. 

The code distinguishes between plants and animals, but the only difference between carnivores and herbivores is the traits "grazing" and "jaws." 

In the long run I plan (and I'm very close to) making this into an evolution simulator that runs using genetic algorithms.

Obviously, herbivores and carnivores eat plants and other animals, respectively. 

Plants eat sun rays. Sun rays are actually generated and placed on the canvas randomly, and you can see this by changing the displayLightRays vairable; it's not just a function of canopy size (although canopy size will allow you to capture more light). The taller plant always gets the light when it falls on multiple canopies. 

**All about energy** 

Organisms run on energy. Staying alive costs energy. 

If your energy goes to 0, it takes away from your animal body, or plant stem. This is significant because the maximum size of other traits is tied to limited by things. 

If your energy exceeds your body size, it can be "spent" on actions. 

**Actions?**

Examples of actions are: grow body, grow mouth, grow jaws, reproduce (which costs *extra* energy, etc. Together, an organisms list of actions, it's lifeEvents, make up what is essentially it's "genome," which is what distinguishes it from other animals. 

Currently, animal genomes don't differ within their types, but as I begin adding more traits, that will be more and more sophisticated. 

**Environment**

This was made in processing, which is essentially just Java with some inbuilt functions to make it killer easy to display items on a canvas.

I haven't optimized it excessively for performance, and there are a few things I'd like to iron out. However, my current setup can handle a collision detection system for thousands of organisms on the canvas once, which I think is pretty neat. 

You will notice that animal movements are currently random. 
