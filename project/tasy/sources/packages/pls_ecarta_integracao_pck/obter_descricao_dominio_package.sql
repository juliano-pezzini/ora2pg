-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_ecarta_integracao_pck.obter_descricao_dominio ( cd_dominio_p dominio.cd_dominio%type) RETURNS varchar AS $body$
DECLARE

	retorno_w dominio.ds_dominio%type := null;

	c01_w CURSOR FOR
	SELECT	a.ds_dominio
	from	dominio	a
	where	a.cd_dominio = cd_dominio_p;

BEGIN
	-- Busca descrição do domínio
	open c01_w;
	fetch c01_w into retorno_w;
	close c01_w;

	return retorno_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_ecarta_integracao_pck.obter_descricao_dominio ( cd_dominio_p dominio.cd_dominio%type) FROM PUBLIC;