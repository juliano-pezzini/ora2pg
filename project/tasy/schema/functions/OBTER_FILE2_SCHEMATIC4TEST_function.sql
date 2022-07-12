-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_file2_schematic4test (NR_SEQ_SCHEDULE_P bigint, NR_SEQ_SCRIPT_P bigint) RETURNS varchar AS $body$
DECLARE


ARQUIVO_W	varchar(4000);


BEGIN
-- function that return address of .html
IF (NR_SEQ_SCHEDULE_P IS NOT NULL AND NR_SEQ_SCHEDULE_P::text <> '') THEN
          SELECT ATTACH.DS_ARQUIVO
             INTO STRICT ARQUIVO_W
          FROM SCHEM_TEST_SCHEDULE_ATTACH ATTACH
          WHERE ATTACH.NR_SEQ_SCHEDULE = (SELECT DS_RETEST FROM SCHEM_TEST_SCHEDULE WHERE NR_SEQUENCIA = NR_SEQ_SCHEDULE_P)
          AND ATTACH.NR_SEQ_SCRIPT = NR_SEQ_SCRIPT_P
          AND ATTACH.IE_TIPO_ANEXO LIKE 'html' 
          AND ATTACH.NR_SEQUENCIA = (SELECT MAX(NR_SEQUENCIA) 
                                    FROM  SCHEM_TEST_SCHEDULE_ATTACH 
                                    WHERE NR_SEQ_SCHEDULE = (SELECT DS_RETEST FROM SCHEM_TEST_SCHEDULE WHERE NR_SEQUENCIA = NR_SEQ_SCHEDULE_P) 
                                    AND NR_SEQ_SCRIPT = NR_SEQ_SCRIPT_P
                                    AND IE_TIPO_ANEXO LIKE 'html');
END IF;

RETURN ARQUIVO_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_file2_schematic4test (NR_SEQ_SCHEDULE_P bigint, NR_SEQ_SCRIPT_P bigint) FROM PUBLIC;

