-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_tit_nota_credito ( nr_titulo_p bigint, ie_opcao_p text, nr_sequencia_p bigint default null) RETURNS varchar AS $body$
DECLARE

/* ie_opcao_p
'QTD' = Número de notas de crédito que possuem o título vinculado;
'SNC' = nr Sequencia Notas de Crédito vinculadas ao título;

*/
ds_retorno_w		varchar(255);
nr_sequencia_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	nota_credito
	where	nr_titulo_receber	= nr_titulo_p
	and		nr_sequencia		<> nr_sequencia_p;


BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	if (ie_opcao_p = 'QTD') then
		select	count(*)
		into STRICT	ds_retorno_w
		from	nota_credito
		where	nr_titulo_receber	= nr_titulo_p
		and		nr_sequencia		<> nr_sequencia_p;
	end if;

	if (ie_opcao_p = 'SNC') then
		open C01;
		loop
		fetch C01 into
			nr_sequencia_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			ds_retorno_w	:= substr(ds_retorno_w || to_char(nr_sequencia_w) || ', ',1,255);
			end;
		end loop;
		close C01;
	end if;

end if;

if (ie_opcao_p = 'SNC') then
	return substr(ds_retorno_w,1,length(ds_retorno_w)-2);
else
	return ds_retorno_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_tit_nota_credito ( nr_titulo_p bigint, ie_opcao_p text, nr_sequencia_p bigint default null) FROM PUBLIC;

