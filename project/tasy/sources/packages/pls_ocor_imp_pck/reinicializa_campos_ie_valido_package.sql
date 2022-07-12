-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ocor_imp_pck.reinicializa_campos_ie_valido (nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
BEGIN
-- Reinicializa o valor dos campos ie_valido_temp e ie_excecao para N em todas as situaaaes.

-- Isso a feito apenas por seguranaa, para nao sobrar nenhum registro alterado de forma indevida

update	pls_oc_cta_selecao_imp
set	ie_valido_temp 	= 'N',
	ie_excecao 	= 'N'
where	nr_id_transacao = nr_id_transacao_p;
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ocor_imp_pck.reinicializa_campos_ie_valido (nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;