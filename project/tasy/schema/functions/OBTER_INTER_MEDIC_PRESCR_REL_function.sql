-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inter_medic_prescr_rel ( nr_prescricao_p bigint, cd_material_p bigint, ie_severidade_p text) RETURNS varchar AS $body$
DECLARE


cd_material_w				integer;
ds_retorno_w				varchar(8000) := '';
ds_material_w				varchar(300);
ds_material_ww				varchar(300);
ds_interacao_w				varchar(4000) := '';
ds_principio_ativo_w		varchar(300);
ds_tipo_w					varchar(300);
ds_severidade_w				varchar(300);
ds_reacao_w					varchar(300);
ds_orientacao_w				varchar(2000);
ds_interacao_alimento_w		varchar(2000);
ds_ref_bibliografica_w		varchar(4000) := '';
ie_mensagem_cadastrada_w	varchar(1);
varMostraReacoes_w			varchar(10);
nr_seq_ficha_tecnica_w		bigint;
cd_estabelecimento_w		bigint;
nr_dias_interacao_w			bigint;
nr_atendimento_w			bigint;

C01 CURSOR FOR
SELECT	distinct
		a.cd_material,
		substr(b.ds_material,1,100),
		a.nr_seq_ficha_tecnica
from	material b,
		prescr_medica_interacao a
where	a.nr_prescricao	= nr_prescricao_p
and		a.cd_material	= b.cd_material
and		a.cd_material = cd_material_p
and		ie_severidade = ie_severidade_p;

C02 CURSOR FOR
SELECT	distinct substr(obter_desc_material(a.cd_material_interacao),1,100),
		CASE WHEN coalesce(a.ie_mensagem_cadastrada,'S')='N' THEN  CASE WHEN coalesce(ds_tipo::text, '') = '' THEN  ''  ELSE ' ' || wheb_mensagem_pck.get_texto(308349) || ' ' || ds_tipo END   ELSE ' ' || ds_tipo END , -- pode provocar
		CASE WHEN coalesce(a.ie_exibir_gravidade,'S')='S' THEN  CASE WHEN substr(obter_valor_dominio(1325, ie_severidade),1,254) IS NULL THEN  ''  ELSE '. ' || wheb_mensagem_pck.get_texto(308350) || ': ' || substr(obter_valor_dominio(1325, ie_severidade),1,254) END   ELSE '' END , -- Gravidade
		coalesce(a.ie_mensagem_cadastrada,'S'),
		a.ds_orientacao,
		substr(Obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao),1,100) ds_principio_ativo,
		a.ds_ref_bibliografica
from	material_interacao_medic a,
		prescr_material b,
		prescr_medica k
where	a.cd_material		= cd_material_w
and		a.cd_material_interacao	= b.cd_material
and		k.nr_prescricao 	= nr_prescricao_p
and		coalesce(b.dt_suspensao::text, '') = ''
and		coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and		((coalesce(a.ie_funcao_prescritor::text, '') = '') or (a.ie_funcao_prescritor = k.ie_funcao_prescritor))
and		k.nr_prescricao		= b.nr_prescricao
and		coalesce(nr_dias_interacao_w,0) = 0

union

select	distinct substr(obter_desc_material(a.cd_material_interacao),1,100),
		CASE WHEN coalesce(a.ie_mensagem_cadastrada,'S')='N' THEN  CASE WHEN coalesce(ds_tipo::text, '') = '' THEN  ''  ELSE ' ' || wheb_mensagem_pck.get_texto(308349) || ' ' || ds_tipo END   ELSE ' ' || ds_tipo END , -- pode provocar
		CASE WHEN coalesce(a.ie_exibir_gravidade,'S')='S' THEN  CASE WHEN substr(obter_valor_dominio(1325, ie_severidade),1,254) IS NULL THEN  ''  ELSE '. ' || wheb_mensagem_pck.get_texto(308350) || ': ' || substr(obter_valor_dominio(1325, ie_severidade),1,254) END   ELSE '' END , -- Gravidade
		coalesce(a.ie_mensagem_cadastrada,'S'),
		a.ds_orientacao,
		substr(Obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao),1,100) ds_principio_ativo,
		a.ds_ref_bibliografica
