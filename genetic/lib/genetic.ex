defmodule Genetic do
  @moduledoc """
  Documentation for `Genetic`.
  """

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    for _ <- 1..population_size, do: genotype.()
  end

  def evaluate(population, fitness_function, _opts \\ []) do
    population
    |> Enum.sort_by(fitness_function, &>=/2)
  end

  def select(population, _opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

  def crossover(population, _opts \\ []) do
    population
    |> Enum.reduce([], fn {p, q}, acc ->
      cx_point = :rand.uniform(length(p))
      {{h1, t1}, {h2, t2}} = {Enum.split(p, cx_point), Enum.split(q, cx_point)}
      {c1, c2} = {h1 ++ t2, h2 ++ t1}
      [c1, c2 | acc]
    end)
  end

  def mutate(population, _opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
        if :rand.uniform() < 0.05 do
          Enum.shuffle(chromosome)
        else
          chromosome
        end
    end)
  end

  def run(fitness_function, genotype, max_fitness, opts \\ []) do
    population = initialize(genotype)
    population
    |> evolve(fitness_function, max_fitness, opts)
  end

  def evolve(population, fitness_function, max_fitness, opts \\ []) do
    population = evaluate(population, fitness_function, opts)
    best = hd(population)
    IO.write("\nCurrent Best: #{fitness_function.(best)}")
    if fitness_function.(best) == max_fitness do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutate(opts)
      |> evolve(fitness_function, max_fitness, opts)
    end
  end
end
