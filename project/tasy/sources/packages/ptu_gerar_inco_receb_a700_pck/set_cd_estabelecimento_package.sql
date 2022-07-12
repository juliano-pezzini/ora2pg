-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ptu_gerar_inco_receb_a700_pck.set_cd_estabelecimento (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN
		PERFORM set_config('ptu_gerar_inco_receb_a700_pck.cd_estabelecimento_w', cd_estabelecimento_p, false);
	end;
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_inco_receb_a700_pck.set_cd_estabelecimento (cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
