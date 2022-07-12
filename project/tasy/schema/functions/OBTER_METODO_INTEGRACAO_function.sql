-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_metodo_integracao ( cd_metodo_p metodo_exame_lab.cd_integracao%TYPE, nr_seq_exame_p exame_lab_metodo.nr_seq_exame%TYPE ) RETURNS varchar AS $body$
DECLARE

    nr_seq_metodo_w metodo_exame_lab.nr_sequencia%TYPE := NULL;

BEGIN
    IF ( coalesce(cd_metodo_p::text, '') = '' ) OR ( coalesce(nr_seq_exame_p::text, '') = '' ) THEN
        CALL wheb_mensagem_pck.exibir_mensagem_abort(
            ds_mensagem_erro_p => 'Parameters cd_metodo_p and nr_seq_exame_p is required'
        );
    END IF;

    BEGIN
        
        SELECT
            nr_seq
        INTO STRICT
            nr_seq_metodo_w
        FROM (
                SELECT
                    a.nr_sequencia nr_seq
                FROM
                    metodo_exame_lab   a
                    INNER JOIN exame_lab_metodo   b ON a.nr_sequencia = b.nr_seq_metodo
                WHERE
                    b.nr_seq_exame = nr_seq_exame_p
                    AND a.ie_situacao = 'A'
                    AND a.cd_integracao = cd_metodo_p
                ORDER BY
                    ie_prioridade
            ) alias0 LIMIT 1;

    EXCEPTION
        WHEN no_data_found THEN
            IF ( coalesce(nr_seq_metodo_w::text, '') = '' ) THEN
                BEGIN

                    SELECT
                        nr_sequencia nr_seq
                    INTO STRICT
                        nr_seq_metodo_w
                    FROM
                        metodo_exame_lab
                    WHERE
                        ie_situacao = 'A'
                        AND cd_integracao = cd_metodo_p  LIMIT 1;

                EXCEPTION
                    WHEN no_data_found THEN
                        nr_seq_metodo_w := NULL;
                END;

            END IF;
    END;

    RETURN nr_seq_metodo_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_metodo_integracao ( cd_metodo_p metodo_exame_lab.cd_integracao%TYPE, nr_seq_exame_p exame_lab_metodo.nr_seq_exame%TYPE ) FROM PUBLIC;
