-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajuste_lic_doc_padrao () AS $body$
DECLARE


qt_existe_w		integer;


BEGIN

select	count(*)
into STRICT	qt_existe_w
from	lic_documentacao_padrao
where	(ds_texto IS NOT NULL AND ds_texto::text <> '');

CALL Exec_Sql_Dinamico('Juan',' ALTER TABLE LIC_DOCUMENTACAO_PADRAO ADD DS_TEXTO_VAR LONG ');

if (qt_existe_w = 0) then
	CALL Exec_Sql_Dinamico('Juan',' UPDATE LIC_DOCUMENTACAO_PADRAO SET DS_TEXTO_VAR = DS_TEXTO ');
end if;

CALL Exec_Sql_Dinamico('Juan',' ALTER TABLE LIC_DOCUMENTACAO_PADRAO DROP COLUMN DS_TEXTO ');
CALL Exec_Sql_Dinamico('Juan',' ALTER TABLE LIC_DOCUMENTACAO_PADRAO RENAME COLUMN DS_TEXTO_VAR TO DS_TEXTO ');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajuste_lic_doc_padrao () FROM PUBLIC;
