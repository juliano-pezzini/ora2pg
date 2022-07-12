-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_apropriacao_pck.atualiza_campo_valido (nr_id_transacao_p pls_pp_rp_aprop_selecao.nr_id_transacao%type, nr_seq_filtro_p pls_pp_rp_cta_filtro.nr_sequencia%type, ie_excecao_p pls_pp_rp_cta_filtro.ie_excecao%type) AS $body$
BEGIN

-- nunca pode entrar aqui quando for exceção de qualquer maneira
if (ie_excecao_p = 'N') then
	-- filtro bom em regra boa usa os campos ie_valido e ie_valido_temp
	update	pls_pp_rp_aprop_selecao
	set	ie_valido = 'N'
	where	nr_id_transacao = nr_id_transacao_p
	and	nr_seq_filtro = nr_seq_filtro_p
	and	ie_valido_temp = 'N';
	
else	-- coloca ie_excecao = N para todos os registros que não casaram com nenhum filtro
	update	pls_pp_rp_aprop_selecao
	set	ie_excecao = 'N'
	where	nr_id_transacao = nr_id_transacao_p
	and	ie_excecao = 'S'
	and	ie_valido_temp = 'N';
end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_apropriacao_pck.atualiza_campo_valido (nr_id_transacao_p pls_pp_rp_aprop_selecao.nr_id_transacao%type, nr_seq_filtro_p pls_pp_rp_cta_filtro.nr_sequencia%type, ie_excecao_p pls_pp_rp_cta_filtro.ie_excecao%type) FROM PUBLIC;