from	material_interacao_medic a,
		prescr_material b,
		prescr_medica k
where	a.cd_material		= cd_material_w
and		a.cd_material		= b.cd_material
and		coalesce(b.dt_suspensao::text, '') = ''
and		k.nr_prescricao		= b.nr_prescricao
and		k.nr_prescricao 	= nr_prescricao_p
and		coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and		((coalesce(a.ie_funcao_prescritor::text, '') = '') or (a.ie_funcao_prescritor = k.ie_funcao_prescritor))
and		exists (	select	1
					from 	medic_uso_continuo c
					where	k.cd_pessoa_fisica      = c.cd_pessoa_fisica
					and     c.cd_material		= a.cd_material_interacao)

union

select	distinct substr(obter_desc_material(b.cd_material),1,100),
		CASE WHEN coalesce(a.ie_mensagem_cadastrada,'S')='N' THEN  CASE WHEN coalesce(ds_tipo::text, '') = '' THEN  ''  ELSE ' ' || wheb_mensagem_pck.get_texto(308349) || ' ' || ds_tipo END   ELSE ' ' || ds_tipo END , -- pode provocar
		CASE WHEN coalesce(a.ie_exibir_gravidade,'S')='S' THEN  CASE WHEN substr(obter_valor_dominio(1325, ie_severidade),1,254) IS NULL THEN  ''  ELSE '. ' || wheb_mensagem_pck.get_texto(308350) || ': ' || substr(obter_valor_dominio(1325, ie_severidade),1,254) END   ELSE '' END , -- Gravidade
		coalesce(a.ie_mensagem_cadastrada,'S'),
		a.ds_orientacao,
		substr(Obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao),1,100) ds_principio_ativo,
		a.ds_ref_bibliografica
from	material x,
		material_interacao_medic a,
		prescr_material b,
		prescr_medica k
where	k.nr_prescricao = nr_prescricao_p
and		k.nr_prescricao = b.nr_prescricao
and		coalesce(b.dt_suspensao::text, '') = ''
and		b.cd_material	= x.cd_material
and		coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and		((coalesce(a.ie_funcao_prescritor::text, '') = '') or (a.ie_funcao_prescritor = k.ie_funcao_prescritor))
and		coalesce(nr_dias_interacao_w,0) = 0
and		a.nr_seq_ficha_interacao = nr_seq_ficha_tecnica_w
and		a.nr_seq_ficha	= x.nr_seq_ficha_tecnica

union

select	distinct substr(obter_desc_material(a.cd_material_interacao),1,100),
		CASE WHEN coalesce(a.ie_mensagem_cadastrada,'S')='N' THEN  CASE WHEN coalesce(ds_tipo::text, '') = '' THEN  ''  ELSE ' ' || wheb_mensagem_pck.get_texto(308349) || ' ' || ds_tipo END   ELSE ' ' || ds_tipo END , -- pode provocar
		CASE WHEN coalesce(a.ie_exibir_gravidade,'S')='S' THEN  CASE WHEN substr(obter_valor_dominio(1325, ie_severidade),1,254) IS NULL THEN  ''  ELSE '. ' || wheb_mensagem_pck.get_texto(308350) || ': ' || substr(obter_valor_dominio(1325, ie_severidade),1,254) END   ELSE '' END , -- Gravidade
		coalesce(a.ie_mensagem_cadastrada,'S'),
		a.ds_orientacao,
		substr(Obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao),1,100) ds_principio_ativo,
		a.ds_ref_bibliografica
from	material_interacao_medic a,
		prescr_material b,
		prescr_medica k
where	a.cd_material		= cd_material_w
and		a.cd_material_interacao	= b.cd_material
and		coalesce(b.dt_suspensao::text, '') = ''
and		coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and		k.nr_prescricao		= b.nr_prescricao
and		((coalesce(a.ie_funcao_prescritor::text, '') = '') or (a.ie_funcao_prescritor = k.ie_funcao_prescritor))
and		k.dt_prescricao		> trunc(clock_timestamp(),'dd') - nr_dias_interacao_w
and		k.nr_atendimento 	= nr_atendimento_w
and		coalesce(nr_dias_interacao_w,0) > 0

