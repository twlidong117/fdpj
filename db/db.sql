-- 基础配置
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- schema

ALTER SCHEMA public OWNER TO postgres;

-- domain

-- 枚举

CREATE TYPE public.gender AS ENUM (
  'male',
  'female'
);

ALTER TYPE public.gender OWNER TO postgres;

CREATE TYPE public.prod_state AS ENUM (
  'on',
  'ready'
  'off'
);

ALTER TYPE public.prod_state OWNER TO postgres;

CREATE TYPE public.order_status AS ENUM (
  'toconfirm',
  'confirmed'
  'cancelled',
  'error'
);

ALTER TYPE public.order_status OWNER TO postgres;

CREATE TYPE public.pay_status AS ENUM (
  'unpaid',
  'paid'
);

ALTER TYPE public.pay_status OWNER TO postgres;

CREATE TYPE public.shipping_status AS ENUM (
  'tosend',
  'sending'
  'received'
);

ALTER TYPE public.shipping_status OWNER TO postgres;

-- 函数

-- 建表：序列+表+视图

SET default_tablespace = '';

SET default_table_access_method = heap;

-- 员工表：employee

CREATE SEQUENCE public.employee_employee_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.employee_employee_id_seq OWNER TO postgres;

CREATE TABLE public.employee (
  employee_id integer DEFAULT nextval('public.employee_employee_id_seq'::regclass) NOT NULL,
  name text NOT NULL,
  birth_date date NOT NULL,
  gender public.gender NOT NULL,
  phone integer NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.employee OWNER TO postgres;

-- 员工用户组关系表：employee_usergroup

CREATE TABLE public.employee_usergroup (
  employee_id integer NOT NULL,
  usergroup_id integer NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.employee_usergroup OWNER TO postgres;

-- 用户组表：usergroup

CREATE SEQUENCE public.usergroup_usergroup_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.usergroup_usergroup_id_seq OWNER TO postgres;

CREATE TABLE public.usergroup (
  usergroup_id integer DEFAULT nextval('public.usergroup_usergroup_id_seq'::regclass) NOT NULL,
  usergroup_name text NOT NULL,
  description text,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.usergroup OWNER TO postgres;

-- 用户组权限规则关系

CREATE TABLE public.usergroup_accesspolicy (
  usergroup_id integer NOT NULL,
  policy_id integer NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.usergroup_accesspolicy OWNER TO postgres;

-- 权限规则表 access_policy

CREATE SEQUENCE public.accesspolicy_policy_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.accesspolicy_policy_id_seq OWNER TO postgres;

CREATE TABLE public.accesspolicy (
  policy_id integer DEFAULT nextval('public.accesspolicy_policy_id_seq'::regclass) NOT NULL,
  accesspolicy_name text NOT NULL,
  description text,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.usergroup OWNER TO postgres;

-- API接口注册表 api

CREATE SEQUENCE public.api_api_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.api_api_id_seq OWNER TO postgres;

CREATE TABLE public.api (
  api_id integer DEFAULT nextval('public.api_api_id_seq'::regclass) NOT NULL,
  uri text NOT NULL,
  description text,
  policy_id integer,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.api OWNER TO postgres;

-- 菜品表 dish

CREATE SEQUENCE public.dish_dish_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.dish_dish_id_seq OWNER TO postgres;

CREATE TABLE public.dish (
  dish_id integer DEFAULT nextval('public.dish_dish_id_seq'::regclass) NOT NULL,
  name text NOT NULL,
  description text,
  price money NOT NULL,
  stock integer NOT NULL,
  status public.prod_state NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.dish OWNER TO postgres;

-- 菜品套餐关系表 dish_meal

CREATE TABLE public.dish_meal (
  dish_id integer NOT NULL,
  meal_id integer NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.dish_meal OWNER TO postgres;

-- 套餐表 meal

CREATE SEQUENCE public.meal_meal_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.meal_meal_id_seq OWNER TO postgres;

CREATE TABLE public.meal (
  meal_id integer DEFAULT nextval('public.meal_meal_id_seq'::regclass) NOT NULL,
  name text NOT NULL,
  description text,
  price money NOT NULL,
  stock integer NOT NULL,
  status public.prod_state NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.meal OWNER TO postgres;

-- 商品图表 prodimage

CREATE SEQUENCE public.prodimage_image_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.prodimage_image_id_seq OWNER TO postgres;

CREATE TABLE public.prodimage (
  image_id integer DEFAULT nextval('public.prodimage_image_id_seq'::regclass) NOT NULL,
  url text NOT NULL,
  dish_id integer,
  meal_id integer,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.prodimage OWNER TO postgres;

-- 订单表 order

CREATE SEQUENCE public.order_order_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.order_order_id_seq OWNER TO postgres;

CREATE TABLE public.order (
  order_id integer DEFAULT nextval('public.order_order_id_seq'::regclass) NOT NULL,
  amount money NOT NULL, 
  order_status public.order_status DEFAULT 'toconfirm'::public.order_status,
  pay_status public.pay_status DEFAULT 'unpaid'::public.pay_status,
  shipping_status public.shipping_status DEFAULT 'tosend'::public.shipping_status,
  customer_id integer NOT NULL,
  address text NOT NULL,
  created_time timestamp with time zone,
  paid_time timestamp with time zone,
  finished_time timestamp with time zone,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.order OWNER TO postgres;

-- 订单信息表 order_info

CREATE SEQUENCE public.orderinfo_info_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.orderinfo_info_id_seq OWNER TO postgres;

CREATE TABLE public.orderinfo (
  info_id integer DEFAULT nextval('public.orderinfo_info_id_seq'::regclass) NOT NULL,
  order_id integer NOT NULL,
  dish_id integer,
  dish_name text,
  dish_price money,
  meal_id integer,
  meal_name text,
  meal_price money,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.orderinfo OWNER TO postgres;

-- 顾客表 customer

CREATE SEQUENCE public.customer_customer_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.customer_customer_id_seq OWNER TO postgres;

CREATE TABLE public.customer (
  customer_id integer DEFAULT nextval('public.customer_customer_id_seq'::regclass) NOT NULL,
  name text NOT NULL,
  phone integer NOT NULL,
  credit money NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.customer OWNER TO postgres;

-- 地址表 address

CREATE SEQUENCE public.address_address_id_seq
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;

ALTER TABLE public.address_address_id_seq OWNER TO postgres;

CREATE TABLE public.address (
  address_id integer DEFAULT nextval('public.address_address_id_seq'::regclass) NOT NULL,
  content text NOT NULL,
  customer_id integer NOT NULL,
  del_flag boolean DEFAULT false NOT NULL,
  create_date date DEFAULT CURRENT_DATE NOT NULL,
  last_update_time timestamp with time zone DEFAULT now()
);

ALTER TABLE public.address OWNER TO postgres;

-- 主键约束

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (employee_id);

ALTER TABLE ONLY public.usergroup
    ADD CONSTRAINT usergroup_pkey PRIMARY KEY (usergroup_id);

ALTER TABLE ONLY public.accesspolicy
    ADD CONSTRAINT accesspolicy_pkey PRIMARY KEY (policy_id);

ALTER TABLE ONLY public.api
    ADD CONSTRAINT api_pkey PRIMARY KEY (api_id);

ALTER TABLE ONLY public.dish
    ADD CONSTRAINT dish_pkey PRIMARY KEY (dish_id);

ALTER TABLE ONLY public.meal
    ADD CONSTRAINT meal_pkey PRIMARY KEY (meal_id);

ALTER TABLE ONLY public.prodimage
    ADD CONSTRAINT prodimage_pkey PRIMARY KEY (image_id);

ALTER TABLE ONLY public.order
    ADD CONSTRAINT order_pkey PRIMARY KEY (order_id);

ALTER TABLE ONLY public.orderinfo
    ADD CONSTRAINT orderinfo_pkey PRIMARY KEY (info_id);

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (address_id);

-- 分表

-- 触发器

-- 索引

-- 外键约束

ALTER TABLE ONLY public.employee_usergroup
    ADD CONSTRAINT employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employee(employee_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.employee_usergroup
    ADD CONSTRAINT usergroup_id_fkey FOREIGN KEY (usergroup_id) REFERENCES public.usergroup(usergroup_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.usergroup_accesspolicy
    ADD CONSTRAINT usergroup_id_fkey FOREIGN KEY (usergroup_id) REFERENCES public.usergroup(usergroup_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.usergroup_accesspolicy
    ADD CONSTRAINT policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.accesspolicy(policy_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.api
    ADD CONSTRAINT policy_id_fkey FOREIGN KEY (policy_id) REFERENCES public.accesspolicy(policy_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.dish_meal
    ADD CONSTRAINT dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dish(dish_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.dish_meal
    ADD CONSTRAINT meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meal(meal_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.prodimage
    ADD CONSTRAINT dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dish(dish_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.prodimage
    ADD CONSTRAINT meal_id_fkey FOREIGN KEY (meal_id) REFERENCES public.meal(meal_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.order
    ADD CONSTRAINT customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.orderinfo
    ADD CONSTRAINT order_id_fkey FOREIGN KEY (order_id) REFERENCES public.order(order_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE ONLY public.address
    ADD CONSTRAINT customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON UPDATE CASCADE ON DELETE RESTRICT;

-- 权限调整

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;