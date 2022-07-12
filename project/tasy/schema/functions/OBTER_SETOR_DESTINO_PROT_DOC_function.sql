-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_destino_prot_doc ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

ds_retorno_w	integer:= 0;

C01 CURSOR FOR
	SELECT 	/*+INDEX(a PRODOCU_PK) */		coalesce(a.cd_setor_destino,0)
	from   	protocolo_documento a,
			protocolo_doc_item b
	where  	a.nr_sequencia = b.nr_sequencia
	and    	b.nr_documento = nr_atendimento_p
	and	coalesce(a.cd_setor_destino,0) <> 0
	order by	a.dt_envio, coalesce(a.cd_setor_destino,0);


BEGIN
/*Alterei a forma de consulta para melhor a performance no HMCG*/

open C01;
loop
fetch C01 into
	ds_retorno_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_destino_prot_doc ( nr_atendimento_p bigint) FROM PUBLIC;
