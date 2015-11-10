PGDMP         :            
    s            brainfights    9.4.0    9.4.0 R    c	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            d	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            e	           1262    66328    brainfights    DATABASE     i   CREATE DATABASE brainfights WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';
    DROP DATABASE brainfights;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            f	           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    5            g	           0    0    public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    5            �            3079    12123    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            h	           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    195            �            1259    66329 
   admin_user    TABLE     �  CREATE TABLE admin_user (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    enabled boolean DEFAULT true NOT NULL,
    login character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL
);
    DROP TABLE public.admin_user;
       public         postgres    false    5            �            1259    66456    admin_user_sequence    SEQUENCE     u   CREATE SEQUENCE admin_user_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.admin_user_sequence;
       public       postgres    false    5            �            1259    66339    answer    TABLE     '  CREATE TABLE answer (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    correct boolean DEFAULT false NOT NULL,
    name character varying(100) NOT NULL,
    question_id bigint
);
    DROP TABLE public.answer;
       public         postgres    false    5            �            1259    66458    answer_sequence    SEQUENCE     q   CREATE SEQUENCE answer_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.answer_sequence;
       public       postgres    false    5            �            1259    66346    category    TABLE     ,  CREATE TABLE category (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    color character varying(50),
    image_url character varying(255),
    name character varying(255) NOT NULL
);
    DROP TABLE public.category;
       public         postgres    false    5            �            1259    66460    category_sequence    SEQUENCE     s   CREATE SEQUENCE category_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.category_sequence;
       public       postgres    false    5            �            1259    66386 
   department    TABLE     :  CREATE TABLE department (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    name character varying(255) NOT NULL,
    scrore integer NOT NULL,
    usercount integer NOT NULL,
    parent_id bigint
);
    DROP TABLE public.department;
       public         postgres    false    5            �            1259    66472    department_sequence    SEQUENCE     u   CREATE SEQUENCE department_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.department_sequence;
       public       postgres    false    5            �            1259    66355    game    TABLE     �  CREATE TABLE game (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    game_finished_date timestamp without time zone,
    game_started_date timestamp without time zone,
    invitation_accepted_date timestamp without time zone,
    invitation_sent_date timestamp without time zone,
    status character varying(255) NOT NULL
);
    DROP TABLE public.game;
       public         postgres    false    5            �            1259    66361 
   game_round    TABLE     >  CREATE TABLE game_round (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    status character varying(255) NOT NULL,
    category_id bigint,
    game_id bigint,
    number integer,
    owner_id bigint
);
    DROP TABLE public.game_round;
       public         postgres    false    5            �            1259    66367    game_round_question    TABLE     �   CREATE TABLE game_round_question (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    gameround_id bigint,
    question_id bigint
);
 '   DROP TABLE public.game_round_question;
       public         postgres    false    5            �            1259    66373    game_round_question_answer    TABLE     O  CREATE TABLE game_round_question_answer (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    is_correct_answer boolean DEFAULT false NOT NULL,
    answer_id bigint,
    gameroundquestion_id bigint,
    gamer_id bigint
);
 .   DROP TABLE public.game_round_question_answer;
       public         postgres    false    5            �            1259    66462 #   game_round_question_answer_sequence    SEQUENCE     �   CREATE SEQUENCE game_round_question_answer_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE public.game_round_question_answer_sequence;
       public       postgres    false    5            �            1259    66464    game_round_question_sequence    SEQUENCE     ~   CREATE SEQUENCE game_round_question_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.game_round_question_sequence;
       public       postgres    false    5            �            1259    66466    game_round_sequence    SEQUENCE     u   CREATE SEQUENCE game_round_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.game_round_sequence;
       public       postgres    false    5            �            1259    66468    game_sequence    SEQUENCE     o   CREATE SEQUENCE game_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.game_sequence;
       public       postgres    false    5            �            1259    66380    gamer    TABLE     �  CREATE TABLE gamer (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    correct_answer_count integer,
    last_update_status_date timestamp without time zone,
    score integer NOT NULL,
    status character varying(255) NOT NULL,
    game_id bigint,
    user_id bigint,
    game_initiator boolean DEFAULT false NOT NULL,
    oponent_id bigint
);
    DROP TABLE public.gamer;
       public         postgres    false    5            �            1259    66470    gamer_sequence    SEQUENCE     p   CREATE SEQUENCE gamer_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.gamer_sequence;
       public       postgres    false    5            �            1259    66392    question    TABLE     M  CREATE TABLE question (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    image_url character varying(255),
    text character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    category_id bigint
);
    DROP TABLE public.question;
       public         postgres    false    5            �            1259    66474    question_sequence    SEQUENCE     s   CREATE SEQUENCE question_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.question_sequence;
       public       postgres    false    5            �            1259    66476    user_sequence    SEQUENCE     o   CREATE SEQUENCE user_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.user_sequence;
       public       postgres    false    5            �            1259    66479    users    TABLE     =  CREATE TABLE users (
    id bigint NOT NULL,
    created_date timestamp without time zone,
    deleted boolean DEFAULT false NOT NULL,
    modified_date timestamp without time zone,
    app_version character varying(50),
    device_os_version character varying(50),
    device_push_key character varying(255),
    device_type character varying(50),
    login character varying(50),
    name character varying(255) NOT NULL,
    password character varying(50),
    "position" character varying(255),
    score integer NOT NULL,
    auth_token character varying(50),
    device_push_token character varying(255),
    drawngames integer,
    email character varying(50),
    last_activity_time timestamp without time zone NOT NULL,
    loosinggames integer,
    totalgames integer,
    wongames integer,
    department_id bigint
);
    DROP TABLE public.users;
       public         postgres    false    5            �            1259    66550    users_friends    TABLE     [   CREATE TABLE users_friends (
    user_id bigint NOT NULL,
    friend_id bigint NOT NULL
);
 !   DROP TABLE public.users_friends;
       public         postgres    false    5            J	          0    66329 
   admin_user 
   TABLE DATA                     public       postgres    false    172   D`       i	           0    0    admin_user_sequence    SEQUENCE SET     ;   SELECT pg_catalog.setval('admin_user_sequence', 1, false);
            public       postgres    false    182            K	          0    66339    answer 
   TABLE DATA                     public       postgres    false    173   ^`       j	           0    0    answer_sequence    SEQUENCE SET     7   SELECT pg_catalog.setval('answer_sequence', 1, false);
            public       postgres    false    183            L	          0    66346    category 
   TABLE DATA                     public       postgres    false    174   �c       k	           0    0    category_sequence    SEQUENCE SET     9   SELECT pg_catalog.setval('category_sequence', 1, false);
            public       postgres    false    184            R	          0    66386 
   department 
   TABLE DATA                     public       postgres    false    180   �e       l	           0    0    department_sequence    SEQUENCE SET     ;   SELECT pg_catalog.setval('department_sequence', 1, false);
            public       postgres    false    190            M	          0    66355    game 
   TABLE DATA                     public       postgres    false    175   3g       N	          0    66361 
   game_round 
   TABLE DATA                     public       postgres    false    176   Ah       O	          0    66367    game_round_question 
   TABLE DATA                     public       postgres    false    177   �i       P	          0    66373    game_round_question_answer 
   TABLE DATA                     public       postgres    false    178   "k       m	           0    0 #   game_round_question_answer_sequence    SEQUENCE SET     K   SELECT pg_catalog.setval('game_round_question_answer_sequence', 44, true);
            public       postgres    false    185            n	           0    0    game_round_question_sequence    SEQUENCE SET     D   SELECT pg_catalog.setval('game_round_question_sequence', 31, true);
            public       postgres    false    186            o	           0    0    game_round_sequence    SEQUENCE SET     ;   SELECT pg_catalog.setval('game_round_sequence', 13, true);
            public       postgres    false    187            p	           0    0    game_sequence    SEQUENCE SET     5   SELECT pg_catalog.setval('game_sequence', 23, true);
            public       postgres    false    188            Q	          0    66380    gamer 
   TABLE DATA                     public       postgres    false    179   n       q	           0    0    gamer_sequence    SEQUENCE SET     6   SELECT pg_catalog.setval('gamer_sequence', 41, true);
            public       postgres    false    189            S	          0    66392    question 
   TABLE DATA                     public       postgres    false    181   yo       r	           0    0    question_sequence    SEQUENCE SET     9   SELECT pg_catalog.setval('question_sequence', 1, false);
            public       postgres    false    191            s	           0    0    user_sequence    SEQUENCE SET     5   SELECT pg_catalog.setval('user_sequence', 1, false);
            public       postgres    false    192            _	          0    66479    users 
   TABLE DATA                     public       postgres    false    193   �t       `	          0    66550    users_friends 
   TABLE DATA                     public       postgres    false    194   �v       �           2606    66338    admin_user_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY admin_user
    ADD CONSTRAINT admin_user_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.admin_user DROP CONSTRAINT admin_user_pkey;
       public         postgres    false    172    172            �           2606    66345    answer_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY answer
    ADD CONSTRAINT answer_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.answer DROP CONSTRAINT answer_pkey;
       public         postgres    false    173    173            �           2606    66354    category_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public         postgres    false    174    174            �           2606    66360 	   game_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY game
    ADD CONSTRAINT game_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.game DROP CONSTRAINT game_pkey;
       public         postgres    false    175    175            �           2606    66366    game_round_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY game_round
    ADD CONSTRAINT game_round_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.game_round DROP CONSTRAINT game_round_pkey;
       public         postgres    false    176    176            �           2606    66379    game_round_question_answer_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT game_round_question_answer_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.game_round_question_answer DROP CONSTRAINT game_round_question_answer_pkey;
       public         postgres    false    178    178            �           2606    66372    game_round_question_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY game_round_question
    ADD CONSTRAINT game_round_question_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.game_round_question DROP CONSTRAINT game_round_question_pkey;
       public         postgres    false    177    177            �           2606    66385 
   gamer_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY gamer
    ADD CONSTRAINT gamer_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.gamer DROP CONSTRAINT gamer_pkey;
       public         postgres    false    179    179            �           2606    66391    organization_unit_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY department
    ADD CONSTRAINT organization_unit_pkey PRIMARY KEY (id);
 K   ALTER TABLE ONLY public.department DROP CONSTRAINT organization_unit_pkey;
       public         postgres    false    180    180            �           2606    66400    question_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY question
    ADD CONSTRAINT question_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.question DROP CONSTRAINT question_pkey;
       public         postgres    false    181    181            �           2606    66487 
   users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         postgres    false    193    193            �           2606    66558    fk126f65eafe2eb43    FK CONSTRAINT     r   ALTER TABLE ONLY users_friends
    ADD CONSTRAINT fk126f65eafe2eb43 FOREIGN KEY (friend_id) REFERENCES users(id);
 I   ALTER TABLE ONLY public.users_friends DROP CONSTRAINT fk126f65eafe2eb43;
       public       postgres    false    194    2251    193            �           2606    66553    fk126f65eec8edef6    FK CONSTRAINT     p   ALTER TABLE ONLY users_friends
    ADD CONSTRAINT fk126f65eec8edef6 FOREIGN KEY (user_id) REFERENCES users(id);
 I   ALTER TABLE ONLY public.users_friends DROP CONSTRAINT fk126f65eec8edef6;
       public       postgres    false    194    193    2251            �           2606    66406    fk39c72301111439cf    FK CONSTRAINT     m   ALTER TABLE ONLY game_round
    ADD CONSTRAINT fk39c72301111439cf FOREIGN KEY (game_id) REFERENCES game(id);
 G   ALTER TABLE ONLY public.game_round DROP CONSTRAINT fk39c72301111439cf;
       public       postgres    false    176    2237    175            �           2606    66411    fk39c723011364b30d    FK CONSTRAINT     u   ALTER TABLE ONLY game_round
    ADD CONSTRAINT fk39c723011364b30d FOREIGN KEY (category_id) REFERENCES category(id);
 G   ALTER TABLE ONLY public.game_round DROP CONSTRAINT fk39c723011364b30d;
       public       postgres    false    176    2235    174            �           2606    66578    fk39c72301de02d632    FK CONSTRAINT     o   ALTER TABLE ONLY game_round
    ADD CONSTRAINT fk39c72301de02d632 FOREIGN KEY (owner_id) REFERENCES gamer(id);
 G   ALTER TABLE ONLY public.game_round DROP CONSTRAINT fk39c72301de02d632;
       public       postgres    false    176    179    2245            �           2606    66441    fk5d932c0111439cf    FK CONSTRAINT     g   ALTER TABLE ONLY gamer
    ADD CONSTRAINT fk5d932c0111439cf FOREIGN KEY (game_id) REFERENCES game(id);
 A   ALTER TABLE ONLY public.gamer DROP CONSTRAINT fk5d932c0111439cf;
       public       postgres    false    2237    175    179            �           2606    66573    fk5d932c0bcd77c7a    FK CONSTRAINT     k   ALTER TABLE ONLY gamer
    ADD CONSTRAINT fk5d932c0bcd77c7a FOREIGN KEY (oponent_id) REFERENCES gamer(id);
 A   ALTER TABLE ONLY public.gamer DROP CONSTRAINT fk5d932c0bcd77c7a;
       public       postgres    false    2245    179    179            �           2606    66488    fk5d932c0ec8edef6    FK CONSTRAINT     h   ALTER TABLE ONLY gamer
    ADD CONSTRAINT fk5d932c0ec8edef6 FOREIGN KEY (user_id) REFERENCES users(id);
 A   ALTER TABLE ONLY public.gamer DROP CONSTRAINT fk5d932c0ec8edef6;
       public       postgres    false    179    2251    193            �           2606    66431    fk610a48f9117b7f05    FK CONSTRAINT        ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT fk610a48f9117b7f05 FOREIGN KEY (gamer_id) REFERENCES gamer(id);
 W   ALTER TABLE ONLY public.game_round_question_answer DROP CONSTRAINT fk610a48f9117b7f05;
       public       postgres    false    179    178    2245            �           2606    66436    fk610a48f94caf2345    FK CONSTRAINT     �   ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT fk610a48f94caf2345 FOREIGN KEY (gameroundquestion_id) REFERENCES game_round_question(id);
 W   ALTER TABLE ONLY public.game_round_question_answer DROP CONSTRAINT fk610a48f94caf2345;
       public       postgres    false    178    177    2241            �           2606    66426    fk610a48f9815623cd    FK CONSTRAINT     �   ALTER TABLE ONLY game_round_question_answer
    ADD CONSTRAINT fk610a48f9815623cd FOREIGN KEY (answer_id) REFERENCES answer(id);
 W   ALTER TABLE ONLY public.game_round_question_answer DROP CONSTRAINT fk610a48f9815623cd;
       public       postgres    false    2233    178    173            �           2606    66563    fk6a68e089f8f9896    FK CONSTRAINT     s   ALTER TABLE ONLY users
    ADD CONSTRAINT fk6a68e089f8f9896 FOREIGN KEY (department_id) REFERENCES department(id);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT fk6a68e089f8f9896;
       public       postgres    false    193    2247    180            �           2606    66416    fk94c11b643bf56be5    FK CONSTRAINT     �   ALTER TABLE ONLY game_round_question
    ADD CONSTRAINT fk94c11b643bf56be5 FOREIGN KEY (gameround_id) REFERENCES game_round(id);
 P   ALTER TABLE ONLY public.game_round_question DROP CONSTRAINT fk94c11b643bf56be5;
       public       postgres    false    176    2239    177            �           2606    66421    fk94c11b64a8b56a0d    FK CONSTRAINT     ~   ALTER TABLE ONLY game_round_question
    ADD CONSTRAINT fk94c11b64a8b56a0d FOREIGN KEY (question_id) REFERENCES question(id);
 P   ALTER TABLE ONLY public.game_round_question DROP CONSTRAINT fk94c11b64a8b56a0d;
       public       postgres    false    177    181    2249            �           2606    66401    fkabca3fbea8b56a0d    FK CONSTRAINT     q   ALTER TABLE ONLY answer
    ADD CONSTRAINT fkabca3fbea8b56a0d FOREIGN KEY (question_id) REFERENCES question(id);
 C   ALTER TABLE ONLY public.answer DROP CONSTRAINT fkabca3fbea8b56a0d;
       public       postgres    false    173    2249    181            �           2606    66451    fkba823be61364b30d    FK CONSTRAINT     s   ALTER TABLE ONLY question
    ADD CONSTRAINT fkba823be61364b30d FOREIGN KEY (category_id) REFERENCES category(id);
 E   ALTER TABLE ONLY public.question DROP CONSTRAINT fkba823be61364b30d;
       public       postgres    false    2235    174    181            �           2606    66446    fkcd3fed10e5765543    FK CONSTRAINT     u   ALTER TABLE ONLY department
    ADD CONSTRAINT fkcd3fed10e5765543 FOREIGN KEY (parent_id) REFERENCES department(id);
 G   ALTER TABLE ONLY public.department DROP CONSTRAINT fkcd3fed10e5765543;
       public       postgres    false    2247    180    180            J	   
   x���          K	   �  x���Ak�@D��{K:h%K��)�r0���`,�Mm����9S��\�.��Ȏ����.VO�?��b��=�w���!�n�,l��4�����,���p����}�}������p6�,��矿>��i�߽n����a���n�,�^��,��ߏ�??n��d!��O���Lr�1�i���8j�.���ua8fr]��˅)�(WI�B:$��^�fʀTri ��[��@ҏ�ei*��KÀ��Hǁh�� �v DK@Àh�@�0 �ր�5 � �hh��� D}cΐh!�H�Z(c/ � ����H�Df�j�H�@$����L���DE�� 2�p���"�R@��bf�?aHj�
 �
�q�6� "1� "1����k�
 �
�ưf(n+�H+�H+`��ư�İ�D�f.n��@$3m������g�
(m������ Db4�V[A��ŭ��D[E���`��V[E���"1���\�~urC(���8�P(�P(�0�q�7�P9�P��a���Ѩb(�P(� 0#r4�����v�����Q7�P��!��%�d�h�1-	������CEK�b�K�to1�&��%����FCђ��� ��F+�B1ʈ�!	��l�1�����W�UQH��(iI�H�����@Р*:�s%-	�2
r:|^8����t�0(]R���G�8�;y2��4S�ڗ�)t�H��G#sJ]ѯS�v�L*u%AF��ˬR�nV�ɬ�
�vuX���+T��a�Z�2�T�N���iU�
\2�TCH��*��R��V�ߠ�Ju
t^�kX�hV&;�����db�.�@���b�:�Ԇ�N,�	=~�uMB�����\�\ޱ������      L	   �  x����KA���sSa�]�~�:x� ��l�.��L�t3;T(A"A�mm#����s�p�]��^>��ﾗ�d�'9���IQoP�a$b
)2��Q0���+�T�*Y?ϋ��0�XUݤ�&�Rӫ4JN���d�D4��㪖�i*.���
+����t�۰�(��&�O�����!����b=�3ރ1x��a(��qQF���>`Cߡ�0�<peXl�Z8L��tE���� ��ί`*[�n�*+�<�1��ϸ��]��P�BBT��֋�O~�o193ޕA�#J�*[���`\&�Z��pl��n�񇽑�'�&�݅)�|�;2������
�|������-+��v�`�_l�,7b����/?��rvI��<t����e���K93JS��Ub��c��ރ	^��1��B$�9��      R	   k  x�ŔKk�@��~�����&��8��AU{�`V�(1�Uz롔z(=�_@ķU���7�?���ҋvwfg�?������
�+����t)f[Ui�ҪX85d�7�-ˮ�_���ٮ:-�ӖN��i��1<U��8�\���"�RE��Nt�EB��+�Qͬ���(x�;�����qۨ>񊷞���k���$�!`��\�l���^�4�5�(v>�{��?�R�s���kⓡah7��c���<y�[���$u��Z�@�G*���Щ����g"��#��$��ܐ����F�Ƀ9^x�z~O6�K����Ku�#�.�����=J�c� ���;C����%�H��e��      M	   �   x�Ր_k�0����--�p��n�O�9��U��.��Q�}�96lKE�Zr��$ܣ�<����v�`a����5��e��j���-�ñv���l\��k���t����y�ݱ-MUُQ����S������N�I3��Ȣcd�Q1��	�1��N�6M��L�u����W���v�u8��AN�3�ig��..ב��B�pI1�c��g+D%�BI��%�BAc�����?}jĹ�*/֛�� ����      N	   3  x�Ŕ]k�0�����R�ɇ��U�d��[/�ʹ��U���bCg��&�I����@�p��"�h�$�qYԗfYJ��I��85#�T����E����k�T��Ц:�w�\�=�,.u��K��E�fg��͛���G�f�qA0��*)�+��19_�!`?n_^7~�?��sJ 	�?X�dR�nd	�*�T�s$���Dϊ�VftR+����*Μ��F��DOk�j�ɛ�8͘b�B�ju����j��ņ�]%����V��iy����[|����������� |�������Rc��6̲~ �VnG      O	   �  x���=k�0�=�B[p��dI�:u�()4iWj��A���+�n0(���b�y%�N��j��f�����l�uy:^U�{�ϗ�x`��J����\ꪬ�3aU���(a�c�l���vz7���L�����|�&�%l��`�3�� 7R��g�m7�s�0�'��e��e� 
!�v��h2al��D���l=DIƹ��`�J)Da���<dREL�;tF�.���V�~�%��ge�Z��z� ���/�������[ѻ1��y��%�[ӻ��B4(�L��{� ����YH���^¹�$ʐ�~o��M
��U�H���{� ���'ԉ�({�����M/A�U�*�bn�p�'Է�-.�t�=L�=�� w�_�*�cn�h�H~��U"\�Äs��=��̿7      P	   �  x�͙AO1���
� i�<c{�ޞz��TQ��^�(Y�H@�$���dI����\�^v�i^�ބ�ǧ���������|�����z��c�6����}�wک�ͺS�ݴ<L�Ś~vj=�N�W�޶����|}�_���ݴ:�o���u�q|��	��ۭ������'u�:u����q
�h�h@c��N�,_�SSq�}���N���헫������z�}�+�����:4ƚ+Nc����Q��$^r'�`�C_be�V#�8	��i�f���
��E�"'q#m,�Y3���$��2��9�Pe�'VL��tV�Ip4����"��tX_B��m�-س�4�4T��Y{N�G(Rl��+,�.�:C	���8ׂ�T$�],6�P����[P��m,6rj�V�F���#��	X4,��a��oLvV�,5
鰼=
m�@M�N:D鴼?���ö~B�KK��
��6�^�

H���Ȣiy�"��X/\ ��6����5]��f���Cb��Yy�BG��vC=zr��J	��W��H����gŉ5�LQ�*��?a�2�����+B?�Xt���D(�u蛰GEV:"�.�ky"KU��w�\q�bѬ�>��Ql�N��EE��*�B{Fu��`�R���m����A}#d3��hS�H�fm�=�����P���>�=�P�bZ�mc����0�X4*oO�?UAC�=�:��f���8���      Q	   e  x���]k�0����s�R�I�l�U�e%�֮�"��բ���EW�~i���7	y0�خ6x"��;:�FiB .d�d&�N �G����$=���E!cFY�#�0ΫL8F�
�s	K����K��M�4˅�bU��/�,Ui��@~�3�)���b�[madSCFq:A�Pw)s雅l:$p����L lO�e�������x�#��;��5�� UTzj���wl؆��+�ƥ�mv���b%��3�۴�p��Q��h�ȟ�=$�����5Jm<�����j�/u^y5���͏�	a�̹�<��=�.C�9�..�x�u�]n�k~��{���6;�<�&ъe�WX��$2�5�g��      S	   !  x�͙MOW����+6$�+��������Ru��D�Hi�H��&Rh-�E���J��[����{�Q��܋�tu��J`ϗ��|ϙ��_����/��o�����A�TP�[��NTZ-᳠J�F���z�Y*�*��߬��V�nm�N���Ͻ�py7_on���K��O�^.�P&jb�89��d�X�\�&
����v��w�_.-�>�u�*�3�8h������)��1.��N�����7+��|���b�tS�t龩������]sj�y"|:6����'S�\��K�YVu= �'�'8��:bT������9U�*�������M{���2����~�^��L�}���A�GD�%8_,q��}�KK&z��ے�3�w.p�P-��'�G棢πx@0�����$d��yb�����Wd�8�� ��:f��^��m/���K�`��q/��xg)�]�Ay2?I��_�:�X�'�����e4Q~��}�XuQ��s����"Y��Q}��t�m��yЃ���6�.Z.DEl#;(��N:g� �Ʊ��7$��I3~�	9��{A�*S�
�+�} 2r�8l}���`�0@�Ԅ5 uE�b:�;��:V�t�O'J�5�A�Ϛa&o3�*��������w�&&̑ؤv�AI}U�HIfq���"�(��!����aPV_	�"�g�x�ର�()ɘ� V>fM�� �b�ڸaŕ��.dīdLˤ�����WK�
����+�ٍo�j�?��g����F�Jy��|@[Lݳ��+��py��n DƟ�60�Ր�������l�f!��^��O�|��A�FxHo?����\#��5�~*� NWC��Q�p��[]&;�:��H�#`3*��k�,u=(��Bk��ت�[�U�B�Ar�}�7-.>�l!��
��y����6,�N�1XAy~�K�!�-��+��ܒ�~A������>ˤ�����o���Ҿe�J\�B��-�n"��&ξMj�����1}�؟������r}����+��d�C'qb�Vв�j�ˎPϣ���m����Xg���+%��vMg{R_�tsd{�,�6�BR�*�e٦;tNA�jW3�syC�j'�hSyO"3�u85GT˕!PޙI�-�����(��驀N2�as��_�/t_E����;����i��	���G�lC^��D_�I�����Uޏ֜�}5W��ZY�'yc��������;����`�=�)��~���r��5��;����/Ճ�J�ӓm���R�)kM9J�ҩ�D�cLM�+G�����<�      _	   �  x��TQo�0~ϯ��B+2�^:m}Ȕ����9�V [�I���,�4[�<챒e�������b�~��D��G�І�
�\��3��K8T�+�Ԓ�B�~�T��!��9d���R�)�G�=*̮�V �a5.3� 5ָQ���7.1��]�֖��;��\��-��@�D���،�V�=fV�}=$n�'���U'� �t�i[Cc3��ȯ/��5�]�4���� ���Ḥ`��w�����_��*Q���q�lҴZ�0r�\ ��
4"������xt?����v�0һϓŇ�W(�o�94�8�Av�X�||o!5�{��������� �g����w/W�~�~������Hͧ�<N�4�u*~t�6��x\�]�-ԣ��k�%��|��DC�
r��m,������&N���̢؛�"��Y�z4)s��K���9���Z��%�����1��W᫙L~���      `	   F   x���v
Q���W(-N-*�O+�L�K)V� q�3St "@��B��O�k��������5�'ٺ����� $2&�     