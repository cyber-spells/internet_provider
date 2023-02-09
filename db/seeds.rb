Employee.create!([
  {
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    name: "Admin",
    role: "admin"
  },
  {
    email: 'system_admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    name: "SystemAdmin",
    role: "system_admin"
  },
  {
    email: 'guest@example.com',
    password: 'password',
    password_confirmation: 'password',
    name: "Guest",
    role: "guest"
  },
])

Tariff.create([
  {
    name: "200Mb",
    speed: 200,
    price: 350,
    expiration_days: 28
  },
  {
    name: "100Mb",
    speed: 100,
    price: 230,
    expiration_days: 28
  },
  {
    name: "50Mb",
    speed: 50,
    price: 180,
    expiration_days: 28
  }
])
10.times do
  Consumer.create([
      {
        phone: "SOME PHONE",
        tariff: Tariff.all.sample,
        balance: rand(0..1000),
        tariff_expiration_at: Date.today+rand(-10..10)
      }
    ])
end
