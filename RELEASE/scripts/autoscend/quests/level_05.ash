// L5 quest progress notes:
// unstarted
// started == acquired [Cobb's Knob map] from council
// step1 == used [Cobb's Knob map] with [Knob Goblin encryption key] to unlock internal zones.
// finished == killed the king. you still need to visit council afterwards to get rewarded.

boolean L5_getEncryptionKey()
{
	if(internalQuestStatus("questL05Goblin") != 0 || item_amount($item[Knob Goblin Encryption Key]) > 0)
	{
		return false;
	}
	if(item_amount($item[11-inch knob sausage]) == 1)
	{
		visit_url("guild.php?place=challenge");
		return true;
	}


	if(canBurnDelay($location[The Outskirts of Cobb\'s Knob]))
	{
		return false;
	}

	if(in_gnoob() && auto_have_familiar($familiar[Robortender]))
	{
		if(!have_skill($skill[Retractable Toes]) && (item_amount($item[Cocktail Mushroom]) == 0))
		{
			handleFamiliar($familiar[Robortender]);
		}
	}

	auto_log_info("Looking for the knob.", "blue");
	return autoAdv($location[The Outskirts of Cobb\'s Knob]);
}

boolean L5_findKnob()
{
	if(internalQuestStatus("questL05Goblin") != 0)
	{
		return false;
	}
	if(item_amount($item[Knob Goblin Encryption Key]) == 1)
	{
		if(item_amount($item[Cobb\'s Knob Map]) == 0)
		{
			council();
		}
		use(1, $item[Cobb\'s Knob Map]);
		return true;
	}
	return false;
}

boolean L5_haremOutfit()
{
	if(internalQuestStatus("questL05Goblin") != 1)
	{
		return false;
	}
	if(possessOutfit("Knob Goblin Harem Girl Disguise"))
	{
		return false;
	}

	if(!adjustForYellowRayIfPossible($monster[Knob Goblin Harem Girl]))
	{
		if(!isAboutToPowerlevel())
		{
			return false;
		}
	}

	if(in_heavyrains())
	{
		buffMaintain($effect[Fishy Whiskers]);
	}
	bat_formBats();

	auto_log_info("Looking for some sexy lingerie!", "blue");
	if(autoAdv($location[Cobb\'s Knob Harem]))
	{
		return true;
	}
	return false;
}

boolean L5_goblinKing()
{
	if(internalQuestStatus("questL05Goblin") != 1)
	{
		return false;
	}
	if(my_level() < 8 && !isAboutToPowerlevel()) // needs to be changed to check if we'll survive
	{
		return false;
	}
	if(my_adventures() <= 2)
	{
		return false;
	}

	if(!possessOutfit("Knob Goblin Harem Girl Disguise"))
	{
		return false;
	}
	if(robot_delay("outfit"))
	{
		return false; // delay for You, Robot path
	}

	auto_log_info("Death to the gobbo!!", "blue");
	if(!autoOutfit("Knob Goblin Harem Girl Disguise"))
	{
		abort("Could not put on Knob Goblin Harem Girl Disguise, aborting");
	}
	buffMaintain($effect[Knob Goblin Perfume]);
	if(have_effect($effect[Knob Goblin Perfume]) == 0)
	{
		boolean advSpent = autoAdv($location[Cobb\'s Knob Harem]);
		if(have_effect($effect[Knob Goblin Perfume]) == 0)
		{
			advSpent = autoAdv($location[Cobb\'s Knob Harem]);
		}
		return advSpent;
	}

	if(my_primestat() == $stat[Muscle])
	{
		buyUpTo(1, $item[Ben-Gal&trade; Balm]);
		buffMaintain($effect[Go Get \'Em\, Tiger!]);
	}
	buyUpTo(1, $item[Hair Spray]);
	buffMaintain($effect[Butt-Rock Hair]);

	if((my_class() == $class[Seal Clubber]) || (my_class() == $class[Turtle Tamer]))
	{
		buyUpTo(1, $item[Blood of the Wereseal]);
		buffMaintain($effect[Temporary Lycanthropy]);
	}

	// TODO: I died here, maybe we should heal a bit?
	if(!in_plumber())
	{
		auto_change_mcd(10); // get the Crown from the Goblin King.
	}
	set_property("auto_nextEncounter","Knob Goblin King");
	boolean advSpent = autoAdv($location[Throne Room]);

	if((item_amount($item[Crown of the Goblin King]) > 0) || (item_amount($item[Glass Balls of the Goblin King]) > 0) || (item_amount($item[Codpiece of the Goblin King]) > 0) || (get_property("questL05Goblin") == "finished") || in_plumber())
	{
		council();
	}
	return advSpent;
}

boolean L5_slayTheGoblinKing()
{
	if(L5_getEncryptionKey() || L5_findKnob() || L5_haremOutfit() || L5_goblinKing())
	{
		return true;
	}
	return false;
}