union

select	distinct substr(obter_desc_material(b.cd_material),1,100),
		CASE WHEN coalesce(a.ie_mensagem_cadastrada,'S')='N' THEN  CASE WHEN coalesce(ds_tipo::text, '') = '' THEN  ''  ELSE ' ' || wheb_mensagem_pck.get_texto(308349) || ' ' || ds_tipo END   ELSE ' ' || ds_tipo END , -- pode provocar
		CASE WHEN coalesce(a.ie_exibir_gravidade,'S')='S' THEN  CASE WHEN substr(obter_valor_dominio(1325, ie_severidade),1,254) IS NULL THEN  ''  ELSE '. ' || wheb_mensagem_pck.get_texto(308350) || ': ' || substr(obter_valor_dominio(1325, ie_severidade),1,254) END   ELSE '' END , -- Gravidade
		coalesce(a.ie_mensagem_cadastrada,'S'),
		a.ds_orientacao,
		substr(Obter_desc_ficha_tecnica(a.nr_seq_ficha_interacao),1,100) ds_principio_ativo,
		a.ds_ref_bibliografica
from	material x,
		material_interacao_medic a,
		prescr_material b,
		prescr_medica k
where	b.cd_material	= x.cd_material
and		k.nr_prescricao = b.nr_prescricao
and		coalesce(b.dt_suspensao::text, '') = ''
and		coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and		a.nr_seq_ficha_interacao = nr_seq_ficha_tecnica_w
and		a.nr_seq_ficha	= x.nr_seq_ficha_tecnica
and		k.dt_prescricao	> trunc(clock_timestamp(),'dd') - nr_dias_interacao_w
and		((coalesce(a.ie_funcao_prescritor::text, '') = '') or (a.ie_funcao_prescritor = k.ie_funcao_prescritor))
and		k.nr_atendimento = nr_atendimento_w
and		coalesce(nr_dias_interacao_w,0) > 0;

c03 CURSOR FOR
SELECT	a.cd_material,
		a.ds_material
from	material a,
		prescr_material b
where	a.cd_material = b.cd_material
and		coalesce(b.dt_suspensao::text, '') = ''
and		b.nr_prescricao = nr_prescricao_p
and		b.cd_material	= cd_material_p;


BEGIN
varMostraReacoes_w := obter_param_usuario(924, 48, obter_perfil_Ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, varMostraReacoes_w);

select	max(nr_atendimento),
		max(cd_estabelecimento)
into STRICT	nr_atendimento_w,
		cd_estabelecimento_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

select	max(nr_dias_interacao)
into STRICT	nr_dias_interacao_w
from	parametro_medico
where	cd_estabelecimento	= cd_estabelecimento_w;

