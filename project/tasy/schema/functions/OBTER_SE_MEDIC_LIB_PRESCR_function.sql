-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medic_lib_prescr ( nr_atendimento_p bigint, cd_material_p bigint, cd_perfil_p bigint, cd_setor_prescricao_p bigint, cd_convenio_p bigint, ie_tipo_atend_p bigint, ds_mensagem_p out text, nm_usuario_p text, nm_usuario_prescritor_p text, ie_agrupador_p text, cd_pessoa_fisica_p text, nr_prescricao_p bigint, ie_via_aplicacao_p text) AS $body$
DECLARE

cd_material_w			bigint;
cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
cont_w				bigint;
nr_seq_regra_w			bigint;
qt_perfil_w			bigint;
ie_permite_prescrever_w		varchar(1);
ds_mensagem_w			varchar(2000);
nm_usuario_regra_w		varchar(15);
cd_perfil_regra_w		bigint;
ds_retorno_w			varchar(1) := 'S';
qt_idade_w			bigint;
qt_idade_dia_w			double precision;
qt_idade_mes_w			double precision;
ie_responsavel_w		varchar(1);
ie_verifica_resp_w		varchar(1);
cd_estabelecimento_w	prescr_medica.cd_estabelecimento%type;
nr_atendimento_w		prescr_medica.nr_atendimento%type;
cd_recomendacao_w		prescr_recomendacao.cd_recomendacao%type;
nr_seq_proc_w			pe_prescr_proc.nr_seq_proc%type;
ie_possui_regra_perfil_w	varchar(1);
ie_possui_regra_usuario_w 	varchar(1);
ie_possui_regra_geral_w     varchar(1);
cd_recomendacao_ant_w		prescr_recomendacao.cd_recomendacao%type;
nr_seq_proc_ant_w			pe_prescr_proc.nr_seq_proc%type;
DT_INICIO_PRESCR_w				prescr_medica.DT_INICIO_PRESCR%type;
ie_regra_usuario_w		varchar(1) := 'N';
cont_interv_w			bigint;

c01 CURSOR FOR
SELECT	a.ie_permite_prescrever,
	a.ds_mensagem,
	a.nr_sequencia,
	coalesce(a.ie_responsavel,'N'),
	(select CASE WHEN count(b.nr_sequencia)=0 THEN 0  ELSE 1 END  from regra_prescr_mat_perfil b where b.nr_seq_regra = a.nr_sequencia) qt_perfil
from	regra_prescr_material a
where	((a.cd_material = cd_material_p) or (coalesce(a.cd_material::text, '') = ''))
and	((coalesce(a.cd_categoria::text, '') = '') or (a.cd_categoria = Obter_Categoria_Atendimento(nr_atendimento_p)))
and	((a.cd_grupo_material = cd_grupo_material_w) or (coalesce(a.cd_grupo_material::text, '') = ''))
and	((a.cd_subgrupo_material = cd_subgrupo_material_w) or (coalesce(a.cd_subgrupo_material::text, '') = ''))
and	((a.cd_classe_material = cd_classe_material_w) or (coalesce(a.cd_classe_material::text, '') = ''))
and 	((coalesce(a.cd_setor_atendimento::text, '') = '') or (a.cd_setor_atendimento = cd_setor_prescricao_p))
and 	((coalesce(a.cd_convenio::text, '') = '') or (a.cd_convenio = cd_convenio_p))
and	((coalesce(a.ie_consiste_assoc,'S') = 'S') or (ie_agrupador_p <> 5))
and 	((coalesce(a.ie_tipo_atendimento::text, '') = '') or (a.ie_tipo_atendimento = ie_tipo_atend_p))
and 	((coalesce(a.ie_via_aplicacao::text, '') = '') or (a.ie_via_aplicacao = ie_via_aplicacao_p))
and	((coalesce(a.ie_somente_prescritor,'N') = 'N') or (nm_usuario_prescritor_p = nm_usuario_p))
and	qt_idade_w between coalesce(a.qt_idade_min,0) and coalesce(a.qt_idade_max,9999)
and	qt_idade_dia_w between coalesce(a.qt_idade_min_dia,0) and coalesce(a.qt_idade_max_dia,55000)
and	qt_idade_mes_w between coalesce(a.qt_idade_min_mes,0) and coalesce(a.qt_idade_max_mes,55000)
and	((coalesce(a.ie_somente_cirurgia,'N') = 'N') or (obter_se_prescr_cirurgia(nr_prescricao_p) = 'S'))
and	coalesce(a.cd_estabelecimento, cd_estabelecimento_w) = cd_estabelecimento_w
and (not exists (select 1 from regra_prescr_mat_perfil b where b.nr_seq_regra = a.nr_sequencia)
	or exists (select 1 from regra_prescr_mat_perfil b where b.nr_seq_regra = a.nr_sequencia and b.cd_perfil = cd_perfil_p)
	or exists (select 1 from regra_prescr_mat_usuario c where c.nr_seq_regra = a.nr_sequencia))
