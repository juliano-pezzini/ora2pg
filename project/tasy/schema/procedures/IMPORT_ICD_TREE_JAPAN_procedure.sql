-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE import_icd_tree_japan () AS $body$
DECLARE


    is_chapter       bigint;
    is_category      bigint;
    is_code          bigint;
    is_cid_version   bigint;

	 -- define weak REF CURSOR type
	cCursor REFCURSOR; -- declare cursor variable
	v_stmt_str      varchar(4000);

	cd_especialidade_cid_w varchar(50);
	cd_categoria_cid_w varchar(50);
	cd_doenca_cid_w varchar(50);
	ds_doenca_cid_w varchar(255);
	nm_usuario_w 		cid_especialidade.NM_USUARIO%TYPE;


BEGIN
	nm_usuario_w := coalesce(WHEB_USUARIO_PCK.get_nm_usuario(), 'TasyLoads');

	v_stmt_str := 'SELECT cd_especialidade_cid, cd_categoria_cid, cd_doenca_cid, ds_doenca_cid FROM icd_tree_jpn
					WHERE cd_especialidade_cid IS NOT NULL AND cd_categoria_cid IS NOT NULL AND cd_doenca_cid IS NOT NULL
					AND LENGTH(cd_especialidade_cid) <= 10 AND LENGTH(cd_categoria_cid) <= 10 AND LENGTH(cd_doenca_cid) <= 10';

	OPEN cCursor FOR EXECUTE v_stmt_str;

	LOOP
		FETCH cCursor INTO cd_especialidade_cid_w, cd_categoria_cid_w, cd_doenca_cid_w, ds_doenca_cid_w;
		EXIT WHEN NOT FOUND; /* apply on cCursor */

		IF ( cd_especialidade_cid_w = '-' ) THEN
			cd_especialidade_cid_w := '999';
		END IF;

		IF ( cd_categoria_cid_w = '-' ) THEN
			cd_categoria_cid_w := 'ZZZ999.999';
		END IF;

        cd_doenca_cid_w := replace(cd_doenca_cid_w, '.', '');
        ds_doenca_cid_w := SUBSTR(ds_doenca_cid_w,1, 240);

        IF (coalesce(ds_doenca_cid_w::text, '') = '') then
          ds_doenca_cid_w := cd_doenca_cid_w;
        end if;

		BEGIN
			SELECT
				COUNT(*)
			INTO STRICT is_chapter
			FROM
				cid_especialidade
			WHERE
				cd_especialidade_cid = cd_especialidade_cid_w;
			IF ( is_chapter = 0 OR coalesce(is_chapter::text, '') = '' ) THEN
				BEGIN
					INSERT INTO cid_especialidade(
						cd_especialidade_cid,
						ds_especialidade_cid,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_situacao
					) VALUES (
						cd_especialidade_cid_w,
						cd_especialidade_cid_w,
						clock_timestamp(),
						nm_usuario_w,
						clock_timestamp(),
						nm_usuario_w,
						'A'
					);

				END;

			ELSE
				BEGIN
					UPDATE cid_especialidade
					SET
						dt_atualizacao = clock_timestamp(),
						nm_usuario = nm_usuario_w,
						ie_situacao = 'A'
					WHERE
						cd_especialidade_cid = cd_especialidade_cid_w;

				END;
			END IF;

            SELECT
                COUNT(*)
            INTO STRICT is_category
            FROM
                cid_categoria
            WHERE
                cd_categoria_cid = cd_categoria_cid_w;
            IF ( is_category = 0 OR coalesce(is_category::text, '') = '' ) THEN
                BEGIN
                    INSERT INTO cid_categoria(
                        cd_categoria_cid,
                        ds_categoria_cid,
                        dt_atualizacao,
                        nm_usuario,
                        cd_especialidade,
                        ie_situacao,
                        dt_atualizacao_nrec,
                        nm_usuario_nrec
                    ) VALUES (
                        cd_categoria_cid_w,
                        cd_categoria_cid_w,
                        clock_timestamp(),
                        nm_usuario_w,
                        cd_especialidade_cid_w,
                        'A',
                        clock_timestamp(),
                        nm_usuario_w
                    );

                END;
            ELSE
                BEGIN
                    UPDATE cid_categoria
                    SET
                        dt_atualizacao = clock_timestamp(),
                        nm_usuario = nm_usuario_w,
                        cd_especialidade = cd_especialidade_cid_w,
                        ie_situacao = 'A'
                    WHERE
                        cd_categoria_cid = cd_categoria_cid_w;

                END;
            END IF;

                SELECT
                    COUNT(*)
                INTO STRICT is_code
                FROM
                    cid_doenca
                WHERE
                    cd_doenca_cid = cd_doenca_cid_w;

                IF ( is_code = 0 OR coalesce(is_code::text, '') = '' ) THEN
                    BEGIN
                        INSERT INTO cid_doenca(
                            cd_doenca_cid,
                            ds_doenca_cid,
                            cd_categoria_cid,
                            dt_atualizacao,
                            nm_usuario,
                            ie_cad_interno,
                            ie_situacao,
                            cd_versao,
                            cd_doenca,
                            ds_descricao_original,
                            dt_atualizacao_nrec,
                            nm_usuario_nrec
                        ) VALUES (
                            cd_doenca_cid_w,
                            ds_doenca_cid_w,
                            cd_categoria_cid_w,
                            clock_timestamp(),
                            nm_usuario_w,
                            'N',
                            'A',
                            'ICD-10',
                            cd_doenca_cid_w,
                            ds_doenca_cid_w,
                            clock_timestamp(),
                            nm_usuario_w
                        );

                    END;
                ELSE
                    BEGIN
                        UPDATE cid_doenca
                        SET
                            ds_doenca_cid = ds_doenca_cid_w,
                            cd_categoria_cid = cd_categoria_cid_w,
                            dt_atualizacao = clock_timestamp(),
                            nm_usuario = nm_usuario_w,
                            ie_cad_interno = 'N',
                            ie_situacao = 'A',
                            cd_versao = 'ICD - 10',
                            cd_doenca = cd_doenca_cid_w,
                            ds_descricao_original = cd_categoria_cid_w
                        WHERE
                            cd_doenca_cid = cd_doenca_cid_w;

                    END;
                END IF;

                IF (cd_doenca_cid_w IS NOT NULL AND cd_doenca_cid_w::text <> '') THEN
                    BEGIN
                        UPDATE cid_doenca_versao
                        SET
                            dt_vigencia_final = clock_timestamp()
                        WHERE
                            cd_doenca_cid = cd_doenca_cid_w
                            AND coalesce(dt_vigencia_final::text, '') = ''
                            AND (dt_vigencia_inicial IS NOT NULL AND dt_vigencia_inicial::text <> '');

                        SELECT
                            COUNT(*)
                        INTO STRICT is_cid_version
                        FROM
                            cid_doenca_versao
                        WHERE
                            cd_doenca_cid = cd_doenca_cid_w
                            and coalesce(dt_vigencia_final::text, '') = '';

                        IF ( is_cid_version = 0 OR coalesce(is_cid_version::text, '') = '' ) THEN
                            INSERT INTO cid_doenca_versao(
                                nr_sequencia,
                                dt_atualizacao,
                                nm_usuario,
                                dt_atualizacao_nrec,
                                nm_usuario_nrec,
                                cd_doenca_cid,
                                dt_versao,
                                dt_vigencia_inicial,
                                dt_vigencia_final,
                                cd_versao
                            ) VALUES (
                                nextval('cid_doenca_versao_seq'),
                                clock_timestamp(),
                                nm_usuario_w,
                                clock_timestamp(),
                                nm_usuario_w,
                                cd_doenca_cid_w,
                                clock_timestamp(),
                                clock_timestamp(),
                                NULL,
                                NULL
                            );

                        END IF;

                    END;
                END IF;

            END;

	END LOOP;

    COMMIT;

	CLOSE cCursor;

    EXECUTE 'truncate table TASY.icd_tree_jpn';
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error occurred while importing ICD Tree:%-%', SQLSTATE, substr(sqlerrm, 1, 64);
      raise;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_icd_tree_japan () FROM PUBLIC;

