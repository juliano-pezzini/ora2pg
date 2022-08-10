-- FUNCTION: public.search_names_dev(text, text, bigint, text, text, smallint, text)

-- DROP FUNCTION IF EXISTS public.search_names_dev(text, text, bigint, text, text, smallint, text);

CREATE OR REPLACE FUNCTION public.search_names_dev(
	nm_filter_p text,
	cd_person_filter_p text,
	nr_person_name_p bigint,
	ds_type_name_p text DEFAULT NULL::text,
	ds_filter_name_p text DEFAULT NULL::text,
	establishment_p smallint DEFAULT NULL::smallint,
	exact_match_p text DEFAULT NULL::text)
    RETURNS SETOF person_name_dev_row 
    LANGUAGE 'plpgsql'
    COST 100
    STABLE SECURITY DEFINER PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE

    -- TYPE cursor_ref REFCURSOR;
    person_name_dev_r        person_name_dev_row;
    person_name_dev_t        person_name_dev_table;
    is_name_feature_enabled  boolean;
    ds_type_name_w           person_name_format.ds_format%type;
    ds_filter_name_w         person_name_format.ds_format%type;
    establishment            estabelecimento.cd_estabelecimento%TYPE;
    nm_filtro_w              varchar(300);
    nm_filtro_validacao_w    varchar(300);
    cd_pessoa_fisica_w       pessoa_fisica.cd_pessoa_fisica%TYPE;
    nm_translated_w          pessoa_fisica.NM_SOCIAL%TYPE;
    nm_social_w              pessoa_fisica.NM_SOCIAL%TYPE;
    nm_pessoa_fisica_w       pessoa_fisica.NM_SOCIAL%TYPE;
    ds_se_nome_social_w      varchar(1);
    ds_param213_w            varchar(10);
    ds_locale_w              user_locale.ds_locale%TYPE;
    nm_filtro_reverse_w      varchar(2000);
    
    
    c01 CURSOR FOR
    SELECT
        b.cd_pessoa_fisica,
        pkg_name_utils.get_person_name(a.nr_sequencia, establishment, ds_type_name_w, ds_filter_name_w),
        CASE ds_locale_w
            WHEN 'ja_JP' THEN
                pkg_name_utils.get_person_name(a.nr_sequencia, establishment, ds_type_name_w, 'translated')
            ELSE
                NULL
        END
    FROM
        ( select pkg_name_utils.search_names(nm_filter_p, ds_filter_name_w, exact_match_p) )         a,
        pessoa_fisica                                                                               b
    WHERE
        b.nr_seq_person_name = a.nr_sequencia;

    c02 CURSOR FOR
    SELECT
        cd_pessoa_fisica,
        coalesce(nm_social, nm_pessoa_fisica),
        CASE ds_locale_w
            WHEN 'ja_JP' THEN
                pkg_name_utils.get_person_name(nr_seq_person_name, establishment, ds_type_name_w, 'translated')
            ELSE
                NULL
        END
    FROM
        pessoa_fisica
    WHERE
        upper(CASE WHEN coalesce(nm_social::text, '') = '' THEN  coalesce(nm_pessoa_pesquisa, nm_pessoa_fisica)  ELSE padronizar_nome(nm_social) END ) LIKE '%'
                                                                                                                   || nm_filtro_w
                                                                                                                   || '%';

    c03 CURSOR FOR
    SELECT
        cd_pessoa_fisica,
        nm_pessoa_fisica,
        nm_translate
    FROM (
            SELECT
                paging.*,
                ROW_NUMBER()
                OVER (
                    ORDER BY framework_order_index
                ) paging_rn
            FROM (
                    SELECT
                        returned_rows.*,
                        NULL framework_order_index
                    FROM (
                            SELECT /*+ first_rows(10000) */                                cd_pessoa_fisica,
                                nm_pessoa_fisica,
                                CASE
                                    WHEN( ds_locale_w = 'ja_JP' ) THEN
                                        pkg_name_utils.get_person_name(nr_seq_person_name, establishment, ds_type_name_w, 'translated')
                                    ELSE
                                        NULL
                                END AS nm_translate
                            FROM
                                pessoa_fisica
                            WHERE
                                nm_pessoa_pesquisa LIKE '%'
                                                        || nm_filtro_w
                                                        || '%'
                        ) returned_rows
                ) paging
        ) alias6
    WHERE ( paging_rn >= 1 )
        AND ( paging_rn <= 10000 );

    c04 CURSOR FOR
    SELECT
        cd_pessoa_fisica,
        nm_social,
        nm_pessoa_fisica,
        CASE
            WHEN( ds_locale_w = 'ja_JP' ) THEN
                pkg_name_utils.get_person_name(nr_seq_person_name, establishment, ds_type_name_w, 'translated')
            ELSE
                NULL
        END
    FROM
        pessoa_fisica
    WHERE
        ( upper(CASE WHEN coalesce(nm_social::text, '') = '' THEN  coalesce(nm_pessoa_pesquisa, nm_pessoa_fisica)  ELSE padronizar_nome(nm_social) END ) LIKE '%'
                                                                                                                     || nm_filtro_w
                                                                                                                     || '%'
          OR ( ( ds_locale_w = 'ja_JP' )
               AND upper(CASE WHEN coalesce(nm_social::text, '') = '' THEN  coalesce(nm_pessoa_pesquisa, nm_pessoa_fisica)  ELSE padronizar_nome(nm_social) END ) LIKE '%'
                                                                                                                              || nm_filtro_reverse_w
                                                                                                                              || '%' ) );

    c05 CURSOR FOR
    SELECT
        b.cd_pessoa_fisica,
        pkg_name_utils.get_person_name(a.nr_sequencia, establishment, ds_type_name_w, 'social'),
        pkg_name_utils.get_person_name(a.nr_sequencia, establishment, ds_type_name_w, 'main'),
        CASE
            WHEN( ds_locale_w = 'ja_JP' ) THEN
                pkg_name_utils.get_person_name(nr_sequencia, establishment, ds_type_name_w, 'translated')
            ELSE
                NULL
        END
    FROM
        ( select pkg_name_utils.search_names(nm_filter_p, ds_filter_name_w, exact_match_p) )         a,
        pessoa_fisica                                                                               b
    WHERE
        b.nr_seq_person_name = a.nr_sequencia;

    c06 CURSOR FOR
    SELECT
        cd_pessoa_fisica,
        nm_social,
        nm_pessoa_fisica,
        CASE
            WHEN( ds_locale_w = 'ja_JP' ) THEN
                pkg_name_utils.get_person_name(nr_seq_person_name, establishment, ds_type_name_w, 'translated')
            ELSE
                NULL
        END
    FROM
        pessoa_fisica
    WHERE
        lower(nm_social) LIKE '%'
                              || lower(nm_filter_p)
                              || '%'
        OR lower(nm_pessoa_fisica) LIKE '%'
                                        || lower(nm_filter_p)
                                        || '%';

    c07 CURSOR FOR
    SELECT
        b.cd_pessoa_fisica,
        pkg_name_utils.get_person_name(a.nr_sequencia, establishment, ds_type_name_w, 'main'),
        CASE
            WHEN( ds_locale_w = 'ja_JP' ) THEN
                pkg_name_utils.get_person_name(b.nr_seq_person_name, establishment, ds_type_name_w, 'translated')
            ELSE
                NULL
        END
    FROM
        ( select pkg_name_utils.search_names(nm_filter_p, ds_filter_name_w, exact_match_p) )         a,
        pessoa_fisica                                                                               b
    WHERE
            b.nr_seq_person_name = a.nr_sequencia
        AND upper(pkg_name_utils.get_person_name(a.nr_sequencia, establishment, ds_type_name_w, 'translated')) LIKE '%'
                                                                                                                    || upper(nm_filtro_w)
                                                                                                                    || '%';

