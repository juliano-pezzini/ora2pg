-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_evento_agenda ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_status_agenda_p text, ie_evento_p text, ie_agenda_p text, ie_tipo_agenda_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, ds_dados_agenda_nr INOUT text, ie_last_status INOUT text, cd_agenda_p bigint default null, cd_setor_atendimento_p bigint default null, ie_classif_agenda_p text default null) AS $body$
DECLARE


ie_evento_agenda_w	varchar(1);
ie_questiona_w		varchar(1);
new_ie_status		varchar(255);
cd_pessoa_fisica_w	varchar(255);
ie_status_agenda_w	varchar(2);
ds_mensagem_w		varchar(455)	:= 'N';
ie_evento_w		varchar(15)	:= 'SPC';
cd_perfil_w		bigint;
ie_tipo_atendimento_w	smallint;
cd_convenio_w		integer;
nr_atendimento_w	agenda_paciente.nr_atendimento%type;
ie_classif_agenda_w     agenda_consulta.ie_classif_agenda%type;


BEGIN

    if (ie_agenda_p in ('CI','E')) then
		select	max(nr_atendimento),
                	max(ie_status_agenda)
		into STRICT	nr_atendimento_w,
               		ie_status_agenda_w
		from	agenda_paciente
		where	nr_sequencia = nr_sequencia_p;
	elsif (ie_agenda_p in ('C','S')) then
		select	max(nr_atendimento),
			max(coalesce(ie_classif_agenda,'0')),
                	max(ie_status_agenda)
		into STRICT	nr_atendimento_w,
			ie_classif_agenda_w,
                	ie_status_agenda_w
		from	agenda_consulta
		where	nr_sequencia = nr_sequencia_p;
	end if;


    	cd_perfil_w := obter_perfil_ativo;
	ie_tipo_atendimento_w := Obter_Tipo_Atendimento(nr_atendimento_w);
	cd_convenio_w := Obter_Convenio_Atendimento(nr_atendimento_w);

    if (ie_evento_p in ('SPCA', 'SAP')) then
        ie_evento_w := ie_evento_p;
    end if;
		
	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') and (ie_evento_p IS NOT NULL AND ie_evento_p::text <> '') and (ie_agenda_p IS NOT NULL AND ie_agenda_p::text <> '') then
			select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_evento_agenda_w
			from	status_evento_agenda a
			where (a.cd_estabelecimento = cd_estabelecimento_p or exists (SELECT 1 
											from STATUS_EVENTO_AGENDA_ESTAB x 
											where x.cd_estabelecimento = cd_estabelecimento_p 
											and a.nr_sequencia 	   = x.nr_seq_status_evento_ag ))
			and	a.ie_evento = ie_evento_p 
			and (coalesce(a.ie_evolucao_clinica::text, '') = '')
 			and (coalesce(a.cd_perfil::text, '') = '' or a.cd_perfil = cd_perfil_w)
			and	((a.ie_agenda = ie_agenda_p)    or (a.ie_agenda = 'T'))
			and (coalesce(a.cd_agenda::text, '') = '' or a.cd_agenda = cd_agenda_p)
			and (coalesce(a.ie_tipo_atendimento::text, '') = '' or a.ie_tipo_atendimento = ie_tipo_atendimento_w)
			and (coalesce(a.cd_setor_atendimento::text, '') = '' or a.cd_setor_atendimento = cd_setor_atendimento_p)
			and (coalesce(a.cd_convenio::text, '') = '' or a.cd_convenio = cd_convenio_w)
			and (coalesce(a.ie_classif_agenda::text, '') = '' or a.ie_classif_agenda = ie_classif_agenda_p) LIMIT 1;
	end if;

	if ((nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and ie_evento_agenda_w = 'S') then

		select	max(substr(obter_descricao_dominio(83,a.ie_status),1,255))
		into STRICT	new_ie_status
		from	status_evento_agenda a
		where	a.nr_sequencia in (     SELECT 	b.nr_sequencia
						from 	status_evento_agenda b
						where (b.cd_estabelecimento = cd_estabelecimento_p or exists (SELECT 1
														from STATUS_EVENTO_AGENDA_ESTAB x 
														where x.cd_estabelecimento = cd_estabelecimento_p 
														and b.nr_sequencia 	   = x.nr_seq_status_evento_ag ))
						and	b.ie_evento = ie_evento_w
						and 	((b.ie_agenda = ie_agenda_p) or (b.ie_agenda = 'T'))
                                 		and (coalesce(b.cd_perfil::text, '') = '' or b.cd_perfil = cd_perfil_w)
				        	and (coalesce(b.cd_agenda::text, '') = '' or b.cd_agenda = cd_agenda_p)
						and (coalesce(b.ie_tipo_atendimento::text, '') = '' or b.ie_tipo_atendimento = ie_tipo_atendimento_w)
						and (coalesce(b.cd_setor_atendimento::text, '') = '' or b.cd_setor_atendimento = cd_setor_atendimento_p)
						and (coalesce(b.cd_convenio::text, '') = '' or b.cd_convenio = cd_convenio_w)
						and (coalesce(b.ie_classif_agenda::text, '') = '' or b.ie_classif_agenda = ie_classif_agenda_p))
		order by 	coalesce(a.cd_agenda,0),
				coalesce(a.cd_perfil,0),
				coalesce(a.ie_evolucao_clinica,'0'),
				coalesce(a.ie_classif_agenda,'*'),
				coalesce(a.cd_convenio,0),
				coalesce(a.nr_seq_tipo_atend,0),
				a.ie_status;

		if (ie_status_agenda_p <> 'E' and ie_evento_w <> 'SAP') then
			ie_questiona_w := obter_param_usuario(281, 324, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_questiona_w);

			if (ie_questiona_w = 'S') or (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

				if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') in ('de_DE', 'de_AT')) then

					ds_mensagem_w		:= substr(obter_texto_tasy(1120044, wheb_usuario_pck.get_nr_seq_idioma),1,255);

				else

					ds_mensagem_w		:= Wheb_mensagem_pck.get_texto(1131037, 'PATIENT_NAME=' || obter_dados_agendas(ie_tipo_agenda_p, nr_sequencia_p, ie_opcao_p) ||
					';SOURCE_STATUS=' || substr(obter_valor_dominio(83, ie_status_agenda_p),1,30) || ';DESTINATION_STATUS=' || new_ie_status);

					if (coalesce(pkg_i18n.get_user_locale, 'pt_BR') <> 'ja_JP') then
						select  max(cd_pessoa_fisica)
						into STRICT    cd_pessoa_fisica_w
						from    agenda_consulta
						where   nr_sequencia = nr_sequencia_p;

						ds_mensagem_w  := ds_mensagem_w || chr(10) || obter_desc_expressao(600812) ||' '|| obter_dados_pf(cd_pessoa_fisica_w,'DN')
						|| chr(10) || obter_desc_expressao(294226) || ': '|| obter_nome_pai_mae(cd_pessoa_fisica_w,'M');
					end if;

				end if;

			end if;
		else
			ds_mensagem_w	:= Wheb_mensagem_pck.get_texto(1131037, 'PATIENT_NAME=' || obter_dados_agendas(ie_tipo_agenda_p, nr_sequencia_p, ie_opcao_p) ||
				';SOURCE_STATUS=' || substr(obter_valor_dominio(83, ie_status_agenda_w),1,30) || ';DESTINATION_STATUS=' || new_ie_status);
		end if;

	end if;

ds_mensagem_p		:= ds_mensagem_w;
ds_dados_agenda_nr	:= obter_dados_agendas(ie_tipo_agenda_p, nr_sequencia_p, 'NR');
ie_last_status		:= obter_se_ultimo_status(ie_tipo_agenda_p,nr_sequencia_p,ie_evento_w,ie_agenda_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_evento_agenda ( nr_atendimento_p bigint, nr_sequencia_p bigint, ie_status_agenda_p text, ie_evento_p text, ie_agenda_p text, ie_tipo_agenda_p bigint, ie_opcao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_mensagem_p INOUT text, ds_dados_agenda_nr INOUT text, ie_last_status INOUT text, cd_agenda_p bigint default null, cd_setor_atendimento_p bigint default null, ie_classif_agenda_p text default null) FROM PUBLIC;

