-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_pendencia_pep ( nr_sequencia_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
Código	C
Descrição 	D
*/
ie_pendencia_w	varchar(2);
ds_retorno_w	varchar(100);


BEGIN

select 	coalesce(max(ie_tipo_pendencia),'L')
into STRICT	ie_pendencia_w
from 	pep_item_pendente
where 	nr_sequencia = nr_sequencia_p;

If (ie_opcao_p	= 'C') then
	ds_retorno_w := ie_pendencia_w;
else
	Select 	CASE WHEN ie_pendencia_w='L' THEN obter_desc_expressao(292540)  ELSE obter_desc_expressao(283825) END
	into STRICT	ds_retorno_w
	;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_pendencia_pep ( nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

