-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_se_item_reval_adep ( nr_seq_cpoe_p bigint, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(1) := 'N';
nr_seq_reval_rule_w		cpoe_revalidation_rule.nr_sequencia%type;
ie_desc_horas_ant_w		parametro_medico.ie_desc_horas_ant%type;
ie_horas_anterior_w		varchar(1) := 'N';
qt_hors_copia_w			integer;


BEGIN

if (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '' AND ie_tipo_item_p IS NOT NULL AND ie_tipo_item_p::text <> '') then

	nr_seq_reval_rule_w := cpoe_obter_seq_reval_rule(nr_seq_cpoe_p, ie_tipo_item_p);
	qt_hors_copia_w 	:= get_qt_hours_after_copy_cpoe(cd_perfil_p => wheb_usuario_pck.get_cd_perfil,
														nm_usuario_p => wheb_usuario_pck.get_nm_usuario,
														cd_estabelecimento_p => wheb_usuario_pck.get_cd_estabelecimento);

	select	coalesce(max(ie_desc_horas_ant),'N')
	into STRICT	ie_desc_horas_ant_w
	from	parametro_medico
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

	if (ie_desc_horas_ant_w = 'N') then
		ie_horas_anterior_w := 'S';
	end if;

	if ((nr_seq_reval_rule_w IS NOT NULL AND nr_seq_reval_rule_w::text <> '') and nr_seq_reval_rule_w > 0) then

		if (ie_tipo_item_p = 'N') then
			
			select	coalesce(max('S'), 'N')
			into STRICT	ds_retorno_w
			from	cpoe_dieta
			where nr_sequencia = nr_seq_cpoe_p
			and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
			and	coalesce(cd_funcao_origem, 2314) = 2314
			and cpoe_obter_data_prox_reval(nr_sequencia, 'N', ie_horas_anterior_w) < clock_timestamp()
			and coalesce(CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE Obter_Data_Menor(dt_suspensao,dt_fim) END , clock_timestamp() + interval '1 days') > (clock_timestamp() + (1/24))
			and obter_se_medico(obter_pf_usuario(nm_usuario_nrec, 'C'), 'M') = 'S'
			and	((cpoe_obter_se_copia_item_term(ds_horarios, cd_intervalo, dt_prox_geracao + (qt_hors_copia_w/24), CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao, dt_fim) END ) = 'S')
				or ((coalesce(dt_fim::text, '') = '') and ie_duracao = 'C'));

		elsif (ie_tipo_item_p = 'D' or ie_tipo_item_p = 'DI' or ie_tipo_item_p = 'DP') then

			select	coalesce(max('S'), 'N')
			into STRICT	ds_retorno_w
			from	cpoe_dialise
			where nr_sequencia = nr_seq_cpoe_p
			and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
			and	coalesce(cd_funcao_origem, 2314) = 2314
			and cpoe_obter_data_prox_reval(nr_sequencia, 'D', ie_horas_anterior_w) < clock_timestamp() 
			and coalesce(CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE Obter_Data_Menor(dt_suspensao,dt_fim) END , clock_timestamp() + interval '1 days') > (clock_timestamp() + (1/24))
			and obter_se_medico(obter_pf_usuario(nm_usuario_nrec, 'C'), 'M') = 'S'
			and	((cpoe_obter_se_copia_item_term(ds_horarios, null, dt_prox_geracao + (qt_hors_copia_w/24), CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao, dt_fim) END ) = 'S')
				or ((coalesce(dt_fim::text, '') = '') and ie_duracao = 'C'));

		elsif (ie_tipo_item_p = 'G') then

			select	coalesce(max('S'), 'N')
			into STRICT	ds_retorno_w
			from	cpoe_gasoterapia
			where nr_sequencia = nr_seq_cpoe_p
			and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
			and	coalesce(cd_funcao_origem, 2314) = 2314
			and cpoe_obter_data_prox_reval(nr_sequencia, 'G', ie_horas_anterior_w) < clock_timestamp() 
			and coalesce(CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE Obter_Data_Menor(dt_suspensao,dt_fim) END , clock_timestamp() + interval '1 days') > (clock_timestamp() + (1/24))
			and obter_se_medico(obter_pf_usuario(nm_usuario_nrec, 'C'), 'M') = 'S'
			and	((cpoe_obter_se_copia_item_term(ds_horarios, cd_intervalo, dt_prox_geracao + (qt_hors_copia_w/24), CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao, dt_fim) END ) = 'S')
				or ((coalesce(dt_fim::text, '') = '') and ie_duracao = 'C'));

		elsif (ie_tipo_item_p = 'M') then

			select	coalesce(max('S'), 'N')
			into STRICT	ds_retorno_w
			from cpoe_material
			where nr_sequencia = nr_seq_cpoe_p
			and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
			and	coalesce(cd_funcao_origem, 2314) = 2314
			and cpoe_obter_data_prox_reval(nr_sequencia, 'M', ie_horas_anterior_w) < clock_timestamp() 
			and  coalesce(ie_material, 'N') = 'N'
			and coalesce(CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih,dt_fim)  ELSE Obter_Data_Menor(dt_suspensao,dt_fim) END , clock_timestamp() + interval '1 days') > (clock_timestamp() + (1/24))
			and obter_se_medico(obter_pf_usuario(nm_usuario_nrec, 'C'), 'M') = 'S'
			and	((cpoe_obter_se_copia_item_term(ds_horarios, cd_intervalo, dt_prox_geracao + (qt_hors_copia_w/24), CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih, dt_fim)  ELSE coalesce(dt_suspensao, dt_fim) END ) = 'S')
				or ((coalesce(dt_fim::text, '') = '') and ie_duracao = 'C'));

		elsif (ie_tipo_item_p = 'R') then
			
			select	coalesce(max('S'), 'N')
			into STRICT	ds_retorno_w
			from	cpoe_recomendacao
			where nr_sequencia = nr_seq_cpoe_p
			and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
			and	coalesce(cd_funcao_origem, 2314) = 2314
			and cpoe_obter_data_prox_reval(nr_sequencia, 'R', ie_horas_anterior_w) < clock_timestamp() 
			and coalesce(CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE Obter_Data_Menor(dt_suspensao,dt_fim) END , clock_timestamp() + interval '1 days') > (clock_timestamp() + (1/24))
			and obter_se_medico(obter_pf_usuario(nm_usuario_nrec, 'C'), 'M') = 'S'
			and	((cpoe_obter_se_copia_item_term(ds_horarios, cd_intervalo, dt_prox_geracao + (qt_hors_copia_w/24), CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao, dt_fim) END ) = 'S')
				or ((coalesce(dt_fim::text, '') = '') and ie_duracao = 'C'));

		elsif (ie_tipo_item_p = 'P') then

			select	coalesce(max('S'), 'N')
			into STRICT	ds_retorno_w
			from	cpoe_procedimento
			where nr_sequencia = nr_seq_cpoe_p 
			and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
			and	coalesce(cd_funcao_origem, 2314) = 2314
			and cpoe_obter_data_prox_reval(nr_sequencia, 'P', ie_horas_anterior_w) < clock_timestamp() 
			and coalesce(CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE Obter_Data_Menor(dt_suspensao,dt_fim) END , clock_timestamp() + interval '1 days') > (clock_timestamp() + (1/24))
			and obter_se_medico(obter_pf_usuario(nm_usuario_nrec, 'C'), 'M') = 'S'
			and	((cpoe_obter_se_copia_item_term(ds_horarios, cd_intervalo, dt_prox_geracao + (qt_hors_copia_w/24), CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao, dt_fim) END ) = 'S')
				or ((coalesce(dt_fim::text, '') = '') and ie_duracao = 'C'));

		end if;
	end if;
end if;

	return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_se_item_reval_adep ( nr_seq_cpoe_p bigint, ie_tipo_item_p text) FROM PUBLIC;
