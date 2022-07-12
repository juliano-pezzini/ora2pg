-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_arquivo_ame_pck.criar_registros (nr_seq_rem_arq_w pls_ame_lote_rem_arquivo.nr_sequencia%type) AS $body$
BEGIN

	PERFORM set_config('pls_gerar_arquivo_ame_pck.qt_nr_linha_detalhe_w', 0, false);
	PERFORM set_config('pls_gerar_arquivo_ame_pck.qt_nr_linha_w', 0, false);
	PERFORM set_config('pls_gerar_arquivo_ame_pck.nr_linha_w', 0, false);
	
	for i in current_setting('pls_gerar_arquivo_ame_pck.pls_ame_regra_banda_t')::pls_ame_regra_banda_row.first .. current_setting('pls_gerar_arquivo_ame_pck.pls_ame_regra_banda_t')::pls_ame_regra_banda_row.last loop
		begin
		
		if (current_setting('pls_gerar_arquivo_ame_pck.pls_ame_regra_banda_t')::pls_ame_regra_banda_row[i].ie_tipo_banda in (1,4)) then
			CALL pls_gerar_arquivo_ame_pck.criar_cabecalhorodape(nr_seq_rem_arq_w, i);
		else
			criar_detalhe(nr_seq_rem_arq_w, i);
		end if;
		
		end;
	end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_arquivo_ame_pck.criar_registros (nr_seq_rem_arq_w pls_ame_lote_rem_arquivo.nr_sequencia%type) FROM PUBLIC;