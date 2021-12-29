defmodule AdventOfCode.Day22 do
  use Agent

  def start_link(), do: Agent.start_link(fn -> :infinity end, name: __MODULE__)
  def get_min_spent_mp(), do: Agent.get(__MODULE__, & &1)
  def set_min_spent_mp(game), do: Agent.update(__MODULE__, fn x -> min(x, game.spent_mp) end)

  def part1(input) do
    start_link()
    [hp, dmg] = parse_input(input)

    init_game(hp, dmg)
    |> play(:player)

    get_min_spent_mp()
  end

  def part2(input) do
    start_link()
    [hp, dmg] = parse_input(input)

    init_game(hp, dmg)
    |> play(:player, :decrease)

    get_min_spent_mp()
  end

  def init_game(boss_hp, boss_dmg) do
    %{
      player: %{hp: 50, mp: 500, armor: 0},
      boss: %{hp: boss_hp, dmg: boss_dmg},
      effects: %{},
      spent_mp: 0,
      played: []
    }
  end

  def spells() do
    %{
      magic_missile: %{
        mp: 53,
        instant: fn game -> update_in(game.boss.hp, &(&1 - 4)) end
      },
      drain: %{
        mp: 73,
        instant: fn game ->
          game |> update_in([:boss, :hp], &(&1 - 2)) |> update_in([:player, :hp], &(&1 + 2))
        end
      },
      shield: %{
        mp: 113,
        instant: fn game -> update_in(game.player.armor, &(&1 + 7)) end,
        end_effect: fn game -> update_in(game.player.armor, &(&1 - 7)) end,
        turns: 6
      },
      poison: %{
        mp: 173,
        effect: fn game -> update_in(game.boss.hp, &(&1 - 3)) end,
        turns: 6
      },
      recharge: %{
        mp: 229,
        effect: fn game -> update_in(game.player.mp, &(&1 + 101)) end,
        turns: 5
      }
    }
  end

  def play(game, player, decrease \\ false)

  def play(game, :player, decrease) do
    Enum.each(spells(), fn spell ->
      try do
        game
        |> then(fn game ->
          if decrease,
            do: game |> update_in([:player, :hp], &(&1 - 1)) |> check_dead(),
            else: game
        end)
        |> apply_effects()
        |> check_dead()
        |> cast(spell)
        |> check_dead()
        |> play(:boss, decrease)
      catch
        {:dead_player, _} -> nil
        {:dead_boss, game} -> set_min_spent_mp(game)
      end
    end)
  end

  def play(game, :boss, decrease) do
    try do
      game
      |> apply_effects()
      |> check_dead()
      |> boss_attack()
      |> check_dead()
      |> play(:player, decrease)
    catch
      {:dead_player, _} -> nil
      {:dead_boss, game} -> set_min_spent_mp(game)
    end
  end

  def cast(game, {spell_name, spell}) do
    if can_cast?(game, {spell_name, spell}) do
      # spend mp
      game =
        game
        |> update_in([:player, :mp], &(&1 - spell.mp))
        |> update_in([:spent_mp], &(&1 + spell.mp))

      # apply spell if it's instant
      game = if spell[:instant], do: spell.instant.(game), else: game

      # store effects in the effects map otherwise
      game =
        if spell[:effect] || spell[:end_effect],
          do: put_in(game, [:effects, spell_name], spell.turns),
          else: game

      # add to list of played spells for debugging
      game = game |> update_in([:played], &[spell_name | &1])

      # abort this path if we're already over our minimum record
      if game.spent_mp > get_min_spent_mp(),
        do: throw({:dead_player, game}),
        else: game
    else
      # cannot cast spell
      throw({:dead_player, game})
    end
  end

  def can_cast?(game, {spell_name, spell}) do
    game.player.mp >= spell.mp and spell_name not in Map.keys(game.effects)
  end

  def apply_effects(game = %{effects: effects}) do
    Enum.reduce(effects, game, fn {spell_name, turns}, acc ->
      spell = spells()[spell_name]

      # ugh
      case {turns, spell[:effect], spell[:end_effect]} do
        {1, eff, nil} -> acc |> eff.() |> pop_in([:effects, spell_name]) |> elem(1)
        {1, nil, end_eff} -> acc |> end_eff.() |> pop_in([:effects, spell_name]) |> elem(1)
        {n, eff, nil} -> acc |> eff.() |> put_in([:effects, spell_name], n - 1)
        {n, nil, _end_eff} -> acc |> put_in([:effects, spell_name], n - 1)
      end
    end)
  end

  def boss_attack(game) do
    dmg = max(game.boss.dmg - game.player.armor, 1)
    update_in(game.player.hp, &(&1 - dmg))
  end

  def check_dead(game) do
    cond do
      game.player.hp <= 0 ->
        throw({:dead_player, game})

      game.boss.hp <= 0 ->
        throw({:dead_boss, game})

      spells() |> Enum.map(&can_cast?(game, &1)) |> Enum.all?(&(&1 == false)) ->
        throw({:dead_player, game})

      true ->
        game
    end
  end

  def parse_input(input) do
    Regex.scan(~r/-?\d*\d+/, input) |> List.flatten() |> Enum.map(&String.to_integer/1)
  end
end
