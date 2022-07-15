-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_vencimento_tit_js ( nr_titulo_p bigint, dt_vencimento_p timestamp, cd_motivo_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN
 
CALL alterar_vencimento_tit_rec(nr_titulo_p, dt_vencimento_p, cd_motivo_p, ds_observacao_p, nm_usuario_p);
 
CALL gerar_bloqueto_tit_rec(nr_titulo_p, 'MTR');
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_vencimento_tit_js ( nr_titulo_p bigint, dt_vencimento_p timestamp, cd_motivo_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

