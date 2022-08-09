-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_ci_paciente_medic ( nr_prescricao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_sequencia_p bigint, ie_momento_p text default 'L') AS $body$
DECLARE


ds_titulo_w					varchar(255);
nm_paciente_w				varchar(255);
nm_medico_w					varchar(255);
nm_usuario_destino_w		varchar(255);
ie_medicacao_paciente_w		varchar(255);
cd_pessoa_fisica_w			varchar(50);
ds_comunicado_w				varchar(4000);
ds_comunic_w				varchar(4000);
ds_material_w				varchar(4000);
ds_justificativa_w			varchar(4000);
cd_perfil_destino_w			varchar(4000);
ds_lista_usuario_destino_w	varchar(1000);
ie_somente_padrao_w			varchar(1);
ie_enviar_atb_w				varchar(1);
ie_objetivo_uso_w			varchar(1);
ie_dias_util_medic_w		varchar(10);
cd_mat_w					bigint;
nr_dia_util_w				bigint;
qt_max_dia_aplic_w			bigint;
qt_max_dia_aplic_ww			bigint;
qt_dia_terapeutico_w		bigint;
qt_dia_profilatico_w		bigint;
cd_setor_w					bigint;
cd_perfil_w					varchar(1000);
ie_classif_custo_w			varchar(10);
ds_dose_w					varchar(1000);
ds_setor_w					varchar(1000);
ie_gerou_w					varchar(1);
ds_convenio_w				varchar(1000);
nr_sequencia_w				bigint;
nr_sequencia_ww				bigint;
cd_grupo_material_w			integer;
cd_subgrupo_material_w		integer;
cd_classe_material_w		integer;
nr_seq_comunic_w			bigint;
nr_min_prescr_w				bigint;
cd_material_w				bigint;
nr_atendimento_w			bigint;
ie_primeiro_dia_w			varchar(1);
ie_enviar_prescritor_w		varchar(1);
ie_ctrl_medic_w				bigint;
nr_seq_medic_w				bigint;
ie_objetivo_w				varchar(60);
qt_dias_solicitado_w		smallint;
cd_convenio_w				integer;
cd_categoria_w				varchar(10);
qt_dias_solic_w				smallint;
qt_dias_liberado_w			smallint;
ds_objetivo_w				varchar(50);
ds_microorganismo_w			varchar(255);
ds_amostra_w				varchar(50);
ds_origem_infeccao_w		varchar(50);
ds_topografia_w				varchar(50);
ds_indicacao_w				varchar(50);
ds_uso_atb_w				varchar(50);
ie_justificativa_w			varchar(5);
ie_tipo_atendimento_w		smallint;
ie_clinica_w				integer;

c01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.ds_titulo,
		a.ds_comunicado,
		a.ie_somente_padrao,
		a.cd_grupo_material,
		a.cd_subgrupo_material,
		a.cd_classe_material,
		a.cd_material,
		coalesce(a.ie_enviar_prescritor,'S'),
		a.ie_primeiro_dia,
		coalesce(a.ie_justificativa,'S'),
		coalesce(a.ie_dados_atb,'S'),
		ie_classif_custo
from	rep_regra_envio_ci_padrao a
where	obter_se_setor_lib_ci(a.nr_sequencia, cd_setor_w) = 'S'
and		((coalesce(cd_estab::text, '') = '') or (cd_estabelecimento_p = cd_estab))
and		((coalesce(a.ie_paciente_medic,'N') = 'S') or (ie_momento_p = 'S'))
and		coalesce(ie_momento,'L') = ie_momento_p
and		coalesce(a.cd_convenio,coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0)
and		coalesce(a.cd_categoria,coalesce(cd_categoria_w,'0')) = coalesce(cd_categoria_w,'0');

c02 CURSOR FOR
SELECT	b.cd_perfil
from		rep_regra_envio_ci_perfil b
where	b.nr_seq_regra	= nr_sequencia_ww;

