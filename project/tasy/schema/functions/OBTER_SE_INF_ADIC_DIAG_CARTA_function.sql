-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_inf_adic_diag_carta (nr_seq_modelo_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ds_retorno_w
from	carta_medica_regra a,
		carta_medica_regra_item b,
		carta_medica_modelo c
where	a.nr_sequencia 	= b.nr_seq_regra
and		a.nr_seq_modelo 	= c.nr_sequencia
and   	c.nr_sequencia    = nr_seq_modelo_p
and		coalesce(ie_incluir_inf_adic,'N') = 'S'
and		exists (	SELECT	1
					from	carta_medica_regra_item x
					where	x.nr_seq_regra 	= b.nr_seq_regra
					and	coalesce(ie_incluir_inf_adic,'N') = 'S');


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_inf_adic_diag_carta (nr_seq_modelo_p bigint) FROM PUBLIC;
