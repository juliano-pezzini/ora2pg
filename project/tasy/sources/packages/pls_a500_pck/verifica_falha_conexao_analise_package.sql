-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_a500_pck.verifica_falha_conexao_analise () AS $body$
DECLARE


c01 CURSOR FOR
	SELECT	f.nr_sequencia nr_seq_fatura,
		f.cd_estabelecimento,
		f.nm_usuario,
		f.ds_sid_processo,
		f.ds_serial_processo
	from	ptu_fatura f,
		ptu_processo_fatura p
	where	f.nr_sequencia		= p.nr_seq_fatura
	and	p.ie_tipo_processo	= 'GA'
	and	p.ie_status_processo	= 'PR'
	and	f.ie_status		= 'EI'
	and	(p.dt_inicio IS NOT NULL AND p.dt_inicio::text <> '')
	and	coalesce(p.dt_fim::text, '') = '';

BEGIN

for r_c01_w in c01 loop
	if (pls_util_pck.obter_se_sessao_ativa(r_c01_w.ds_sid_processo, r_c01_w.ds_serial_processo) = 'N') then
		-- Grava o log atual com o erro

		CALL pls_a500_pck.gerar_log_imp_a500( r_c01_w.nr_seq_fatura, 'GA', 'FA', r_c01_w.nm_usuario, clock_timestamp(), null, 'Falha na geracao de analise, conexao perdida.', 'S');
	
		-- Invalida a fatura

		CALL pls_a500_pck.invalida_fat_a500( r_c01_w.nr_seq_fatura, 'S', r_c01_w.cd_estabelecimento, r_c01_w.nm_usuario);
	end if;
end loop;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_a500_pck.verifica_falha_conexao_analise () FROM PUBLIC;