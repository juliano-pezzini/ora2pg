-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_guia_cobra_prev ( nr_seq_guia_p bigint, nr_seq_segurado_p bigint, qt_dias_cobranca_prev_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 		varchar(1) := 'N';
qt_reg_w		integer;
dt_solicitacao_w	timestamp;


BEGIN

select	dt_solicitacao
into STRICT	dt_solicitacao_w
from	pls_guia_plano
where	nr_sequencia = nr_seq_guia_p;

if (qt_dias_cobranca_prev_p > 0) then
	select	count(*)
	into STRICT	qt_reg_w
	from	pls_guia_plano
	where	nr_sequencia	<> nr_seq_guia_p
	and	nr_seq_segurado = nr_seq_segurado_p
	and	ie_cobranca_prevista = 'S'
	and	dt_solicitacao between trunc(dt_solicitacao_w - qt_dias_cobranca_prev_p) and fim_dia(dt_solicitacao_w);

	if (qt_reg_w > 0) then
		ds_retorno_w := 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_guia_cobra_prev ( nr_seq_guia_p bigint, nr_seq_segurado_p bigint, qt_dias_cobranca_prev_p bigint) FROM PUBLIC;

