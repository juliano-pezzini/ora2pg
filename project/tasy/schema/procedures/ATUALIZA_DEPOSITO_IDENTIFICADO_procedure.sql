-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_deposito_identificado (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
UPDATE	deposito_identificado 
SET	ie_valor_deposito  = NULL, 
	dt_deposito	 = NULL, 
	ie_status	= 'AD', 
	nm_usuario	= nm_usuario_p 
where	nr_sequencia	= nr_sequencia_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_deposito_identificado (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