order	by
		coalesce(a.cd_material,0),
		coalesce(a.cd_classe_material,0),
		coalesce(a.cd_subgrupo_material,0),
		coalesce(a.cd_grupo_material,0),
		coalesce(qt_perfil,0),
		coalesce(a.cd_setor_atendimento,0),
		coalesce(a.ie_tipo_atendimento,0),
		coalesce(a.cd_convenio,0),
		coalesce(a.qt_idade_min,0),
		coalesce(a.qt_idade_max,0);


C02 CURSOR FOR
	SELECT	cd_recomendacao,
			null
	from	prescr_recomendacao b,
			prescr_medica a
	where	a.nr_prescricao = b.nr_prescricao
	and		coalesce(b.dt_suspensao::text, '') = ''
	and		a.nr_atendimento = nr_atendimento_w
	and		DT_INICIO_PRESCR_w between dt_inicio_prescr and dt_validade_prescr
	
union all

	SELECT	 null,
			 b.nr_seq_proc
	from	 pe_prescricao a,
			 pe_prescr_proc b
	where    b.nr_seq_prescr = a.nr_sequencia
	and		(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	AND		coalesce(dt_inativacao::text, '') = ''
	and		nr_atendimento = nr_atendimento_w
	and		DT_INICIO_PRESCR_w between dt_inicio_prescr and dt_validade_prescr
	order by 1,2;


BEGIN

select 	max(nr_atendimento),
		max(DT_INICIO_PRESCR)
into STRICT		nr_atendimento_w,
			DT_INICIO_PRESCR_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

cd_estabelecimento_w	:= obter_estabelecimento_ativo;

select	Obter_estrutura_material(cd_material,'G'),
	Obter_estrutura_material(cd_material,'S'),
	Obter_estrutura_material(cd_material,'C')
into STRICT	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w
from	material
where	cd_material = cd_material_p;

select	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'A')),
	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA')),
	max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'M'))
into STRICT	qt_idade_w,
	qt_idade_dia_w,
	qt_idade_mes_w
from	pessoa_fisica b
where	b.cd_pessoa_fisica	= cd_pessoa_fisica_p;

