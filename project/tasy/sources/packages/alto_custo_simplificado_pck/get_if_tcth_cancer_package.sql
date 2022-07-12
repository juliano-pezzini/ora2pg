-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_simplificado_pck.get_if_tcth_cancer (cd_pessoa_fisica_p text) RETURNS bigint AS $body$
BEGIN
		return alto_custo_cancer_pck.get_if_tcth(cd_pessoa_fisica_p);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_simplificado_pck.get_if_tcth_cancer (cd_pessoa_fisica_p text) FROM PUBLIC;
