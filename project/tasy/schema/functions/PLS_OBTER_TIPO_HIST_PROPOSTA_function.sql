-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_tipo_hist_proposta ( nr_seq_tipo_hist_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*	ie_opcao_p
D - Histórico da proposta
*/
ds_tipo_w			pls_tipo_hist_prop.ds_tipo%type;


BEGIN

if (ie_opcao_p = 'D') then
	select	ds_tipo
	into STRICT	ds_tipo_w
	from	pls_tipo_hist_prop
	where	nr_sequencia = nr_seq_tipo_hist_p;
end if;

return	ds_tipo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_tipo_hist_proposta ( nr_seq_tipo_hist_p bigint, ie_opcao_p text) FROM PUBLIC;

