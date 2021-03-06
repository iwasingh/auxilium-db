PGDMP                         v           auxilium    10.3    10.3 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            �           1262    42765    auxilium    DATABASE     z   CREATE DATABASE auxilium WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_GB.UTF-8' LC_CTYPE = 'en_GB.UTF-8';
    DROP DATABASE auxilium;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            �           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    3                        3079    12928    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            �           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1            �            1255    43096 &   dispatcher_shift_equalities_function()    FUNCTION       CREATE FUNCTION public.dispatcher_shift_equalities_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      _shift record;
    BEGIN

      SELECT shift.* INTO _shift FROM shift, assistance WHERE NEW.assistance_ticket = assistance.ticket
        AND shift.id = NEW.dispatcher_shift_id
        AND assistance.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
  
      IF _shift IS NULL THEN
        RAISE EXCEPTION 'dispatcher_shift_equalities_function exception. Shift or Timestamp not valid'
        USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
      END IF;
  
      SELECT shift.* INTO _shift FROM shift, assistance WHERE NEW.assistance_ticket = assistance.ticket
        AND shift.id = NEW.dispatcher_shift_id
        AND (assistance.end_at IS NULL OR assistance.end_at BETWEEN shift_date + interval '1 hour' * hour_start 
          AND shift_date + interval '1 hour' * hour_end);

      IF _shift IS NULL THEN
        RAISE EXCEPTION 'dispatcher_shift_equalities_function exception. Shift or Timestamp not valid'
        USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
      END IF;
      RETURN NEW;
    END
$$;
 =   DROP FUNCTION public.dispatcher_shift_equalities_function();
       public       postgres    false    3    1            �            1255    43089    is_resource_a_leaf()    FUNCTION       CREATE FUNCTION public.is_resource_a_leaf() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      resource_tb record;
    BEGIN
      IF NEW.resource_id IS NOT NULL THEN
        SELECT resource.id INTO resource_tb FROM resource WHERE resource.parent = NEW.resource_id;
        IF resource_tb IS NOT NULL THEN
          RAISE EXCEPTION 'is_resource_a_leaf (%). resource_id is not a leaf', NEW.resource_id
            USING HINT = 'Please check your resource table';
        END IF;
      END IF;
      RETURN NEW;
    END