c14 CURSOR FOR
SELECT	c.ds_justificativa,
		substr(Obter_Descricao_mat_prescr(c.cd_material),1,80),
		a.cd_material,
		(c.qt_dose || c.cd_unidade_medida_dose),
		c.ie_medicacao_paciente,
		obter_ctrl_antimicrobiano_mat(c.cd_material),
		c.nr_sequencia,
		coalesce(c.qt_dias_solicitado,0),
		coalesce(c.qt_dias_liberado,0),
		substr(obter_valor_dominio(1280, c.ie_objetivo),1,50) ds_objetivo,
		substr(obter_desc_microorganismo(c.cd_microorganismo_cih),1,255) ds_microorganismo,
		substr(obter_cih_amostra(c.cd_amostra_cih),1,50) ds_amostra,
		substr(obter_valor_dominio(1288, c.ie_origem_infeccao),1,50) ds_origem_infeccao,
		substr(obter_desc_topografia(c.cd_topografia_cih),1,50) ds_topografia,
		substr(obter_valor_dominio(1927, c.ie_indicacao),1,50) ds_indicacao,
		CASE WHEN coalesce(ie_uso_antimicrobiano,'N')='S' THEN  obter_desc_expressao(327113)  ELSE obter_desc_expressao(327114) END  ds_uso_atb,
		x.ie_dias_util_medic,
		CASE WHEN x.ie_dias_util_medic='O' THEN  c.nr_dia_util+1  ELSE c.nr_dia_util END  nr_dia_util,
		CASE WHEN x.ie_dias_util_medic='O' THEN  obter_qt_max_dia_aplic_mat(c.cd_material)  ELSE obter_qt_max_dia_aplic_mat(c.cd_material) END ,
		coalesce(obter_dados_medic_atb_num(c.cd_material,cd_estabelecimento_p,x.qt_dia_terapeutico,'DT',obter_tipo_atendimento(b.nr_atendimento),b.cd_setor_atendimento,obter_clinica_atend(b.nr_atendimento,'C')),0),
		coalesce(obter_dados_medic_atb_num(c.cd_material,cd_estabelecimento_p,x.qt_dia_profilatico,'DP',obter_tipo_atendimento(b.nr_atendimento),b.cd_setor_atendimento,obter_clinica_atend(b.nr_atendimento,'C')),0),
		c.ie_objetivo
from	estrutura_material_v a,
		material x,
		prescr_material c,
		prescr_medica b
where	b.nr_prescricao    = c.nr_prescricao
and		a.cd_material		= c.cd_material
and		c.nr_prescricao		= nr_prescricao_p
and		x.cd_material		= c.cd_material
and		coalesce(c.nr_seq_kit::text, '') = ''
and		coalesce(c.nr_sequencia_diluicao::text, '') = ''
and		c.ie_agrupador in (1,2,4,8,12)
and		((coalesce(ie_classif_custo_w::text, '') = '') or (ie_classif_custo_w = obter_dados_material_estab(c.cd_material, cd_estabelecimento_p, 'CU')))
and		((coalesce(cd_mat_w::text, '') = '') or (a.cd_material	= cd_mat_w))
and		((coalesce(cd_grupo_material_w::text, '') = '') or (a.cd_grupo_material	= cd_grupo_material_w))
and		((coalesce(cd_subgrupo_material_w::text, '') = '') or (a.cd_subgrupo_material = cd_subgrupo_material_w))
and		((coalesce(cd_classe_material_w::text, '') = '') or (a.cd_classe_material = cd_classe_material_w))
and		((coalesce(nr_sequencia_p::text, '') = '') or (c.nr_sequencia = nr_sequencia_p));

c15 CURSOR FOR
SELECT	b.nm_usuario_regra
from	rep_regra_envio_ci_padrao a,
		rep_usuario_ci_medic b
where	a.nr_sequencia	= b.nr_seq_regra
and		b.nr_seq_regra	= nr_sequencia_ww;


BEGIN

select	min(nr_sequencia)
into STRICT	nr_sequencia_w
from	comunic_interna_classif
where	ie_tipo	= 'F';

select	max(obter_nome_pf_pj(cd_pessoa_fisica,null)),
		max(obter_nome_pf_pj(cd_prescritor,null)),
		max(cd_setor_atendimento),
		max(nr_atendimento),
		max(obter_nome_setor(cd_setor_atendimento)),
		max(obter_Convenio_atendimento(nr_atendimento)),
		max(cd_pessoa_fisica),
		max(Obter_Tipo_Atendimento(nr_atendimento)),
		max(obter_clinica_atend(nr_atendimento,'C'))
into STRICT	nm_paciente_w,
		nm_medico_w,
		cd_setor_w,
		nr_atendimento_w,
		ds_setor_w,
		cd_convenio_w,
		cd_pessoa_fisica_w,
		ie_tipo_atendimento_w,
		ie_clinica_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

ds_convenio_w	:= obter_nome_convenio(cd_convenio_w);
cd_categoria_w	:= Obter_Cat_Conv_Atend(nr_atendimento_w, cd_convenio_w);

