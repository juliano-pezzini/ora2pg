-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_pontos_aval_nut_enf ( nr_atendimento_p bigint, ie_opcao_p text, dt_avaliacao_p timestamp) RETURNS varchar AS $body$
DECLARE


qt_pontos_w	double precision;


BEGIN

select	somente_numero(sum(b.qt_ponto))
into STRICT	qt_pontos_w
from	tipo_aval_nut_enf b,
	atend_aval_nut_enf a
where	b.nr_sequencia		= a.nr_seq_tipo_aval
and (ie_opcao_p = 'T' or (ie_opcao_p in ('D','TD') and trunc(a.dt_avaliacao) = trunc(dt_avaliacao_p) ))
and	a.nr_atendimento	= nr_atendimento_p;

if (ie_opcao_p	= 'TD') then
	return	to_char(dt_avaliacao_p,'dd/mm/yyyy')||'   :   '||qt_pontos_w;
end if;


return	qt_pontos_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_pontos_aval_nut_enf ( nr_atendimento_p bigint, ie_opcao_p text, dt_avaliacao_p timestamp) FROM PUBLIC;

