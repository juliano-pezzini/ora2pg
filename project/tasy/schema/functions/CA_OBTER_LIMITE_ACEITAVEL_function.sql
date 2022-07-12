-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ca_obter_limite_aceitavel (nr_seq_exame_p bigint, nr_seq_analise_p bigint) RETURNS bigint AS $body$
DECLARE


ie_local_analise_w	varchar(1);
vl_limite_w			double precision;
nr_sequencia_w		bigint;


BEGIN

if	((coalesce(nr_seq_exame_p,0) > 0) and (coalesce(nr_seq_analise_p,0) > 0))then

	ie_local_analise_w := ca_obter_ponto_maquina(nr_seq_analise_p);

	select	max(vl_limite)
	into STRICT	vl_limite_w
	from	ca_exame_referencia
	where	nr_seq_exame = nr_seq_exame_p
	and		((ie_local_analise = ie_local_analise_w) or (coalesce(ie_local_analise::text, '') = ''));

end if;

return	vl_limite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ca_obter_limite_aceitavel (nr_seq_exame_p bigint, nr_seq_analise_p bigint) FROM PUBLIC;
