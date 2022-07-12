-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_pag_item (nr_seq_pagamento_item_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
	'LP' - Número do lote de pagamento
*/
nr_seq_pagamento_w		bigint;
ds_retorno_w			varchar(255) := '';


BEGIN

select	max(nr_seq_pagamento)
into STRICT	nr_seq_pagamento_w
from	pls_pagamento_item
where	nr_sequencia	= nr_seq_pagamento_item_p;

if (ie_opcao_p	= 'LP') then
	select	max(nr_seq_lote)
	into STRICT	ds_retorno_w
	from	pls_pagamento_prestador
	where	nr_sequencia	= nr_seq_pagamento_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_pag_item (nr_seq_pagamento_item_p bigint, ie_opcao_p text) FROM PUBLIC;

