-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_filtro_prod_medica_pck.atualizar_lista_filtro ( tb_nr_seq_selecao_p pls_util_cta_pck.t_number_table, ie_valido_p pls_pp_rp_cta_selecao.ie_valido%type) AS $body$
BEGIN

-- se tiver registro manda para o banco
if (tb_nr_seq_selecao_p.count > 0) then
	forall i in tb_nr_seq_selecao_p.first..tb_nr_seq_selecao_p.last
		update	pls_pp_rp_cta_selecao
		set	ie_valido_temp = ie_valido_p
		where	nr_sequencia = tb_nr_seq_selecao_p(i);
	commit;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_filtro_prod_medica_pck.atualizar_lista_filtro ( tb_nr_seq_selecao_p pls_util_cta_pck.t_number_table, ie_valido_p pls_pp_rp_cta_selecao.ie_valido%type) FROM PUBLIC;
