-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_vincula_atendimento ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_tipo_agenda_p bigint, nm_usuario_p text, ie_exec_regra_p text default 'N') AS $body$
DECLARE


ie_executa_evento_w			varchar(15);
ie_tipo_agenda_w 			varchar(2) := '';
cd_convenio_w				atend_categoria_convenio.cd_convenio%type;
ie_conv_menor_prio_w		parametro_agenda.ie_conv_menor_prio%type;


BEGIN
	SELECT max(ie_conv_menor_prio)
	INTO STRICT ie_conv_menor_prio_w
	FROM parametro_agenda
	WHERE cd_estabelecimento = obter_estabelecimento_ativo;

	if (coalesce(nr_sequencia_p,0) > 0 and coalesce(nr_atendimento_p,0) > 0)  then
	
		if (ie_conv_menor_prio_w = 'S') then
			SELECT 	MAX(cd_convenio)
			into STRICT 	cd_convenio_w
			FROM 	atend_categoria_convenio a
			WHERE 	a.nr_atendimento = nr_atendimento_p
			AND     NOT EXISTS ( 	SELECT	b.nr_prioridade
													FROM 	atend_categoria_convenio b
													WHERE 	b.nr_atendimento = nr_atendimento_p
													AND		a.nr_prioridade > b.nr_prioridade);
		end if;
	
		if ((coalesce(ie_tipo_agenda_p,0) = 3) or (coalesce(ie_tipo_agenda_p,0) = 5)) then

			update	agenda_consulta
			set	nr_atendimento  = nr_atendimento_p,
				dt_atualizacao  = clock_timestamp(),
				nm_usuario	= coalesce(nm_usuario_p,obter_usuario_ativo),
				cd_convenio = coalesce(cd_convenio_w, cd_convenio),
                cd_pessoa_fisica = (SELECT cd_pessoa_fisica
                                    from atendimento_paciente
                                    where nr_atendimento = nr_atendimento_p)
			where	nr_sequencia    = nr_sequencia_p
			and	coalesce(nr_atendimento::text, '') = '';
			
			if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') = 'ja_JP') then
				CALL generate_cpoe_slip_number(null,null,null,nr_sequencia_p,null,nm_usuario_p);
			end if;

		else

			update	agenda_paciente
			set	nr_atendimento  = nr_atendimento_p,
				dt_atualizacao  = clock_timestamp(),
				nm_usuario	= coalesce(nm_usuario_p,obter_usuario_ativo),
				cd_convenio = coalesce(cd_convenio_w, cd_convenio),
                cd_pessoa_fisica = (SELECT cd_pessoa_fisica
                                    from atendimento_paciente
                                    where nr_atendimento = nr_atendimento_p)
			where	nr_sequencia    = nr_sequencia_p
			and	coalesce(nr_atendimento::text, '') = '';

		end if;

		if (ie_exec_regra_p = 'S') then
			/*
			Se necessario executar os eventos das agendas para geracao de atendimento deve ser feita validacao para chamar como GA e nao VA
			*/
			select	max(obter_se_existe_evento_agenda(wheb_usuario_pck.get_cd_estabelecimento,'VA',ie_tipo_agenda_p))
			into STRICT	ie_executa_evento_w
			;

			if (ie_tipo_agenda_p = 1)then
			   ie_tipo_agenda_w := 'CI';
			elsif (ie_tipo_agenda_p = 2)then
			       ie_tipo_agenda_w := 'E';
			elsif (ie_tipo_agenda_p = 3) then
    			       ie_tipo_agenda_w := 'C';
			elsif (ie_tipo_agenda_p = 5) then
			       ie_tipo_agenda_w := 'S';
			end if;

			if (ie_executa_evento_w = 'S' and obter_se_atendimento_futuro(nr_atendimento_p) = 'N') then
				CALL executar_evento_agenda('VA',ie_tipo_agenda_w,nr_sequencia_p,wheb_usuario_pck.get_cd_estabelecimento,wheb_usuario_pck.get_nm_usuario,null,null);
			end if;
  		end if;

	end if;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_vincula_atendimento ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_tipo_agenda_p bigint, nm_usuario_p text, ie_exec_regra_p text default 'N') FROM PUBLIC;

