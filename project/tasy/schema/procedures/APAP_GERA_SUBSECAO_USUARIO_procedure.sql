-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apap_gera_subsecao_usuario () AS $body$
DECLARE


TYPE APAP_LOCALIZADOR_SUBSECAO_T        IS TABLE OF w_apap_localizador%ROWTYPE         index by integer;
APAP_LOCALIZADOR_SUBSECAO_R             APAP_LOCALIZADOR_SUBSECAO_T;
sql_errm_w	varchar(2000);

BEGIN
delete
from 	w_apap_localizador 
where 	nm_usuario = wheb_usuario_pck.get_nm_usuario;
commit;

begin
SELECT 	* BULK COLLECT
INTO STRICT 	APAP_LOCALIZADOR_SUBSECAO_R
FROM 	table(localizador_subsecao_pck.get_estrutura(null,null,null));

IF (APAP_LOCALIZADOR_SUBSECAO_R.FIRST IS NOT NULL AND APAP_LOCALIZADOR_SUBSECAO_R.FIRST::text <> '') THEN
	FORALL i IN APAP_LOCALIZADOR_SUBSECAO_R.FIRST .. APAP_LOCALIZADOR_SUBSECAO_R.LAST  
	INSERT INTO w_apap_localizador VALUES APAP_LOCALIZADOR_SUBSECAO_R(i);
END IF;

exception
when unique_violation then sql_errm_w := sqlerrm;
when Others then sql_errm_w := sqlerrm;
end;


commit;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apap_gera_subsecao_usuario () FROM PUBLIC;

