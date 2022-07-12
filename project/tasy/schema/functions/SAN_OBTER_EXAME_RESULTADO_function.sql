-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_exame_resultado (nr_seq_doacao_p bigint, nr_seq_exame_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w varchar(255);


BEGIN

	select	san_obter_result_exame(b.nr_seq_exame_lote,b.nr_seq_exame)
	into STRICT	ds_retorno_w
	from	san_exame_lote a,
			san_exame_realizado b,
			san_exame c,
			san_doacao d
	where	b.nr_seq_exame_lote = 	a.nr_sequencia
	and		c.nr_sequencia =		b.nr_seq_exame
	and		(san_obter_result_exame(b.nr_seq_exame_lote,b.nr_seq_exame) IS NOT NULL AND (san_obter_result_exame(b.nr_seq_exame_lote,b.nr_seq_exame))::text <> '')
	and		a.nr_seq_doacao = 		d.nr_sequencia
	and		c.nr_sequencia = 		nr_seq_exame_p
	and		a.nr_seq_doacao = 		nr_seq_doacao_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_exame_resultado (nr_seq_doacao_p bigint, nr_seq_exame_p text) FROM PUBLIC;
