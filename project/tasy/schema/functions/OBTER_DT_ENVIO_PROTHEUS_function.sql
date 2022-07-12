-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_envio_protheus (nr_seq_protocolo_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_envio_w	timestamp;
ie_acao_w	protocolo_convenio_integr.ie_acao%type;

/*
	ie_acao_w =>	1 - Indica que foi gerado o arquivo de integração
			2 - Indica que foi desfeito a geração do arquivo de integração
*/
c01 CURSOR FOR
SELECT	dt_atualizacao,
	ie_acao
from	protocolo_convenio_integr
where	nr_seq_protocolo = nr_seq_protocolo_p
order by	nr_sequencia;


BEGIN

open c01;
loop
	fetch	c01
	into	dt_envio_w,
		ie_acao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

if (ie_acao_w = 2) then
	dt_envio_w := null;
end if;

return	dt_envio_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_envio_protheus (nr_seq_protocolo_p bigint) FROM PUBLIC;
