-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cus_associar_centro_setor ( cd_estabelecimento_p bigint, cd_centro_controle_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	setor_atendimento
set	cd_centro_controle	= cd_centro_controle_p,
	cd_estabelecimento	= cd_estabelecimento_p
where	cd_setor_atendimento	= cd_setor_atendimento_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cus_associar_centro_setor ( cd_estabelecimento_p bigint, cd_centro_controle_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

