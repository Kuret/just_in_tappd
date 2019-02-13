alias JustInTappd.Repo
alias JustInTappd.Accounts.User

%User{
  id: Ecto.UUID.generate(),
  email: "rick+justintappd@littel.me",
  first_name: "Rick",
  last_name: "Littel",
  active: true
}
|> Repo.insert!()

%User{
  id: Ecto.UUID.generate(),
  email: "ronalddijkstra@gmail.com",
  first_name: "Ronald",
  last_name: "Dijkstra",
  active: true
}
|> Repo.insert!()

%User{
  id: Ecto.UUID.generate(),
  email: "just_in_beer@hotmail.com",
  first_name: "Justin",
  last_name: "van Akkeren",
  active: true
}
|> Repo.insert!()
