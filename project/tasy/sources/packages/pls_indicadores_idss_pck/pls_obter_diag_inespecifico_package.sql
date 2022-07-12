-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_indicadores_idss_pck.pls_obter_diag_inespecifico ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


	qt_especifico_w		bigint;
	qt_nao_especifico_w	bigint;
						
	
BEGIN
	
	select	count(*)
	into STRICT	qt_nao_especifico_w
	FROM pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_tipo_atendimento t ON (b.nr_seq_tipo_atendimento = t.nr_sequencia)
WHERE a.nr_sequencia = b.nr_seq_protocolo  and ((b.ie_tipo_guia = 5)
	or (t.ie_grupo_evento = 5 or t.ie_internado = 'S')) and pkg_date_utils.start_of(a.dt_mes_competencia, 'MONTH') = pkg_date_utils.start_of(dt_referencia_p, 'MONTH') and exists (	SELECT	1
			from	pls_diagnostico_conta d
			where	d.nr_seq_conta = b.nr_sequencia
			and	substr(cd_doenca,1,1) = 'Z');
	
	select	count(*)
	into STRICT	qt_especifico_w
	FROM pls_protocolo_conta a, pls_conta b
LEFT OUTER JOIN pls_tipo_atendimento t ON (b.nr_seq_tipo_atendimento = t.nr_sequencia)
WHERE a.nr_sequencia = b.nr_seq_protocolo  and ((b.ie_tipo_guia = 5)
	or (t.ie_grupo_evento = 5 or t.ie_internado = 'S')) and pkg_date_utils.start_of(a.dt_mes_competencia, 'MONTH') = pkg_date_utils.start_of(dt_referencia_p, 'MONTH') and exists (	SELECT	1
			from	pls_diagnostico_conta d
			where	d.nr_seq_conta = b.nr_sequencia
			and	substr(cd_doenca,1,1) <> 'Z');
			
	PERFORM set_config('pls_indicadores_idss_pck.vl_total_w', dividir(qt_nao_especifico_w,qt_especifico_w) * 100, false);

	insert into pls_indic_dados(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					cd_grupo,
					cd_indicador,
					dt_competencia,
					vl_indicador)
			values (nextval('pls_indic_dados_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					cd_grupo_p,
					cd_indicador_p,
					dt_referencia_p,
					current_setting('pls_indicadores_idss_pck.vl_total_w')::bigint);

	commit;

	PERFORM set_config('pls_indicadores_idss_pck.vl_div_w', 0, false);
	PERFORM set_config('pls_indicadores_idss_pck.vl_total_w', 0, false);

	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_indicadores_idss_pck.pls_obter_diag_inespecifico ( cd_grupo_p text, cd_indicador_p text, dt_referencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
