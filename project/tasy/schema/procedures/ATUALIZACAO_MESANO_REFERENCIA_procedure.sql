-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizacao_mesano_referencia ( dt_parametro_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
 
 
cd_convenio_w	integer;

C01 CURSOR FOR 
	SELECT	cd_convenio 
	from	convenio 
	where	ie_tipo_convenio <> 3;
	/* OS 652363 Removido a verificação dos convênios Ativos conforme histórico do cliente do dia 23/10/2013 14:14:03. */
 

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	cd_convenio_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	CALL Atualiza_MesAno_Refer_Conta(Trunc(dt_parametro_p,'MONTH'), cd_convenio_w, nm_usuario_p,'S','S',cd_estabelecimento_p);
	 
	end;
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizacao_mesano_referencia ( dt_parametro_p timestamp, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

