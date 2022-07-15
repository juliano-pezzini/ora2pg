-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE job_regra_alterar_local_status ( nr_atendimento_p text, ie_acao_p text, nm_usuario_p text, cd_perfil_p bigint default null, cd_estabelecimento_p bigint default null) AS $body$
DECLARE

jobno bigint;
qt_reg_w	bigint;

BEGIN

SELECT	count(*)
INTO STRICT	qt_reg_w
FROM	REGRA_ATEND_LOCAL_STATUS
WHERE	ie_situacao = 'A'
and	ie_acao = ie_acao_p
AND	cd_estabelecimento = cd_estabelecimento_p
AND	cd_perfil = cd_perfil_p;

	if (qt_reg_w	> 0) then
		dbms_job.submit(jobno, 'regra_alterar_local_status_job('|| to_char(nr_atendimento_p) || ', ''' || ie_acao_p || ''', '  || ' ''' || nm_usuario_p || ''', ' ||cd_perfil_p||','|| cd_estabelecimento_p|| ');');
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE job_regra_alterar_local_status ( nr_atendimento_p text, ie_acao_p text, nm_usuario_p text, cd_perfil_p bigint default null, cd_estabelecimento_p bigint default null) FROM PUBLIC;

