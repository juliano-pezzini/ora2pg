-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_cirurgia_mes_ant ( dt_referencia_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
dt_incicio_w	timestamp;
dt_fim_w	timestamp;
					

BEGIN 
 
dt_incicio_w	:=	PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(dt_referencia_p, -1, 0),'month',0);
dt_fim_w	:=	PKG_DATE_UTILS.GET_DATETIME(PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.ADD_MONTH(dt_referencia_p, -1, 0), 'MONTH', 0), coalesce(dt_referencia_p, PKG_DATE_UTILS.GET_TIME('00:00:00')));
 
CALL EIS_Cirurgia_Mensal(dt_incicio_w,dt_fim_w,nm_usuario_p);
 
CALL Eis_Atualizar_Resumo_Geral(dt_incicio_w,nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_cirurgia_mes_ant ( dt_referencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

