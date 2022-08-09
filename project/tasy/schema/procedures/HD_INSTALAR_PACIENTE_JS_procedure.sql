-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_instalar_paciente_js ( nr_seq_dialise_p bigint, qt_pa_sist_pre_pe_p bigint, qt_pa_diast_pre_pe_p bigint, qt_pa_sist_pre_deit_p bigint, qt_pa_diast_pre_deit_p bigint, qt_peso_pre_p bigint, qt_peso_ideal_p bigint, nr_seq_acesso_p bigint, cd_estabelecimento_p bigint, dt_instalacao_p timestamp, nr_seq_motivo_peso_pre_p text, nr_seq_motivo_pa_deitado_pre_p text, nr_seq_motivo_pa_pe_pre_p text, qt_soro_reposicao_p bigint, qt_soro_devolucao_p bigint, nr_seq_tipo_soro_p bigint, qt_freq_resp_pre_p bigint, qt_glicemia_capilar_pre_p bigint, qt_saturacao_o2_pre_p bigint, qt_insulina_pre_p bigint, qt_glicose_adm_pre_p bigint, cd_escala_dor_p text, qt_escala_dor_p bigint, nr_seq_result_dor_p bigint, nr_seq_topografia_dor_p bigint, ie_lado_p text, ie_tipo_dor_p text, nr_seq_condicao_dor_p bigint, nr_seq_inapto_dor_p bigint, ie_frequencia_dor_p text, qt_periodo_p bigint, ie_periodo_p text, ie_etapa_dialise_p text, nr_atendimento_p bigint, nr_seq_sinal_vital_pe_p INOUT bigint, nr_seq_sinal_vital_sent_p INOUT bigint, qt_temp_auxiliar_pre_p bigint, qt_freq_cardiaca_pre_p bigint, nm_usuario_p text, ds_erro_p INOUT text, ds_observacao_p text) AS $body$
DECLARE

			
nr_pos  integer := 0;
						

