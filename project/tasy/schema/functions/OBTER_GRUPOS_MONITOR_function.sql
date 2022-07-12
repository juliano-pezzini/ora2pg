-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_grupos_monitor (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


retorno_w 	varchar(20);
nr_seq_grupo_w  varchar(20);


C01 CURSOR FOR
	SELECT DISTINCT NR_SEQ_GRUPO_LOCAL_SENHA
	FROM CUSTOMIZACAO_MONITOR_ITEM
	WHERE NR_SEQ_CUSTOMIZACAO = nr_sequencia_p
	AND ie_tipo_componente = 1;


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_grupo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		retorno_w := retorno_w + ',' + nr_seq_grupo_w;
	end;
end loop;
close C01;


return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_grupos_monitor (nr_sequencia_p bigint) FROM PUBLIC;
