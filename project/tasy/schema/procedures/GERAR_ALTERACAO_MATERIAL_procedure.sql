-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_alteracao_material ( nr_prescricao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) AS $body$
DECLARE


nr_sequencia_w				bigint;
cd_intervalo_padrao_w		varchar(7);
cd_intervalo_padrao_ww		varchar(7);
cd_material_w				integer;
ie_via_aplicacao_w			varchar(5);
cd_setor_atendimento_w		integer;
cd_pessoa_fisica_w			varchar(10);
qt_peso_w					real;
qt_dose_padrao_w			double precision;
qt_dose_mat_prescr_w		double precision;
cd_intervalo_mat_prescr_w	varchar(7);
cd_pessoa_alteracao_w		varchar(10);
cd_unidade_padrao_w			varchar(30);
cd_unidade_padrao_ww		varchar(30);
cd_unidade_medida_dose_w	varchar(30);
ie_Unidade_Medida_Medic_w	bigint;
ie_DefinePadraoAposVia_w	varchar(1);
ie_agrupador_w				smallint;
nr_seq_diluicao_w			bigint;
ds_mensagem_w				varchar(255);
nr_atendimento_w			bigint;
ie_bomba_infusao_w			prescr_material.ie_bomba_infusao%type;


c01 CURSOR FOR
	SELECT	a.nr_sequencia,
			a.cd_material,
			a.ie_via_aplicacao,
			b.cd_setor_atendimento,
			b.cd_pessoa_fisica,
			b.qt_peso,
			a.qt_dose,
			a.cd_intervalo,
			a.cd_unidade_medida_dose,
			a.ie_agrupador,
			a.nr_sequencia_diluicao,
			b.nr_atendimento,
			a.ie_bomba_infusao
	from		prescr_material a,
			prescr_medica b
	where	a.nr_prescricao	= b.nr_prescricao
	and		a.nr_prescricao	= nr_prescricao_p
	and		ie_suspenso <> 'S'
	and		a.ie_agrupador = 1
	and		coalesce(a.nr_seq_kit::text, '') = ''
	and		coalesce(b.nr_seq_protocolo::text, '') = '';



BEGIN

ie_Unidade_Medida_Medic_w := obter_param_usuario(924, 50, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_Unidade_Medida_Medic_w);
ie_DefinePadraoAposVia_w := obter_param_usuario(924, 623, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_DefinePadraoAposVia_w);

