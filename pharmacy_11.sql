-- Производитель
CREATE TABLE
  manufacturer (
    id serial PRIMARY KEY,
    company_name varchar(255) NOT NULL UNIQUE,
    phone varchar(30) NOT NULL,
    email varchar(50) NOT NULL,
    address varchar(255) NOT NULL,
    description text NOT NULL,
    country varchar(50) NOT NULL
  );

-- Единицы измерения
CREATE TABLE
  units_of_measurement (
    id serial PRIMARY KEY,
    measurement_name varchar(20) UNIQUE NOT NULL
  );

-- Форма выпуска
CREATE TABLE
  dosage_form (
    id serial PRIMARY KEY,
    dosage_form_name varchar(30) UNIQUE NOT NULL
  );

-- Категория продукта
CREATE TABLE
  product_category (
    id serial PRIMARY KEY,
    category varchar(50) UNIQUE NOT NULL
  );

-- Поставщик
CREATE TABLE
  supplier (
    id serial PRIMARY KEY,
    company_name varchar(50) UNIQUE NOT NULL,
    phone varchar(30) NOT NULL,
    email varchar(30) NOT NULL,
    address varchar(255) NOT NULL
  );

-- Статус заказа
CREATE TABLE
  order_status (
    id serial PRIMARY KEY,
    status varchar(20) UNIQUE NOT NULL
  );

-- Рецепт
CREATE TABLE
  prescription (
    id serial PRIMARY KEY,
    prescription_number varchar UNIQUE NOT NULL,
    customer_name varchar(50) NOT NULL,
    doctor_name varchar(50) NOT NULL,
    date date NOT NULL,
    expiration_date date NOT NULL,
    description text
  );

-- Роль пользователя
CREATE TABLE
  role (
    id serial PRIMARY KEY,
    role varchar(50) UNIQUE NOT NULL
  );

-- Пользователи
CREATE TABLE
  users (
    id serial PRIMARY KEY,
    login varchar(32) NOT NULL,
    password varchar(64) NOT NULL,
    is_activ boolean NOT NULL,
    role_id bigint NOT NULL,
    FOREIGN KEY (role_id) REFERENCES role (id)
  );

-- Верификация
CREATE TABLE
  verification (
    id serial PRIMARY KEY,
    email varchar(128) NOT NULL UNIQUE,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users (id)
  );

-- Препарат
CREATE TABLE
  product (
    id serial PRIMARY KEY,
    name varchar(50) NOT NULL UNIQUE,
    manufacturer_id int,
    FOREIGN KEY (manufacturer_id) REFERENCES manufacturer (id),
    prescriptionReqired boolean NOT NULL,
    price DECIMAL(8, 2) NOT NULL CONSTRAINT the_prise_must_be_greather_than_0 CHECK (price > 0),
    category_id int NOT NULL,
    FOREIGN KEY (category_id) REFERENCES product_category (id),
    units_of_ms_id int NOT NULL,
    FOREIGN KEY (units_of_ms_id) REFERENCES units_of_measurement (id),
    dosage_form_id int NOT NULL,
    FOREIGN KEY (dosage_form_id) REFERENCES dosage_form (id),
    description text
  );

-- Данные пользователя
CREATE TABLE
  user_data (
    id serial PRIMARY KEY,
    first_name varchar(255) NOT NULL,
    last_name varchar(255) NOT NULL,
    address text NOT NULL,
    user_id int NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id)
  );

-- Склад
CREATE TABLE
  warehouse (
    id serial PRIMARY KEY,
    product_id int,
    FOREIGN KEY (product_id) REFERENCES product (id),
    stock_quantity int,
    CONSTRAINT quantity_must_be_greather_than_0 CHECK (stock_quantity > 0)
  );

-- Детали рецепта
CREATE TABLE
  prescription_details (
    id serial PRIMARY KEY,
    product_id int NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product (id),
    prescription_id int NOT NULL,
    FOREIGN KEY (prescription_id) REFERENCES prescription (id),
    quantity int NOT NULL CONSTRAINT quantity_must_be_greather_then_0 CHECK (quantity > 0)
  );

-- Поступление товара на склад
CREATE TABLE
  stock_entry (
    id serial PRIMARY KEY,
    date date NOT NULL,
    supplier_id int NOT NULL,
    FOREIGN KEY (supplier_id) REFERENCES supplier (id),
    user_id int NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users (id)
  );

