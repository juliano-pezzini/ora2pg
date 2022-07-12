-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valores_convreceb (nr_sequencia_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/* ie_opção
	'G' - Glosado
*/
vl_glosado_w	double precision;


BEGIN

if (ie_opcao_p = 'G') then


	select	sum(a.vl_glosado)
	into STRICT	vl_glosado_w
	from	convenio_retorno_item a
	where	a.nr_seq_retorno in (SELECT	b.nr_seq_retorno
			from	convenio_ret_receb b,
				convenio_receb c
			where	b.nr_seq_receb	= c.nr_sequencia
			and	c.nr_sequencia	= nr_sequencia_p);
end if;

return vl_glosado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valores_convreceb (nr_sequencia_p bigint, ie_opcao_p text) FROM PUBLIC;

