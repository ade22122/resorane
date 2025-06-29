PGDMP  $    #                }         	   restorane    17.5    17.5 X    2           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            3           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            4           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            5           1262    17926 	   restorane    DATABASE     }   CREATE DATABASE restorane WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE restorane;
                     postgres    false            �            1259    18068    cart    TABLE     �   CREATE TABLE public.cart (
    id integer NOT NULL,
    user_id integer,
    menu_item_id integer,
    quantity integer DEFAULT 1 NOT NULL
);
    DROP TABLE public.cart;
       public         heap r       postgres    false            �            1259    18067    cart_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cart_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.cart_id_seq;
       public               postgres    false    236            6           0    0    cart_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.cart_id_seq OWNED BY public.cart.id;
          public               postgres    false    235            �            1259    17971 
   menu_items    TABLE     �   CREATE TABLE public.menu_items (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    is_available boolean DEFAULT true,
    image character varying(100)
);
    DROP TABLE public.menu_items;
       public         heap r       postgres    false            �            1259    17970    menu_items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.menu_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.menu_items_id_seq;
       public               postgres    false    224            7           0    0    menu_items_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;
          public               postgres    false    223            �            1259    18006    order_items    TABLE     �   CREATE TABLE public.order_items (
    id integer NOT NULL,
    order_id integer,
    menu_item_id integer,
    quantity integer NOT NULL
);
    DROP TABLE public.order_items;
       public         heap r       postgres    false            �            1259    18005    order_items_id_seq    SEQUENCE     �   CREATE SEQUENCE public.order_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.order_items_id_seq;
       public               postgres    false    228            8           0    0    order_items_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.order_items_id_seq OWNED BY public.order_items.id;
          public               postgres    false    227            �            1259    17981    orders    TABLE       CREATE TABLE public.orders (
    id integer NOT NULL,
    user_id integer,
    waiter_id integer,
    table_id integer,
    status character varying(20) DEFAULT 'new'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_price numeric
);
    DROP TABLE public.orders;
       public         heap r       postgres    false            �            1259    17980    orders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public               postgres    false    226            9           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public               postgres    false    225            �            1259    18023    payments    TABLE     �  CREATE TABLE public.payments (
    id integer NOT NULL,
    order_id integer,
    user_id integer,
    amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    payment_time timestamp without time zone,
    CONSTRAINT payments_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'paid'::character varying, 'failed'::character varying])::text[])))
);
    DROP TABLE public.payments;
       public         heap r       postgres    false            �            1259    18022    payments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.payments_id_seq;
       public               postgres    false    230            :           0    0    payments_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;
          public               postgres    false    229            �            1259    18058    reports    TABLE     �   CREATE TABLE public.reports (
    id integer NOT NULL,
    report_type character varying(50),
    data jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.reports;
       public         heap r       postgres    false            �            1259    18057    reports_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reports_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public               postgres    false    234            ;           0    0    reports_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;
          public               postgres    false    233            �            1259    17951    reservations    TABLE     �  CREATE TABLE public.reservations (
    id integer NOT NULL,
    user_id integer,
    table_id integer,
    reservation_time timestamp without time zone NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reservations_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'cancelled'::character varying])::text[])))
);
     DROP TABLE public.reservations;
       public         heap r       postgres    false            �            1259    17950    reservations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reservations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.reservations_id_seq;
       public               postgres    false    222            <           0    0    reservations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.reservations_id_seq OWNED BY public.reservations.id;
          public               postgres    false    221            �            1259    17941    restaurant_tables    TABLE     �   CREATE TABLE public.restaurant_tables (
    id integer NOT NULL,
    table_number integer NOT NULL,
    seats integer NOT NULL,
    is_available boolean DEFAULT true
);
 %   DROP TABLE public.restaurant_tables;
       public         heap r       postgres    false            �            1259    17940    restaurant_tables_id_seq    SEQUENCE     �   CREATE SEQUENCE public.restaurant_tables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.restaurant_tables_id_seq;
       public               postgres    false    220            =           0    0    restaurant_tables_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.restaurant_tables_id_seq OWNED BY public.restaurant_tables.id;
          public               postgres    false    219            �            1259    18042    reviews    TABLE       CREATE TABLE public.reviews (
    id integer NOT NULL,
    user_id integer,
    text text,
    rating integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);
    DROP TABLE public.reviews;
       public         heap r       postgres    false            �            1259    18041    reviews_id_seq    SEQUENCE     �   CREATE SEQUENCE public.reviews_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reviews_id_seq;
       public               postgres    false    232            >           0    0    reviews_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;
          public               postgres    false    231            �            1259    17928    users    TABLE     �  CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash text NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['guest'::character varying, 'waiter'::character varying, 'admin'::character varying])::text[])))
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    17927    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    218            ?           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    217            a           2604    18071    cart id    DEFAULT     b   ALTER TABLE ONLY public.cart ALTER COLUMN id SET DEFAULT nextval('public.cart_id_seq'::regclass);
 6   ALTER TABLE public.cart ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    236    235    236            U           2604    17974    menu_items id    DEFAULT     n   ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);
 <   ALTER TABLE public.menu_items ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    223    224    224            Z           2604    18009    order_items id    DEFAULT     p   ALTER TABLE ONLY public.order_items ALTER COLUMN id SET DEFAULT nextval('public.order_items_id_seq'::regclass);
 =   ALTER TABLE public.order_items ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    227    228    228            W           2604    17984 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    225    226    226            [           2604    18026    payments id    DEFAULT     j   ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);
 :   ALTER TABLE public.payments ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    230    229    230            _           2604    18061 
   reports id    DEFAULT     h   ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    233    234    234            R           2604    17954    reservations id    DEFAULT     r   ALTER TABLE ONLY public.reservations ALTER COLUMN id SET DEFAULT nextval('public.reservations_id_seq'::regclass);
 >   ALTER TABLE public.reservations ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    222    221    222            P           2604    17944    restaurant_tables id    DEFAULT     |   ALTER TABLE ONLY public.restaurant_tables ALTER COLUMN id SET DEFAULT nextval('public.restaurant_tables_id_seq'::regclass);
 C   ALTER TABLE public.restaurant_tables ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    220    219    220            ]           2604    18045 
   reviews id    DEFAULT     h   ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);
 9   ALTER TABLE public.reviews ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    231    232    232            N           2604    17931    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    217    218    218            /          0    18068    cart 
   TABLE DATA           C   COPY public.cart (id, user_id, menu_item_id, quantity) FROM stdin;
    public               postgres    false    236   �i       #          0    17971 
   menu_items 
   TABLE DATA           W   COPY public.menu_items (id, name, description, price, is_available, image) FROM stdin;
    public               postgres    false    224   �i       '          0    18006    order_items 
   TABLE DATA           K   COPY public.order_items (id, order_id, menu_item_id, quantity) FROM stdin;
    public               postgres    false    228   @l       %          0    17981    orders 
   TABLE DATA           c   COPY public.orders (id, user_id, waiter_id, table_id, status, created_at, total_price) FROM stdin;
    public               postgres    false    226   �l       )          0    18023    payments 
   TABLE DATA           W   COPY public.payments (id, order_id, user_id, amount, status, payment_time) FROM stdin;
    public               postgres    false    230   *m       -          0    18058    reports 
   TABLE DATA           D   COPY public.reports (id, report_type, data, created_at) FROM stdin;
    public               postgres    false    234   Gm       !          0    17951    reservations 
   TABLE DATA           c   COPY public.reservations (id, user_id, table_id, reservation_time, status, created_at) FROM stdin;
    public               postgres    false    222   dm                 0    17941    restaurant_tables 
   TABLE DATA           R   COPY public.restaurant_tables (id, table_number, seats, is_available) FROM stdin;
    public               postgres    false    220   �m       +          0    18042    reviews 
   TABLE DATA           H   COPY public.reviews (id, user_id, text, rating, created_at) FROM stdin;
    public               postgres    false    232   ;n                 0    17928    users 
   TABLE DATA           N   COPY public.users (id, username, password_hash, role, created_at) FROM stdin;
    public               postgres    false    218   Xn       @           0    0    cart_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.cart_id_seq', 1, false);
          public               postgres    false    235            A           0    0    menu_items_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.menu_items_id_seq', 13, true);
          public               postgres    false    223            B           0    0    order_items_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.order_items_id_seq', 12, true);
          public               postgres    false    227            C           0    0    orders_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.orders_id_seq', 7, true);
          public               postgres    false    225            D           0    0    payments_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.payments_id_seq', 1, false);
          public               postgres    false    229            E           0    0    reports_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.reports_id_seq', 1, false);
          public               postgres    false    233            F           0    0    reservations_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.reservations_id_seq', 13, true);
          public               postgres    false    221            G           0    0    restaurant_tables_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.restaurant_tables_id_seq', 11, true);
          public               postgres    false    219            H           0    0    reviews_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);
          public               postgres    false    231            I           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 3, true);
          public               postgres    false    217            ~           2606    18074    cart cart_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_pkey;
       public                 postgres    false    236            r           2606    17979    menu_items menu_items_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.menu_items DROP CONSTRAINT menu_items_pkey;
       public                 postgres    false    224            v           2606    18011    order_items order_items_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_pkey;
       public                 postgres    false    228            t           2606    17989    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public                 postgres    false    226            x           2606    18030    payments payments_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_pkey;
       public                 postgres    false    230            |           2606    18066    reports reports_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public                 postgres    false    234            p           2606    17959    reservations reservations_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.reservations DROP CONSTRAINT reservations_pkey;
       public                 postgres    false    222            l           2606    17947 (   restaurant_tables restaurant_tables_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.restaurant_tables DROP CONSTRAINT restaurant_tables_pkey;
       public                 postgres    false    220            n           2606    17949 4   restaurant_tables restaurant_tables_table_number_key 
   CONSTRAINT     w   ALTER TABLE ONLY public.restaurant_tables
    ADD CONSTRAINT restaurant_tables_table_number_key UNIQUE (table_number);
 ^   ALTER TABLE ONLY public.restaurant_tables DROP CONSTRAINT restaurant_tables_table_number_key;
       public                 postgres    false    220            z           2606    18051    reviews reviews_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_pkey;
       public                 postgres    false    232            h           2606    17937    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    218            j           2606    17939    users users_username_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_username_key;
       public                 postgres    false    218            �           2606    18080    cart cart_menu_item_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);
 E   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_menu_item_id_fkey;
       public               postgres    false    236    224    4722            �           2606    18075    cart cart_user_id_fkey    FK CONSTRAINT     u   ALTER TABLE ONLY public.cart
    ADD CONSTRAINT cart_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 @   ALTER TABLE ONLY public.cart DROP CONSTRAINT cart_user_id_fkey;
       public               postgres    false    218    4712    236            �           2606    18017 )   order_items order_items_menu_item_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_menu_item_id_fkey FOREIGN KEY (menu_item_id) REFERENCES public.menu_items(id);
 S   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_menu_item_id_fkey;
       public               postgres    false    224    228    4722            �           2606    18012 %   order_items order_items_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);
 O   ALTER TABLE ONLY public.order_items DROP CONSTRAINT order_items_order_id_fkey;
       public               postgres    false    226    228    4724            �           2606    18000    orders orders_table_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);
 E   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_table_id_fkey;
       public               postgres    false    4716    220    226            �           2606    17990    orders orders_user_id_fkey    FK CONSTRAINT     y   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 D   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_user_id_fkey;
       public               postgres    false    218    4712    226            �           2606    17995    orders orders_waiter_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_waiter_id_fkey FOREIGN KEY (waiter_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_waiter_id_fkey;
       public               postgres    false    218    4712    226            �           2606    18031    payments payments_order_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);
 I   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_order_id_fkey;
       public               postgres    false    230    4724    226            �           2606    18036    payments payments_user_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 H   ALTER TABLE ONLY public.payments DROP CONSTRAINT payments_user_id_fkey;
       public               postgres    false    230    218    4712                       2606    17965 '   reservations reservations_table_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.restaurant_tables(id);
 Q   ALTER TABLE ONLY public.reservations DROP CONSTRAINT reservations_table_id_fkey;
       public               postgres    false    220    4716    222            �           2606    17960 &   reservations reservations_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 P   ALTER TABLE ONLY public.reservations DROP CONSTRAINT reservations_user_id_fkey;
       public               postgres    false    222    4712    218            �           2606    18052    reviews reviews_user_id_fkey    FK CONSTRAINT     {   ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 F   ALTER TABLE ONLY public.reviews DROP CONSTRAINT reviews_user_id_fkey;
       public               postgres    false    4712    232    218            /      x������ � �      #   S  x��TMn�@^�O���ӄK����n��p�EV&ii*"�l����K~��p���F���\�tэ��|���[�u�?*�N3J(�%M�l�N�Q_遾��J���r�6��㨷�׏:A���UW��r�)�F�l���	����F�s���`�	�K�~�}��U�	�1��L S%�9�R�����!�!>f�g��<S���%���	m �����Hʹ�E ShXP�UJ��Z��4��hynp��R@ٜ� ���沖4ҽJ���j:�9�T5�<:��P�_*���kZBkfC�=*CңMbL@��߉�D�L̇	�I��Ha�Q��`�镌A;
�ቐ��W�彡̘���o�F�i�6sdCc��C	`U��:S����U]*o�lV�w.L��=�1H��g���]NW5ܧw�u}���RJ��N�%�b��i��rc�����O
��{@͚�T��\���~A����LpSv+X	�Ҙ�yw{�_�C?*�q�o��s��e�S��.�D&a��gn�W���Y��/�����O6�8����
�t�	�Qjr�@횣����;\��f�ߏ�N��H�fY�5��      '   H   x�%���0�0LU�q�����(��@1�@�0`q����D���tQ|`mn1n�b�[�,mi�o��8�      %   �   x�}�11��y8kmǉ�G����:�_D�(��Վv]II����|?��q'�����^ 	$��{�����b�	B������+��;jJ��P��*�4vj��]-F���w�$#}��WBh��v.�|�;7^      )      x������ � �      -      x������ � �      !   y   x�uͻ�0��Z�"H�#��4�� p�>����H���G�Sh����`���{��W�3�%͞s�-����[<kr���:q�]�?�#�'�{Z�k���-�ɘ� ��$�K]1�         >   x���	�0þuÔ^�٥ct����$)�Q�M[��&�N7��'�~��7�>_��|OD?1%      +      x������ � �         j   x�u�;�@��z}�\ +����Yh"%B)B�"!A�_�aZ֍L������HT�Y�1��fݪ�\|�����cD�do�������� &��^s��A�dyE� �     