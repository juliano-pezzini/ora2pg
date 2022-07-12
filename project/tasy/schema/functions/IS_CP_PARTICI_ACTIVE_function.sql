-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION is_cp_partici_active (nr_sequencia_p protocolo_integrado_partic.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


is_active_w                protocolo_integrado_partic.ie_adicionar%type;


BEGIN

select coalesce(max('A'), 'I')
        into STRICT is_active_w
from protocolo_integrado_partic
        where nr_sequencia = nr_sequencia_p
        and dt_liberacao <= clock_timestamp()
        and (dt_validade >= clock_timestamp() or coalesce(dt_validade::text, '') = '');

return is_active_w;
			
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION is_cp_partici_active (nr_sequencia_p protocolo_integrado_partic.nr_sequencia%type) FROM PUBLIC;

