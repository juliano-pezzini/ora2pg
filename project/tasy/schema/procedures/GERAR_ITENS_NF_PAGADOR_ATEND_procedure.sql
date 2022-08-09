-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_nf_pagador_atend ( nr_sequencia_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w		bigint;
cd_procedimento_w	bigint;
cd_material_w		bigint;
ie_origem_proced_w	bigint;

c01 CURSOR FOR
SELECT	cd_procedimento,
	ie_origem_proced,
	cd_material
from	parametro_nfs_lista
where	cd_estabelecimento = cd_estabelecimento_p
and	cd_convenio = cd_convenio_p
and	((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (cd_material IS NOT NULL AND cd_material::text <> ''));


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	parametro_nfs_lista
where	cd_estabelecimento = cd_estabelecimento_p
and	cd_convenio = cd_convenio_p
and	((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '') or (cd_material IS NOT NULL AND cd_material::text <> ''));

if (qt_registro_w > 0) then

	open C01;
	loop
	fetch C01 into
		cd_procedimento_w,
		ie_origem_proced_w,
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (cd_procedimento_w > 0) then
			cd_material_w := null;
		end if;

		insert into conta_paciente_nf_pag_item(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_registro,
			cd_procedimento,
			cd_material,
			qt_material,
			vl_unitario,
			vl_total_item,
			ie_origem_proced)
		values (	nextval('conta_paciente_nf_pag_item_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_p,
			cd_procedimento_w,
			cd_material_w,
			1,
			0,
			0,
			ie_origem_proced_w);
		end;
	end loop;
	close C01;

else

	select	cd_procedimento,
		ie_origem_proced
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w
	from	parametro_nfs
	where	cd_estabelecimento = cd_estabelecimento_p
	and	cd_convenio = cd_convenio_p;

	if (cd_procedimento_w > 0) then

		insert into conta_paciente_nf_pag_item(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_registro,
			cd_procedimento,
			cd_material,
			qt_material,
			vl_unitario,
			vl_total_item,
			ie_origem_proced)
		values (	nextval('conta_paciente_nf_pag_item_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_sequencia_p,
			cd_procedimento_w,
			null,
			1,
			0,
			0,
			ie_origem_proced_w);

	end if;

end if;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_nf_pagador_atend ( nr_sequencia_p bigint, cd_convenio_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
