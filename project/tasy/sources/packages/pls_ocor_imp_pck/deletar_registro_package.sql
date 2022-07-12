-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ocor_imp_pck.deletar_registro ( ie_proc_mat_p text, dados_tabela_aux_val_limit_p pls_ocor_imp_pck.dados_tabela_aux_val_limit) AS $body$
BEGIN

-- Deve ser verificado se a por procedimento ou por material para que se tenha certeza de que esta sendo deletada a linha correta

-- e seja acessado a tabela pelos campos corretos e nao fique sendo verificado nas restriaaes do delete pois tende a ser mais custoso.

-- Procedimento

if (ie_proc_mat_p = 'P') then

	-- Apaga o registro selecionado.

	delete	FROM pls_oc_cta_val_limit_aux
	where	nr_id_transacao		= dados_tabela_aux_val_limit_p.nr_id_transacao
	and	nr_seq_tipo_limitacao	= dados_tabela_aux_val_limit_p.nr_seq_tipo_limitacao
	and	nr_seq_segurado		= dados_tabela_aux_val_limit_p.nr_seq_segurado
	and	nr_seq_conta		= dados_tabela_aux_val_limit_p.nr_seq_conta
	and	nr_seq_conta_proc	= dados_tabela_aux_val_limit_p.nr_seq_conta_proc;
-- Material

elsif (ie_proc_mat_p = 'M') then

	-- Apaga o registro selecionado.

	delete	FROM pls_oc_cta_val_limit_aux
	where	nr_id_transacao		= dados_tabela_aux_val_limit_p.nr_id_transacao
	and	nr_seq_tipo_limitacao	= dados_tabela_aux_val_limit_p.nr_seq_tipo_limitacao
	and	nr_seq_segurado		= dados_tabela_aux_val_limit_p.nr_seq_segurado
	and	nr_seq_conta		= dados_tabela_aux_val_limit_p.nr_seq_conta
	and	nr_seq_conta_mat	= dados_tabela_aux_val_limit_p.nr_seq_conta_mat;
end if;
commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ocor_imp_pck.deletar_registro ( ie_proc_mat_p text, dados_tabela_aux_val_limit_p pls_ocor_imp_pck.dados_tabela_aux_val_limit) FROM PUBLIC;
