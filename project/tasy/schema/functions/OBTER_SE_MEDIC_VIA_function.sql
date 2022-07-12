-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medic_via ( nr_seq_atendimento_p bigint, ie_via_aplicacao_p text) RETURNS varchar AS $body$
DECLARE


ie_via_w	varchar(1);


BEGIN

select 	coalesce(max('S'),'N')
into STRICT	ie_via_w
from   	paciente_atend_medic
where  	nr_seq_atendimento = nr_seq_atendimento_p
and    	upper(ie_via_aplicacao) = upper(ie_via_aplicacao_p);

return	ie_via_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medic_via ( nr_seq_atendimento_p bigint, ie_via_aplicacao_p text) FROM PUBLIC;
