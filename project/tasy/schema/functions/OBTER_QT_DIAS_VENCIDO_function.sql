-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_dias_vencido (dt_vencimento_p timestamp, nr_titulo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
dt_liquidacao_w		timestamp;

/*Function criada para ser utilizada na coluna Qt dias vencido da tabela TITULO_RECEBER das visoes 9747 e 6072
Isso pois so usando obter_dias_entre_datas direto na visao, se o titulo n esta vencido retornava um valor negativo*/
BEGIN

if (dt_vencimento_p IS NOT NULL AND dt_vencimento_p::text <> '') and (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then

	begin

	select	max(a.dt_liquidacao)
	into STRICT	dt_liquidacao_w
	from	titulo_receber a
	where	a.nr_titulo = nr_titulo_p;


	if (coalesce(dt_liquidacao_w::text, '') = '') then /*somente tratar para titulos nao liquidados, quando o titulo ja estiver liquidado, nao deve apresentar quantidade de dias vencidos*/
		ds_retorno_w:= substr(to_char(obter_dias_entre_datas(dt_vencimento_p, clock_timestamp())),1,10);

		if (ds_retorno_w < 0) then /*se no estiver vencido ainda, retorna negativo, e se for, deve substituir por 0*/
			ds_retorno_w := 0;

		end if;

	elsif (dt_liquidacao_w IS NOT NULL AND dt_liquidacao_w::text <> '') then

		ds_retorno_w:= substr(to_char(obter_dias_entre_datas(dt_vencimento_p, dt_liquidacao_w)),1,10);

		if (ds_retorno_w < 0) then /*se no estiver vencido ainda, retorna negativo, e se for, deve substituir por 0*/
			ds_retorno_w := 0;

		end if;

	end if;

	exception when others then
		ds_retorno_w := null;
	end;

end if;

return	substr(ds_retorno_w,1,254);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_dias_vencido (dt_vencimento_p timestamp, nr_titulo_p bigint) FROM PUBLIC;
