-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_faixa_etaria ( qt_idade_p bigint, nr_tipo_faixa_etaria_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/* ie_opcao_p
	S = Sequência
	D = Descrição do ítem */
ds_retorno_w			varchar(255);
nr_seq_faixa_etaria_w		bigint;
ds_faixa_w			varchar(255);


BEGIN

select	max(b.nr_sequencia)
into STRICT	nr_seq_faixa_etaria_w
from	pls_faixa_etaria a,
	pls_faixa_etaria_item b
where	a.nr_sequencia	= b.nr_seq_faixa_etaria
and	qt_idade_p	between b.qt_idade_inicial and b.qt_idade_final
and	a.nr_sequencia	= nr_tipo_faixa_etaria_p;

if (ie_opcao_p	= 'D') and (coalesce(nr_seq_faixa_etaria_w,0) <> 0) then
	select	'De ' || qt_idade_inicial || ' a ' || qt_idade_final
	into STRICT	ds_faixa_w
	from	pls_faixa_etaria_item
	where	nr_sequencia	= nr_seq_faixa_etaria_w;
end if;

if (ie_opcao_p = 'S') then
	ds_retorno_w	:= to_char(nr_seq_faixa_etaria_w);
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_faixa_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_faixa_etaria ( qt_idade_p bigint, nr_tipo_faixa_etaria_p bigint, ie_opcao_p text) FROM PUBLIC;