open C01;
loop
fetch C01 into
	cd_material_w,
	ds_material_ww,
	nr_seq_ficha_tecnica_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_interacao_w := '';

	open C02;
	loop
	fetch C02 into
		ds_material_w,
		ds_tipo_w,
		ds_severidade_w,
		ie_mensagem_cadastrada_w,
		ds_orientacao_w,
		ds_principio_ativo_w,
		ds_ref_bibliografica_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(length(ds_interacao_w),0) < 3000) then
			begin
			if (coalesce(ds_interacao_w::text, '') = '') then
				ds_interacao_w := wheb_mensagem_pck.get_texto(308351,	'DS_MATERIAL_A=' || ds_material_ww || ';' ||
																		'DS_MATERIAL_B=' || ds_material_w);
								-- A administração de #@DS_MATERIAL_A#@ com #@DS_MATERIAL_B#@
			else
				ds_interacao_w :=	ds_interacao_w  || chr(13) || chr(10) ||
									wheb_mensagem_pck.get_texto(308351,	'DS_MATERIAL_A=' || ds_material_ww || ';' ||
																		'DS_MATERIAL_B=' || ds_material_w);
									-- A administração de #@DS_MATERIAL_A#@ com #@DS_MATERIAL_B#@
			end if;

			--OS 150881
			if (ie_mensagem_cadastrada_w = 'S') and (ds_tipo_w IS NOT NULL AND ds_tipo_w::text <> '') then
				ds_interacao_w	:= '';
			end if;

			if (ds_tipo_w IS NOT NULL AND ds_tipo_w::text <> '') then
				ds_interacao_w := ds_interacao_w  || ds_tipo_w;
			end if;
			if (ds_severidade_w IS NOT NULL AND ds_severidade_w::text <> '') then
				--ds_interacao_w := ds_interacao_w  || ds_severidade_w;
				ds_severidade_w := ds_severidade_w;
			end if;
			if (ds_principio_ativo_w IS NOT NULL AND ds_principio_ativo_w::text <> '') then
				ds_interacao_w	:= ds_interacao_w || '. ' || wheb_mensagem_pck.get_texto(308352) || ': ' || ds_principio_ativo_w; -- Princípio ativo
			end if;

			ds_interacao_w := ds_interacao_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(308353) || ': ' || ds_orientacao_w; -- Orientação/Recomendação
			if (ie_mensagem_cadastrada_w = 'B') and (ds_ref_bibliografica_w IS NOT NULL AND ds_ref_bibliografica_w::text <> '') then
				ds_interacao_w	:= ds_interacao_w || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(308354) || ': ' || ds_ref_bibliografica_w; -- Ref. Bibliografica
			end if;

			ds_interacao_w := ds_interacao_w || chr(13) || chr(10);
			end;
		end if;

		end;
	end loop;
	close C02;

	if (ds_interacao_w IS NOT NULL AND ds_interacao_w::text <> '') and (coalesce(length(ds_retorno_w),0) < 8000) then
		if (coalesce(ds_retorno_w::text, '') = '') then
			ds_retorno_w := substr(upper(ds_severidade_w) || chr(13) || chr(10) || ds_interacao_w ||chr(13) || chr(10),1,8000);
		else
			ds_retorno_w := substr(ds_retorno_w ||chr(13) || chr(10) || upper(ds_severidade_w) || chr(13) || chr(10) ||ds_interacao_w,1,8000);
		end if;
	end if;

	if (varMostraReacoes_w = 'T') and (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		select	substr(max(b.ds_reacao),1,200)
		into STRICT	ds_reacao_w
		from	material_reacao b,
				material a
		where	a.cd_material	= b.cd_material
		and		a.cd_material	= cd_material_w;

		if (ds_reacao_w IS NOT NULL AND ds_reacao_w::text <> '') then
			ds_retorno_w := substr(ds_retorno_w ||chr(13) || chr(10) || wheb_mensagem_pck.get_texto(308358) || ': ' ||ds_reacao_w,1,8000); -- Reação adversa
		end if;
	end if;


	end;
end loop;
close C01;

open C03;
loop
fetch C03 into
	cd_material_w,
	ds_material_ww;
EXIT WHEN NOT FOUND; /* apply on C03 */
	select	max(ds_interacao)
	into STRICT	ds_interacao_alimento_w
	from	medic_interacao_alimento a
	where	cd_material	= cd_material_w
	and		((coalesce(cd_dieta::text, '') = '') or (exists (SELECT	1
											from	prescr_dieta b
											where	b.nr_Prescricao	= nr_prescricao_p
											and		b.cd_dieta		= a.cd_dieta)));

	if (ds_interacao_alimento_w IS NOT NULL AND ds_interacao_alimento_w::text <> '') then
		ds_retorno_w	:= substr(ds_retorno_w || chr(13) || chr(10) ||
									wheb_mensagem_pck.get_texto(308355, 'DS_MATERIAL_WW=' || ds_material_ww || ';' ||
																		'DS_INTERACAO_ALIMENTO_W=' || ds_interacao_alimento_w),1,8000);
									-- O item #@DS_MATERIAL_WW#@ possui interação com os alimentos: #@DS_INTERACAO_ALIMENTO_W#@
	end if;
end loop;
close C03;

return substr(ds_retorno_w,1,4000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inter_medic_prescr_rel ( nr_prescricao_p bigint, cd_material_p bigint, ie_severidade_p text) FROM PUBLIC;
