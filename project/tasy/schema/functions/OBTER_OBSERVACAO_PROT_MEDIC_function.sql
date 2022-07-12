-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_observacao_prot_medic ( cd_protocolo_p bigint, nr_seq_medicacao_p bigint) RETURNS varchar AS $body$
DECLARE



ds_observacao_w	 	varchar(2000);

BEGIN

if (cd_protocolo_p	> 0) then

	SELECT 	max(subStr(ds_observacao,1,1999))
	into STRICT	ds_observacao_w
	from	protocolo_medicacao
	where 	cd_protocolo = cd_protocolo_p
	and	   	nr_sequencia = nr_seq_medicacao_p;

end if;

return ds_observacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_observacao_prot_medic ( cd_protocolo_p bigint, nr_seq_medicacao_p bigint) FROM PUBLIC;

