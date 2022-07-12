-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_filtro_rec_glosa_pck.limpar_transacao (nr_id_transacao_p pls_pp_cta_rec_selecao.nr_id_transacao%type) AS $body$
BEGIN

delete	from pls_pp_cta_rec_selecao
where	nr_id_transacao = nr_id_transacao_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_filtro_rec_glosa_pck.limpar_transacao (nr_id_transacao_p pls_pp_cta_rec_selecao.nr_id_transacao%type) FROM PUBLIC;
