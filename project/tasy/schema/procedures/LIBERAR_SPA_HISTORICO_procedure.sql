-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_spa_historico ( nr_sequencia_p bigint, valor_p text, ie_tipo_p text) AS $body$
DECLARE


nm_usuario_w			usuario.nm_usuario%type := wheb_usuario_pck.get_nm_usuario;


BEGIN
if (ie_tipo_p = 'L') then
	update spa_historico
	set DT_LIBERACAO 	= clock_timestamp(), 
		NM_USUARIO_LIB 	= nm_usuario_w 
	where NR_SEQUENCIA = nr_sequencia_p;
end if;

if (ie_tipo_p = 'I') then
	update spa_historico
	set IE_SITUACAO 	= valor_p
	where NR_SEQUENCIA = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_spa_historico ( nr_sequencia_p bigint, valor_p text, ie_tipo_p text) FROM PUBLIC;

