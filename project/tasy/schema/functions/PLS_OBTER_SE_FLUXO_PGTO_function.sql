-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_fluxo_pgto ( nr_seq_lote_pgto_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
ie_periodo_w			varchar(1)	:='S';
qt_predecessores_w		bigint;
nr_seq_periodo_w		bigint;
nr_fluxo_w			bigint;
nr_fluxo_predecessor_w		bigint;
dt_mes_competencia_w		timestamp;

C01 CURSOR FOR /* Ler todos os periodos de fluxo predecessor ao do lote atual */
	SELECT	nr_fluxo_pgto
	from	pls_periodo_pagamento
	where	nr_fluxo_pgto	<	nr_fluxo_w
	and	coalesce(nr_fluxo_pgto,0) > 0
	and 	ie_tipo_periodo	= '1'
	order by nr_fluxo_pgto;


BEGIN
select 	dt_mes_competencia, /*Obter mes referência do lote*/
	nr_seq_periodo
into STRICT	dt_mes_competencia_w,
	nr_seq_periodo_w
from	pls_lote_pagamento
where	nr_sequencia	= nr_seq_lote_pgto_p;

select	max(a.nr_fluxo_pgto) /* Obter o fluxo do lote de pagamento */
into STRICT	nr_fluxo_w
from	pls_periodo_pagamento	a
where	a.nr_sequencia	= nr_seq_periodo_w;

if (coalesce(nr_fluxo_w::text, '') = '') then /* Se o lote não possui fluxo definido, então retorna vazio */
	ds_retorno_w	:= '';
else
	open C01; /* Verificar se existe fluxo predecessor ao fluxo do lote */
	loop
	fetch C01 into
		nr_fluxo_predecessor_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select 	count(*)
		into STRICT 	qt_predecessores_w
		from 	pls_periodo_pagamento	a,
			pls_lote_pagamento	b
		where	a.nr_fluxo_pgto				= nr_fluxo_predecessor_w
		and	trunc(b.dt_mes_competencia,'month')	= trunc(dt_mes_competencia_w,'month')
		and	a.nr_sequencia				= b.nr_seq_periodo;

		if (qt_predecessores_w  = 0) then
			ie_periodo_w	:= 'N';
		end if;
		end;
	end loop;
	close C01;
end if;

if (ie_periodo_w = 'N') then
	ds_retorno_w	:= 'Não existe um lote de pagamento predecessor para o lote atual!';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_fluxo_pgto ( nr_seq_lote_pgto_p bigint) FROM PUBLIC;
