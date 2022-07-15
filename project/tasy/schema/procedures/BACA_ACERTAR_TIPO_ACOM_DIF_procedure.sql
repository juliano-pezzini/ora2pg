-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acertar_tipo_acom_dif (nm_usuario_p text) AS $body$
DECLARE



qt_registros_w		bigint;


BEGIN

select 	count(*)
into STRICT	qt_registros_w
from 	user_cons_columns
where 	constraint_name = 'TIPACDI_UK';

if (qt_registros_w < 6) then

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE TIPO_ACOMOD_DIFERENCA DROP CONSTRAINT TIPACDI_UK ');

	CALL Exec_sql_Dinamico('Ricardo',' DROP index TIPACDI_UK ');

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE TIPO_ACOMOD_DIFERENCA ADD
		(
		      CONSTRAINT TIPACDI_UK Unique  (
		               	CD_TIPO_ACOMODACAO,
		               	CD_CONVENIO,
		               	CD_TIPO_ACOMOD_DIF,
				IE_CALCULO_DIFERENCA,
				cd_procedimento,
				ie_origem_proced)
		USING INDEX   Tablespace TASY_INDEX) ');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acertar_tipo_acom_dif (nm_usuario_p text) FROM PUBLIC;

