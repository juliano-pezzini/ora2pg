-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_evolucao_nao_lib ( qt_hora_adicional_p bigint, dt_parametro_p timestamp) AS $body$
DECLARE


cd_evolucao_w		bigint;
dt_evolucao_w		timestamp;
cd_pessoa_fisica_w	varchar(15);
nr_atendimento_w	bigint;
ie_evolucao_clinica_w	varchar(3);

c010 CURSOR FOR
	SELECT	cd_evolucao,
		dt_evolucao,
		cd_pessoa_fisica,
		nr_atendimento,
		ie_evolucao_clinica
	from	evolucao_paciente
	where	dt_evolucao < (dt_parametro_p - qt_hora_adicional_p / 24)
	  and	coalesce(dt_liberacao::text, '') = ''
	  and	ie_evolucao_clinica <> 'AE';

c010_w	c010%rowtype;

BEGIN

OPEN C010;
LOOP
FETCH C010 into
	cd_evolucao_w,
	dt_evolucao_w,
	cd_pessoa_fisica_w,
	nr_atendimento_w,
	ie_evolucao_clinica_w;
EXIT WHEN NOT FOUND; /* apply on C010 */
	BEGIN
	cd_evolucao_w	:= cd_evolucao_w;
	begin
	delete from evolucao_paciente
	where	cd_evolucao = cd_evolucao_w;
	exception
		when others then
			cd_evolucao_w := cd_evolucao_w;
	end;

	CALL gravar_log_exclusao('EVOLUCAO_PACIENTE','JOB',
			' CD_EVOLUCAO : ' || cd_evolucao_w ||
			' DT_EVOLUCAO : ' || to_char(dt_evolucao_w,'dd/mm/yyyy hh24:mi:ss') ||
			' CD_PESSOA_FISICA : ' ||cd_pessoa_fisica_w ||
			' NR_ATENDIMENTO : '||nr_atendimento_w ||
			 ' IE_EVOLUCAO_CLINICA : '||ie_evolucao_clinica_w
			,'N');

	END;
END LOOP;
close c010;

commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_evolucao_nao_lib ( qt_hora_adicional_p bigint, dt_parametro_p timestamp) FROM PUBLIC;

