-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE verifica_medic_dupl_dia ( cd_material_p bigint, nr_prescricao_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;
dt_prescricao_w			timestamp;
ie_consitir_susp_w		varchar(10);
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_setor_atendimento_w	bigint;
ie_consistir_setor_w	varchar(10);
dt_inicio_prescr_w		timestamp;
dt_validade_prescr_w	timestamp;
ie_validade_prescr_w	varchar(1);

C01 CURSOR FOR
	SELECT 	distinct
			nr_prescricao,
			nm_medico,
			ie_suspenso,
			dt_suspensao,
			ds_motivo_susp
	from	(
		SELECT	a.nr_prescricao,
				substr(obter_nome_medico(b.cd_medico,'N'),1,60) nm_medico,
				CASE WHEN a.ie_suspenso='S' THEN  upper(obter_desc_expressao(298991))  ELSE '' END  ie_suspenso,
				a.dt_suspensao,
				substr(a.ds_motivo_susp,1,80) ds_motivo_susp
		from	material			c,
				prescr_material		a,
				prescr_medica		b
		where	b.nr_prescricao				<> nr_prescricao_p
		and		a.cd_material				= cd_material_p
		and		a.cd_material				= c.cd_material
		and		b.cd_pessoa_fisica			= cd_pessoa_fisica_w
		and 	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(b.dt_prescricao)		= ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_prescricao_w)
		and 	ie_validade_prescr_w 		= 'S'
		and		a.nr_prescricao				= b.nr_prescricao
		and		(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
		and		coalesce(c.ie_consiste_dupl, 'S') = 'S'
		and		coalesce(a.ie_modificado,'N') 	<> 'S'
		and		((ie_consitir_susp_w		= 'S') or (coalesce(a.ie_suspenso,'N') 	= 'N'))
		and		((ie_consistir_setor_w 		= 'S') or (b.cd_setor_atendimento 	= cd_setor_atendimento_w))
		
union all

		select	a.nr_prescricao,
				substr(obter_nome_medico(b.cd_medico,'N'),1,60) nm_medico,
				CASE WHEN a.ie_suspenso='S' THEN  upper(obter_desc_expressao(298991))  ELSE '' END  ie_suspenso,
				a.dt_suspensao,
				substr(a.ds_motivo_susp,1,80) ds_motivo_susp
		from	material			c,
				prescr_material		a,
				prescr_medica		b
		where	b.nr_prescricao				<> nr_prescricao_p
		and		a.cd_material				= cd_material_p
		and		a.cd_material				= c.cd_material
		and		b.cd_pessoa_fisica			= cd_pessoa_fisica_w
		and		dt_inicio_prescr_w between b.dt_inicio_prescr and b.dt_validade_prescr
		and	  	ie_validade_prescr_w 		= 'C'
		and		a.nr_prescricao				= b.nr_prescricao
		and		(coalesce(b.dt_liberacao, b.dt_liberacao_medico) IS NOT NULL AND (coalesce(b.dt_liberacao, b.dt_liberacao_medico))::text <> '')
		and		coalesce(c.ie_consiste_dupl, 'S') = 'S'
		and		coalesce(a.ie_modificado,'N') 	<> 'S'
		and		((ie_consitir_susp_w		= 'S') or (coalesce(a.ie_suspenso,'N') 	= 'N'))
		and		((ie_consistir_setor_w 		= 'S') or (b.cd_setor_atendimento 	= cd_setor_atendimento_w))		
	) alias38;

BEGIN

select	max(dt_prescricao),
		max(cd_pessoa_fisica),
		max(cd_estabelecimento),
		max(cd_setor_atendimento),
		max(dt_inicio_prescr),
		max(dt_validade_prescr)
into STRICT	dt_prescricao_w,
		cd_pessoa_fisica_w,
		cd_estabelecimento_w,
		cd_setor_atendimento_w,
		dt_inicio_prescr_w,
		dt_validade_prescr_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;

ie_consitir_susp_w := Obter_Param_Usuario(924, 307, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w, ie_consitir_susp_w);
ie_consistir_setor_w := Obter_Param_Usuario(924, 902, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w, ie_consistir_setor_w);
ie_validade_prescr_w := Obter_Param_Usuario(924, 308, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_w, ie_validade_prescr_w);

if (coalesce(ie_validade_prescr_w, 'N') <> 'N') then

	for r_c01_w in C01
	loop
		if (r_c01_w.dt_suspensao IS NOT NULL AND r_c01_w.dt_suspensao::text <> '') then
			ds_retorno_p	:= substr(ds_retorno_p || r_c01_w.ie_suspenso ||
				' '   || obter_desc_expressao(696058) || ': ' || r_c01_w.nr_prescricao || chr(13)|| 
				'   ' || obter_desc_expressao(720297) || ': ' || r_c01_w.nm_medico || chr(13) || 
				'   ' || obter_desc_expressao(312437) || '.: ' || PKG_DATE_FORMATERS.TO_VARCHAR(r_c01_w.dt_suspensao, 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p) || chr(13) ||
				'   ' || obter_desc_expressao(707599) || ': ' || r_c01_w.ds_motivo_susp || chr(10) || chr(13) || chr(13),1,255);
		else
			ds_retorno_p	:= substr(ds_retorno_p || r_c01_w.ie_suspenso || ' ' || r_c01_w.nr_prescricao || ' ' || r_c01_w.nm_medico  || chr(10) || chr(13),1,255);
		end if;
	end loop;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE verifica_medic_dupl_dia ( cd_material_p bigint, nr_prescricao_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;

