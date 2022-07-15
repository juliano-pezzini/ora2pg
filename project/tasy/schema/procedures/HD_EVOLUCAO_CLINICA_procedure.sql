-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_evolucao_clinica (cd_pessoa_fisica_p text, nr_atendimento_p bigint, dt_evolucao_p timestamp, ie_tipo_evolucao_p text, ie_evolucao_p text, ds_evolucao_p text) AS $body$
DECLARE

    cd_setor_atendimento_w evolucao_paciente.cd_setor_atendimento%type;
    nm_usuario_w           evolucao_paciente.nm_usuario%type := obter_usuario_ativo;
    nr_atendimento_w       evolucao_paciente.nr_atendimento%type;
	cd_medico_w			   evolucao_paciente.cd_medico%type;	

BEGIN

    IF nr_atendimento_p = 0 THEN
        nr_atendimento_w := NULL;
    ELSE
        nr_atendimento_w := nr_atendimento_p;
    END IF;

    IF (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') THEN
        SELECT obter_setor_atendimento(nr_atendimento_w) INTO STRICT cd_setor_atendimento_w;
    END IF;
	
	select	max(cd_pessoa_fisica)
	into STRICT	cd_medico_w
	from	usuario
	where	nm_usuario = nm_usuario_w;

    INSERT INTO evolucao_paciente(cd_evolucao,
         cd_pessoa_fisica,
         nr_atendimento,
         cd_setor_atendimento,
         dt_evolucao,
         ie_tipo_evolucao,
         ie_evolucao_clinica,
         ds_evolucao,
         dt_atualizacao,
         nm_usuario,
         dt_liberacao,
         ie_situacao,
		 cd_medico)
    VALUES (nextval('evolucao_paciente_seq'),
         cd_pessoa_fisica_p,
         nr_atendimento_w,
         cd_setor_atendimento_w,
         dt_evolucao_p,
         ie_tipo_evolucao_p,
         ie_evolucao_p,
         ds_evolucao_p,
         clock_timestamp(),
         nm_usuario_w,
         clock_timestamp(),
         'A',
		 cd_medico_w);
    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_evolucao_clinica (cd_pessoa_fisica_p text, nr_atendimento_p bigint, dt_evolucao_p timestamp, ie_tipo_evolucao_p text, ie_evolucao_p text, ds_evolucao_p text) FROM PUBLIC;

