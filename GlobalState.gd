extends Node

# This script is used for managing anything that needs to be global state.
# Some people will say global states are bad. And they are, to a degree, correct.
# But for example, it makes much more sense to cache a Player node here than it
# does to have every single node try to grab the player using get_node() or
# get_nodes_in_group() or whatever.

