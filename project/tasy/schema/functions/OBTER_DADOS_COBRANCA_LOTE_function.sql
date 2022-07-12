-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_cobranca_lote ( nr_seq_lote_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
IMP - Maior data de impressão do lote.
*/
ds_retorno_w	varchar(255);


BEGIN

if (ie_opcao_p = 'IMP') then
	select	coalesce(max(dt_atualizacao), '')
	into STRICT	ds_retorno_w
	from	cobranca_paciente_imp
	where	nr_seq_lote = nr_seq_lote_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_cobranca_lote ( nr_seq_lote_p bigint, ie_opcao_p text) FROM PUBLIC;
