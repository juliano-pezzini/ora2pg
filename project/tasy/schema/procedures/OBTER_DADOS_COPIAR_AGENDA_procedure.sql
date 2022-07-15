-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_copiar_agenda ( ie_opcao_p text, nr_seq_agenda_p bigint, nr_seq_agenda_cop_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_perg_copia_p INOUT text, ds_msg_agend_enc_p INOUT text, ds_msg_perg_nao_autor_p INOUT text, cd_pessoa_fisica_p INOUT text) AS $body$
DECLARE

 
nr_atendimento_w		bigint;
ie_atend_agenda_aberto_w	varchar(1);
ie_consiste_autconv_age_w	varchar(1);
ie_consistir_vinc_atend_w	varchar(1);
ie_atualizar_sessao_w	varchar(1);


BEGIN 
 
select	nr_atendimento, 
	substr(replace(obter_texto_tasy(50301, wheb_usuario_pck.get_nr_seq_idioma), 
		'#@NM_PACIENTE#@', coalesce(obter_nome_pf(cd_pessoa_fisica), nm_paciente)), 1,255) 
into STRICT	nr_atendimento_w, 
	ds_perg_copia_p 
from	agenda_consulta 
where	nr_sequencia = nr_seq_agenda_p;
 
if (ie_opcao_p = 'C') then 
	ds_perg_copia_p	:= replace(ds_perg_copia_p, '#@DS_FUNCAO#@', obter_texto_tasy(50302, wheb_usuario_pck.get_nr_seq_idioma));
elsif (ie_opcao_p = 'T') then 
	ds_perg_copia_p	:= replace(ds_perg_copia_p, '#@DS_FUNCAO#@', obter_texto_tasy(50303, wheb_usuario_pck.get_nr_seq_idioma));
end if;
 
if (ie_opcao_p = 'C') then 
	begin 
	if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
		begin 
		ie_atend_agenda_aberto_w	:= obter_se_atend_ageserv_aberto(nr_seq_agenda_p,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento);
		 
		if (ie_atend_agenda_aberto_w = 'N') then 
			ds_msg_agend_enc_p	:= substr(obter_texto_tasy(50309, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		end if;
		end;
	end if;
 
	ie_consiste_autconv_age_w	:= obter_se_consiste_autconv_age(nr_seq_agenda_p, nm_usuario_p);
 
	if (ie_consiste_autconv_age_w = 'S') then 
		begin 
		-- Agenda de Serviços - Parâmetro [44] - Consistir a autorização da sessão ao vincular o atendimento 
		ie_consistir_vinc_atend_w := obter_param_usuario(866, 44, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_consistir_vinc_atend_w);
 
		if (ie_consistir_vinc_atend_w = 'C') then 
			ds_msg_perg_nao_autor_p	:= substr(obter_texto_tasy(50317, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		elsif (ie_consistir_vinc_atend_w = 'I') then 
			ds_msg_perg_nao_autor_p	:= substr(obter_texto_tasy(50319, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		end if;
		end;
	end if;
	end;
end if;
 
-- Agenda de Serviços - Parâmetro [74] - Ao copiar\transferir atualizar a sessão do paciente 
ie_atualizar_sessao_w := obter_param_usuario(866, 74, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualizar_sessao_w);
 
if (ie_atualizar_sessao_w = 'S') then 
	begin 
	select	substr(obter_dados_agendamento(nr_seq_agenda_cop_p, 'CDP'), 1,10) 
	into STRICT	cd_pessoa_fisica_p 
	;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_copiar_agenda ( ie_opcao_p text, nr_seq_agenda_p bigint, nr_seq_agenda_cop_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ds_perg_copia_p INOUT text, ds_msg_agend_enc_p INOUT text, ds_msg_perg_nao_autor_p INOUT text, cd_pessoa_fisica_p INOUT text) FROM PUBLIC;

