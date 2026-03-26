# FullFlower Demo Project

## Code structure considerations:

- I used an object-oriented NPC class, as this is how I have implemented similar systems like NPCs, map resources, et cetera in my games. It allows for easily extendable NPC behaviors and cleaner implementation than singletons.

- I used my own Networking module and bootstrap system that I have written & used previously.

- I avoid using ClientScripts and ServerScripts unless necessary, and I keep most of my systems as singleton modulescripts.

- The NPC class uses simple state management to prevent multiple simultaneous interactions and edge cases.

- I used a simple client-side dialogue handler that can deal with multi-line dialogue and player choices.

- NPC config files allow behavior like price ranges and custom dialogue options, while still being fast and easy to implement within the 4-hour window.

- The NPC class, behavior, and dialogue choices are all handled server-side for simplicity, while the client only handles displaying dialogue and sending user interaction information back to the server, such as exiting the dialogue or selecting an option.

I performed some basic test cases including:
- Interacting with the NPCs with all furniture states
- Spamming interactions, skipping dialogue
- Attempting to talk to multiple NPCs simultaneously

## Assumptions:

1. For this implementation, I assumed that the only transactions being made are the player selling furniture to an NPC.
2. I assumed that NPC prices are not haggle-able

## Improvements that could be made:

- The NPC data is fairly robust for the use-case, and does allow for functionality to be added on, but if I had more time I would probably choose to use some form of graph structure to model interactions as this would allow for a lot more extendability and prevent things from getting messy if we added too much functionality.

- I might choose to handle more of the interaction logic on the client, and offload a smaller part onto the server (ie, state handling and verification). This might allow for a better user experience, especially if working with high latency.

- The current implementation just uses a runtime player attribute to track money transactions. If working with more time and in a real development context I would use datastore / profilestore systems.

- The NPCs could track their past transactions and use this to inform future behavior- for example, an NPC who has purchased from the player many times may be more likely to come back.

- NPCs could have more complex behaviors or "personalities"- maybe different NPCs prefer different styles of furniture, and will pay more for their preferences.

- The state of the Dialogue GUI and the NPC interaction state are not strongly tied -- there are networked events that pass between the server-side NPC logic and the client-side dialogue handler, but it is concievable that some edge cases may cause their states to get out of sync. I would think about building a more robust system where the player/NPC interaction state and the GUI are strongly connected.