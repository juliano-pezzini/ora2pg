-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE finalizar_escala_plantao ( cd_estabelecimento_p bigint, nm_usuario_p text ) AS $body$
DECLARE

 
cd_medico_w		bigint;	
dt_referencia_w		timestamp;
	

BEGIN 
 
cd_medico_w	:= Obter_Pessoa_Fisica_Usuario(nm_usuario_p, 'C');
 
select	max(dt_referencia) 
into STRICT	dt_referencia_w 
from	medico_controle 
where	cd_medico = cd_medico_w 
and	coalesce(dt_saida::text, '') = '';
 
update	medico_controle 
set	dt_saida 	= clock_timestamp(), 
	qt_min_total	= (clock_timestamp() - dt_entrada) * 1440 
where	dt_referencia	= dt_referencia_w 
and	cd_medico	= cd_medico_w;
 
CALL gerar_escala_resumo_medico(cd_medico_w, dt_referencia_w, cd_estabelecimento_p, nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE finalizar_escala_plantao ( cd_estabelecimento_p bigint, nm_usuario_p text ) FROM PUBLIC;
