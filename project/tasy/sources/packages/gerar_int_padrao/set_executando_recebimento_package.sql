-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE gerar_int_padrao.set_executando_recebimento ( ie_executando_recebimento_p text) AS $body$
BEGIN
PERFORM set_config('gerar_int_padrao.ie_executando_recebimento_w', ie_executando_recebimento_p, false);
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_int_padrao.set_executando_recebimento ( ie_executando_recebimento_p text) FROM PUBLIC;
