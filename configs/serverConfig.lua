Auth = exports.plouffe_lib:Get("Auth")
Utils = exports.plouffe_lib:Get("Utils")
Callback = exports.plouffe_lib:Get("Callback")

Server = {
	ready = false,
}

Pac = {}

Pac.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0),
  lockpickAmount = 13,
  readyDelay = math.random(1000 * 60 * 60, 1000 * 60 * 60 * 2)
}

Pac.Zones = {
  pac_office_right_1_1 = {
    name = "pac_office_right_1_1",
    coords = vector3(251.77481079102, 207.87237548828, 106.28205871582),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_right_1_1"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_right_1_2 = {
    name = "pac_office_right_1_2",
    coords = vector3(260.22900390625, 204.83934020996, 106.28205871582),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_right_1_2"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_left_1_1 = {
    name = "pac_office_left_1_1",
    coords = vector3(261.80993652344, 235.49325561523, 106.282081604),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_left_1_1"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_left_1_2 = {
    name = "pac_office_left_1_2",
    coords = vector3(270.38262939453, 232.28388977051, 106.28218078613),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_left_1_2"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_right_2_1 = {
    name = "pac_office_right_2_1",
    coords = vector3(251.82543945313, 207.99325561523, 110.1731262207),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_right_2_1"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_right_2_2 = {
    name = "pac_office_right_2_2",
    coords = vector3(260.28063964844, 204.90425109863, 110.1731262207),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_right_2_2"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_left_2_1 = {
    name = "pac_office_left_2_1",
    coords = vector3(261.94140625, 235.35134887695, 110.1731262207),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_left_2_1"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  },

  pac_office_left_2_2 = {
    name = "pac_office_left_2_2",
    coords = vector3(270.39920043945, 232.36199951172, 110.1731262207),
    distance = 0.5,
    isZone = true,
    label = "Connection",
    params = {fnc = "TryHack", zone = "pac_office_left_2_2"},
    keyMap = {
      key = "E",
      event = "plouffe_pacifique:onZone"
    }
  }
}

Pac.Doords = {
  thermal = {

  },

  lockpick = {
    "pac_bank_office_entry_right",
    "pac_bank_office_entry_right_2",
    "pac_bank_office_entry_left",
    "pac_bank_office_entry_left_2",
    "pac_bank_second_floor_office_1",
    "pac_bank_second_floor_office_2",
    "pac_bank_second_floor_office_3",
    "pac_bank_second_floor_office_4",
    "pac_bank_second_floor_office_main",
    "pac_bank_second_floor_stairs_right",
    "pac_bank_first_floor_stairs_right",
    "pac_bank_second_floor_stairs_left",
    "pac_bank_first_floor_stairs_left",
    "pac_bank_roof_top"
  },

  drill = {
    "pac_bank_basement_entry_right",
    "pac_bank_basement_entry_left",
    "pac_bank_basement_office",
    "pac_bank_basement_secured_right",
    "pac_bank_basement_secured_left",
    "pac_bank_basement_vault_lock_1",
    "pac_bank_basement_vault_lock_2"
  }
}

Pac.Trolley = {
  cash = {trolley = "hei_prop_hei_cash_trolly_01", prop = "hei_prop_heist_cash_pile", empty = "hei_prop_hei_cash_trolly_03"},
  gold = {trolley = "ch_prop_gold_trolly_01a", prop = "ch_prop_gold_bar_01a", empty = "hei_prop_hei_cash_trolly_03"},
  diamond = {trolley = "ch_prop_diamond_trolly_01a", prop = "ch_prop_vault_dimaondbox_01a", empty = "hei_prop_hei_cash_trolly_03"}
}

Pac.TrolleySpawns = {
  pac_bank_basement_secured_left = {
    {
      model = "cash",
      coords = vector3(240.50567321777, 211.99467773438, 96.121903686523),
      rotation = vector3(0.0, -0.0, -85.13)
    },

    {
      model = "cash",
      coords = vector3(241.39567321777, 215.06467773438, 96.121903686523),
      rotation = vector3(0.0, -0.0, -133.41)
    },

    {
      model = "cash",
      coords = vector3(241.50567321777, 210.44467773437, 96.121903686523),
      rotation = vector3(0.0, -0.0, -14.9)
    },

    {
      model = "cash",
      coords = vector3(244.51307067871, 213.8863067627, 96.121903686523),
      rotation = vector3(0.0, -0.0, 87.199999999999)
    }
  },

  pac_bank_basement_secured_right = {

    {
      model = "cash",
      coords = vector3(253.12530273438, 239.82112854004, 96.121903686523),
      rotation = vector3(0.0, -0.0, 139.46)
    },

    {
      model = "cash",
      coords = vector3(253.56030273438, 238.14112854004, 96.121903686523),
      rotation = vector3(0.0, -0.0, 79.7)
    },

    {
      model = "cash",
      coords = vector3(249.68530273437, 238.55862854004, 96.121903686523),
      rotation = vector3(0.0, -0.0, -108.61)
    },

    {
      model = "cash",
      coords = vector3(252.59160766602, 235.81209411621, 96.121903686523),
      rotation = vector3(0.0, -0.0, 70.3)
    }
  },

  vault = {
    {
      model = "gold",
      coords = vector3(226.47784729004, 231.55779418945, 96.121903686523),
      rotation = vector3(0.0, -0.0, -110.0)
    },

    {
      model = "gold",
      coords = vector3(227.24185913086, 233.60814147949, 96.121903686523),
      rotation = vector3(0.2, -0.0, -109.1)
    }
  }
}
