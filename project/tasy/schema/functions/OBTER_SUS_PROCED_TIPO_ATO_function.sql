-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sus_proced_tipo_ato (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


nr_sequencia_w	bigint;
ds_retorno_w	varchar(254);

/*
'CS' - Código do tipo de serviço
'CP' - Código do tipo de Ato
'S' - Tipo de serviço
'P' - Tipo de Ato
*/
BEGIN

select	coalesce(min(nr_sequencia), 0)
into STRICT	nr_sequencia_w
from	sus_proced_tipo_ato
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p
and	cd_estabelecimento	= cd_estabelecimento_p;

ds_retorno_w	:= '';
if (nr_sequencia_w > 0) then
	if (ie_opcao_p = 'CS') then
		select	IE_TIPO_SERVICO_SUS
		into STRICT	ds_retorno_w
		from	sus_proced_tipo_ato
		where	nr_sequencia	= nr_sequencia_w;
	elsif (ie_opcao_p = 'CP') then
		select	IE_TIPO_ATO_SUS
		into STRICT	ds_retorno_w
		from	sus_proced_tipo_ato
		where	nr_sequencia	= nr_sequencia_w;
	elsif (ie_opcao_p = 'S') then
		select	obter_valor_dominio(807, IE_TIPO_SERVICO_SUS)
		into STRICT	ds_retorno_w
		from	sus_proced_tipo_ato
		where	nr_sequencia	= nr_sequencia_w;
	elsif (ie_opcao_p = 'P') then
		select	obter_valor_dominio(808, IE_TIPO_ATO_SUS)
		into STRICT	ds_retorno_w
		from	sus_proced_tipo_ato
		where	nr_sequencia	= nr_sequencia_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sus_proced_tipo_ato (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_estabelecimento_p bigint, ie_opcao_p text) FROM PUBLIC;
