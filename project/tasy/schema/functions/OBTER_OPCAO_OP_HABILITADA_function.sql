-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_opcao_op_habilitada (ie_opcao_p text, nr_seq_status_op_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(5) := 'N';


BEGIN
if (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	select 	coalesce(max('S'),'N')
	into STRICT 	ds_retorno_w
	from 	regra_opcoes_op
	where 	ie_opcao	= ie_opcao_p
	and 	nr_seq_status 	= nr_seq_status_op_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_opcao_op_habilitada (ie_opcao_p text, nr_seq_status_op_p bigint) FROM PUBLIC;
