-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_encerrar_escalas_tratamento (cd_pessoa_fisica_p bigint) AS $body$
DECLARE


    c01 CURSOR(cd_pessoa_fisica_p text) FOR
        SELECT hed.nr_sequencia
          FROM hd_escala_dialise hed
         WHERE hed.cd_pessoa_fisica = cd_pessoa_fisica_p
           AND coalesce(hed.dt_fim::text, '') = '';

BEGIN
    FOR i IN c01(cd_pessoa_fisica_p => cd_pessoa_fisica_p) LOOP
        CALL hd_encerrar_escala_tratamento(nr_seq_escala_p => i.nr_sequencia);
    END LOOP;

    UPDATE hd_escala_dialise_dia a
       SET a.dt_fim_escala_dia = clock_timestamp()
     WHERE coalesce(a.dt_fim_escala_dia::text, '') = ''
       AND EXISTS (SELECT 1
              FROM hd_escala_dialise b
             WHERE b.nr_sequencia = a.nr_seq_escala
               AND b.cd_pessoa_fisica = cd_pessoa_fisica_p);
    COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_encerrar_escalas_tratamento (cd_pessoa_fisica_p bigint) FROM PUBLIC;
