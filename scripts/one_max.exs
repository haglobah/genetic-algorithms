population = for _ <-  1..100, do: for _ <- 1..1000, do: Enum.random(0..1)

evaluate =
  fn population ->
    Enum.sort_by(population, &Enum.sum/1, &>=/2)
  end
