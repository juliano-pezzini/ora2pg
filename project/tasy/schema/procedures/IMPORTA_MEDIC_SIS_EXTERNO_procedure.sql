-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importa_medic_sis_externo (cd_codigo_p text, ds_medic_p text, ie_tipo_p text) AS $body$
DECLARE


/* Tipo:
ABCFarma: ABC
*/
nr_sequencia_w		bigint;
qt_registro_w		bigint;


BEGIN

select 	nextval('material_sistema_externo_seq')
into STRICT	nr_sequencia_w
;

select 	count(*)
into STRICT	qt_registro_w
from	material_sistema_externo
where	cd_codigo = cd_codigo_p
and	ie_sistema = ie_tipo_p;

if (ie_tipo_p = 'ABC') and (qt_registro_w = 0) then
	begin
	insert into MATERIAL_SISTEMA_EXTERNO(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		ie_sistema,
		cd_material,
		cd_codigo,
		cd_referencia) values (nr_sequencia_w,
					clock_timestamp(),
					'IMPORTACAO',
					clock_timestamp(),
					'IMPORTACAO',
					'ABC',
					null,
					cd_codigo_p,
					ds_medic_p);

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importa_medic_sis_externo (cd_codigo_p text, ds_medic_p text, ie_tipo_p text) FROM PUBLIC;
