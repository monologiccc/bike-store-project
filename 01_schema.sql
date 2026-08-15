CREATE TABLE brands (
    brand_id   INTEGER PRIMARY KEY,
    brand_name TEXT
);

CREATE TABLE categories (
    category_id   INTEGER PRIMARY KEY,
    category_name TEXT
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name  TEXT,
    last_name   TEXT,
    phone       TEXT,
    email       TEXT,
    street      TEXT,
    city        TEXT,
    state       TEXT,
    zip_code    TEXT
);

CREATE TABLE stores (
    store_id   INTEGER PRIMARY KEY,
    store_name TEXT,
    phone      TEXT,
    email      TEXT,
    street     TEXT,
    city       TEXT,
    state      TEXT,
    zip_code   TEXT
);

CREATE TABLE products (
    product_id   INTEGER PRIMARY KEY,
    product_name TEXT,
    brand_id     INTEGER REFERENCES brands(brand_id),
    category_id  INTEGER REFERENCES categories(category_id),
    model_year   INTEGER,
    list_price   DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id      INTEGER PRIMARY KEY,
    customer_id   INTEGER REFERENCES customers(customer_id),
    order_status  INTEGER,
    order_date    DATE,
    required_date DATE,
    shipped_date  DATE,
    store_id      INTEGER REFERENCES stores(store_id),
    staff_id      INTEGER
);

CREATE TABLE order_items (
    order_id   INTEGER REFERENCES orders(order_id),
    item_id    INTEGER,
    product_id INTEGER REFERENCES products(product_id),
    quantity   INTEGER,
    list_price DECIMAL(10,2),
    discount   DECIMAL(4,2),
    PRIMARY KEY (order_id, item_id)
);
