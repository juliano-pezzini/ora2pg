-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_contagem_liberada ( nr_seq_registro_p bigint, nr_seq_inspecao_p bigint, nr_seq_contagem_p bigint) RETURNS varchar AS $body$
DECLARE


/* nr_seq_contagem_p
1 -  Contagem 1
2 -  Contagem 2
*/
qt_existe_w		bigint;
ds_retorno_w		varchar(1)  := 'N';
dt_liberacao_w		timestamp 	    := null;


BEGIN

begin
	select	count(*)
	into STRICT	qt_existe_w
	from	inspecao_contagem
	where	nr_seq_registro = nr_seq_registro_p
	and	nr_seq_inspecao = nr_seq_inspecao_p
	and	nr_seq_contagem = nr_seq_contagem_p;

	if (qt_existe_w > 0) then
		select	dt_liberacao
		into STRICT	dt_liberacao_w
		from	inspecao_contagem
		where	nr_seq_registro = nr_seq_registro_p
		and	nr_seq_inspecao = nr_seq_inspecao_p
		and	nr_seq_contagem = nr_seq_contagem_p;
	else
		ds_retorno_w := 'N';
	end if;
exception
when others then
	dt_liberacao_w := null;
end;

if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_contagem_liberada ( nr_seq_registro_p bigint, nr_seq_inspecao_p bigint, nr_seq_contagem_p bigint) FROM PUBLIC;

