-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_filtro_ocor_fin_pck.obter_restricao_pagamento ( nr_seq_evento_p pls_pp_rp_filtro_pag.nr_seq_evento%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) AS $body$
DECLARE


ds_restricao_pag_w	varchar(2500);
ds_alias_eve_w		varchar(10);
ds_campos_w		varchar(500);
ds_tabela_w		varchar(200);


BEGIN

ds_restricao_pag_w := null;
ds_campos_w := null;
ds_tabela_w := null;
ds_alias_eve_w := pls_pp_filtro_ocor_fin_pck.obter_alias_tabela('evento');

-- evento
if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then
	ds_restricao_pag_w := ds_restricao_pag_w || ' and ' || ds_alias_eve_w || '.nr_sequencia = :nr_seq_evento_pc' || pls_util_pck.enter_w;
	valor_bind_p := sql_pck.bind_variable(':nr_seq_evento_pc', nr_seq_evento_p, valor_bind_p);
end if;

ds_campos_p := ds_campos_w;
ds_tabela_p := ds_tabela_w;

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_filtro_ocor_fin_pck.obter_restricao_pagamento ( nr_seq_evento_p pls_pp_rp_filtro_pag.nr_seq_evento%type, ds_campos_p out text, ds_tabela_p out text, valor_bind_p INOUT sql_pck.t_dado_bind) FROM PUBLIC;
