/* ***************************************************** **
   practical_ddl_schema.sql
   
   Companion script for Practical Oracle SQL, Apress 2020
   by Kim Berg Hansen, https://www.kibeha.dk
   Use at your own risk
   *****************************************************
   
   Creation of objects in schema PRACTICAL
   Tables and indexe.
   
   To be executed in schema PRACTICAL
** ***************************************************** */
-- alter session set current_schema = practical;
/* -----------------------------------------------------
   Create tables
   ----------------------------------------------------- */

create table customers (
   id          integer constraint customer_pk primary key
 , name        varchar2(20 char) not null
);

create table conway_gen_zero (
   x           integer not null
 , y           integer not null
 , alive       integer not null check (alive in (0,1))
 , constraint conway_gen_zero_pk primary key (x, y)
);

create table web_devices (
   day         date constraint web_devices_pk primary key
 , pc          integer
 , tablet      integer
 , phone       integer
);

create table web_demographics (
   day         date constraint web_demographics_pk primary key
 , m_tw_cnt    integer
 , m_tw_qty    integer
 , m_fb_cnt    integer
 , m_fb_qty    integer
 , f_tw_cnt    integer
 , f_tw_qty    integer
 , f_fb_cnt    integer
 , f_fb_qty    integer
);

create table channels_dim (
   id          integer constraint channels_dim_pk primary key
 , name        varchar2(20 char) not null
 , shortcut    varchar2(2  char) not null
);

create table gender_dim (
   letter      char(1 char) constraint gender_dim_pk primary key
 , name        varchar2(10 char)
);

create table packaging (
   id          integer constraint packaging_pk primary key
 , name        varchar2(20 char) not null
);

create table packaging_relations (
   packaging_id   not null constraint packing_relations_parent_fk
                              references packaging
 , contains_id    not null constraint packing_relations_child_fk
                              references packaging
 , qty            integer not null
 , constraint packaging_relations_pk primary key (packaging_id, contains_id)
);

create index packing_relations_child_fk_ix on packaging_relations (contains_id);

create table product_groups (
   id          integer constraint product_groups_pk primary key
 , name        varchar2(20 char) not null
);

create table products (
   id          integer constraint products_pk primary key
 , name        varchar2(20 char) not null
 , group_id    not null constraint products_product_groups_fk
                           references product_groups
);

create index products_product_groups_fk_ix on products (group_id);

create table monthly_sales (
   product_id  not null constraint monthly_sales_product_fk
                           references products
 , mth         date     not null
 , qty         number   not null
 , constraint monthly_sales_pk primary key (product_id, mth)
 , constraint monthly_sales_mth_valid check (
      mth = trunc(mth, 'MM')
   )
);

create table breweries (
   id          integer constraint brewery_pk primary key
 , name        varchar2(20 char) not null
);

create table purchases (
   id          integer constraint purchases_pk primary key
 , purchased   date     not null
 , brewery_id  not null constraint purchases_brewery_fk
                           references breweries
 , product_id  not null constraint purchases_product_fk
                           references products
 , qty         number   not null
 , cost        number   not null
);

create index purchases_brewery_fk_ix on purchases (brewery_id);

create index purchases_product_fk_ix on purchases (product_id);

create table product_alcohol (
   product_id     not null constraint product_alcohol_pk primary key
                           constraint product_alcohol_product_fk
                              references products
 , sales_volume   number   not null
 , abv            number   not null
);

create table customer_favorites (
   customer_id    not null constraint customer_favorites_customer_fk
                              references customers
 , favorite_list  varchar2(4000 char)
 , constraint customer_favorites_pk primary key (customer_id)
);

create table customer_reviews (
   customer_id    not null constraint customer_reviews_customer_fk
                              references customers
 , review_list    varchar2(4000 char)
 , constraint customer_reviews_pk primary key (customer_id)
);

create table locations (
   id          integer constraint location_pk primary key
 , warehouse   integer     not null
 , aisle       varchar2(1) not null
 , position    integer     not null
 , constraint locations_uq unique (warehouse, aisle, position)
);

create table inventory (
   id          integer  constraint inventory_pk primary key
 , location_id not null constraint inventory_location_fk
                           references locations
 , product_id  not null constraint inventory_product_fk
                           references products
 , purchase_id not null constraint inventory_purchase_fk
                           references purchases
 , qty         number   not null
);

create index inventory_location_fk_ix on inventory (location_id);

create index inventory_product_fk_ix on inventory (product_id);

create index inventory_purchase_fk_ix on inventory (purchase_id);

create table orders (
   id          integer  constraint order_pk primary key
 , customer_id not null constraint order_customer_fk
                           references customers
 , ordered     date
 , delivery    date
);