-- Детали поступления товара
CREATE TABLE
  stock_entry_details (
    id serial PRIMARY KEY,
    product_id int NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product (id),
    stock_entry_id int NOT NULL,
    FOREIGN KEY (stock_entry_id) REFERENCES stock_entry (id),
    quantity int NOT NULL CONSTRAINT quantity_must_be_greather_than_0 CHECK (quantity > 0),
    entry_price decimal(8, 2) NOT NULL CONSTRAINT price_cant_be_lower_than_0 CHECK (entry_price >= 0)
  );

-- Заказ
CREATE TABLE
  clients_order (
    id serial PRIMARY KEY,
    order_date date NOT NULL,
    employee_id int,
    FOREIGN KEY (employee_id) REFERENCES users (id),
    customer_id int NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES users (id),
    total_amount decimal(8, 2) NOT NULL CONSTRAINT amount_cant_be_lower_than_0 CHECK (total_amount >= 0),
    status_id int NOT NULL,
    FOREIGN KEY (status_id) REFERENCES order_status (id),
    prescription_id int,
    FOREIGN KEY (prescription_id) REFERENCES prescription (id)
  );

-- Детали заказа
CREATE TABLE
  order_details (
    id serial PRIMARY KEY,
    product_id int NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product (id),
    order_id int NOT NULL,
    FOREIGN KEY (order_id) REFERENCES "clients_order" (id),
    quantity int NOT NULL CONSTRAINT quantity_must_be_greather_than_0 CHECK (quantity > 0)
  );

--Заполнение таблиц
INSERT INTO
  role (role)
VALUES
  ('admin'),
  ('customer'),
  ('employee');

INSERT INTO
  users (login, password, is_activ, role_id)
VALUES
  ('login1', 'password1', true, 1),
  ('login2', 'password2', false, 2),
  ('login3', 'password3', true, 2),
  ('login4', 'password4', false, 2),
  ('login5', 'password5', true, 3),
  ('login6', 'password6', false, 2),
  ('login7', 'password7', true, 2),
  ('login8', 'password8', false, 2),
  ('login9', 'password9', true, 2),
  ('login10', 'password10', false, 2),
  ('login11', 'password11', true, 3),
  ('login12', 'password12', false, 2),
  ('login13', 'password13', true, 2),
  ('login14', 'password14', false, 2),
  ('login15', 'password15', true, 2),
  ('login16', 'password16', false, 2),
  ('login17', 'password17', true, 2),
  ('login18', 'password18', false, 3),
  ('login19', 'password19', true, 2),
  ('login20', 'password20', false, 2);

INSERT INTO
  verification (email, user_id)
VALUES
  ('julia.martin@example.com', 1),
  ('james.jackson@example.com', 2),
  ('elise.david@example.com', 3),
  ('pahal.namnaik@example.com', 4),
  ('magnus.andersen@example.com', 5),
  ('glafira.filipenko@example.com', 6),
  ('lotta.tikkanen@example.com', 7),
  ('jesse.seppala@example.com', 8),
  ('swantje.moll@example.com', 9),
  ('esat.okumus@example.com', 10),
  ('taras.tertishniy@example.com', 11),
  ('amol.thampy@example.com', 12),
  ('stephanie.lucas@example.com', 13),
  ('austin.hale@example.com', 14),
  ('florian.andeweg@example.com', 15),
  ('nicolas.lefebvre@example.com', 16),
  ('kerim.karabocek@example.com', 17),
  ('otto.lehto@example.com', 18),
  ('emily.boyd@example.com', 19),
  ('krissie.vanhulst@example.com', 20);

INSERT INTO
  user_data (first_name, last_name, address, user_id)
