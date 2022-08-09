-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_orient_notas_link_actions ( ie_action_p text, nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE, nr_seq_orient_pad_not_p nut_orient_padrao_notas.nr_sequencia%TYPE default null, ds_orientacao_p nut_orientacao.ds_orientacao%TYPE default null, nm_usuario_p text default wheb_usuario_pck.get_nm_usuario) AS $body$
DECLARE

/*
ie_action_p:
C (Check - Insert)
U (Uncheck - Delete)
O (OK - Delete all)
R (reload all)
*/
    nr_sequencia_w              nut_orient_pad_not_linkage.nr_sequencia%TYPE;
    nr_seq_orient_pad_not_w     nut_orient_padrao_notas.nr_sequencia%TYPE;
    ds_texto_adicional_label_w  varchar(200) := obter_desc_expressao(299345);
    ie_texto_adicional_w        smallint;WITH RECURSIVE cte AS (


    c_titulos CURSOR FOR
    SELECT regexp_substr(ds_orientacao_p,'[^;]+', 1, level) ds_titulo  
    (regexp_substr(ds_orientacao_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(ds_orientacao_p, '[^;]+', 1, level))::text <> '')  UNION ALL

    
    c_titulos CURSOR FOR
    SELECT regexp_substr(ds_orientacao_p,'[^;]+', 1, level) ds_titulo  
    (regexp_substr(ds_orientacao_p, '[^;]+', 1, level) IS NOT NULL AND (regexp_substr(ds_orientacao_p, '[^;]+', 1, level))::text <> '') JOIN cte c ON ()

) SELECT * FROM cte;
;

BEGIN
    SELECT
        nextval('nut_orient_pad_not_linkage_seq')
    INTO STRICT nr_sequencia_w
;

    CASE ie_action_p
        WHEN 'C' THEN
            INSERT INTO nut_orient_pad_not_linkage(
                nr_sequencia,
                nr_atendimento,
                nr_seq_orient_pad_not,
                ds_texto_adicional,
                nm_usuario_nrec,
                nm_usuario,
                dt_atualizacao_nrec,
                dt_atualizacao
            ) VALUES (
                nr_sequencia_w,
                nr_atendimento_p,
                nr_seq_orient_pad_not_p,
                NULL,
                nm_usuario_p,
                nm_usuario_p,
                clock_timestamp(),
                clock_timestamp());

        WHEN 'U' THEN
            DELETE FROM nut_orient_pad_not_linkage
            WHERE
                nr_atendimento = nr_atendimento_p
                AND nr_seq_orient_pad_not = nr_seq_orient_pad_not_p;

        WHEN 'O' THEN
            DELETE FROM nut_orient_pad_not_linkage
            WHERE
                nr_atendimento = nr_atendimento_p;

        WHEN 'R' THEN
            DELETE FROM nut_orient_pad_not_linkage
            WHERE
                nr_atendimento = nr_atendimento_p;
            BEGIN
              FOR c_titulos_row IN c_titulos
              LOOP
                IF ((c_titulos_row.ds_titulo IS NOT NULL AND c_titulos_row.ds_titulo::text <> '') OR c_titulos_row.ds_titulo <> '') THEN
                    select position(ds_texto_adicional_label_w in c_titulos_row.ds_titulo)
                    into STRICT ie_texto_adicional_w 
;

                    IF ie_texto_adicional_w = 1 THEN
                        UPDATE nut_orient_pad_not_linkage SET
                            ds_texto_adicional = SUBSTR(replace(c_titulos_row.ds_titulo, ds_texto_adicional_label_w, ''),3)
                        WHERE nr_sequencia = nr_sequencia_w;

                    ELSE                    
                        SELECT
                            nextval('nut_orient_pad_not_linkage_seq')
                        INTO STRICT nr_sequencia_w
;

                        SELECT
                            MAX(nr_sequencia)
                        INTO STRICT nr_seq_orient_pad_not_w
                        FROM
                            nut_orient_padrao_notas
                        WHERE
                            ds_titulo = c_titulos_row.ds_titulo;

                        INSERT INTO nut_orient_pad_not_linkage(
                            nr_sequencia,
                            nr_atendimento,
                            nr_seq_orient_pad_not,
                            ds_texto_adicional,
                            nm_usuario_nrec,
                            nm_usuario,
                            dt_atualizacao_nrec,
                            dt_atualizacao
                        ) VALUES (
                            nr_sequencia_w,
                            nr_atendimento_p,
                            nr_seq_orient_pad_not_w,
                            NULL,
                            nm_usuario_p,
                            nm_usuario_p,
                            clock_timestamp(),
                            clock_timestamp());
                    END IF;
                END IF;
              END LOOP;
            END;

    END CASE;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_orient_notas_link_actions ( ie_action_p text, nr_atendimento_p atendimento_paciente.nr_atendimento%TYPE, nr_seq_orient_pad_not_p nut_orient_padrao_notas.nr_sequencia%TYPE default null, ds_orientacao_p nut_orientacao.ds_orientacao%TYPE default null, nm_usuario_p text default wheb_usuario_pck.get_nm_usuario) FROM PUBLIC;