BEGIN

/* Validation used because of web applications that have no user in the Tasy session. This validation should not be altered or deleted. */

    IF (establishment_p IS NOT NULL AND establishment_p::text <> '') THEN
        establishment := establishment_p;
    ELSE
        establishment       := wheb_usuario_pck.get_cd_estabelecimento();
    END IF;
    nm_filtro_w         := padronizar_nome(nm_filter_p);
	-- person_name_dev_r   := person_name_dev_row(NULL, NULL);
    person_name_dev_r   := ROW(NULL, NULL)::person_name_dev_row;
    nm_filtro_w         := padronizar_nome(nm_filter_p);
    ds_type_name_w      := ds_type_name_p;
    ds_filter_name_w    := ds_filter_name_p;
    ds_se_nome_social_w := pkg_name_utils.get_social_name_enabled(establishment);
    ds_param213_w       := pkg_name_utils.get_name_feature_enabled();
    ds_locale_w         := pkg_i18n.get_user_locale();

    IF ds_locale_w = 'ja_JP' THEN
        nm_filtro_reverse_w := get_patient_reverse_name(nm_filtro_w);
    ELSE
        nm_filtro_reverse_w := NULL;
    END IF;

    IF (nr_person_name_p IS NOT NULL AND nr_person_name_p::text <> '') THEN
        IF ( ds_filter_name_w = 'both' ) THEN
            ds_filter_name_w := NULL;
        END IF;
        IF ( coalesce(ds_type_name_w::text, '') = '' ) THEN
            ds_type_name_w := 'full';
        END IF;
        IF ( coalesce(ds_filter_name_w::text, '') = '' ) THEN
            ds_filter_name_w := 'main';
            IF ( ds_se_nome_social_w = 'S' ) THEN
                ds_filter_name_w := 'social,' || ds_filter_name_w;
            END IF;
        END IF;

        IF ( ds_se_nome_social_w = 'T' ) THEN
            SELECT
                cd_pessoa_fisica,
                pkg_name_utils.get_person_name(nr_person_name_p, establishment, ds_type_name_w, 'social'),
                pkg_name_utils.get_person_name(nr_person_name_p, establishment, ds_type_name_w, 'main'),
                CASE ds_locale_w
                    WHEN 'ja_JP' THEN
                        pkg_name_utils.get_person_name(nr_person_name_p, establishment, ds_type_name_w, 'translated')
                    ELSE
                        NULL
                END
            INTO STRICT
                cd_pessoa_fisica_w,
                nm_social_w,
                nm_pessoa_fisica_w,
                nm_translated_w
            FROM
                pessoa_fisica
            WHERE
                    nr_seq_person_name = nr_person_name_p  LIMIT 1;

            person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
            IF ( ds_locale_w = 'ja_JP' ) THEN
                IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                    person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                 || ' ('
                                                                 || nm_translated_w
                                                                 || ')', 1,
                                                                200);

                ELSE
                    person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w, 1, 200);
                END IF;
            ELSIF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                person_name_dev_r.nm_pessoa_fisica := substr(nm_social_w
                                                             || ' ('
                                                             || nm_pessoa_fisica_w
                                                             || ')', 1, 200);
            ELSE
                person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
            END IF;

        ELSE
            SELECT
                cd_pessoa_fisica,
                pkg_name_utils.get_person_name(nr_person_name_p, establishment, ds_type_name_w, ds_filter_name_w),
                pkg_name_utils.get_person_name(nr_person_name_p, establishment, ds_type_name_w, 'translated')
            INTO STRICT
                cd_pessoa_fisica_w,
                nm_pessoa_fisica_w,
                nm_translated_w
            FROM
                pessoa_fisica
            WHERE
                    nr_seq_person_name = nr_person_name_p  LIMIT 1;

            person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
            person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
            IF ( ds_locale_w = 'ja_JP' ) THEN
                IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                    person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                 || ' ('
                                                                 || nm_translated_w
                                                                 || ')', 1,
                                                                200);

                ELSE
                    person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w, 1, 200);
                END IF;
            ELSIF ( ds_filter_name_w = 'social,main' )
                AND ( coalesce(trim(both person_name_dev_r.nm_pessoa_fisica)::text, '') = '' )
            THEN
                SELECT
                    pkg_name_utils.get_person_name(nr_person_name_p, establishment, ds_type_name_w, 'main')
                INTO STRICT person_name_dev_r.nm_pessoa_fisica
                FROM
                    pessoa_fisica
                WHERE
                        nr_seq_person_name = nr_person_name_p  LIMIT 1;

            END IF;

        END IF;

        RETURN NEXT  person_name_dev_r;
    ELSIF (cd_person_filter_p IS NOT NULL AND cd_person_filter_p::text <> '') THEN
        IF ( ds_filter_name_w = 'both' ) THEN
            ds_filter_name_w := NULL;
        END IF;
        is_name_feature_enabled := ds_param213_w = 'S';
        IF ( is_name_feature_enabled ) THEN
            IF ( coalesce(ds_type_name_w::text, '') = '' ) THEN
                ds_type_name_w := 'full';
            END IF;
            IF ( coalesce(ds_filter_name_w::text, '') = '' ) THEN
                ds_filter_name_w := 'main';
                IF ( ds_se_nome_social_w = 'S' ) THEN
                    ds_filter_name_w := 'social,' || ds_filter_name_w;
                END IF;
            END IF;

            IF ( ds_se_nome_social_w = 'T' ) THEN
                SELECT
                    a.cd_pessoa_fisica,
                    pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w, 'social'),
                    pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w, 'main'),
                    pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w,
                                                   'translated')
                INTO STRICT
                    cd_pessoa_fisica_w,
                    nm_social_w,
                    nm_pessoa_fisica_w,
                    nm_translated_w
                FROM
                    pessoa_fisica a
                WHERE
                        a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                IF ( ds_locale_w = 'ja_JP' ) THEN
                    IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                     || ' ('
                                                                     || nm_translated_w
                                                                     || ')',
                                                                    1,
                                                                    200);

                    ELSE
                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w, 1, 200);
                    END IF;
                ELSIF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                    person_name_dev_r.nm_pessoa_fisica := substr(nm_social_w
                                                                 || ' ('
                                                                 || nm_pessoa_fisica_w
                                                                 || ')', 1,
                                                                200);
                ELSE
                    person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                END IF;

            ELSE
                SELECT
                    a.cd_pessoa_fisica,
                    pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w,
                                                   ds_filter_name_w),
                    pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w,
                                                   'translated')
                INTO STRICT
                    cd_pessoa_fisica_w,
                    nm_pessoa_fisica_w,
                    nm_translated_w
                FROM
                    pessoa_fisica a
                WHERE
                        a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                IF ( ds_locale_w = 'ja_JP' ) THEN
                    IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                     || ' ('
                                                                     || nm_translated_w
                                                                     || ')',
                                                                    1,
                                                                    200);

                    ELSE
                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w, 1, 200);
                    END IF;
                ELSE
                    person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                END IF;

            END IF;

            RETURN NEXT  person_name_dev_r;
        ELSE
            BEGIN
                IF ( ds_se_nome_social_w = 'S' ) THEN
                    BEGIN
                        SELECT
                            a.cd_pessoa_fisica,
                            coalesce(a.nm_social, a.nm_pessoa_fisica)
                        INTO STRICT
                            person_name_dev_r.cd_pessoa_fisica,
                            person_name_dev_r.nm_pessoa_fisica
                        FROM
                            pessoa_fisica a
                        WHERE
                                a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                    EXCEPTION
                        WHEN no_data_found THEN
                            NULL;
                        WHEN too_many_rows THEN
                            NULL;
                    END;
                ELSIF ( ds_se_nome_social_w = 'T' ) THEN
                    IF ( ds_locale_w = 'ja_JP' ) THEN
                        BEGIN
                            SELECT
                                a.cd_pessoa_fisica,
                                a.nm_social,
                                a.nm_pessoa_fisica,
                                pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w,
                                                               'translated')
                            INTO STRICT
                                cd_pessoa_fisica_w,
                                nm_social_w,
                                nm_pessoa_fisica_w,
                                nm_translated_w
                            FROM
                                pessoa_fisica a
                            WHERE
                                    a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                NULL;
                            WHEN too_many_rows THEN
                                NULL;
                        END;

                        person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                        IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                            person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                         || ' ('
                                                                         || nm_translated_w
                                                                         || ')',
                                                                        1,
                                                                        200);
                        ELSIF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                            person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                         || ' ('
                                                                         || nm_social_w
                                                                         || ')',
                                                                        1,
                                                                        200);
                        ELSE
                            person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                        END IF;

                    ELSE
                        BEGIN
                            SELECT
                                a.cd_pessoa_fisica,
                                a.nm_social,
                                a.nm_pessoa_fisica
                            INTO STRICT
                                cd_pessoa_fisica_w,
                                nm_social_w,
                                nm_pessoa_fisica_w
                            FROM
                                pessoa_fisica a
                            WHERE
                                    a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                NULL;
                            WHEN too_many_rows THEN
                                NULL;
                        END;

                        person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                        IF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                            person_name_dev_r.nm_pessoa_fisica := substr(nm_social_w
                                                                         || ' ('
                                                                         || nm_pessoa_fisica_w
                                                                         || ')',
                                                                        1,
                                                                        200);
                        ELSE
                            person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                        END IF;

                    END IF;
                ELSE
                    IF ( ds_locale_w = 'ja_JP' ) THEN
                        BEGIN
                            SELECT
                                a.cd_pessoa_fisica,
                                a.nm_pessoa_fisica,
                                pkg_name_utils.get_person_name(a.nr_seq_person_name, establishment, ds_type_name_w,
                                                               'translated')
                            INTO STRICT
                                person_name_dev_r.cd_pessoa_fisica,
                                person_name_dev_r.nm_pessoa_fisica,
                                nm_translated_w
                            FROM
                                pessoa_fisica a
                            WHERE
                                    a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                NULL;
                            WHEN too_many_rows THEN
                                NULL;
                        END;

                        IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                            person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                         || ' ('
                                                                         || nm_translated_w
                                                                         || ')',
                                                                        1,
                                                                        200);

                        END IF;

                    ELSE
                        BEGIN
                            SELECT
                                a.cd_pessoa_fisica,
                                a.nm_pessoa_fisica
                            INTO STRICT
                                person_name_dev_r.cd_pessoa_fisica,
                                person_name_dev_r.nm_pessoa_fisica
                            FROM
                                pessoa_fisica a
                            WHERE
                                    a.cd_pessoa_fisica = cd_person_filter_p  LIMIT 1;

                        EXCEPTION
                            WHEN no_data_found THEN
                                NULL;
                            WHEN too_many_rows THEN
                                NULL;
                        END;
                    END IF;
                END IF;

                RETURN NEXT  person_name_dev_r;
            END;
        END IF;

    ELSE
        BEGIN
            IF (nm_filter_p IS NOT NULL AND nm_filter_p::text <> '') THEN
                BEGIN
                    is_name_feature_enabled := ds_param213_w = 'S';
                    IF ( is_name_feature_enabled ) THEN
                        IF ( ds_filter_name_w = 'both' ) THEN
                            ds_filter_name_w := NULL;
                        END IF;
                        IF ( coalesce(ds_type_name_w::text, '') = '' ) THEN
                            ds_type_name_w := 'full';
                        END IF;
                        IF ( coalesce(ds_filter_name_w::text, '') = '' ) THEN
                            ds_filter_name_w := 'main';
                            IF ( ds_se_nome_social_w = 'S' ) THEN
                                ds_filter_name_w := 'social,' || ds_filter_name_w;
                            END IF;
                        END IF;

                        IF ( ds_se_nome_social_w = 'T' ) THEN
                            OPEN c05;
                            LOOP
                                FETCH c05 INTO
                                    cd_pessoa_fisica_w,
                                    nm_social_w,
                                    nm_pessoa_fisica_w,
                                    nm_translated_w;
                                EXIT WHEN NOT FOUND; /* apply on c05 */
                                person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                                IF ( ds_locale_w = 'ja_JP' ) THEN
                                    IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                     || ' ('
                                                                                     || nm_translated_w
                                                                                     || ')',
                                                                                    1,
                                                                                    200);

                                    ELSE
                                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w, 1, 200);
                                    END IF;
                                ELSIF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                                    person_name_dev_r.nm_pessoa_fisica := substr(nm_social_w
                                                                                 || ' ('
                                                                                 || nm_pessoa_fisica_w
                                                                                 || ')',
                                                                                1,
                                                                                200);
                                ELSE
                                    person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                END IF;

                                RETURN NEXT  person_name_dev_r;
                            END LOOP;

                            CLOSE c05;
                        ELSE
                            OPEN c01;
                            LOOP
                                FETCH c01 INTO
                                    cd_pessoa_fisica_w,
                                    nm_pessoa_fisica_w,
                                    nm_translated_w;
                                EXIT WHEN NOT FOUND; /* apply on c01 */
                                person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                                IF ( ds_locale_w = 'ja_JP' ) THEN
                                    IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                     || ' ('
                                                                                     || nm_translated_w
                                                                                     || ')',
                                                                                    1,
                                                                                    200);

                                    ELSE
                                        person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w, 1, 200);
                                    END IF;
                                ELSE
                                    person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                END IF;

                                RETURN NEXT  person_name_dev_r;
                            END LOOP;

                            CLOSE c01;
                        END IF;

                    ELSE
                        BEGIN
                            IF ( ds_filter_name_w = 'both' ) THEN
                                OPEN c06;
                                LOOP
                                    FETCH c06 INTO
                                        cd_pessoa_fisica_w,
                                        nm_social_w,
                                        nm_pessoa_fisica_w,
                                        nm_translated_w;
                                    EXIT WHEN NOT FOUND; /* apply on c06 */
                                    person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                                    IF ( ds_locale_w = 'ja_JP' ) THEN
                                        IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                            person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                         || ' ('
                                                                                         || nm_translated_w
                                                                                         || ')',
                                                                                        1,
                                                                                        200);

                                        ELSIF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                                            person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                         || ' ('
                                                                                         || nm_social_w
                                                                                         || ')',
                                                                                        1,
                                                                                        200);
                                        ELSE
                                            person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                        END IF;
                                    ELSE
                                        IF ( ds_se_nome_social_w = 'S' ) THEN
                                            person_name_dev_r.nm_pessoa_fisica := coalesce(nm_social_w, nm_pessoa_fisica_w);
                                        ELSIF ( ds_se_nome_social_w = 'T' ) THEN
                                            IF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                                                person_name_dev_r.nm_pessoa_fisica := substr(nm_social_w
                                                                                             || ' ('
                                                                                             || nm_pessoa_fisica_w
                                                                                             || ')',
                                                                                            1,
                                                                                            200);

                                            ELSE
                                                person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                            END IF;
                                        ELSE
                                            person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                        END IF;
                                    END IF;

                                    RETURN NEXT  person_name_dev_r;
                                END LOOP;

                                CLOSE c06;
                            ELSIF (
                                ds_se_nome_social_w = 'S'
                                AND ds_filter_name_w <> 'translated'
                            ) THEN
                                IF ( coalesce(nm_filter_p::text, '') = '' ) THEN
                                    RETURN;
                                END IF;
                                OPEN c02;
                                LOOP
                                    FETCH c02 INTO
                                        person_name_dev_r.cd_pessoa_fisica,
                                        person_name_dev_r.nm_pessoa_fisica,
                                        nm_translated_w;
                                    EXIT WHEN NOT FOUND; /* apply on c02 */
                                    IF ( ds_locale_w = 'ja_JP' ) THEN
                                        IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                            person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                         || ' ('
                                                                                         || nm_translated_w
                                                                                         || ')',
                                                                                        1,
                                                                                        200);

                                        ELSE
                                            person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                        END IF;
                                    END IF;

                                    RETURN NEXT  person_name_dev_r;
                                END LOOP;

                                CLOSE c02;
                            ELSIF (
                                ds_se_nome_social_w = 'T'
                                AND ds_filter_name_w <> 'translated'
                            ) THEN
                                BEGIN
                                    OPEN c04;
                                    LOOP
                                        FETCH c04 INTO
                                            cd_pessoa_fisica_w,
                                            nm_social_w,
                                            nm_pessoa_fisica_w,
                                            nm_translated_w;
                                        EXIT WHEN NOT FOUND; /* apply on c04 */
                                        person_name_dev_r.cd_pessoa_fisica := cd_pessoa_fisica_w;
                                        IF ( ds_locale_w = 'ja_JP' ) THEN
                                            IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                                person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                             || ' ('
                                                                                             || nm_translated_w
                                                                                             || ')',
                                                                                            1,
                                                                                            200);

                                            ELSIF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                                                person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                             || ' ('
                                                                                             || nm_social_w
                                                                                             || ')',
                                                                                            1,
                                                                                            200);
                                            ELSE
                                                person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                            END IF;
                                        ELSE
                                            IF (nm_social_w IS NOT NULL AND nm_social_w::text <> '') THEN
                                                person_name_dev_r.nm_pessoa_fisica := substr(nm_social_w
                                                                                             || ' ('
                                                                                             || nm_pessoa_fisica_w
                                                                                             || ')',
                                                                                            1,
                                                                                            200);

                                            ELSE
                                                person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                            END IF;
                                        END IF;

                                        RETURN NEXT  person_name_dev_r;
                                    END LOOP;

                                    CLOSE c04;
                                END;
                            ELSE
                                nm_filtro_validacao_w := replace(replace(nm_filtro_w, '%', ''), ' ', '');

                                IF ( coalesce(length(nm_filtro_validacao_w), 0) <= 2 ) THEN
                                    RETURN;
                                END IF;

                                IF ( ds_filter_name_p = 'translated' ) THEN
                                    OPEN c07;
                                    LOOP
                                        FETCH c07 INTO
                                            person_name_dev_r.cd_pessoa_fisica,
                                            nm_pessoa_fisica_w,
                                            nm_translated_w;
                                        EXIT WHEN NOT FOUND; /* apply on c07 */
                                        person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                        IF ( ds_locale_w = 'ja_JP' ) THEN
                                            IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                                person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                             || ' ('
                                                                                             || nm_translated_w
                                                                                             || ')',
                                                                                            1,
                                                                                            200);

                                            END IF;
                                        END IF;

                                        RETURN NEXT  person_name_dev_r;
                                    END LOOP;

                                    CLOSE c07;
                                ELSE
                                    OPEN c03;
                                    LOOP
                                        FETCH c03 INTO
                                            person_name_dev_r.cd_pessoa_fisica,
                                            nm_pessoa_fisica_w,
                                            nm_translated_w;
                                        EXIT WHEN NOT FOUND; /* apply on c03 */
                                        person_name_dev_r.nm_pessoa_fisica := nm_pessoa_fisica_w;
                                        IF ( ds_locale_w = 'ja_JP' ) THEN
                                            IF (nm_translated_w IS NOT NULL AND nm_translated_w::text <> '') THEN
                                                person_name_dev_r.nm_pessoa_fisica := substr(nm_pessoa_fisica_w
                                                                                             || ' ('
                                                                                             || nm_translated_w
                                                                                             || ')',
                                                                                            1,
                                                                                            200);

                                            END IF;
                                        END IF;

                                        RETURN NEXT  person_name_dev_r;
                                    END LOOP;

                                    CLOSE c03;
                                END IF;

                            END IF;

                        END;
                    END IF;

                END;

            ELSE
                RETURN;
            END IF;

        END;
    END IF;

END;
$BODY$;

ALTER FUNCTION public.search_names_dev(text, text, bigint, text, text, smallint, text)
    OWNER TO postgres;