open	C01;
loop
fetch	C01 into
		ie_permite_prescrever_w,
		ds_mensagem_w,
		nr_seq_regra_w,
		ie_responsavel_w,
		qt_perfil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if (ie_responsavel_w = 'S') then
		select	obter_se_usu_resp_atendimento(cd_pessoa_fisica_p,nm_usuario_p)
		into STRICT	ie_verifica_resp_w
		;
		if (ie_verifica_resp_w = 'N') then
			ds_retorno_w := ie_verifica_resp_w;
			ds_mensagem_p	:= ds_mensagem_w;
			exit;
		end if;
	end if;

	select 	count(*)
	into STRICT	cont_interv_w
	from   	regra_prescr_mat_interv
	where 	nr_seq_regra = nr_seq_regra_w
	and		ie_situacao = 'A';

	select	count(*)
	into STRICT	cont_w
	from	regra_prescr_mat_usuario
	where	nr_seq_regra 		= nr_seq_regra_w
	and		nm_usuario_regra	= nm_usuario_p;

	if (cont_w > 0) then
		ds_retorno_w	:= ie_permite_prescrever_w;
		ds_mensagem_p	:= ds_mensagem_w;
		ie_possui_regra_usuario_w := 'S';

		if (cont_interv_w = 0) then
			exit;
		else
			ie_regra_usuario_w := 'S';
		end if;

	else
		select	count(*)
		into STRICT	cont_w
		from	regra_prescr_mat_perfil
		where	nr_seq_regra	= nr_seq_regra_w
		and		cd_perfil	= cd_perfil_p;

		if (cont_w > 0) then
			ds_retorno_w	:= ie_permite_prescrever_w;
			ds_mensagem_p	:= ds_mensagem_w;
			ie_possui_regra_perfil_w := 'S';
		else	--vhkrausser - Regras genêricas -> sem restrição de usuario/perfil
			Select	sum(num)
			into STRICT	cont_w
			from (
				SELECT	count(*) num
				from	regra_prescr_mat_usuario
				where	nr_seq_regra 		= nr_seq_regra_w
				
union all

				SELECT	count(*) num
				from	regra_prescr_mat_perfil
				where	nr_seq_regra		= nr_seq_regra_w) alias3;

				if (cont_w > 0) then
					select CASE WHEN ie_permite_prescrever_w='N' THEN 'S'  ELSE 'N' END
					into STRICT	ie_permite_prescrever_w
					;
				end if;




			if (cont_w = 0) then
				ds_retorno_w	:= ie_permite_prescrever_w;
				ds_mensagem_p	:= ds_mensagem_w;
				ie_possui_regra_geral_w := 'N';
			end if;
		end if;
	end if;

	if (ie_possui_regra_perfil_w = 'S') or (ie_possui_regra_usuario_w = 'S') or (ie_possui_regra_geral_w = 'N') then

			if (cont_interv_w > 0) then

				select 	CASE WHEN ds_retorno_w='N' THEN 'S'  ELSE 'N' END
				into STRICT	ds_retorno_w
				;

				open C02;
				loop
				fetch C02 into
					cd_recomendacao_w,
					nr_seq_proc_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
					begin

					select 	count(nr_seq_regra)
					into STRICT	cont_w
					from 	regra_prescr_mat_interv
					where 	nr_seq_regra = nr_seq_regra_w
					and		(((cd_recomendacao = cd_recomendacao_w) or (nr_seq_proc = nr_seq_proc_w)) or
					   		 ((cd_recomendacao = cd_recomendacao_ant_w) or (nr_seq_proc = nr_seq_proc_ant_w)))
					and		ie_situacao = 'A';

					if (cont_w > 0) then
						ds_retorno_w			:= ie_permite_prescrever_w;
						ds_mensagem_p			:= ds_mensagem_w;

						--Considerar os ítens anteriores quando encontrar o proximo registro do cursor02
						cd_recomendacao_ant_w	:= cd_recomendacao_w;
						nr_seq_proc_ant_w		:= nr_seq_proc_w;
					end if;

					end;
				end loop;
				close C02;
			else
				ds_retorno_w	:= ie_permite_prescrever_w;
				ds_mensagem_p	:= ds_mensagem_w;
			end if;
	end if;

	if (ie_regra_usuario_w = 'S') then
		exit;
	end if;

end loop;
close C01;

return;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medic_lib_prescr ( nr_atendimento_p bigint, cd_material_p bigint, cd_perfil_p bigint, cd_setor_prescricao_p bigint, cd_convenio_p bigint, ie_tipo_atend_p bigint, ds_mensagem_p out text, nm_usuario_p text, nm_usuario_prescritor_p text, ie_agrupador_p text, cd_pessoa_fisica_p text, nr_prescricao_p bigint, ie_via_aplicacao_p text) FROM PUBLIC;
