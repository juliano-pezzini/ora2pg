-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_acertar_medic_brasindice (nm_usuario_p text) AS $body$
DECLARE



qt_registros_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	material_brasindice
where	coalesce(nr_sequencia::text, '') = '';

if (qt_registros_w > 0) then
	begin

	update	material_brasindice
	set	nr_sequencia	= nextval('material_brasindice_seq')
	where	nr_sequencia is  null;

	CALL Exec_sql_Dinamico('Ricardo',' alter table material_brasindice modify (nr_sequencia NOT NULL) ');

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE MATERIAL_BRASINDICE DROP CONSTRAINT MATBRAS_PK ');

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE MATERIAL_BRASINDICE ADD
		(CONSTRAINT MATBRAS_PK Primary Key  (NR_SEQUENCIA)
		USING INDEX   Tablespace TASY_INDEX) ');

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE MATERIAL_BRASINDICE ADD
		(
		      CONSTRAINT MATBRAS_UK Unique (
		               CD_LABORATORIO,
		               CD_MEDICAMENTO,
		               CD_APRESENTACAO,
		               CD_MATERIAL,
		               IE_PRIORIDADE,
		               CD_CONVENIO,
			       CD_ESTABELECIMENTO)
		USING INDEX   Tablespace TASY_INDEX) ');

	end;
end if;

select 	count(*)
into STRICT	qt_registros_w
from 	user_cons_columns
where 	constraint_name = 'MATBRAS_UK';

if (qt_registros_w < 7) then

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE MATERIAL_BRASINDICE DROP CONSTRAINT MATBRAS_UK ');

	CALL Exec_sql_Dinamico('Ricardo',' ALTER TABLE MATERIAL_BRASINDICE ADD
		(
		      CONSTRAINT MATBRAS_UK Unique  (
		               CD_LABORATORIO,
		               CD_MEDICAMENTO,
		               CD_APRESENTACAO,
		               CD_MATERIAL,
		               IE_PRIORIDADE,
		               CD_CONVENIO,
			       CD_ESTABELECIMENTO)
		USING INDEX   Tablespace TASY_INDEX) ');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_acertar_medic_brasindice (nm_usuario_p text) FROM PUBLIC;

