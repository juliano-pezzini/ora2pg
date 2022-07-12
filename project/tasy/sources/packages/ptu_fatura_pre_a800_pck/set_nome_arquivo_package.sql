-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_fatura_pre_a800_pck.set_nome_arquivo ( nm_arquivo_p text) AS $body$
BEGIN
		PERFORM set_config('ptu_fatura_pre_a800_pck.nm_arquivo_w', nm_arquivo_p, false);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_fatura_pre_a800_pck.set_nome_arquivo ( nm_arquivo_p text) FROM PUBLIC;
