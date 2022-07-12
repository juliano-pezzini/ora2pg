-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_desc_estagio_proc ( nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w				varchar(80);
nr_seq_estagio_w			bigint;


BEGIN
if (nr_seq_ordem_p IS NOT NULL AND nr_seq_ordem_p::text <> '') then
	select	max(nr_seq_estagio)
	into STRICT	nr_seq_estagio_w
	from 	man_ordem_servico
	where	nr_sequencia = nr_seq_ordem_p;

	select	obter_desc_expressao(cd_exp_estagio, ds_estagio)
	into STRICT	ds_retorno_w
	from	man_estagio_processo
	where	nr_sequencia	= nr_seq_estagio_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_desc_estagio_proc ( nr_seq_ordem_p bigint) FROM PUBLIC;