open C01;
loop
fetch C01 into
	nr_sequencia_ww,
	ds_titulo_w,
	ds_comunic_w,
	ie_somente_padrao_w,
	cd_grupo_material_w,
	cd_subgrupo_material_w,
	cd_classe_material_w,
	cd_mat_w,
	ie_enviar_prescritor_w,
	ie_primeiro_dia_w,
	ie_justificativa_w,
	ie_enviar_atb_w,
	ie_classif_custo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	ds_comunicado_w := null;
	open C14;
	loop
	fetch C14 into
		ds_justificativa_w,
		ds_material_w,
		cd_material_w,
		ds_dose_w,
		ie_medicacao_paciente_w,
		ie_ctrl_medic_w,
		nr_seq_medic_w,
		qt_dias_solic_w,
		qt_dias_liberado_w,
		ds_objetivo_w,
		ds_microorganismo_w,
		ds_amostra_w,
		ds_origem_infeccao_w,
		ds_topografia_w,
		ds_indicacao_w,
		ds_uso_atb_w,
		ie_dias_util_medic_w,
		nr_dia_util_w,
		qt_max_dia_aplic_w,
		qt_dia_terapeutico_w,
		qt_dia_profilatico_w,
		ie_objetivo_uso_w;
	EXIT WHEN NOT FOUND; /* apply on C14 */

		ie_gerou_w	:= 'N';

		select	coalesce(obter_dados_medic_atb_num(max(cd_material), cd_estabelecimento_p ,max(qt_max_dia_aplic),'DA',ie_tipo_atendimento_w, cd_setor_w,ie_clinica_w),0)
		into STRICT		qt_max_dia_aplic_ww
		from		rep_regra_dias_util
		where	cd_material = cd_material_w
		and		cd_pessoa_fisica = cd_pessoa_fisica_w;

		if (ie_dias_util_medic_w <> 'N') then
			if (qt_max_dia_aplic_ww > 0 ) and (nr_dia_util_w > qt_max_dia_aplic_ww) then
				ie_gerou_w	:= 'S';
			elsif (coalesce(qt_max_dia_aplic_ww,0) = 0) and (nr_dia_util_w > qt_max_dia_aplic_w) then
				ie_gerou_w := 'S';
			elsif (coalesce(qt_dia_terapeutico_w,0) > 0) and (nr_dia_util_w > qt_dia_terapeutico_w) and (ie_objetivo_uso_w in ('T','D','E')) then
				ie_gerou_w	:= 'S';
			elsif (coalesce(qt_dia_profilatico_w,0) > 0) and (nr_dia_util_w > qt_dia_profilatico_w) and (ie_objetivo_uso_w in ('F','P','C')) then
				ie_gerou_w	:= 'S';
			end if;
		end if;

		if (ie_gerou_w = 'S') or (ie_momento_p = 'S') then --- feito o tratamento para que somente quando for dias ultrapassados ou for chamado por suspenção. OS 699147
			if (ds_comunicado_w IS NOT NULL AND ds_comunicado_w::text <> '') then
				ds_comunicado_w	:= ds_comunicado_w || chr(13) || chr(13) || ds_material_w;
			else
				ds_comunicado_w	:= chr(13) || ds_material_w;
			end if;

			ds_comunicado_w := ds_comunicado_w || chr(13) || '  ' || obter_desc_expressao(326100) || ' ' || ds_dose_w;
		end if;

		if (ie_gerou_w = 'S') then

			if (qt_dias_solic_w > 0) then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' ||  obter_desc_expressao(287854) || ': ' || qt_dias_solic_w,1,2000);
			end if;
			if (qt_dias_liberado_w > 0) then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(343379) || ' ' || qt_dias_liberado_w,1,2000);
			end if;
			if (ds_objetivo_w IS NOT NULL AND ds_objetivo_w::text <> '') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(294569) || ': ' || ds_objetivo_w,1,2000);
			end if;
			if (ds_microorganismo_w IS NOT NULL AND ds_microorganismo_w::text <> '') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(293299) || ': ' || ds_microorganismo_w,1,2000);
			end if;
			if (ds_amostra_w IS NOT NULL AND ds_amostra_w::text <> '') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(283442) || ': ' || ds_amostra_w,1,2000);
			end if;
			if (ds_origem_infeccao_w IS NOT NULL AND ds_origem_infeccao_w::text <> '') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(294936) || ': ' || ds_origem_infeccao_w,1,2000);
			end if;
			if (ds_topografia_w IS NOT NULL AND ds_topografia_w::text <> '') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(300156) || ': ' || ds_topografia_w,1,2000);
			end if;
			if (ds_indicacao_w IS NOT NULL AND ds_indicacao_w::text <> '') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(291834) || ': ' || ds_indicacao_w,1,2000);
			end if;
			if (ds_uso_atb_w IS NOT NULL AND ds_uso_atb_w::text <> '') and (ie_enviar_atb_w = 'S') then
				ds_comunicado_w	:= substr(ds_comunicado_w || chr(13) || '   ' || obter_desc_expressao(300885) || ': ' || ds_uso_atb_w,1,2000);
			end if;

			if (ie_ctrl_medic_w > 0) and (ie_justificativa_w = 'S') then
				select	substr(obter_valor_dominio(1280,ie_objetivo),1,60),
						coalesce(qt_dias_solicitado,0)qt_dias_solicitado
				into STRICT		ie_objetivo_w,
						qt_dias_solicitado_w
				from		prescr_material
				where	nr_prescricao	= nr_prescricao_p
				and		nr_sequencia	= nr_seq_medic_w;

				ds_comunicado_w := ds_comunicado_w || chr(13) ||
							'  ' || obter_desc_expressao(727882) || ':  ' || coalesce(ds_justificativa_w,'') || ' (' || ie_objetivo_w || ')' || chr(13) ||
							'  ' || obter_desc_expressao(303740) || ':  ' || qt_dias_solicitado_w;
			elsif (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') and (ie_justificativa_w = 'S') then
				ds_comunicado_w := ds_comunicado_w || chr(13) || ds_justificativa_w;
			end if;
			if (ie_medicacao_paciente_w = 'S') then
				ds_comunicado_w := ds_comunicado_w || chr(13) || obter_desc_expressao(339240) || '.';
			end if;
		end if;
	end loop;
	close C14;

	if (ie_primeiro_dia_w = 'S') then

		select	min(a.nr_prescricao)
		into STRICT		nr_min_prescr_w
		from		prescr_medica b,
				prescr_material a
		where	a.nr_prescricao		= b.nr_prescricao
		and		b.nr_atendimento	= nr_atendimento_w
		and		a.cd_material		= cd_material_w
		and		coalesce(a.dt_suspensao::text, '') = ''
		and		coalesce(b.dt_suspensao::text, '') = '';

		if (nr_min_prescr_w < nr_prescricao_p) then
			ds_comunicado_w	:= '';
		end if;
	end if;

	if (ds_comunicado_w IS NOT NULL AND ds_comunicado_w::text <> '') then
		ds_lista_usuario_destino_w := null;
		open C15;
		loop
		fetch C15 into
			nm_usuario_destino_w;
		EXIT WHEN NOT FOUND; /* apply on C15 */
			if (ds_lista_usuario_destino_w IS NOT NULL AND ds_lista_usuario_destino_w::text <> '') then
				ds_lista_usuario_destino_w := substr(ds_lista_usuario_destino_w || ',',1,1000);
			end if;
			ds_lista_usuario_destino_w := substr(ds_lista_usuario_destino_w || nm_usuario_destino_w,1,1000);
		end loop;
		close C15;

		cd_perfil_w := null;

		open c02;
		loop
		fetch c02 into
			cd_perfil_destino_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') or (cd_perfil_w <> '') then
				cd_perfil_w := cd_perfil_w || ',';
			end if;
			cd_perfil_w := substr(cd_perfil_w || cd_perfil_destino_w,1,1000);
		end loop;
		close c02;

		if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') and (substr(cd_perfil_w,length(cd_perfil_w), 1) <> ',') then
			cd_perfil_w	:= cd_perfil_w || ',';
		end if;

		ds_comunic_w	:=
        obter_desc_expressao(296208) || ': ' || nr_prescricao_p || chr(13) ||
				obter_desc_expressao(283863) || ': ' || nr_atendimento_w || chr(13) ||
				obter_desc_expressao(295156) || ': ' || nm_paciente_w || chr(13) ||
				obter_desc_expressao(696060) || ': ' || ds_setor_w|| chr(13) ||
				obter_desc_expressao(286193) || ': ' || ds_convenio_w|| chr(13) ||
				obter_desc_expressao(296217) || ': ' || nm_medico_w || chr(13) || chr(13) ||
				ds_comunic_w;

		if (ds_titulo_w IS NOT NULL AND ds_titulo_w::text <> '') then

			select	nextval('comunic_interna_seq')
			into STRICT	nr_seq_comunic_w
			;

			insert	into comunic_interna(
				dt_comunicado,
				ds_titulo,
				ds_comunicado,
				nm_usuario,
				nm_usuario_destino,
				dt_atualizacao,
				ie_geral,
				ie_gerencial,
				ds_perfil_adicional,
				nr_sequencia,
				nr_seq_classif,
				dt_liberacao)
			values (
				clock_timestamp(),
				ds_titulo_w,
				ds_comunic_w || chr(13) || ds_comunicado_w,
				nm_usuario_p,
				ds_lista_usuario_destino_w,
				clock_timestamp(),
				'N',
				'N',
				cd_perfil_w,
				nr_seq_comunic_w,
				nr_sequencia_w,
				clock_timestamp());

			if (ie_enviar_prescritor_w = 'N') then
				insert into comunic_interna_lida
				values (	nr_seq_comunic_w,
						nm_usuario_p,
						clock_timestamp());
			end if;

			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

		end if;
	end if;

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_ci_paciente_medic ( nr_prescricao_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_sequencia_p bigint, ie_momento_p text default 'L') FROM PUBLIC;
