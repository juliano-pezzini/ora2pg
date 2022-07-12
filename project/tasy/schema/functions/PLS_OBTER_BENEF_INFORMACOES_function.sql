-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_benef_informacoes ( nr_seq_segurado_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*ROTINA UTILIZADA NO RELATORIO CPLS 2136 */

ds_retorno_w	varchar(255) := '';
/*ie_opcao_p */

/*DUR - > Data de utilização recente */

BEGIN

if (coalesce(nr_seq_segurado_p,0) > 0) then

	if (ie_opcao_p = 'DUR') then
		select	to_char( max(dt_emissao),'dd/mm/yyyy')
		into STRICT	ds_retorno_w
		from	pls_conta
		where 	nr_Seq_segurado = nr_seq_segurado_p;
	end if;

end if;
return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_benef_informacoes ( nr_seq_segurado_p bigint, ie_opcao_p text) FROM PUBLIC;

