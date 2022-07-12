-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_se_regra_reproducao (nr_seq_doacao_p bigint, nr_seq_derivado_p bigint) RETURNS varchar AS $body$
DECLARE


ds_resultado_w	varchar(1);
ie_tipo_bolsa_w	varchar(5);


BEGIN

if (nr_seq_derivado_p IS NOT NULL AND nr_seq_derivado_p::text <> '') then

	select	max(a.ie_tipo_bolsa)
	into STRICT	ie_tipo_bolsa_w
	from	san_doacao a
	where	a.nr_sequencia = nr_seq_doacao_p;

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ds_resultado_w
	from	san_derivado_reproducao a
	where	a.nr_seq_derivado = nr_seq_derivado_p
	and	((coalesce(a.ie_tipo_bolsa,0) = 0) or (coalesce(a.ie_tipo_bolsa,0) = ie_tipo_bolsa_w))
	and	a.ie_situacao = 'A';

end if;

return	ds_resultado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_se_regra_reproducao (nr_seq_doacao_p bigint, nr_seq_derivado_p bigint) FROM PUBLIC;