VALUES
  (
    'Julia',
    'Martin',
    'Rue du Stade 1127, Switzerland, Montilliez',
    1
  ),
  (
    'James',
    'Jackson',
    'Highgate 5926, New Zealand, Blenheim',
    2
  ),
  (
    'Elise',
    'David',
    'Rue des Ecrivains 6331, France, Lille',
    3
  ),
  (
    'Pahal',
    'Namnaik',
    'Bhavani Peth 4563, India, Pimpri-Chinchwad',
    4
  ),
  (
    'Magnus',
    'Andersen',
    'Engtoften 9382, Denmark, Rønnede',
    5
  ),
  (
    'Glafira',
    'Filipenko',
    'Cheska 112, Ukraine, Voznesenivka',
    6
  ),
  (
    'Lotta',
    'Tikkanen',
    'Esplanadi 9220, Finland, Karjalohja',
    7
  ),
  (
    'Jesse',
    'Seppala',
    'Tehtaankatu 4542, Finland, Kimitoön',
    8
  ),
  (
    'Swantje',
    'Moll',
    'Bergstraße 7531, Germany, Naumburg',
    9
  ),
  (
    'Esat',
    'Okumus',
    'Fatih Sultan Mehmet Cd 8945, Turkey, Trabzon',
    10
  ),
  (
    'Taras',
    'Tertishniy',
    'Starozamkova 6157, Ukraine, Nosivka',
    11
  ),
  (
    'Amol',
    'Thampy',
    'Dadabhai Naoroji Rd 2518, India, Mahbubnagar',
    12
  ),
  (
    'Stephanie',
    'Lucas',
    'Rue Chazière 4091, Switzerland, Ueken',
    13
  ),
  (
    'Austin',
    'Hale',
    'Queensway 2678, United Kingdom, Manchester',
    14
  ),
  (
    'Florian',
    'Andeweg',
    'Burgemeester Hoekstrastraat 87, Netherlands, Vught',
    15
  ),
  (
    'Nicolas',
    'Lefebvre',
    'Rue Desaix 4048, France, Rennes',
    16
  ),
  (
    'Kerim',
    'Karaböcek',
    'Fatih Sultan Mehmet Cd 8678, Turkey, Kirklareli',
    17
  ),
  (
    'Otto',
    'Lehto',
    'Aleksanterinkatu 244, Finland, Kolari',
    18
  ),
  (
    'Emily',
    'Boyd',
    'Park Avenue 5004, United Kingdom, Brighton and Hove',
    19
  ),
  (
    'Krissie',
    'Van Hulst',
    'Burgemeestersplantsoen 7519, Netherlands, Banhol',
    20
  );

INSERT INTO
  manufacturer (
    company_name,
    phone,
    email,
    address,
    description,
    country
  )
VALUES
  (
    'company_name1',
    'phone1',
    'email1',
    'address1',
    'description1',
    'country1'
  ),
  (
    'company_name2',
    'phone2',
    'email2',
    'address2',
    'description2',
    'country2'
  ),
  (
    'company_name3',
    'phone3',
    'email3',
    'address3',
    'description3',
    'country3'
  ),
  (
    'company_name4',
    'phone4',
    'email4',
    'address4',
    'description4',
    'country4'
  ),
  (
    'company_name5',
    'phone5',
    'email5',
    'address5',
    'description5',
    'country5'
  ),
  (
    'company_name6',
    'phone6',
    'email6',
    'address6',
    'description6',
    'country6'
  );

SELECT
  *
FROM
  manufacturer;

INSERT INTO
  supplier (company_name, phone, email, address)
VALUES
  (
    'Global Pharma',
    '+1-202-555-0182',
    'contact@globalpharma.com',
    '123 Elm St, New York, NY, USA'
  ),
  (
    'Health Solutions Inc.',
    '+1-202-555-0198',
    'info@healions.com',
    '456 Oak St, Boston, MA, USA'
  ),
  (
    'MediSupply Co.',
    '+44-20-7946-0958',
    'support@medisupply.co.uk',
    '789 Maple Ave, London, UK'
  ),
  (
    'Wellness World',
    '+49-30-555-0123',
    'sales@wellnessworld.de',
    '101 Pine St, Berlin, Germany'
  ),
  (
    'LifeLine Distributors',
    '+33-1-555-0145',
    'contact@lifelinedistri.fr',
    '202 Cedar St, Paris, France'
  ),
  (
    'PharmaDirect',
    '+1-305-555-0119',
    'orders@pharmadirect.com',
    '303 Walnut Ave, Miami, FL, USA'
  ),
  (
    'Healthy You Supplies',
    '+61-2-5550-1234',
    'service@healthyyou.au',
    '404 Spruce St, Sydney, Australia'
  ),
  (
    'MedAlliance',
    '+81-3-5550-9876',
    'contact@medalliance.jp',
    '505 Birch Rd, Tokyo, Japan'
  );

