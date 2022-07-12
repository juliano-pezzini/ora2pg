-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_status_prog_reajuste ( nr_seq_prog_reaj_coletivo_p pls_prog_reaj_coletivo.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_status_w	pls_prog_reaj_coletivo.ie_status%type;
ds_retorno_w	varchar(255);


BEGIN

select	max(ie_status)
into STRICT	ie_status_w
from	pls_prog_reaj_coletivo
where	nr_sequencia = nr_seq_prog_reaj_coletivo_p;

if (ie_status_w in ('A', 'L')) then
	ds_retorno_w	:= 'L'; -- Liberado
else
	ds_retorno_w	:= 'N'; -- Não liberado
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_status_prog_reajuste ( nr_seq_prog_reaj_coletivo_p pls_prog_reaj_coletivo.nr_sequencia%type) FROM PUBLIC;
