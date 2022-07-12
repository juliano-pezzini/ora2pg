-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_tp_guia_med_exibe ( nr_seq_prestador_p bigint) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1);


BEGIN
select	coalesce(max(a.ie_entra_portal),'S')
into STRICT	ie_retorno_w
from	pls_tipo_guia_med_partic	a
where	a.nr_seq_prestador	= nr_seq_prestador_p;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_tp_guia_med_exibe ( nr_seq_prestador_p bigint) FROM PUBLIC;

