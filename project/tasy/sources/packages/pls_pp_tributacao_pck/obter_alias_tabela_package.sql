-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_pp_tributacao_pck.obter_alias_tabela (ds_tabela_p text) RETURNS varchar AS $body$
DECLARE


ds_alias_w	varchar(10);


BEGIN

-- retorna o alias que sera utilizado no select de acordo com a tabela

case(ds_tabela_p)

	when 'pls_pp_lote' then
		ds_alias_w := 'lote';

	when 'pls_pp_item_lote' then
		ds_alias_w := 'item';

	when 'pls_pp_prestador_tmp' then
		ds_alias_w := 'prest';

	else
		ds_alias_w := null;
end case;

return ds_alias_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_pp_tributacao_pck.obter_alias_tabela (ds_tabela_p text) FROM PUBLIC;