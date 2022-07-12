-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION emar_obter_se_aprazado ( nr_sequencia_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_aprazado_w	varchar(1) := 'N';


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_aprazado_w
from 	prescr_solucao_evento
where 	nr_sequencia = nr_sequencia_p
and 	ie_alteracao = 16
and 	(dt_aprazamento IS NOT NULL AND dt_aprazamento::text <> '');

return ie_aprazado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION emar_obter_se_aprazado ( nr_sequencia_p bigint ) FROM PUBLIC;