BEGIN
	
	ds_erro_p := HD_Instalar_Paciente(	nr_seq_dialise_p, qt_pa_sist_pre_pe_p, qt_pa_diast_pre_pe_p, qt_pa_sist_pre_deit_p, qt_pa_diast_pre_deit_p, qt_peso_pre_p, qt_peso_ideal_p, nr_seq_acesso_p, cd_estabelecimento_p, dt_instalacao_p, nr_seq_motivo_peso_pre_p, nr_seq_motivo_pa_deitado_pre_p, nr_seq_motivo_pa_pe_pre_p, qt_soro_reposicao_p, qt_soro_devolucao_p, nr_seq_tipo_soro_p, qt_freq_resp_pre_p, qt_glicemia_capilar_pre_p, qt_saturacao_o2_pre_p, qt_insulina_pre_p, qt_glicose_adm_pre_p, 'N', qt_temp_auxiliar_pre_p, qt_freq_cardiaca_pre_p, nm_usuario_p, ds_erro_p);
				
	begin -- OS 1070724, alteração expressa por: alcornetet
	
	CALL novo_hd_escala_dor(	nr_seq_dialise_p,
				cd_escala_dor_p,
				qt_escala_dor_p,
				nr_seq_result_dor_p,
				nr_seq_topografia_dor_p,
				ie_lado_p,
				ie_tipo_dor_p,
				nr_seq_condicao_dor_p,
				nr_seq_inapto_dor_p,
				ie_frequencia_dor_p,
				qt_periodo_p,
				ie_periodo_p,
				ie_etapa_dialise_p,
				'N',
				nm_usuario_p,
				ds_observacao_p);

	if (qt_pa_sist_pre_pe_p <> 0) or (qt_pa_diast_pre_pe_p <> 0) then
		nr_seq_sinal_vital_pe_p := hd_inserir_sinal_vital(	nr_atendimento_p, qt_pa_sist_pre_pe_p, qt_pa_diast_pre_pe_p, qt_peso_pre_p, qt_freq_resp_pre_p, qt_glicemia_capilar_pre_p, qt_saturacao_o2_pre_p, qt_insulina_pre_p, qt_glicose_adm_pre_p, cd_escala_dor_p, qt_escala_dor_p, nr_seq_result_dor_p, nr_seq_topografia_dor_p, ie_lado_p, ie_tipo_dor_p, nr_seq_condicao_dor_p, nr_seq_inapto_dor_p, ie_frequencia_dor_p, qt_periodo_p, 'S', 'N', ie_periodo_p, 'N', qt_temp_auxiliar_pre_p, qt_freq_cardiaca_pre_p, dt_instalacao_p, nr_seq_sinal_vital_pe_p, nm_usuario_p, ds_observacao_p);
	end if;

	nr_seq_sinal_vital_sent_p := hd_inserir_sinal_vital(	nr_atendimento_p, qt_pa_sist_pre_deit_p, qt_pa_diast_pre_deit_p, qt_peso_pre_p, qt_freq_resp_pre_p, qt_glicemia_capilar_pre_p, qt_saturacao_o2_pre_p, qt_insulina_pre_p, qt_glicose_adm_pre_p, cd_escala_dor_p, qt_escala_dor_p, nr_seq_result_dor_p, nr_seq_topografia_dor_p, ie_lado_p, ie_tipo_dor_p, nr_seq_condicao_dor_p, nr_seq_inapto_dor_p, ie_frequencia_dor_p, qt_periodo_p, 'S', 'S', ie_periodo_p, 'N', qt_temp_auxiliar_pre_p, qt_freq_cardiaca_pre_p, dt_instalacao_p, nr_seq_sinal_vital_sent_p, nm_usuario_p, ds_observacao_p);
	exception
	when others then
		if (coalesce(ds_erro_p::text, '') = '') or (ds_erro_p = '') then
			
			ds_erro_p := SQLERRM(-20011);
			
			SELECT 	INSTR(ds_erro_p,'#@#@', 1, 1)
			into STRICT 	nr_pos 
			;	
			
			if (nr_pos <> 0)then
				
				select	substr(ds_erro_p, 1, nr_pos) 			
				into STRICT 	ds_erro_p
				;
				
				ds_erro_p := ds_erro_p ||  chr(10) || wheb_mensagem_pck.get_texto(446137);
			
			end if;
		
			commit;
			
		end if;
	end;

if (coalesce(ds_erro_p::text, '') = '') or (ds_erro_p = '') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_instalar_paciente_js ( nr_seq_dialise_p bigint, qt_pa_sist_pre_pe_p bigint, qt_pa_diast_pre_pe_p bigint, qt_pa_sist_pre_deit_p bigint, qt_pa_diast_pre_deit_p bigint, qt_peso_pre_p bigint, qt_peso_ideal_p bigint, nr_seq_acesso_p bigint, cd_estabelecimento_p bigint, dt_instalacao_p timestamp, nr_seq_motivo_peso_pre_p text, nr_seq_motivo_pa_deitado_pre_p text, nr_seq_motivo_pa_pe_pre_p text, qt_soro_reposicao_p bigint, qt_soro_devolucao_p bigint, nr_seq_tipo_soro_p bigint, qt_freq_resp_pre_p bigint, qt_glicemia_capilar_pre_p bigint, qt_saturacao_o2_pre_p bigint, qt_insulina_pre_p bigint, qt_glicose_adm_pre_p bigint, cd_escala_dor_p text, qt_escala_dor_p bigint, nr_seq_result_dor_p bigint, nr_seq_topografia_dor_p bigint, ie_lado_p text, ie_tipo_dor_p text, nr_seq_condicao_dor_p bigint, nr_seq_inapto_dor_p bigint, ie_frequencia_dor_p text, qt_periodo_p bigint, ie_periodo_p text, ie_etapa_dialise_p text, nr_atendimento_p bigint, nr_seq_sinal_vital_pe_p INOUT bigint, nr_seq_sinal_vital_sent_p INOUT bigint, qt_temp_auxiliar_pre_p bigint, qt_freq_cardiaca_pre_p bigint, nm_usuario_p text, ds_erro_p INOUT text, ds_observacao_p text) FROM PUBLIC;
