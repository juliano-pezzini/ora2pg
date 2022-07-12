-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_bordero_pagamento ( nr_bordero_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



/*

ie_opcao_p
C -> cheque do bordero + cheque bordero titulo
TP -> TIpo de baixa do bordero
*/
nr_cheque_w	varchar(20);
ds_resultado_w	varchar(255);
cd_tipo_baixa_w		bordero_pagamento.cd_tipo_baixa%type;


c01 CURSOR FOR
SELECT	CASE WHEN coalesce(a.nr_cheque::text, '') = '' THEN ''  ELSE a.nr_cheque || ', ' END
from 	cheque b,
	CHEQUE_BORDERO_TITULO a
WHERE	a.nr_seq_cheque	= b.nr_sequencia
and	coalesce(b.dt_cancelamento::text, '') = ''
and	a.nr_bordero	= nr_bordero_p;


BEGIN

select	max(nr_cheque),
		max(cd_tipo_baixa)
into STRICT	nr_cheque_w,
		cd_tipo_baixa_w
from	bordero_pagamento
where	nr_bordero	= nr_bordero_p;

if (ie_opcao_p = 'C') then

	ds_resultado_W	:= nr_cheque_w;

	nr_cheque_w	:= '';

	open c01;
	loop
	fetch c01 into
	        nr_cheque_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

        	ds_resultado_w	:= substr(ds_resultado_w || nr_cheque_w,1,254);

	end loop;
	close c01;

elsif (ie_opcao_p = 'TP') then
	ds_resultado_w :=	to_char(cd_tipo_baixa_w);
end if;

return  ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_bordero_pagamento ( nr_bordero_p bigint, ie_opcao_p text) FROM PUBLIC;

