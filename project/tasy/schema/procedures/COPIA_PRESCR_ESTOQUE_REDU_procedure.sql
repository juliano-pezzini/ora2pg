-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_prescr_estoque_redu ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Campos da tabela LOOP */

cd_local_estoque_w		bigint;
qt_dose_w                 		double precision;
cd_material_substituir_w  		integer;

/*  Sequencia da tabela */

nr_sequencia_w			bigint;

C01 CURSOR FOR
	SELECT	cd_local_estoque,
		qt_dose,
		cd_material_substituir
	from	prescr_estoque_redu
	where	cd_material = cd_material_p;


BEGIN

open C01;
loop
fetch C01 into
	cd_local_estoque_w,
	qt_dose_w,
	cd_material_substituir_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('prescr_estoque_redu_seq')
	into STRICT	nr_sequencia_w
	;

	insert into prescr_estoque_redu(	nr_sequencia,
					cd_material,
					dt_atualizacao,
					nm_usuario,
					cd_local_estoque,
					qt_dose,
					cd_material_substituir
					)
		values (	nr_sequencia_w,
					cd_material_novo_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_local_estoque_w,
					qt_dose_w,
					cd_material_substituir_w
					);

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_prescr_estoque_redu ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) FROM PUBLIC;
