-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_rep_regra_convenio_mat ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


/* Campos da tabela LOOP */

cd_convenio_w			integer;
ie_tipo_atendimento_w		smallint;
ie_permite_w			varchar(1);
ie_justificativa_w			varchar(1);

/*  Sequencia da tabela */

nr_sequencia_w			bigint;

C01 CURSOR FOR
	SELECT	cd_convenio,
	        	ie_tipo_atendimento,
	        	ie_permite,
	        	ie_justificativa
	from	rep_regra_convenio_mat
	where	cd_material = cd_material_p;


BEGIN

open C01;
loop
fetch C01 into
	cd_convenio_w,
	ie_tipo_atendimento_w,
	ie_permite_w,
	ie_justificativa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('rep_regra_convenio_mat_seq')
	into STRICT	nr_sequencia_w
	;

	insert into rep_regra_convenio_mat(	nr_sequencia,
					cd_material,
					dt_atualizacao,
					nm_usuario,
					cd_convenio,
					ie_tipo_atendimento,
					ie_permite,
					ie_justificativa
					)
		values (	nr_sequencia_w,
					cd_material_novo_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_convenio_w,
					ie_tipo_atendimento_w,
					ie_permite_w,
					ie_justificativa_w
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
-- REVOKE ALL ON PROCEDURE copia_rep_regra_convenio_mat ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_material_novo_p bigint, nm_usuario_p text) FROM PUBLIC;

