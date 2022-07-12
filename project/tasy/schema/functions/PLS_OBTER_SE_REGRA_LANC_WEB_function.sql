-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_regra_lanc_web (ie_tipo_guia_p pls_regra_lanc_automatico.ie_tipo_guia %type, nr_seq_prestador_p pls_regra_lanc_automatico.nr_seq_prestador%type, cd_medico_solicitante_p pls_regra_lanc_automatico.cd_medico_solicitante%type) RETURNS varchar AS $body$
DECLARE


ie_retorno_w 	varchar(1) := 'N';
qt_registros_w	bigint;


BEGIN

select	count(1)
into STRICT	qt_registros_w
from	pls_regra_lanc_automatico a
where	ie_evento = 8
and (ie_tipo_guia  = ie_tipo_guia_p or coalesce(ie_tipo_guia::text, '') = '')
and (cd_medico_solicitante = cd_medico_solicitante_p or	coalesce(cd_medico_solicitante::text, '') = '')
and (nr_seq_prestador = nr_seq_prestador_p or coalesce(nr_seq_prestador::text, '') = '')
and (ie_origem_lancamento = 'P' or	ie_origem_lancamento = 'A')
and		ie_situacao = 'A'
and		exists (SELECT	1
			   from		pls_regra_lanc_aut_item
			   where	nr_seq_regra = a.nr_sequencia
			   and		ie_situacao = 'A');


if (qt_registros_w > 0) then
	ie_retorno_w := 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_regra_lanc_web (ie_tipo_guia_p pls_regra_lanc_automatico.ie_tipo_guia %type, nr_seq_prestador_p pls_regra_lanc_automatico.nr_seq_prestador%type, cd_medico_solicitante_p pls_regra_lanc_automatico.cd_medico_solicitante%type) FROM PUBLIC;
