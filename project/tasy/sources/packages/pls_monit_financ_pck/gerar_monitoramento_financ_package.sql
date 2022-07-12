-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

-- Rotina para gerar todos os monitoramentos financeiros
CREATE OR REPLACE PROCEDURE pls_monit_financ_pck.gerar_monitoramento_financ ( nm_usuario_p usuario.nm_usuario%type ) AS $body$
BEGIN

--1 - Contas fora de faturamento e deviam ser faturadas
CALL pls_monit_financ_pck.gerar_monit_financ_conta_fat(nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_monit_financ_pck.gerar_monitoramento_financ ( nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