create index order_customer_fk_ix on orders (customer_id);

create table orderlines (
   id          integer  constraint orderline_pk primary key
 , order_id    not null constraint orderline_order_fk
                           references orders
 , product_id  not null constraint orderline_product_fk
                           references products
 , qty         number   not null
 , amount      number   not null
);

create index orderline_order_fk_ix on orderlines (order_id);

create table monthly_budget (
   product_id  not null constraint monthly_budget_product_fk
                           references products
 , mth         date     not null
 , qty         number   not null
 , constraint monthly_budget_pk primary key (product_id, mth)
 , constraint monthly_budget_mth_valid check (
      mth = trunc(mth, 'MM')
   )
);

create table product_minimums (
   product_id     not null constraint product_minimums_pk primary key
                           constraint product_minimums_product_fk
                              references products
 , qty_minimum    number   not null
 , qty_purchase   number   not null
);

create table stock (
   symbol   varchar2(10) constraint stock_pk primary key
 , company  varchar2(40) not null
);

create table ticker (
   symbol   constraint ticker_symbol_fk references stock
 , day      date   not null
 , price    number not null
 , constraint ticker_pk primary key (symbol, day)
);

create table web_apps (
   id             integer constraint web_apps_pk primary key
 , name           varchar2(20 char) not null
);

create table web_pages (
   app_id         not null constraint web_pages_app_fk
                     references web_apps
 , page_no        integer not null
 , friendly_url   varchar2(20 char) not null
 , constraint web_pages_pk primary key (app_id, page_no)
);

create table web_counter_hist (
   app_id      integer not null
 , page_no     integer not null
 , day         date    not null
 , counter     integer not null
 , constraint web_counter_hist_pk primary key (app_id, page_no, day)
 , constraint web_counter_hist_page_fk foreign key (app_id, page_no)
      references web_pages (app_id, page_no)
);

create table server_heartbeat (
   server      varchar2(15 char) not null
 , beat_time   date              not null
 , constraint server_heartbeat_uq unique (
      server, beat_time
   )
);

create table web_page_visits (
   client_ip   varchar2(15 char) not null
 , visit_time  date              not null
 , app_id      integer           not null
 , page_no     integer           not null
 , constraint web_page_visits_page_fk foreign key (app_id, page_no)
      references web_pages (app_id, page_no)
);

create index web_page_visits_page_fk_ix on web_page_visits (app_id, page_no);

create table employees (
   id             integer constraint employees_pk primary key
 , name           varchar2(20 char) not null
 , title          varchar2(20 char) not null
 , supervisor_id  constraint employees_supervisor_fk
                     references employees
);

create index employees_supervisor_fk_ix on employees (supervisor_id);

create table emp_hire_periods (
   emp_id         not null constraint emp_hire_periods_emp_fk
                     references employees
 , start_date     date not null
 , end_date       date
 , title          varchar2(20 char) not null
 , constraint emp_hire_periods_pk primary key (emp_id, start_date)
 , period for employed_in (start_date, end_date)
);

create table picking_list (
   id             integer constraint picking_list_pk primary key
 , created        date not null
 , picker_emp_id  constraint picking_list_emp_fk
                     references employees
);

create index picking_list_emp_fk_ix on picking_list (picker_emp_id);

create table picking_line (
   picklist_id    not null constraint picking_line_picking_list_fk
                     references picking_list
 , line_no        integer not null
 , location_id    not null constraint picking_line_location_fk
                     references locations
 , order_id       not null constraint picking_line_order_fk
                     references orders
 , product_id     not null constraint picking_line_product_fk
                     references products
 , qty            number not null
 , constraint     picking_line_pk primary key (picklist_id, line_no)
);

create index picking_line_location_fk_ix on picking_line (location_id);

create index picking_line_order_fk_ix on picking_line (order_id);

create index picking_line_product_fk_ix on picking_line (product_id);

create table picking_log (
   picklist_id    not null constraint picking_log_picking_list_fk
                     references picking_list
 , log_time       date not null
 , activity       varchar2(1 char) not null
                     check (activity in ('A', 'P', 'D'))
 , location_id    constraint picking_log_location_fk
                     references locations
 , pickline_no    integer
 , constraint picking_log_picking_line_fk foreign key (picklist_id, pickline_no)
      references picking_line (picklist_id, line_no)
 , constraint picking_log_picking_line_ck
      check (not (activity = 'P' and pickline_no is null))
);

create index picking_log_picking_line_fk_ix on picking_log (picklist_id, pickline_no);

create index picking_log_location_fk on picking_log (location_id);