-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Rotina responsável pela consistência das inconsistências do lote
CREATE OR REPLACE PROCEDURE pls_gerar_pre_estab_ans_pck.consiste_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_chamada_delphi_p text) AS $body$
DECLARE


dados_inconsistencia_w		dados_inconsistencia;
i				integer := 0;

C01 CURSOR(nr_seq_lote_pc	pls_monitor_tiss_lote.nr_sequencia%type) FOR
	SELECT	cd_cnes,
		nr_seq_prestador,
		cd_cpf_cnpj,
		ie_tipo_ident_prest,
		cd_municipio_ibge_prest,
		vl_total_franquia,
		nr_sequencia,
		nr_registro_operadora_inter
	from	pls_monit_tiss_pre_est_val
	where	nr_seq_lote_monitor = nr_seq_lote_pc;
BEGIN
-- Caso a chamada da rotina seja pelo Delphi, grava o processo executado
if (ie_chamada_delphi_p = 'S') then
	CALL pls_gerar_pre_estab_ans_pck.grava_processo(nr_seq_lote_p, 4, nm_usuario_p);
end if;

-- Exclui as inconsistência lançadas para consistir o lote novamente
for r_C01_w in C01(nr_seq_lote_p) loop

	dados_inconsistencia_w.nr_seq_pre_estab_val(i) := r_C01_w.nr_sequencia;

	if (dados_inconsistencia_w.nr_seq_pre_estab_val.count >= current_setting('pls_gerar_pre_estab_ans_pck.qt_transacao_w')::integer) then
		dados_inconsistencia_w := pls_gerar_pre_estab_ans_pck.limpar_inconsistencias(dados_inconsistencia_w);
	end if;
end loop;

dados_inconsistencia_w := pls_gerar_pre_estab_ans_pck.limpar_inconsistencias(dados_inconsistencia_w);

for r_C01_w in C01(nr_seq_lote_p) loop

	-- Caso seja um lote de franquia tera o prestador informado
	if (r_C01_w.nr_seq_prestador IS NOT NULL AND r_C01_w.nr_seq_prestador::text <> '') then
		-- Se não encontrou CNES
		if (coalesce(r_C01_w.cd_cnes::text, '') = '') then
			dados_inconsistencia_w.nr_seq_pre_estab_val(i) := r_C01_w.nr_sequencia;
			dados_inconsistencia_w.cd_inconsistencia(i) := 'INC033';
			i := i + 1;
		end if;
		-- Se o tipo de prestador não bater com o CPF ou CNPJ
		if	((coalesce(length(r_C01_w.cd_cpf_cnpj),0) <> 14) and (r_C01_w.ie_tipo_ident_prest = '1')) or
			((coalesce(length(r_C01_w.cd_cpf_cnpj),0) <> 11) and (r_C01_w.ie_tipo_ident_prest = '2')) then
			dados_inconsistencia_w.nr_seq_pre_estab_val(i) := r_C01_w.nr_sequencia;
			dados_inconsistencia_w.cd_inconsistencia(i) := 'INC034';
			i := i + 1;
		end if;
		-- Se não tem município IBGE informado
		if (coalesce(r_C01_w.cd_municipio_ibge_prest, '0') = '0') then
			dados_inconsistencia_w.nr_seq_pre_estab_val(i) := r_C01_w.nr_sequencia;
			dados_inconsistencia_w.cd_inconsistencia(i) := 'INC002';
			i := i + 1;
		end if;
	end if;
	-- Se não tem valor da franquia
	if (coalesce(r_C01_w.vl_total_franquia,0) <= 0) then
		dados_inconsistencia_w.nr_seq_pre_estab_val(i) := r_C01_w.nr_sequencia;
		dados_inconsistencia_w.cd_inconsistencia(i) := 'INC035';
		i := i + 1;
	end if;
	-- Se não tem nem prestador nem operadora inforamdo
	if (coalesce(r_C01_w.nr_seq_prestador::text, '') = '') and (coalesce(r_C01_w.nr_registro_operadora_inter::text, '') = '') then
		dados_inconsistencia_w.nr_seq_pre_estab_val(i) := r_C01_w.nr_sequencia;
		dados_inconsistencia_w.cd_inconsistencia(i) := 'INC036';
		i := i + 1;
	end if;
	-- Se alcançou a quantidade de registros, lança as inconsistência
	if (dados_inconsistencia_w.nr_seq_pre_estab_val.count >= current_setting('pls_gerar_pre_estab_ans_pck.qt_transacao_w')::integer) then
		dados_inconsistencia_w := pls_gerar_pre_estab_ans_pck.grava_inconsistencia(dados_inconsistencia_w, nm_usuario_p);
	end if;
end loop;
-- Chama a rotina novamente para caso tenha sobrado registros
dados_inconsistencia_w := pls_gerar_pre_estab_ans_pck.grava_inconsistencia(dados_inconsistencia_w, nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pre_estab_ans_pck.consiste_lote ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_chamada_delphi_p text) FROM PUBLIC;