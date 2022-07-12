-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_participa_alta (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(1);


BEGIN

select coalesce(max(ie_controla_alta),'N')
into STRICT ds_retorno_w
from pep_pac_ci
where nr_sequencia = (SELECT max(nr_sequencia)
					from pep_pac_ci
					where nr_atendimento = nr_atendimento_p
					and (ie_controla_alta IS NOT NULL AND ie_controla_alta::text <> '')
					and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> ''));

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_participa_alta (nr_atendimento_p bigint) FROM PUBLIC;

