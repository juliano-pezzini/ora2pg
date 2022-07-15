-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE abrir_mes_fechado_js (nm_usuario_p text) AS $body$
BEGIN

--fin_gerar_log_controle_banco(2, 'O usuário ' || nm_usuario_p || ' alterou o parâmetro 50 da função Controle Bancário permitindo abrir novo mês sem fechar o anterior.',	nm_usuario_p,'S');
CALL fin_gerar_log_controle_banco(2,wheb_mensagem_pck.get_texto(304668,'NM_USUARIO_P='||nm_usuario_p),nm_usuario_p,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE abrir_mes_fechado_js (nm_usuario_p text) FROM PUBLIC;

