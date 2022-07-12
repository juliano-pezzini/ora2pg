-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_reajuste_pck.inserir_regra_copartic () AS $body$
DECLARE


current_setting('pls_reajuste_pck.c01')::CURSOR( CURSOR(	nr_seq_regra_copart_pc		pls_regra_coparticipacao.nr_sequencia%type) FOR
	SELECT	dt_inicio_vigencia,
		dt_fim_vigencia,
		nr_seq_grupo_servico,
		nr_seq_grupo_prestador,
		ie_tipo_guia,
		nr_seq_saida_int,
		nr_seq_saida_int_princ,
		ie_tipo_protocolo,
		nr_seq_tipo_atendimento,
		ie_tipo_atend_tiss,
		cd_procedimento,
		ie_origem_proced,
		nr_seq_prestador, 
		ie_apresentacao
	from	pls_regra_copartic_exce
	where	nr_seq_regra_copartic 	= nr_seq_regra_copart_pc;

C02 CURSOR(	nr_seq_regra_copart_pc		pls_regra_coparticipacao.nr_sequencia%type) FOR
	SELECT	qt_dias_retorno
	from	pls_regra_copartic_retorno
	where	nr_seq_regra_copartic	= nr_seq_regra_copart_pc;

BEGIN
if (tb_nr_seq_regra_copart_w.count > 0) then
	for i in tb_nr_seq_regra_copart_w.first..tb_nr_seq_regra_copart_w.last loop
		begin
		select	nextval('pls_regra_coparticipacao_seq')
		into STRICT	nr_seq_regra_copart_w
		;
		
		insert into pls_regra_coparticipacao(nr_sequencia, dt_atualizacao, nm_usuario,
			dt_atualizacao_nrec, nm_usuario_nrec, dt_inicio_vigencia,
			ie_tipo_atendimento, dt_contrato_de, dt_contrato_ate,
			qt_eventos_minimo, ie_situacao, nr_seq_tipo_coparticipacao,
			tx_coparticipacao, vl_maximo, vl_coparticipacao,
			nr_seq_contrato, nr_seq_lote_reajuste, qt_ocorrencias,
			ie_tipo_ocorrencia, ie_tipo_data_consistencia, ie_reajuste,
			qt_meses_intervalo, nr_seq_plano, nr_seq_prestador,
			nr_seq_tipo_prestador, qt_idade_min, qt_idade_max,
			ie_titularidade, ie_tipo_parentesco, qt_diaria_inicial,
			qt_diaria_final, qt_ocorrencia_grupo_serv, qt_periodo_ocor,
			ie_tipo_periodo_ocor, nr_seq_grupo_serv, ie_incidencia_valor_maximo,
			ie_periodo_valor_maximo, ie_forma_cobr_internacao, ie_ano_calendario_outras_ocor,
			ie_considera_outra_ocor_regra, ie_incidencia_valor_fixo, ie_tipo_incidencia,
			ie_incidencia_proc_mat, dt_fim_vigencia, nr_seq_intercambio,
			cd_procedimento, cd_sistema_anterior, ie_incide_vl_fixo_cta,
			ie_origem_proced, ie_prestador_cooperado, vl_base_min,
			vl_base_max, ie_incidencia_psiquiatria)
		(SELECT	nr_seq_regra_copart_w, clock_timestamp(), nm_usuario_p,
			clock_timestamp(), nm_usuario_p, dt_reajuste_p,
			ie_tipo_atendimento, dt_contrato_de, dt_contrato_ate,
			qt_eventos_minimo, ie_situacao, nr_seq_tipo_coparticipacao,
			tx_coparticipacao, tb_vl_copart_max_copart_w(i), tb_vl_fixo_reajustado_copart_w(i),
			tb_nr_seq_contrato_copart_w(i), tb_nr_seq_lote_reaj_copart_w(i), qt_ocorrencias,
			ie_tipo_ocorrencia, ie_tipo_data_consistencia, ie_reajuste,
			qt_meses_intervalo, nr_seq_plano, nr_seq_prestador,
			nr_seq_tipo_prestador, qt_idade_min, qt_idade_max,
			ie_titularidade, ie_tipo_parentesco, qt_diaria_inicial,
			qt_diaria_final, qt_ocorrencia_grupo_serv, qt_periodo_ocor,
			ie_tipo_periodo_ocor, nr_seq_grupo_serv, ie_incidencia_valor_maximo,
			ie_periodo_valor_maximo, ie_forma_cobr_internacao, ie_ano_calendario_outras_ocor,
			ie_considera_outra_ocor_regra, ie_incidencia_valor_fixo, coalesce(ie_tipo_incidencia,'B'),
			ie_incidencia_proc_mat, dt_fim_vigencia, tb_nr_seq_interc_copart_w(i),
			cd_procedimento, cd_sistema_anterior, ie_incide_vl_fixo_cta, 
			ie_origem_proced, ie_prestador_cooperado, vl_base_min,
			vl_base_max, ie_incidencia_psiquiatria
		from	pls_regra_coparticipacao
		where	nr_sequencia	= tb_nr_seq_regra_copart_w(i));
		
		if (tb_ie_origem_copart_w(i) = 'C') then
			update	pls_regra_coparticipacao
			set	dt_fim_vigencia	= fim_dia(dt_reajuste_p - 1)
			where	nr_sequencia	= tb_nr_seq_regra_copart_w(i);
		end if;
		
		update	pls_reajuste_copartic
		set	nr_seq_regra_gerada	= nr_seq_regra_copart_w
		where	nr_sequencia		= tb_nr_seq_reaj_copart_w(i);
		
		for r_c01_w in current_setting('pls_reajuste_pck.c01')::CURSOR( (tb_nr_seq_regra_copart_w(i)) loop
			begin
			insert into pls_regra_copartic_exce(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_regra_copartic,
					dt_inicio_vigencia, dt_fim_vigencia, nr_seq_grupo_servico,
					nr_seq_grupo_prestador, ie_tipo_guia, nr_seq_saida_int,
					nr_seq_saida_int_princ, ie_tipo_protocolo, nr_seq_tipo_atendimento,
					ie_tipo_atend_tiss, cd_procedimento, ie_origem_proced,
					nr_seq_prestador, ie_apresentacao)
			values (	nextval('pls_regra_copartic_exce_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, nr_seq_regra_copart_w,
					r_c01_w.dt_inicio_vigencia, r_c01_w.dt_fim_vigencia, r_c01_w.nr_seq_grupo_servico,
					r_c01_w.nr_seq_grupo_prestador, r_c01_w.ie_tipo_guia, r_c01_w.nr_seq_saida_int,
					r_c01_w.nr_seq_saida_int_princ, r_c01_w.ie_tipo_protocolo, r_c01_w.nr_seq_tipo_atendimento,
					r_c01_w.ie_tipo_atend_tiss, r_c01_w.cd_procedimento, r_c01_w.ie_origem_proced,
					r_c01_w.nr_seq_prestador, r_c01_w.ie_apresentacao);
			end;
		end loop; --C01
		
		for r_c02_w in c02(tb_nr_seq_regra_copart_w(i)) loop
			begin
			insert into pls_regra_copartic_retorno(	nr_sequencia, dt_atualizacao, nm_usuario,
					dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_regra_copartic,
					qt_dias_retorno)
			values (	nextval('pls_regra_copartic_retorno_seq'), clock_timestamp(), nm_usuario_p,
					clock_timestamp(), nm_usuario_p, nr_seq_regra_copart_w,
					r_c02_w.qt_dias_retorno);
			end;
		end loop; --C02
		end;
	end loop;
end if;

CALL pls_reajuste_pck.limpar_vetor_regra_copart();

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_reajuste_pck.inserir_regra_copartic () FROM PUBLIC;