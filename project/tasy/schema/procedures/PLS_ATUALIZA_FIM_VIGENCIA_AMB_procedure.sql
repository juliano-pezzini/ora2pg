-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualiza_fim_vigencia_amb ( cd_edicao_amb_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_inicio_vigencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

dt_fim_vigencia_w	timestamp;


BEGIN 
dt_fim_vigencia_w := (dt_inicio_vigencia_p - 1);
 
update	preco_amb 
set	dt_final_vigencia 	= dt_fim_vigencia_w 
where	cd_procedimento		= cd_procedimento_p 
and	trunc(dt_inicio_vigencia,'dd') 	<> trunc(dt_inicio_vigencia_p,'dd') 
and	ie_origem_proced	= ie_origem_proced_p 
and	cd_edicao_amb	= cd_edicao_amb_p 
and	coalesce(dt_final_vigencia::text, '') = '';
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualiza_fim_vigencia_amb ( cd_edicao_amb_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, dt_inicio_vigencia_p timestamp, nm_usuario_p text) FROM PUBLIC;
