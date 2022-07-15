-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cih_duplicar_microorganismo ( cd_microorganismo_p bigint, nm_usuario_p text, cd_novo_microorganismo_p INOUT bigint) AS $body$
DECLARE

ie_existe_w			varchar(1);

cd_microorganismo_w		bigint;
ds_microorganismo_w		varchar(255);
ie_situacao_w			varchar(1);
ds_microorganismo_integr_w	varchar(70);
nr_seq_grupo_w			bigint;
ie_isolamento_permanente_w	varchar(1);
nr_seq_apres_w			smallint;
ie_resultado_cultura_w		varchar(2);

cd_medicamento_w		bigint;
nr_seq_material_w		bigint;
nr_seq_grupo_micro_w		bigint;
cd_setor_atendimento_w		integer;

c01 CURSOR FOR
SELECT	cd_medicamento,
	nr_seq_material,
	nr_seq_grupo_micro,
	cd_setor_atendimento
from	cih_microorg_medic
where	cd_microorganismo = cd_microorganismo_p;


BEGIN

cd_novo_microorganismo_p := 0;

select	max(cd_microorganismo) + 1
into STRICT	cd_microorganismo_w
from	cih_microorganismo;

select 	'S',
	substr(Obter_Desc_Expressao(303214) || ds_microorganismo,1,255),
	ie_situacao,
	ds_microorganismo_integr,
	nr_seq_grupo,
	ie_isolamento_permanente,
	nr_seq_apres,
	ie_resultado_cultura
into STRICT	ie_existe_w,
	ds_microorganismo_w,
	ie_situacao_w,
	ds_microorganismo_integr_w,
	nr_seq_grupo_w,
	ie_isolamento_permanente_w,
	nr_seq_apres_w,
	ie_resultado_cultura_w
from	cih_microorganismo
where	cd_microorganismo = cd_microorganismo_p;

if ('S' = ie_existe_w AND cd_microorganismo_w > 0) then
	--Insere novo Microorganismo
	INSERT INTO cih_microorganismo(cd_microorganismo,
	ds_microorganismo,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_situacao,
	ds_microorganismo_integr,
	nr_seq_grupo,
	ie_isolamento_permanente,
	nr_seq_apres,
	ie_resultado_cultura
	)
	VALUES (cd_microorganismo_w,
	ds_microorganismo_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_situacao_w,
	ds_microorganismo_integr_w,
	nr_seq_grupo_w,
	ie_isolamento_permanente_w,
	nr_seq_apres_w,
	ie_resultado_cultura_w
	);

	--Insere Antibióticos
	open C01;
	loop
	fetch c01 into
		cd_medicamento_w,
		nr_seq_material_w,
		nr_seq_grupo_micro_w,
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		insert into cih_microorg_medic(cd_microorganismo,
			cd_medicamento,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_material,
			nr_seq_grupo_micro,
			cd_setor_atendimento
		) values (
			cd_microorganismo_w,
			cd_medicamento_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_material_w,
			nr_seq_grupo_micro_w,
			cd_setor_atendimento_w
		);
	end loop;
	close C01;

	commit;

	cd_novo_microorganismo_p := cd_microorganismo_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cih_duplicar_microorganismo ( cd_microorganismo_p bigint, nm_usuario_p text, cd_novo_microorganismo_p INOUT bigint) FROM PUBLIC;

