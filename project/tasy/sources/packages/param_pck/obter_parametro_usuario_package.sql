-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE param_pck.obter_parametro_usuario ( cd_funcao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, vl_parametro_p INOUT text) AS $body$
BEGIN

	vl_parametro_p	:= param_pck.obter_valor_parametro_usuario(	cd_funcao_p,
									nr_sequencia_p,
									cd_perfil_p,
									nm_usuario_p,
									cd_estabelecimento_p);
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE param_pck.obter_parametro_usuario ( cd_funcao_p bigint, nr_sequencia_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, vl_parametro_p INOUT text) FROM PUBLIC;