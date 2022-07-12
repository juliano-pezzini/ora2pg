-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




CREATE OR REPLACE FUNCTION pls_gerenciar_reembolso_pck.obter_qtde_reg_valido_filtro ( nr_id_transacao_p pls_def_reemb_selecao.nr_id_transacao%type, dados_filtro_p pls_gerenciar_reembolso_pck.dados_filtro) RETURNS integer AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


qt_registro_w 	integer;


BEGIN

select	count(1)
into STRICT	qt_registro_w
from	pls_def_reemb_selecao a
where	a.nr_id_transacao = nr_id_transacao_p
and	a.ie_valido = 'S'
and	nr_seq_filtro = dados_filtro_p.nr_sequencia;

return qt_registro_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_gerenciar_reembolso_pck.obter_qtde_reg_valido_filtro ( nr_id_transacao_p pls_def_reemb_selecao.nr_id_transacao%type, dados_filtro_p pls_gerenciar_reembolso_pck.dados_filtro) FROM PUBLIC;
