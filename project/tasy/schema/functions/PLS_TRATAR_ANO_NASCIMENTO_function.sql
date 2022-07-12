-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_tratar_ano_nascimento (dt_ano_nascimento_p timestamp) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: converte um ano que está no formato 'dd/mm/yy' para 'dd/mm/yyyy'. se o ano da data passada por
parametro for maior que o ano atual, o mesmo é decrementado em 100, evitando que seja transformado em uma data futura.
Exemplo:
	to_date('01/01/48','dd/mm/rrrr'); --retorna 01/01/2048
	pls_tratar_ano_nascimento(to_date('01/01/48','dd/mm/rrrr')); --retorna 01/01/1948
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_ano_w		smallint;
ds_mes_dia_w	varchar(5);
ds_retorno_w	varchar(10);


BEGIN

ds_mes_dia_w := to_char(dt_ano_nascimento_p, 'dd/mm');

nr_ano_w := extract(year from to_date(dt_ano_nascimento_p, 'dd/mm/rrrr'));

if (nr_ano_w > (to_char(clock_timestamp(), 'yyyy'))::numeric ) then
	nr_ano_w := nr_ano_w - 100;
end if;

ds_retorno_w := ds_mes_dia_w||'/'||to_char(nr_ano_w);

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_tratar_ano_nascimento (dt_ano_nascimento_p timestamp) FROM PUBLIC;

