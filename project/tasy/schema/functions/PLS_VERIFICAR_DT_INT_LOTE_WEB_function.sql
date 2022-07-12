-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verificar_dt_int_lote_web (nr_seq_protocolo_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1) := 'S';
qt_registros_w		bigint;

/*
ds_retorno_w =
	N = data de geração a analise gerada
	S = pendente
*/
BEGIN

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	select  count(1)
	into STRICT    qt_registros_w
	from    pls_lote_protocolo_conta a,
		pls_protocolo_conta b
	where   a.nr_sequencia = b.nr_seq_lote_conta
	and	b.nr_sequencia = nr_seq_protocolo_p
	and	(a.dt_geracao_analise IS NOT NULL AND a.dt_geracao_analise::text <> '');
elsif (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	select  count(1)
	into STRICT    qt_registros_w
	from    pls_lote_protocolo_conta a,
		pls_protocolo_conta b,
		pls_conta c
	where   a.nr_sequencia = b.nr_seq_lote_conta
	and	b.nr_sequencia = c.nr_seq_protocolo
	and	c.nr_sequencia = nr_seq_conta_p
	and	(a.dt_geracao_analise IS NOT NULL AND a.dt_geracao_analise::text <> '');
elsif (nr_seq_proc_p IS NOT NULL AND nr_seq_proc_p::text <> '') then
	select  count(1)
	into STRICT    qt_registros_w
	from    pls_lote_protocolo_conta a,
		pls_protocolo_conta b,
		pls_conta c,
		pls_conta_proc d
	where   a.nr_sequencia = b.nr_seq_lote_conta
	and	b.nr_sequencia = c.nr_seq_protocolo
	and	c.nr_sequencia = d.nr_seq_conta
	and	d.nr_sequencia = nr_seq_proc_p
	and	(a.dt_geracao_analise IS NOT NULL AND a.dt_geracao_analise::text <> '');
end if;


if (qt_registros_w > 0) then
	ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verificar_dt_int_lote_web (nr_seq_protocolo_p bigint, nr_seq_conta_p bigint, nr_seq_proc_p bigint) FROM PUBLIC;

