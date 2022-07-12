-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_metodo_pago (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(2000);
nr_count_w	bigint;
cd_tipo_recebimento_w   varchar(10);

C01 CURSOR FOR
SELECT  adiciona_zeros_esquerda(b.cd_tipo_recebimento,2)
from	nota_fiscal a,
        fis_metodo_pagamento b
where	a.nr_sequencia = b.nr_seq_nota
and     a.nr_sequencia = nr_sequencia_p
order by b.nr_sequencia;


BEGIN

ds_retorno_w := '';
nr_count_w := 0;

open	c01;
loop
fetch	c01 into
	cd_tipo_recebimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	nr_count_w := nr_count_w + 1;

	if (nr_count_w = 1) then
		ds_retorno_w := ds_retorno_w || to_char(cd_tipo_recebimento_w);
	else
		ds_retorno_w := ds_retorno_w ||','|| to_char(cd_tipo_recebimento_w);
	end if;

	end;
	end loop;
	close c01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_metodo_pago (nr_sequencia_p bigint) FROM PUBLIC;