-- Filling data for the  product_category table
INSERT INTO
  product_category (category)
VALUES
  ('Antibiotics'),
  ('Analgesics'),
  ('Anti-inflammatory'),
  ('Vitamins and supplements'),
  ('Antihistamines'),
  ('Antivirals'),
  ('Immunomodulators'),
  ('Hormonal drugs'),
  ('Antibacterials'),
  ('Cardiology drugs'),
  ('Antidiabetics'),
  ('Antifungals'),
  ('Anticough drugs'),
  ('Gastroenterology drugs'),
  ('Antidepressants'),
  ('Antipyretics');

-- Filling data for the units_of_measurement  table
INSERT INTO
  units_of_measurement (measurement_name)
VALUES
  ('Milligrams (mg)'),
  ('Grams (g)'),
  ('Kilograms (kg)'),
  ('Micrograms (mcg)'),
  ('Milliliters (ml)'),
  ('Liters (l )'),
  ('Items'),
  ('Capsules'),
  ('Tablets'),
  ('Ampoules'),
  ('Bottles'),
  ('Packages'),
  ('Sachets'),
  ('Suppositories'),
  ('Ointment'),
  ('Gels');

-- Filling data for the  dosage_form table
INSERT INTO
  dosage_form (dosage_form_name)
VALUES
  ('Tablet'),
  ('Capsule'),
  ('Powder'),
  ('Injection solution'),
  ('Syrup'),
  ('Suspension'),
  ('Gel'),
  ('Ointment'),
  ('Cream'),
  ('Suppository'),
  ('Spray'),
  ('Drops'),
  ('Paste'),
  ('Lotion'),
  ('Patch'),
  ('Granules');

-- Filling data for the product table
INSERT INTO
  product (
    name,
    manufacturer_id,
    prescriptionReqired,
    price,
    category_id,
    units_of_ms_id,
    dosage_form_id,
    description
  )
VALUES
  (
    'Aspirin',
    1,
    true,
    5.99,
    1,
    1,
    1,
    'Pain reliever and fever reducer'
  ),
  (
    'Ibuprofen',
    2,
    true,
    7.99,
    2,
    2,
    1,
    'Non-steroidal anti-inflammatory drug'
  ),
  (
    'Paracetamol',
    1,
    false,
    6.49,
    1,
    1,
    1,
    'Pain reliever and fever reducer'
  ),
  (
    'Amoxicillin',
    3,
    true,
    12.99,
    3,
    3,
    2,
    'Antibiotic for bacterial infections'
  ),
  (
    'Cetirizine',
    2,
    false,
    8.49,
    4,
    1,
    1,
    'Antihistamine for allergies'
  ),
  (
    'Vitamin C',
    1,
    false,
    4.99,
    5,
    1,
    1,
    'Supplement for immune support'
  ),
  (
    'Lisinopril',
    4,
    true,
    9.99,
    3,
    2,
    1,
    'Blood pressure medication'
  ),
  (
    'Metformin',
    5,
    true,
    10.99,
    3,
    2,
    1,
    'Diabetes management'
  ),
  (
    'Omeprazole',
    6,
    true,
    14.99,
    4,
    2,
    1,
    'Stomach acid reducer'
  ),
  (
    'Prednisone',
    2,
    true,
    11.99,
    4,
    2,
    1,
    'Steroid to reduce inflammation'
  ),
  (
    'Folic Acid',
    1,
    false,
    3.99,
    5,
    1,
    1,
    'B vitamin for health support'
  ),
  (
    'Amlodipine',
    4,
    true,
    9.49,
    3,
    1,
    1,
    'Blood pressure medication'
  ),
  (
    'Losartan',
    5,
    true,
    8.99,
    3,
    2,
    1,
    'Angiotensin receptor blocker'
  ),
  (
    'Atorvastatin',
    6,
    true,
    13.99,
    3,
    2,
    1,
    'Cholesterol-lowering medication'
  ),
  (
    'Loratadine',
    2,
    false,
    6.49,
    4,
    1,
    1,
    'Non-drowsy antihistamine'
  ),
  (
    'Vitamin D',
    1,
    false,
    5.99,
    5,
    1,
    1,
    'Supplement for bone health'
  );
  
