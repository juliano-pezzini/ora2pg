-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_inserir_medic_padrao (cd_medico_p text, ds_material_p text, ds_generico_p text, ds_apresentacao_p text, ds_posologia_p text, ds_via_aplic_p text, ds_laboratorio_p text, ds_contra_ind_p text, ds_efeito_p text, ds_indicacao_p text, nm_usuario_p text) AS $body$
DECLARE



nr_seq_grupo_medic_w		bigint;
nr_seq_medicamento_w		bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_grupo_medic_w
from	med_grupo_medic
where	cd_medico		= cd_medico_p
and	upper(ds_grupo_medic)	= 'IMPORTADO';

if (nr_seq_grupo_medic_w = 0) then
	begin

	select	nextval('med_grupo_medic_seq')
	into STRICT	nr_seq_grupo_medic_w
	;


	insert into med_grupo_medic(nr_sequencia,
		ds_grupo_medic,
		cd_medico,
		dt_atualizacao,
		nm_usuario,
		ie_situacao)
	values (nr_seq_grupo_medic_w,
		'Importado',
		cd_medico_p,
		clock_timestamp(),
		nm_usuario_p,
		'A');

	end;
end if;


select	nextval('med_medic_padrao_seq')
into STRICT	nr_seq_medicamento_w
;


insert	into med_medic_padrao(nr_sequencia,
	ds_material,
	dt_atualizacao,
	nm_usuario,
	ds_posologia,
	cd_medico,
	nr_seq_grupo_medic,
	ds_generico,
	ds_forma_apres,
	ds_contra_indicacao,
	ds_efeito,
	ds_indicacao,
	ds_laboratorio,
	ds_observacao,
	ie_situacao)
values (nr_seq_medicamento_w,
	substr(ds_material_p,1,100),
	clock_timestamp(),
	nm_usuario_p,
	substr(ds_posologia_p,1,1800),
	cd_medico_p,
	nr_seq_grupo_medic_w,
	substr(ds_generico_p,1,100),
	substr(ds_apresentacao_p,1,255),
	substr(ds_contra_ind_p,1,255),
	substr(ds_efeito_p,1,255),
	substr(ds_indicacao_p,1,255),
	substr(ds_laboratorio_p,1,40),
	substr(ds_via_aplic_p,1,255),
	'A');

commit;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_inserir_medic_padrao (cd_medico_p text, ds_material_p text, ds_generico_p text, ds_apresentacao_p text, ds_posologia_p text, ds_via_aplic_p text, ds_laboratorio_p text, ds_contra_ind_p text, ds_efeito_p text, ds_indicacao_p text, nm_usuario_p text) FROM PUBLIC;