select	max(cd_pessoa_fisica)
into STRICT	cd_pessoa_alteracao_w
from	usuario
where	nm_usuario = nm_usuario_p;

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	cd_material_w,
	ie_via_aplicacao_w,
	cd_setor_atendimento_w,
	cd_pessoa_fisica_w,
	qt_peso_w,
	qt_dose_mat_prescr_w,
	cd_intervalo_mat_prescr_w,
	cd_unidade_medida_dose_w,
	ie_agrupador_w,
	nr_seq_diluicao_w,
	nr_atendimento_w,
	ie_bomba_infusao_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	select	cd_intervalo_padrao
	into STRICT	cd_intervalo_padrao_w
	from 	material
	where 	cd_material = cd_material_w;

	qt_dose_padrao_w	:= Obter_Padrao_Param_Prescr(
								nr_atendimento_w,
								cd_material_w,
								ie_via_aplicacao_w,
								cd_setor_atendimento_w,
								cd_pessoa_fisica_w,
								Obter_Idade_PF(cd_pessoa_fisica_w, clock_timestamp(), 'A'),
								qt_peso_w, 'N',
								'D',
								cd_intervalo_mat_prescr_w);
	if (coalesce(qt_dose_padrao_w::text, '') = '') or (qt_dose_padrao_w = '') then
		qt_dose_padrao_w := 1;
	end if;

	if (coalesce(ie_Unidade_Medida_Medic_w,1) = 1) then
		select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UMS'),1,30) cd_unidade_medida_consumo
		into STRICT	cd_unidade_padrao_w
		from 	material
		where 	cd_material = cd_material_w;
	elsif (coalesce(ie_Unidade_Medida_Medic_w,1) = 2) then
		select 	max(cd_unidade_medida)
		into STRICT	cd_unidade_padrao_w
		from 	material_conversao_unidade
		where 	cd_material = cd_material_w
		and 	upper(cd_unidade_medida) = upper(obter_unid_med_usua('ML'));
	elsif (coalesce(ie_Unidade_Medida_Medic_w,1) = 3) then
		select 	max(a.cd_unidade_medida)
		into STRICT	cd_unidade_padrao_w
		from 	unidade_medida_dose_v a
		where 	a.cd_material	= cd_material_w
		and	a.ie_prioridade = (	SELECT 	min(b.ie_prioridade)
							from 	unidade_medida_dose_v b
							where	a.cd_material = b.cd_material);
	end if;

	if (ie_DefinePadraoAposVia_w = 'S') then
		cd_unidade_padrao_ww	:= Obter_Padrao_Param_Prescr(
									nr_atendimento_w,
									cd_material_w,
									ie_via_aplicacao_w,
									cd_setor_atendimento_w,
									cd_pessoa_fisica_w,
									Obter_Idade_PF(cd_pessoa_fisica_w, clock_timestamp(), 'A'),
									qt_peso_w, 'N',
									'U',
									cd_intervalo_mat_prescr_w);
		if (cd_unidade_padrao_ww <> '') or (cd_unidade_padrao_ww IS NOT NULL AND cd_unidade_padrao_ww::text <> '') then
			cd_unidade_padrao_w := cd_unidade_padrao_ww;
		end if;

		cd_intervalo_padrao_ww	:= Obter_Padrao_Param_Prescr(
									nr_atendimento_w,
									cd_material_w,
									ie_via_aplicacao_w,
									cd_setor_atendimento_w,
									cd_pessoa_fisica_w,
									Obter_Idade_PF(cd_pessoa_fisica_w, clock_timestamp(), 'A'),
									qt_peso_w, 'N',
									'I',
									cd_intervalo_mat_prescr_w);
		if (cd_intervalo_padrao_ww <> '') or (cd_intervalo_padrao_ww IS NOT NULL AND cd_intervalo_padrao_ww::text <> '') then
			cd_intervalo_padrao_w := cd_intervalo_padrao_ww;
		end if;
	end if;

	if (qt_dose_mat_prescr_w <> qt_dose_padrao_w) then
		insert into	prescr_material_alteracao(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_seq_prescricao,
				ie_acao,
				cd_pessoa_alteracao,
				ds_alteracao
				)
		values (
				nextval('prescr_material_alteracao_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				nr_sequencia_w,
				'D',
				cd_pessoa_alteracao_w,
				WHEB_MENSAGEM_PCK.get_texto(458030,'de='||qt_dose_padrao_w||';para='||qt_dose_mat_prescr_w)/*Alterado de ___ para ___*/
				);
	end if;

	if (coalesce(cd_unidade_medida_dose_w,OBTER_DESC_EXPRESSAO(305401)) <> coalesce(cd_unidade_padrao_w,OBTER_DESC_EXPRESSAO(305401))) then
		insert into	prescr_material_alteracao(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_seq_prescricao,
				ie_acao,
				cd_pessoa_alteracao,
				ds_alteracao
				)
		values (
				nextval('prescr_material_alteracao_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				nr_sequencia_w,
				'U',
				cd_pessoa_alteracao_w,
				WHEB_MENSAGEM_PCK.get_texto(458030,'de='||CASE WHEN coalesce(cd_unidade_padrao_w::text, '') = '' THEN OBTER_DESC_EXPRESSAO(305401)  ELSE Obter_Desc_Unid_Med(cd_unidade_padrao_w) END
				||';para='||CASE WHEN coalesce(cd_unidade_medida_dose_w::text, '') = '' THEN OBTER_DESC_EXPRESSAO(305401)  ELSE Obter_Desc_Unid_Med(cd_unidade_medida_dose_w) END )
				);
	end if;

	if (coalesce(cd_intervalo_padrao_w,OBTER_DESC_EXPRESSAO(305401)) <> coalesce(cd_intervalo_mat_prescr_w,OBTER_DESC_EXPRESSAO(305401))) then

		insert into	prescr_material_alteracao(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_prescricao,
				nr_seq_prescricao,
				ie_acao,
				cd_pessoa_alteracao,
				ds_alteracao
				)
		values (
				nextval('prescr_material_alteracao_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_prescricao_p,
				nr_sequencia_w,
				'I',
				cd_pessoa_alteracao_w,
				WHEB_MENSAGEM_PCK.get_texto(458030,'de='||CASE WHEN coalesce(cd_intervalo_padrao_w::text, '') = '' THEN OBTER_DESC_EXPRESSAO(305401)  ELSE obter_desc_intervalo(cd_intervalo_padrao_w) END
				||';para='||CASE WHEN coalesce(cd_intervalo_mat_prescr_w::text, '') = '' THEN OBTER_DESC_EXPRESSAO(305401)  ELSE obter_desc_intervalo(cd_intervalo_mat_prescr_w) END )
				);
	end if;
end loop;
close c01;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_alteracao_material ( nr_prescricao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint ) FROM PUBLIC;
