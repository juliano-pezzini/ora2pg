-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_sincronizar_interv ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_so_proc_setor_usuario_p text, ie_so_interv_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text) AS $body$
DECLARE
				
				 
ds_sep_bv_w		varchar(50);
nr_seq_pe_prescr_w	bigint;
nr_seq_pe_proc_w	bigint;
nr_seq_horario_w	bigint;
ie_status_horario_w	varchar(1);
cd_intervencao_w	varchar(255);
ds_intervencao_w	varchar(255);
ie_acm_sn_w		varchar(1);
cd_intervalo_w		varchar(7);
ds_intervalo_w		varchar(100);
ds_atividades_w		varchar(2000);
ds_comando_update_w	varchar(4000);

 
c01 CURSOR FOR 
SELECT	a.nr_sequencia nr_seq_pe_prescr, 
	c.nr_seq_pe_proc, 
	c.nr_sequencia, 
	substr(obter_status_hor_interv(c.dt_fim_horario,c.dt_suspensao),1,1), 
	c.nr_seq_proc cd_intervencao, 
	y.ds_procedimento ds_recomendacao, 
	obter_se_acm_sn(null,x.ie_se_necessario) ie_acm_sn,		 
	x.cd_intervalo, 
	obter_desc_inf_sae_adep(x.ie_se_necessario,w.ds_prescricao) ds_prescricao, 
	substr(adep_obter_desc_ativ_interv(c.nr_seq_proc),1,2000) ds_atividades 
FROM pe_procedimento y, pe_prescr_proc_hor c, pe_prescricao a, pe_prescr_proc x
LEFT OUTER JOIN intervalo_prescricao w ON (x.cd_intervalo = w.cd_intervalo)
WHERE y.nr_sequencia = x.nr_seq_proc and y.nr_sequencia = c.nr_seq_proc and x.nr_seq_prescr = c.nr_seq_pe_prescr and x.nr_sequencia = c.nr_seq_pe_proc and x.nr_seq_prescr = a.nr_sequencia and c.nr_seq_pe_prescr = a.nr_sequencia and a.nr_atendimento = nr_atendimento_p and a.dt_validade_prescr > dt_validade_limite_p and (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') and coalesce(x.ie_adep,'N') in ('S','M') and ((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = '')) and obter_se_exibir_interv_adep(ie_so_proc_setor_usuario_p, ie_so_interv_setor_usuario_p, x.nr_seq_proc, cd_perfil_p, cd_setor_usuario_p, nm_usuario_p) = 'S' and coalesce(c.ie_situacao,'A') = 'A' and coalesce(a.ie_situacao,'A') <> 'I' and ((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) and ((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = '')) and ((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = '')) and ((ie_regra_inclusao_p = 'S') or 
	 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'SAE', 
																	cd_estabelecimento_p, 
																	cd_setor_usuario_p, 
																	cd_perfil_p, 
																	null, 
																	null, 
																	null, 
																	null, 
																	null, 
																	null, 
																	null, -- nr_prescricao_p. Passei nulo porque criaram o param na adep_obter_regra_inclusao como default null, e não haviam passado nada 
																	null) = 'S')))  -- nr_seq_exame 
  and c.dt_horario = dt_horario_p and ((ie_prescr_setor_p = 'N') or ((ie_prescr_setor_p = 'S') and (a.cd_setor_atendimento = Obter_Unidade_Atendimento(nr_atendimento_p, 'IA', 'CS')))) group by 
	a.nr_sequencia, 
	c.nr_seq_pe_proc, 
	c.nr_sequencia, 
	c.dt_fim_horario, 
	c.dt_suspensao, 
	c.nr_seq_proc, 
	y.ds_procedimento, 
	x.ie_se_necessario, 
	x.cd_intervalo, 
	w.ds_prescricao 
order by 
	c.dt_suspensao;
	

BEGIN 
ds_sep_bv_w := obter_separador_bv;
 
open c01;
loop 
fetch c01 into	nr_seq_pe_prescr_w, 
		nr_seq_pe_proc_w, 
		nr_seq_horario_w, 
		ie_status_horario_w, 
		cd_intervencao_w, 
		ds_intervencao_w, 
		ie_acm_sn_w,		 
		cd_intervalo_w, 
		ds_intervalo_w, 
		ds_atividades_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_comando_update_w	:=	' update w_adep_t ' || 
					' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' || 
					' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' || 
					' ds_diluicao = :ds_atividades ' || 
					' where nm_usuario = :nm_usuario ' || 
					' and ie_tipo_item = :ie_tipo ' || 
					' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' || 
					' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					 
					' and cd_item = :cd_item ' || 
					' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' || 
					' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';
				 
	CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w || 
								'nr_prescricao=' || to_char(nr_seq_pe_prescr_w) || ds_sep_bv_w || 
								'ds_atividades=' || to_char(ds_atividades_w) || ds_sep_bv_w || 
								'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
								'ie_tipo=E' || ds_sep_bv_w || 
								'nr_seq_item='|| to_char(nr_seq_pe_proc_w) || ds_sep_bv_w || 
								'cd_item=' || to_char(cd_intervencao_w) || ds_sep_bv_w || 
								'cd_intervalo=' || cd_intervalo_w || ds_sep_bv_w || 
								'ds_prescricao=' || ds_intervalo_w || ds_sep_bv_w );
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_sincronizar_interv ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_so_proc_setor_usuario_p text, ie_so_interv_setor_usuario_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_setor_p text) FROM PUBLIC;

