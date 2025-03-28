/*
	Copyright (C) 2015 - 2025
	by Iris Morelle <shadowm2006@gmail.com>
	Part of the Battle for Wesnoth Project https://www.wesnoth.org/

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY.

	See the COPYING file for more details.
*/

#include "gui/dialogs/multiplayer/mp_join_game_password_prompt.hpp"


namespace gui2::dialogs
{

REGISTER_DIALOG(mp_join_game_password_prompt)

mp_join_game_password_prompt::mp_join_game_password_prompt(
		std::string& password)
	: modal_dialog(window_id())
{
	register_text("password", true, password, true);
}

} // namespace dialogs