$$;
 +   DROP FUNCTION public.is_resource_a_leaf();
       public       postgres    false    1    3            �            1255    43104 (   maintainer_borrow_not_available_object()    FUNCTION     u  CREATE FUNCTION public.maintainer_borrow_not_available_object() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      _borrow record;
    BEGIN
      SELECT maintainer_shift_id INTO _borrow FROM borrow WHERE maintainer_shift_id = NEW.maintainer_shift_id 
        AND end_at IS NULL AND inventory_nr = NEW.inventory_nr AND inventory_device_name = NEW.inventory_device_name;
      IF _borrow IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_borrow_not_available_object exception. The Object is not available!'
        USING HINT = 'Please check objects restitution date';
      END IF;
      RETURN NEW;
    END
$$;
 ?   DROP FUNCTION public.maintainer_borrow_not_available_object();
       public       postgres    false    3    1            �            1255    43098 +   maintainer_is_already_occupied_assistance()    FUNCTION     5  CREATE FUNCTION public.maintainer_is_already_occupied_assistance() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      _assistances record;
    BEGIN
      SELECT maintainer_shift_id INTO _assistances FROM assistance WHERE maintainer_shift_id = NEW.maintainer_shift_id AND end_at IS NULL;
      IF _assistances IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_is_already_occupied_assistance exception. The maintaner had to finish others assistance first!'
        USING HINT = 'Please check assistance';
      END IF;
      RETURN NEW;
    END
$$;
 B   DROP FUNCTION public.maintainer_is_already_occupied_assistance();
       public       postgres    false    3    1            �            1255    43101 -   maintainer_is_already_occupied_intervention()    FUNCTION     <  CREATE FUNCTION public.maintainer_is_already_occupied_intervention() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      _intervents record;
    BEGIN
      SELECT maintainer_shift_id INTO _intervents FROM intervention WHERE maintainer_shift_id = NEW.maintainer_shift_id AND end_at IS NULL;
      IF _intervents IS NOT NULL THEN
        RAISE EXCEPTION 'maintainer_is_already_occupied_intervention exception. The maintaner had to finish others intervention first!'
        USING HINT = 'Please check intervetions';
      END IF;
      RETURN NEW;
    END
$$;
 D   DROP FUNCTION public.maintainer_is_already_occupied_intervention();
       public       postgres    false    3    1            �            1255    43090 !   shift_dates_equalities_function()    FUNCTION     �  CREATE FUNCTION public.shift_dates_equalities_function() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE
      _shift record;
    BEGIN
        IF NEW.start_at IS NOT NULL THEN
        SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.start_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
  
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
  
        IF NEW.end_at IS NOT NULL THEN
          SELECT * INTO _shift FROM shift WHERE id = NEW.maintainer_shift_id
          AND NEW.end_at BETWEEN shift_date + interval '1 hour' * hour_start AND shift_date + interval '1 hour' * hour_end;
        END IF;
        
        IF _shift IS NULL THEN
          RAISE EXCEPTION 'shift_dates_equalities_function exception. Timestamp not valid for the shift'
          USING HINT = 'Please check your shift dates and the table start_at or end_at timestamps';
        END IF;
      RETURN NEW;
    END
$$;
 8   DROP FUNCTION public.shift_dates_equalities_function();
       public       postgres    false    1    3            �            1255    43088    shift_overlap_employee_type()    FUNCTION     +  CREATE FUNCTION public.shift_overlap_employee_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
      shift_id INTEGER;
      other_table text;
    BEGIN
	  other_table = TG_ARGV[0];
      EXECUTE format('SELECT shift_id FROM %I WHERE shift_id = $1', other_table) INTO shift_id USING NEW.shift_id;
        IF shift_id IS NOT NULL THEN
          RAISE EXCEPTION 'shift_overlap_employee_type(%). id Already exists', other_table
            USING HINT = 'Please check your shift id on tables';
        END IF;
      RETURN NEW;
    END
$_$;
 4   DROP FUNCTION public.shift_overlap_employee_type();
       public       postgres    false    1    3            �            1259    43061 
   assistance    TABLE     �   CREATE TABLE public.assistance (
    maintainer_shift_id integer,
    ticket integer NOT NULL,
    start_at timestamp(0) without time zone NOT NULL,
    end_at timestamp(0) without time zone,
    CONSTRAINT assistance_check CHECK ((end_at > start_at))
);
    DROP TABLE public.assistance;
       public         postgres    false    3            �            1259    43059    assistance_ticket_seq    SEQUENCE     �   CREATE SEQUENCE public.assistance_ticket_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.assistance_ticket_seq;
       public       postgres    false    224    3            �           0    0    assistance_ticket_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.assistance_ticket_seq OWNED BY public.assistance.ticket;
            public       postgres    false    223            �            1259    42797 
   attachment    TABLE     d   CREATE TABLE public.attachment (
    resource_id integer NOT NULL,
    media_id integer NOT NULL
);
    DROP TABLE public.attachment;
       public         postgres    false    3            �            1259    43073    attendee    TABLE     s   CREATE TABLE public.attendee (
    assistance_ticket integer NOT NULL,
    dispatcher_shift_id integer NOT NULL
);
    DROP TABLE public.attendee;
       public         postgres    false    3            �            1259    43040    borrow    TABLE     L  CREATE TABLE public.borrow (
    maintainer_shift_id integer,
    inventory_nr integer NOT NULL,
    inventory_device_name character varying(50) NOT NULL,
    motivation text,
    start_at timestamp(0) without time zone NOT NULL,
    end_at timestamp(0) without time zone,
    CONSTRAINT borrow_check CHECK ((end_at > start_at))
);
    DROP TABLE public.borrow;
       public         postgres    false    3            �            1259    42925 	   condition    TABLE     K   CREATE TABLE public.condition (
    name character varying(50) NOT NULL
);
    DROP TABLE public.condition;
       public         postgres    false    3            �            1259    42958    condition_groupn    TABLE     �   CREATE TABLE public.condition_groupn (
    condition_name character varying(50) NOT NULL,
    groupn_title character(4) NOT NULL
);
 $   DROP TABLE public.condition_groupn;
       public         postgres    false    3            �            1259    42846    contact    TABLE     s   CREATE TABLE public.contact (
    number character varying(15) NOT NULL,
    employee_cf character(16) NOT NULL
);
    DROP TABLE public.contact;
       public         postgres    false    3            �            1259    42930    device    TABLE     X   CREATE TABLE public.device (
    name character varying(50) NOT NULL,
    specs text
);
    DROP TABLE public.device;
       public         postgres    false    3            �            1259    42973    device_groupn    TABLE     ~   CREATE TABLE public.device_groupn (
    device_name character varying(50) NOT NULL,
    groupn_title character(4) NOT NULL
);
 !   DROP TABLE public.device_groupn;
       public         postgres    false    3            �            1259    42915 
   dispatcher    TABLE     B   CREATE TABLE public.dispatcher (
    shift_id integer NOT NULL
);
    DROP TABLE public.dispatcher;
       public         postgres    false    3            �            1259    42831    employee    TABLE       CREATE TABLE public.employee (
    cf character(16) NOT NULL,
    name character varying(30) NOT NULL,
    surname character varying(30) NOT NULL,
    address character varying(40) NOT NULL,
    town_cap character(6) NOT NULL,
    office_id integer NOT NULL
);
    DROP TABLE public.employee;
       public         postgres    false    3            �            1259    42951    groupn    TABLE       CREATE TABLE public.groupn (
    title character(4) NOT NULL,
    damage smallint NOT NULL,
    risk smallint NOT NULL,
    CONSTRAINT groupn_damage_check CHECK (((damage >= 1) AND (damage <= 3))),
    CONSTRAINT groupn_risk_check CHECK (((risk >= 1) AND (risk <= 3)))
);
    DROP TABLE public.groupn;
       public         postgres    false    3            �            1259    43003    intervention    TABLE     z  CREATE TABLE public.intervention (
    maintainer_shift_id integer NOT NULL,
    task_name character(8) NOT NULL,
    town_cap character(6) NOT NULL,
    address character varying(40) NOT NULL,
    description text,
    start_at timestamp(0) without time zone NOT NULL,
    end_at timestamp(0) without time zone,
    CONSTRAINT intervention_check CHECK ((end_at > start_at))
);
     DROP TABLE public.intervention;
       public         postgres    false    3            �            1259    43027 	   inventory    TABLE     �   CREATE TABLE public.inventory (
    nr integer NOT NULL,
    device_name character varying(50) NOT NULL,
    description text
);
    DROP TABLE public.inventory;
       public         postgres    false    3            �            1259    42905 
   maintainer    TABLE     B   CREATE TABLE public.maintainer (
    shift_id integer NOT NULL
);
    DROP TABLE public.maintainer;
       public         postgres    false    3            �            1259    42773    media    TABLE     �   CREATE TABLE public.media (
    id integer NOT NULL,
    source character varying(80) NOT NULL,
    typology_type character varying(6) NOT NULL
);
    DROP TABLE public.media;
       public         postgres    false    3            �            1259    42771    media_id_seq    SEQUENCE     �   CREATE SEQUENCE public.media_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.media_id_seq;
       public       postgres    false    198    3            �           0    0    media_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.media_id_seq OWNED BY public.media.id;
            public       postgres    false    197            �            1259    42856    message    TABLE     �   CREATE TABLE public.message (
    "timestamp" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    text text,
    resource_id integer NOT NULL,
    employee_cf character(16) NOT NULL
);
    DROP TABLE public.message;
       public         postgres    false    3            �            1259    42820    office    TABLE     �   CREATE TABLE public.office (
    id integer NOT NULL,
    address character varying(40) NOT NULL,
    mail character varying(30) NOT NULL,
    phone character varying(15) NOT NULL,
    town_cap character(6) NOT NULL
);
    DROP TABLE public.office;
       public         postgres    false    3            �            1259    42818    office_id_seq    SEQUENCE     �   CREATE SEQUENCE public.office_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.office_id_seq;
       public       postgres    false    3    204            �           0    0    office_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.office_id_seq OWNED BY public.office.id;
            public       postgres    false    203            �            1259    42786    resource    TABLE     y   CREATE TABLE public.resource (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    parent integer
);
    DROP TABLE public.resource;
       public         postgres    false    3            �            1259    42784    resource_id_seq    SEQUENCE     �   CREATE SEQUENCE public.resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.resource_id_seq;
       public       postgres    false    3    200            �           0    0    resource_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.resource_id_seq OWNED BY public.resource.id;
            public       postgres    false    199            �            1259    42875    session    TABLE     9   CREATE TABLE public.session (
    id integer NOT NULL
);
    DROP TABLE public.session;
       public         postgres    false    3            �            1259    42882    shift    TABLE     �  CREATE TABLE public.shift (
    id integer NOT NULL,
    shift_date date NOT NULL,
    employee_cf character(16) NOT NULL,
    session_id integer NOT NULL,
    hour_start smallint NOT NULL,
    hour_end smallint NOT NULL,
    CONSTRAINT shift_check CHECK ((hour_end > hour_start)),
    CONSTRAINT shift_hour_end_check CHECK (((hour_end >= 0) AND (hour_end < 24))),
    CONSTRAINT shift_hour_start_check CHECK (((hour_start >= 0) AND (hour_start < 24)))
);
    DROP TABLE public.shift;
       public         postgres    false    3            �            1259    42880    shift_id_seq    SEQUENCE     �   CREATE SEQUENCE public.shift_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.shift_id_seq;
       public       postgres    false    210    3            �           0    0    shift_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.shift_id_seq OWNED BY public.shift.id;
            public       postgres    false    209            �            1259    42938    task    TABLE     u   CREATE TABLE public.task (
    name character(8) NOT NULL,
    description text NOT NULL,
    resource_id integer
);
    DROP TABLE public.task;
       public         postgres    false    3            �            1259    42988    task_groupn    TABLE     q   CREATE TABLE public.task_groupn (
    task_name character(8) NOT NULL,
    groupn_title character(4) NOT NULL
);
    DROP TABLE public.task_groupn;
       public         postgres    false    3            �            1259    42812    town    TABLE     �   CREATE TABLE public.town (
    cap character(5) NOT NULL,
    name character varying(40) NOT NULL,
    CONSTRAINT town_cap_check CHECK ((cap ~ similar_escape('[0-9]{5}'::text, NULL::text)))
);
    DROP TABLE public.town;
       public         postgres    false    3            �            1259    42766    typology    TABLE     I   CREATE TABLE public.typology (
    type character varying(6) NOT NULL
);
    DROP TABLE public.typology;
       public         postgres    false    3            �
           2604    43064    assistance ticket    DEFAULT     v   ALTER TABLE ONLY public.assistance ALTER COLUMN ticket SET DEFAULT nextval('public.assistance_ticket_seq'::regclass);
 @   ALTER TABLE public.assistance ALTER COLUMN ticket DROP DEFAULT;
       public       postgres    false    223    224    224            �
           2604    42776    media id    DEFAULT     d   ALTER TABLE ONLY public.media ALTER COLUMN id SET DEFAULT nextval('public.media_id_seq'::regclass);
 7   ALTER TABLE public.media ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    197    198    198            �
           2604    42823 	   office id    DEFAULT     f   ALTER TABLE ONLY public.office ALTER COLUMN id SET DEFAULT nextval('public.office_id_seq'::regclass);
 8   ALTER TABLE public.office ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    203    204            �
           2604    42789    resource id    DEFAULT     j   ALTER TABLE ONLY public.resource ALTER COLUMN id SET DEFAULT nextval('public.resource_id_seq'::regclass);
 :   ALTER TABLE public.resource ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    199    200    200            �
           2604    42885    shift id    DEFAULT     d   ALTER TABLE ONLY public.shift ALTER COLUMN id SET DEFAULT nextval('public.shift_id_seq'::regclass);
 7   ALTER TABLE public.shift ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    209    210    210            �          0    43061 
   assistance 
   TABLE DATA               S   COPY public.assistance (maintainer_shift_id, ticket, start_at, end_at) FROM stdin;
    public       postgres    false    224   �       �          0    42797 
   attachment 
   TABLE DATA               ;   COPY public.attachment (resource_id, media_id) FROM stdin;
    public       postgres    false    201   ��       �          0    43073    attendee 
   TABLE DATA               J   COPY public.attendee (assistance_ticket, dispatcher_shift_id) FROM stdin;
    public       postgres    false    225   ��       �          0    43040    borrow 
   TABLE DATA               x   COPY public.borrow (maintainer_shift_id, inventory_nr, inventory_device_name, motivation, start_at, end_at) FROM stdin;
    public       postgres    false    222   ��       �          0    42925 	   condition 
   TABLE DATA               )   COPY public.condition (name) FROM stdin;
    public       postgres    false    213   ��       �          0    42958    condition_groupn 
   TABLE DATA               H   COPY public.condition_groupn (condition_name, groupn_title) FROM stdin;
    public       postgres    false    217   �       �          0    42846    contact 
   TABLE DATA               6   COPY public.contact (number, employee_cf) FROM stdin;
    public       postgres    false    206   ��       �          0    42930    device 
   TABLE DATA               -   COPY public.device (name, specs) FROM stdin;
    public       postgres    false    214   )�       �          0    42973    device_groupn 
   TABLE DATA               B   COPY public.device_groupn (device_name, groupn_title) FROM stdin;
    public       postgres    false    218   ��       �          0    42915 
   dispatcher 
   TABLE DATA               .   COPY public.dispatcher (shift_id) FROM stdin;
    public       postgres    false    212   ��       �          0    42831    employee 
   TABLE DATA               S   COPY public.employee (cf, name, surname, address, town_cap, office_id) FROM stdin;
    public       postgres    false    205   �       �          0    42951    groupn 
   TABLE DATA               5   COPY public.groupn (title, damage, risk) FROM stdin;
    public       postgres    false    216   M�       �          0    43003    intervention 
   TABLE DATA               x   COPY public.intervention (maintainer_shift_id, task_name, town_cap, address, description, start_at, end_at) FROM stdin;
    public       postgres    false    220   ��       �          0    43027 	   inventory 
   TABLE DATA               A   COPY public.inventory (nr, device_name, description) FROM stdin;
    public       postgres    false    221   ��       �          0    42905 
   maintainer 
   TABLE DATA               .   COPY public.maintainer (shift_id) FROM stdin;
    public       postgres    false    211   k�       �          0    42773    media 
   TABLE DATA               :   COPY public.media (id, source, typology_type) FROM stdin;
    public       postgres    false    198   ��       �          0    42856    message 
   TABLE DATA               N   COPY public.message ("timestamp", text, resource_id, employee_cf) FROM stdin;
    public       postgres    false    207   ��       �          0    42820    office 
   TABLE DATA               D   COPY public.office (id, address, mail, phone, town_cap) FROM stdin;
    public       postgres    false    204   �       �          0    42786    resource 
   TABLE DATA               5   COPY public.resource (id, title, parent) FROM stdin;
    public       postgres    false    200   ��       �          0    42875    session 
   TABLE DATA               %   COPY public.session (id) FROM stdin;
    public       postgres    false    208   ��       �          0    42882    shift 
   TABLE DATA               ^   COPY public.shift (id, shift_date, employee_cf, session_id, hour_start, hour_end) FROM stdin;
    public       postgres    false    210   �       �          0    42938    task 
   TABLE DATA               >   COPY public.task (name, description, resource_id) FROM stdin;
    public       postgres    false    215   ��       �          0    42988    task_groupn 
   TABLE DATA               >   COPY public.task_groupn (task_name, groupn_title) FROM stdin;
    public       postgres    false    219   "�       �          0    42812    town 
   TABLE DATA               )   COPY public.town (cap, name) FROM stdin;
    public       postgres    false    202   Z�       �          0    42766    typology 
   TABLE DATA               (   COPY public.typology (type) FROM stdin;
    public       postgres    false    196   ��       �           0    0    assistance_ticket_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.assistance_ticket_seq', 1, false);
            public       postgres    false    223            �           0    0    media_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.media_id_seq', 1, false);
            public       postgres    false    197            �           0    0    office_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.office_id_seq', 1, false);
            public       postgres    false    203            �           0    0    resource_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.resource_id_seq', 1, false);
            public       postgres    false    199            �           0    0    shift_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.shift_id_seq', 1, false);
            public       postgres    false    209            (           2606    43067    assistance assistance_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.assistance
    ADD CONSTRAINT assistance_pkey PRIMARY KEY (ticket);
 D   ALTER TABLE ONLY public.assistance DROP CONSTRAINT assistance_pkey;
       public         postgres    false    224            �
           2606    42801    attachment attachment_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.attachment
    ADD CONSTRAINT attachment_pkey PRIMARY KEY (resource_id, media_id);
 D   ALTER TABLE ONLY public.attachment DROP CONSTRAINT attachment_pkey;
       public         postgres    false    201    201            *           2606    43077    attendee attendee_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.attendee
    ADD CONSTRAINT attendee_pkey PRIMARY KEY (assistance_ticket, dispatcher_shift_id);
 @   ALTER TABLE ONLY public.attendee DROP CONSTRAINT attendee_pkey;
       public         postgres    false    225    225            &           2606    43048    borrow borrow_pkey 
   CONSTRAINT     {   ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_pkey PRIMARY KEY (inventory_nr, inventory_device_name, start_at);
 <   ALTER TABLE ONLY public.borrow DROP CONSTRAINT borrow_pkey;
       public         postgres    false    222    222    222                       2606    42962 &   condition_groupn condition_groupn_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY public.condition_groupn
    ADD CONSTRAINT condition_groupn_pkey PRIMARY KEY (condition_name, groupn_title);
 P   ALTER TABLE ONLY public.condition_groupn DROP CONSTRAINT condition_groupn_pkey;
       public         postgres    false    217    217                       2606    42929    condition condition_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.condition
    ADD CONSTRAINT condition_pkey PRIMARY KEY (name);
 B   ALTER TABLE ONLY public.condition DROP CONSTRAINT condition_pkey;
       public         postgres    false    213                       2606    42850    contact contact_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (number);
 >   ALTER TABLE ONLY public.contact DROP CONSTRAINT contact_pkey;
       public         postgres    false    206                       2606    42977     device_groupn device_groupn_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public.device_groupn
    ADD CONSTRAINT device_groupn_pkey PRIMARY KEY (device_name, groupn_title);
 J   ALTER TABLE ONLY public.device_groupn DROP CONSTRAINT device_groupn_pkey;
       public         postgres    false    218    218                       2606    42937    device device_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (name);
 <   ALTER TABLE ONLY public.device DROP CONSTRAINT device_pkey;
       public         postgres    false    214                       2606    42919    dispatcher dispatcher_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.dispatcher
    ADD CONSTRAINT dispatcher_pkey PRIMARY KEY (shift_id);
 D   ALTER TABLE ONLY public.dispatcher DROP CONSTRAINT dispatcher_pkey;
       public         postgres    false    212                       2606    42835    employee employee_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (cf);
 @   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_pkey;
       public         postgres    false    205                       2606    42957    groupn groupn_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.groupn
    ADD CONSTRAINT groupn_pkey PRIMARY KEY (title);
 <   ALTER TABLE ONLY public.groupn DROP CONSTRAINT groupn_pkey;
       public         postgres    false    216            "           2606    43011    intervention intervention_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_pkey PRIMARY KEY (maintainer_shift_id, start_at);
 H   ALTER TABLE ONLY public.intervention DROP CONSTRAINT intervention_pkey;
       public         postgres    false    220    220            $           2606    43034    inventory inventory_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (nr, device_name);
 B   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_pkey;
       public         postgres    false    221    221                       2606    42909    maintainer maintainer_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.maintainer
    ADD CONSTRAINT maintainer_pkey PRIMARY KEY (shift_id);
 D   ALTER TABLE ONLY public.maintainer DROP CONSTRAINT maintainer_pkey;
       public         postgres    false    211            �
           2606    42778    media media_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.media DROP CONSTRAINT media_pkey;
       public         postgres    false    198                       2606    42864    message message_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (employee_cf, "timestamp");
 >   ALTER TABLE ONLY public.message DROP CONSTRAINT message_pkey;
       public         postgres    false    207    207                        2606    42825    office office_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.office
    ADD CONSTRAINT office_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.office DROP CONSTRAINT office_pkey;
       public         postgres    false    204            �
           2606    42791    resource resource_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.resource DROP CONSTRAINT resource_pkey;
       public         postgres    false    200                       2606    42879    session session_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.session DROP CONSTRAINT session_pkey;
       public         postgres    false    208            
           2606    42890    shift shift_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_pkey;
       public         postgres    false    210                       2606    42892 &   shift shift_shift_date_employee_cf_key 
   CONSTRAINT     t   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_shift_date_employee_cf_key UNIQUE (shift_date, employee_cf);
 P   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_shift_date_employee_cf_key;
       public         postgres    false    210    210                       2606    42894 %   shift shift_shift_date_session_id_key 
   CONSTRAINT     r   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_shift_date_session_id_key UNIQUE (shift_date, session_id);
 O   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_shift_date_session_id_key;
       public         postgres    false    210    210                        2606    42992    task_groupn task_groupn_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.task_groupn
    ADD CONSTRAINT task_groupn_pkey PRIMARY KEY (task_name, groupn_title);
 F   ALTER TABLE ONLY public.task_groupn DROP CONSTRAINT task_groupn_pkey;
       public         postgres    false    219    219                       2606    42945    task task_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (name);
 8   ALTER TABLE ONLY public.task DROP CONSTRAINT task_pkey;
       public         postgres    false    215            �
           2606    42817    town town_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.town
    ADD CONSTRAINT town_pkey PRIMARY KEY (cap);
 8   ALTER TABLE ONLY public.town DROP CONSTRAINT town_pkey;
       public         postgres    false    202            �
           2606    42770    typology typology_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.typology
    ADD CONSTRAINT typology_pkey PRIMARY KEY (type);
 @   ALTER TABLE ONLY public.typology DROP CONSTRAINT typology_pkey;
       public         postgres    false    196            S           2620    43097 7   attendee dispatcher_shift_equalities_assistance_trigger    TRIGGER     �   CREATE TRIGGER dispatcher_shift_equalities_assistance_trigger BEFORE INSERT OR UPDATE ON public.attendee FOR EACH ROW EXECUTE PROCEDURE public.dispatcher_shift_equalities_function();
 P   DROP TRIGGER dispatcher_shift_equalities_assistance_trigger ON public.attendee;
       public       postgres    false    225    238            P           2620    43105 5   borrow maintainer_borrow_not_available_object_trigger    TRIGGER     �   CREATE TRIGGER maintainer_borrow_not_available_object_trigger BEFORE INSERT ON public.borrow FOR EACH ROW EXECUTE PROCEDURE public.maintainer_borrow_not_available_object();
 N   DROP TRIGGER maintainer_borrow_not_available_object_trigger ON public.borrow;
       public       postgres    false    222    235            R           2620    43099 <   assistance maintainer_is_already_occupied_assistance_trigger    TRIGGER     �   CREATE TRIGGER maintainer_is_already_occupied_assistance_trigger BEFORE INSERT ON public.assistance FOR EACH ROW EXECUTE PROCEDURE public.maintainer_is_already_occupied_assistance();
 U   DROP TRIGGER maintainer_is_already_occupied_assistance_trigger ON public.assistance;
       public       postgres    false    236    224            N           2620    43102 @   intervention maintainer_is_already_occupied_intervention_trigger    TRIGGER     �   CREATE TRIGGER maintainer_is_already_occupied_intervention_trigger BEFORE INSERT ON public.intervention FOR EACH ROW EXECUTE PROCEDURE public.maintainer_is_already_occupied_intervention();
 Y   DROP TRIGGER maintainer_is_already_occupied_intervention_trigger ON public.intervention;
       public       postgres    false    241    220            I           2620    43091 +   attachment media_is_resource_a_leaf_trigger    TRIGGER     �   CREATE TRIGGER media_is_resource_a_leaf_trigger BEFORE INSERT OR UPDATE ON public.attachment FOR EACH ROW EXECUTE PROCEDURE public.is_resource_a_leaf();
 D   DROP TRIGGER media_is_resource_a_leaf_trigger ON public.attachment;
       public       postgres    false    232    201            Q           2620    43095 4   assistance shift_dates_equalities_assistance_trigger    TRIGGER     �   CREATE TRIGGER shift_dates_equalities_assistance_trigger BEFORE INSERT OR UPDATE ON public.assistance FOR EACH ROW EXECUTE PROCEDURE public.shift_dates_equalities_function();
 M   DROP TRIGGER shift_dates_equalities_assistance_trigger ON public.assistance;
       public       postgres    false    243    224            O           2620    43103 ,   borrow shift_dates_equalities_borrow_trigger    TRIGGER     �   CREATE TRIGGER shift_dates_equalities_borrow_trigger BEFORE INSERT OR UPDATE ON public.borrow FOR EACH ROW EXECUTE PROCEDURE public.shift_dates_equalities_function();
 E   DROP TRIGGER shift_dates_equalities_borrow_trigger ON public.borrow;
       public       postgres    false    243    222            M           2620    43100 8   intervention shift_dates_equalities_intervention_trigger    TRIGGER     �   CREATE TRIGGER shift_dates_equalities_intervention_trigger BEFORE INSERT OR UPDATE ON public.intervention FOR EACH ROW EXECUTE PROCEDURE public.shift_dates_equalities_function();
 Q   DROP TRIGGER shift_dates_equalities_intervention_trigger ON public.intervention;
       public       postgres    false    243    220            K           2620    43094 4   dispatcher shift_overlap_employee_dispatcher_trigger    TRIGGER     �   CREATE TRIGGER shift_overlap_employee_dispatcher_trigger BEFORE INSERT OR UPDATE ON public.dispatcher FOR EACH ROW EXECUTE PROCEDURE public.shift_overlap_employee_type('dispatcher');
 M   DROP TRIGGER shift_overlap_employee_dispatcher_trigger ON public.dispatcher;
       public       postgres    false    233    212            J           2620    43093 4   maintainer shift_overlap_employee_maintainer_trigger    TRIGGER     �   CREATE TRIGGER shift_overlap_employee_maintainer_trigger BEFORE INSERT OR UPDATE ON public.maintainer FOR EACH ROW EXECUTE PROCEDURE public.shift_overlap_employee_type('maintainer');
 M   DROP TRIGGER shift_overlap_employee_maintainer_trigger ON public.maintainer;
       public       postgres    false    233    211            L           2620    43092 $   task task_is_resource_a_leaf_trigger    TRIGGER     �   CREATE TRIGGER task_is_resource_a_leaf_trigger BEFORE INSERT OR UPDATE ON public.task FOR EACH ROW EXECUTE PROCEDURE public.is_resource_a_leaf();
 =   DROP TRIGGER task_is_resource_a_leaf_trigger ON public.task;
       public       postgres    false    232    215            F           2606    43068 .   assistance assistance_maintainer_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.assistance
    ADD CONSTRAINT assistance_maintainer_shift_id_fkey FOREIGN KEY (maintainer_shift_id) REFERENCES public.maintainer(shift_id) ON UPDATE CASCADE ON DELETE SET NULL;
 X   ALTER TABLE ONLY public.assistance DROP CONSTRAINT assistance_maintainer_shift_id_fkey;
       public       postgres    false    211    224    2832            .           2606    42807 #   attachment attachment_media_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.attachment
    ADD CONSTRAINT attachment_media_id_fkey FOREIGN KEY (media_id) REFERENCES public.media(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.attachment DROP CONSTRAINT attachment_media_id_fkey;
       public       postgres    false    198    201    2808            -           2606    42802 &   attachment attachment_resource_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.attachment
    ADD CONSTRAINT attachment_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.attachment DROP CONSTRAINT attachment_resource_id_fkey;
       public       postgres    false    201    200    2810            G           2606    43078 (   attendee attendee_assistance_ticket_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendee
    ADD CONSTRAINT attendee_assistance_ticket_fkey FOREIGN KEY (assistance_ticket) REFERENCES public.assistance(ticket) ON UPDATE CASCADE ON DELETE CASCADE;
 R   ALTER TABLE ONLY public.attendee DROP CONSTRAINT attendee_assistance_ticket_fkey;
       public       postgres    false    224    2856    225            H           2606    43083 *   attendee attendee_dispatcher_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.attendee
    ADD CONSTRAINT attendee_dispatcher_shift_id_fkey FOREIGN KEY (dispatcher_shift_id) REFERENCES public.dispatcher(shift_id) ON UPDATE CASCADE ON DELETE CASCADE;
 T   ALTER TABLE ONLY public.attendee DROP CONSTRAINT attendee_dispatcher_shift_id_fkey;
       public       postgres    false    2834    225    212            D           2606    43049    borrow borrow_inventory_nr_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_inventory_nr_fkey FOREIGN KEY (inventory_nr, inventory_device_name) REFERENCES public.inventory(nr, device_name) ON UPDATE CASCADE;
 I   ALTER TABLE ONLY public.borrow DROP CONSTRAINT borrow_inventory_nr_fkey;
       public       postgres    false    222    221    221    2852    222            E           2606    43054 &   borrow borrow_maintainer_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_maintainer_shift_id_fkey FOREIGN KEY (maintainer_shift_id) REFERENCES public.maintainer(shift_id) ON UPDATE CASCADE ON DELETE SET NULL;
 P   ALTER TABLE ONLY public.borrow DROP CONSTRAINT borrow_maintainer_shift_id_fkey;
       public       postgres    false    211    2832    222            :           2606    42963 5   condition_groupn condition_groupn_condition_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.condition_groupn
    ADD CONSTRAINT condition_groupn_condition_name_fkey FOREIGN KEY (condition_name) REFERENCES public.condition(name) ON UPDATE CASCADE ON DELETE CASCADE;
 _   ALTER TABLE ONLY public.condition_groupn DROP CONSTRAINT condition_groupn_condition_name_fkey;
       public       postgres    false    213    217    2836            ;           2606    42968 3   condition_groupn condition_groupn_groupn_title_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.condition_groupn
    ADD CONSTRAINT condition_groupn_groupn_title_fkey FOREIGN KEY (groupn_title) REFERENCES public.groupn(title) ON UPDATE CASCADE ON DELETE CASCADE;
 ]   ALTER TABLE ONLY public.condition_groupn DROP CONSTRAINT condition_groupn_groupn_title_fkey;
       public       postgres    false    216    217    2842            2           2606    42851     contact contact_employee_cf_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_employee_cf_fkey FOREIGN KEY (employee_cf) REFERENCES public.employee(cf) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.contact DROP CONSTRAINT contact_employee_cf_fkey;
       public       postgres    false    206    205    2818            <           2606    42978 ,   device_groupn device_groupn_device_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.device_groupn
    ADD CONSTRAINT device_groupn_device_name_fkey FOREIGN KEY (device_name) REFERENCES public.device(name) ON UPDATE CASCADE ON DELETE CASCADE;
 V   ALTER TABLE ONLY public.device_groupn DROP CONSTRAINT device_groupn_device_name_fkey;
       public       postgres    false    218    214    2838            =           2606    42983 -   device_groupn device_groupn_groupn_title_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.device_groupn
    ADD CONSTRAINT device_groupn_groupn_title_fkey FOREIGN KEY (groupn_title) REFERENCES public.groupn(title) ON UPDATE CASCADE ON DELETE CASCADE;
 W   ALTER TABLE ONLY public.device_groupn DROP CONSTRAINT device_groupn_groupn_title_fkey;
       public       postgres    false    218    2842    216            8           2606    42920 #   dispatcher dispatcher_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dispatcher
    ADD CONSTRAINT dispatcher_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shift(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.dispatcher DROP CONSTRAINT dispatcher_shift_id_fkey;
       public       postgres    false    2826    210    212            1           2606    42841     employee employee_office_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.office(id) ON UPDATE CASCADE ON DELETE SET NULL;
 J   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_office_id_fkey;
       public       postgres    false    205    204    2816            0           2606    42836    employee employee_town_cap_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_town_cap_fkey FOREIGN KEY (town_cap) REFERENCES public.town(cap) ON UPDATE CASCADE;
 I   ALTER TABLE ONLY public.employee DROP CONSTRAINT employee_town_cap_fkey;
       public       postgres    false    202    205    2814            @           2606    43012 2   intervention intervention_maintainer_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_maintainer_shift_id_fkey FOREIGN KEY (maintainer_shift_id) REFERENCES public.maintainer(shift_id) ON UPDATE CASCADE ON DELETE CASCADE;
 \   ALTER TABLE ONLY public.intervention DROP CONSTRAINT intervention_maintainer_shift_id_fkey;
       public       postgres    false    211    2832    220            A           2606    43017 (   intervention intervention_task_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_task_name_fkey FOREIGN KEY (task_name) REFERENCES public.task(name) ON UPDATE CASCADE;
 R   ALTER TABLE ONLY public.intervention DROP CONSTRAINT intervention_task_name_fkey;
       public       postgres    false    220    2840    215            B           2606    43022 '   intervention intervention_town_cap_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.intervention
    ADD CONSTRAINT intervention_town_cap_fkey FOREIGN KEY (town_cap) REFERENCES public.town(cap) ON UPDATE CASCADE;
 Q   ALTER TABLE ONLY public.intervention DROP CONSTRAINT intervention_town_cap_fkey;
       public       postgres    false    202    220    2814            C           2606    43035 $   inventory inventory_device_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_device_name_fkey FOREIGN KEY (device_name) REFERENCES public.device(name) ON UPDATE CASCADE ON DELETE CASCADE;
 N   ALTER TABLE ONLY public.inventory DROP CONSTRAINT inventory_device_name_fkey;
       public       postgres    false    221    2838    214            7           2606    42910 #   maintainer maintainer_shift_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.maintainer
    ADD CONSTRAINT maintainer_shift_id_fkey FOREIGN KEY (shift_id) REFERENCES public.shift(id) ON UPDATE CASCADE ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.maintainer DROP CONSTRAINT maintainer_shift_id_fkey;
       public       postgres    false    211    2826    210            +           2606    42779    media media_typology_type_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_typology_type_fkey FOREIGN KEY (typology_type) REFERENCES public.typology(type) ON UPDATE CASCADE;
 H   ALTER TABLE ONLY public.media DROP CONSTRAINT media_typology_type_fkey;
       public       postgres    false    198    196    2806            4           2606    42870     message message_employee_cf_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_employee_cf_fkey FOREIGN KEY (employee_cf) REFERENCES public.employee(cf) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.message DROP CONSTRAINT message_employee_cf_fkey;
       public       postgres    false    207    205    2818            3           2606    42865     message message_resource_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON UPDATE CASCADE ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.message DROP CONSTRAINT message_resource_id_fkey;
       public       postgres    false    207    2810    200            /           2606    42826    office office_town_cap_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.office
    ADD CONSTRAINT office_town_cap_fkey FOREIGN KEY (town_cap) REFERENCES public.town(cap) ON UPDATE CASCADE;
 E   ALTER TABLE ONLY public.office DROP CONSTRAINT office_town_cap_fkey;
       public       postgres    false    2814    202    204            ,           2606    42792    resource resource_parent_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.resource
    ADD CONSTRAINT resource_parent_fkey FOREIGN KEY (parent) REFERENCES public.resource(id) ON UPDATE CASCADE ON DELETE SET NULL;
 G   ALTER TABLE ONLY public.resource DROP CONSTRAINT resource_parent_fkey;
       public       postgres    false    200    2810    200            5           2606    42895    shift shift_employee_cf_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_employee_cf_fkey FOREIGN KEY (employee_cf) REFERENCES public.employee(cf) ON UPDATE CASCADE ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_employee_cf_fkey;
       public       postgres    false    2818    205    210            6           2606    42900    shift shift_session_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shift
    ADD CONSTRAINT shift_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.session(id) ON UPDATE CASCADE ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.shift DROP CONSTRAINT shift_session_id_fkey;
       public       postgres    false    2824    210    208            >           2606    42998 )   task_groupn task_groupn_groupn_title_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.task_groupn
    ADD CONSTRAINT task_groupn_groupn_title_fkey FOREIGN KEY (groupn_title) REFERENCES public.groupn(title) ON UPDATE CASCADE ON DELETE CASCADE;
 S   ALTER TABLE ONLY public.task_groupn DROP CONSTRAINT task_groupn_groupn_title_fkey;
       public       postgres    false    216    219    2842            ?           2606    42993 &   task_groupn task_groupn_task_name_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.task_groupn
    ADD CONSTRAINT task_groupn_task_name_fkey FOREIGN KEY (task_name) REFERENCES public.task(name) ON UPDATE CASCADE ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.task_groupn DROP CONSTRAINT task_groupn_task_name_fkey;
       public       postgres    false    215    2840    219            9           2606    42946    task task_resource_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_resource_id_fkey FOREIGN KEY (resource_id) REFERENCES public.resource(id) ON UPDATE CASCADE ON DELETE SET NULL;
 D   ALTER TABLE ONLY public.task DROP CONSTRAINT task_resource_id_fkey;
       public       postgres    false    2810    200    215            �   q   x�m��	C1г=E�Ų'_�t�9�BiI��!���a^6/�AK�4��.�y���'�_w4�d�� |es�"&�>,ݵ����~���9����7+v�m���+}>T��`0�      �      x�3�4�2bsNC.K 64 1z\\\ ,	5      �   %   x�3�4�2bcNS.Ns.S 6� bC�=... J#;      �   �   x���;�0@��� Ul
�ۡ�bATEJ�s�������'�O�$P�g����
�E�[�� ��q�кerM�;p�uO�E)A
u�t�`i�0_L�\'&)I��l� C�����Q�<HH�P�&W�d��j{��2�񹅡!�J�G����8�?��v�R> J��       �   \   x�}�1
�0�=��	D�:.�f�$������A\/��4�H� J񀹽�$�{����C�����y����R��1J�Z�ru���?�],X9      �   p   x�}�1�0Й��'��r��= K�z�����Y8=B �����ծHE����,s��&�P�V��$J`mb��
7�F��Ǟ��
��a�jzX����Si��P6]�����6���0E�      �   |   x�u�K
�0@�q����I�P�HSJA����@ǎ/��liL��\���{�,���ϣ��$���tf�`46���<{��:����D*�\m��k��ާ���d�/[~.ęH��^��?��#-      �   U   x���	�0�s3E�xu	'��Öh�����/O���o�ȳ,k����E��J��S�'��Yӷ����� y#      �   B   x�K/M�+��p50���K)�Mr��r!��p%�ؕ")1�*(�+Ír��7����� ��&      �      x�3�2�2��24������ �      �   5  x�e��N�0Fח���?X�TҢ1�M��355���i|_L5�����s�|h�>c��2|	��8o�On�pg5���4�l����F��M��gM��G�_\ e���L��0h���&F$�E�R�\�i�ن$�~�z�@���K��i����g�  Qі���II���+����Ba��=|�څ��)B�B))*�gyI���e�~vU���?��}2>|�ǈ_���k��-3���5_�*?��i�ӣ{����-�>��s��P���^���yG�"#��R���zƻ���P��kH~FX�xE�'�:x�      �   #   x�p50�4�4�
p502A# Ø+F��� [      �   Q  x�Œ�N�0���)�(򝝤�V�n���H�M��"�#�����M!��T����ﻻ���f�}e�dH�������^����j(�M����8��ؠ�Q��`o��Fyuz�P:��*��Z�����>4ցwm�b�\��W�(�K�&����[���e��Q�F���C�S9����s��$����~vCL.�(�`���G�3b�	>a�m�LR1g�
��~����3+λ�0��� �}�����"�$�12�<)�mO�h��ƻ]�kA�֔�5�>�`>),��&d�gSr�+�Y\unc��)�1u�5���12IsX��P���4M? �:2c      �   z   x�m�A�0��+���~^Ћ�D�R���?QA���f�O�ʰ�����a���~�_^\^]��h�|�zʵv}(��v$��abL$�Kajy�s��+,��f:ҏF����K�-�F      �      x�3�2�2�2������ ��      �   H   x�=�A
�0�s���G��k	�Ii��{sγ���)��Q�!e�����|Y*Y�>��ԗVP^>7f� �tW      �   	  x����J�0���S�V���{w�hO�e6L�mR�ӃO��b����`!�d2��(!�F�R\���ȇ� F��`D"��=X.��5OǶ�eS��*�u�~��>2d�G�)�}%g��1zףulE�9�td���,�8�	C&���{��o|�nΡ�ϱjX�طts��G����ۮ��[�/�:yr��@<C�KF��J�߬ǻ�x�jq+�Aջ�?(5��%�sr0M���� ^��>-��k�z�B��=_E�팴7      �   �   x�m��
�0E��+���E�ա��
��<�`�)I��o�X:\�w���bD�������O��NAi��t�W)Gr��,z� UD����ŭ\'w�]�)�b�"W�c)>������u��B�9T,%����/8o�2J��?2�GD�Q� ﵔ�g?      �     x�U�Ar� E�p
���I�^�'�FƲ�� /|�ޥ��I����!��8v>�d
�@@�r�8Q���a���e��2�4�4������E��?�ws-�J�#��`��2M����W�P�E�٣K
9^�(��̘��,�&�Y�'�D�NI��h����{x�h���kx~&d�iVP��CH씺m��wCI�$DHm��a�~j��U9��������@!!�a�X���Q�Su�������Ay��h���[aϽp�CI�󯺣��Xk����v      �      x�3400�2400F �D�p��qqq L:�      �   �   x�m�An� ����]R����!���-;RU���(4UJ%oX}��RA8I8!R���S�d5�BQ�u�u�����*�'�k���K��[DRST�֡mG���-e~߃\%du~�P:D`7£4�O�;*+M��_��\��Uդ�)-9�A=�����.���?�p]r^R��ov������zb�o��O�      �   +  x�u��N�0���S�	�v����B{DB&u�%7)��O��n�zH��7����x:��v�ѻH.t���c
X��(%}v{���<t$0�<MHt�@ΛCsܐ��w(��&
���g[h֟�B��967���D�k"��W�.l A�)�qM�0R�8e�4�?��dn+�Ҽ?#��B���W!����'�S�G�%rq%�Uҕy.nJ��6Z�!��g.-�
zmsMhU����1�iw�xm^y�*��|`ҠL[q�������y`Ag�G���%����ua웷��i�e���      �   (   x�s�q	�70�p50�rE��xf(rf�rF\1z\\\ ��"      �   l   x��1�  g�����QG�t�bD-��&�o2��.21�$}�*����L6�m��ۏ��%����H��q���mU��}��Ԫ�^]�?�������"�L�      �      x�+HI�*�LI����MLO����� Nc     