-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_ficha_disp ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*
Cobertura		'C'
Fixação		'F'
Causa da retirada 	'CR'
Tipo da causa	'TC'
*/
ds_retorno_w	varchar(255);


BEGIN

If (ie_opcao_p = 'C') then

	select ds_tipo_cobertura
	into STRICT   ds_retorno_w
	from   dispositivo_tipo_cobertura
	where  nr_sequencia = nr_sequencia_p;

elsif (ie_opcao_p = 'F') then

	select  ds_fixacao
	into STRICT 	ds_retorno_w
	from	dispositivo_fixacao
	where	nr_sequencia = nr_sequencia_p;

elsif (ie_opcao_p = 'CR') then

	select  ds_causa
	into STRICT 	ds_retorno_w
	from	dispositivo_causa_retirada
	where	nr_sequencia = nr_sequencia_p;

elsif (ie_opcao_p = 'TC') then

	select  obter_valor_dominio(4891,ie_tipo_causa)
	into STRICT 	ds_retorno_w
	from	dispositivo_causa_retirada
	where	nr_sequencia = nr_sequencia_p;

end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_ficha_disp ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

