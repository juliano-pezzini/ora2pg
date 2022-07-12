-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_estoque_locale_usuario ( cd_setor_p bigint, cd_parametero_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


/*
ATENÇÃO:
Essa function foi criada pelo usuário SWJAIN (Site India) e nao havia sido documentada.
Estou documentando, porem, eventuais problemas devem ser de responsabilidade do usuario citado.
*/
ie_parametro_w			varchar(1);
cd_retorno_w			bigint := 0;


BEGIN

ie_parametro_w := obter_param_usuario(143, 163, wheb_usuario_pck.get_cd_perfil, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_parametro_w);

IF (ie_parametro_w = 'S') THEN
	SELECT	obter_local_estoque_setor(wheb_usuario_pck.get_cd_setor_atendimento,wheb_usuario_pck.get_cd_estabelecimento)
	INTO STRICT	cd_retorno_w
	;
END IF;

RETURN cd_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_estoque_locale_usuario ( cd_setor_p bigint, cd_parametero_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
