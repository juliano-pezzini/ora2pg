-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_orientacao_exame_js ( nr_prescricao_p bigint, nr_seq_exame_p bigint, cd_material_exame_p text, nr_seq_material_p bigint, ie_opcao_p bigint, ie_pasta_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p:	0- Orientação -> Técnica
	1 - Orientação -> Usuário
	2 - Orientação -> Medicamento
	2 - orirntação ->  Paciente

ie_pasta_p: 0 -> Pendentes
	1 -> Outras

*/
ds_retorno_w			varchar(4000);
ds_orientacao_tecnica_w		varchar(4000);
ds_orientacao_usuario_w		varchar(4000);
ds_orientacao_medic_w		varchar(4000);
ie_tecnica_w			varchar(1);
ie_usuario_w			varchar(1);
ie_medicamento_w		varchar(1);
ie_paciente_w			varchar(1);


BEGIN

if (ie_opcao_p = 0) then
	ie_tecnica_w	 := 'S';
	ie_usuario_w	 := 'N';
	ie_medicamento_w := 'N';
elsif (ie_opcao_p = 1) then
	ie_tecnica_w	 := 'N';
	ie_usuario_w	 := 'S';
	ie_medicamento_w := 'N';
elsif (ie_opcao_p = 2) then
	ie_tecnica_w	 := 'N';
	ie_usuario_w	 := 'N';
	ie_medicamento_w := 'S';
elsif (ie_opcao_p = 3) then
	ie_tecnica_w	 := 'N';
	ie_usuario_w	 := 'N';
	ie_medicamento_w := 'N';
	ie_paciente_w	 := 'S';
end if;

if (ie_pasta_p = 'P') then

	ds_orientacao_tecnica_w := substr(obter_orientacao_exame_id_sexo(nr_seq_exame_p, nr_prescricao_p, cd_estabelecimento_p, ie_tecnica_w, ie_usuario_w, ie_medicamento_w, ie_paciente_w),1,4000);

	if (ie_opcao_p = 0) and (coalesce(ds_orientacao_tecnica_w::text, '') = '') then

		select 	max(substr(trim(both a.ds_orientacao_tecnica),1,4000))
		into STRICT	ds_orientacao_tecnica_w
		from   	exame_lab_material a,
			material_exame_lab b
		where  	a.nr_seq_material 	= b.nr_sequencia
		and    	a.nr_seq_exame 		= nr_seq_exame_p
		and    	b.cd_material_exame  	= cd_material_exame_p;
	end if;

elsif (ie_pasta_p = 'O') then

	ds_orientacao_tecnica_w := substr(obter_orientacao_exame_id_sexo(nr_seq_exame_p, nr_prescricao_p, cd_estabelecimento_p, ie_tecnica_w, ie_usuario_w, ie_medicamento_w, ie_paciente_w),1,4000);

	if (ie_opcao_p = 0) and (coalesce(ds_orientacao_tecnica_w::text, '') = '') then

		select	substr(trim(both a.ds_orientacao_tecnica),1,4000)
		into STRICT	ds_orientacao_tecnica_w
		from   	exame_lab_material a
		where  	a.nr_seq_material = nr_seq_material_p
		and    	a.nr_seq_exame = nr_seq_exame_p;

	end if;

end if;

ds_retorno_w := substr(ds_orientacao_tecnica_w,1,255);

if (coalesce(ds_orientacao_tecnica_w::text, '') = '') then

	select	max(substr(ds_orientacao_tecnica,1,4000)),
		max(substr(ds_orientacao_usuario,1,4000)),
		max(substr(ds_orientacao_medicamento,1,4000))
	into STRICT	ds_orientacao_tecnica_w	,
		ds_orientacao_usuario_w,
		ds_orientacao_medic_w
	from 	exame_laboratorio
	where 	nr_seq_exame = nr_seq_exame_p;

	if (ie_opcao_p = 0) then
		ds_retorno_w := ds_orientacao_tecnica_w;
	elsif (ie_opcao_p = 1) then
		ds_retorno_w := ds_orientacao_usuario_w;
	elsif (ie_opcao_p = 2) then
		ds_retorno_w := ds_orientacao_medic_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_orientacao_exame_js ( nr_prescricao_p bigint, nr_seq_exame_p bigint, cd_material_exame_p text, nr_seq_material_p bigint, ie_opcao_p bigint, ie_pasta_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

