-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_agenda_cons_js ( ds_lista_agendas_p text, ds_remetente_p text, ds_mensagem_p text, ie_confirmar_p text, ds_retorno_p INOUT text, nm_usuario_p text) AS $body$
DECLARE

 
ds_lista_agendas_w	varchar(2000);
nr_pos_virgula_w	bigint;
nr_seq_agenda_w		bigint;
cd_agenda_w			bigint;
nr_telefone_w		varchar(40);
ds_erro_w			varchar(2000);
nr_sequencia_w		agenda_consulta.nr_sequencia%type;
ds_mensagem_w		varchar(4000);
ds_texto_sms_padrao_w	varchar(4000);
ie_utiliza_sms_padrao_w		varchar(1);
ds_texto_padrao_antigo_w	varchar(4000);
ie_tipo_mensagem_w		varchar(1); -- A - antigo // N - novo // M - mensagem 
C01 CURSOR(nr_Seq_agenda_pc bigint) FOR 
	SELECT	 
		TO_CHAR(b.dt_agenda, 'dd/mm/yyyy hh24:mi:ss') dt_agenda, 
		SUBSTR(obter_nome_pf(b.cd_pessoa_fisica),1,60) nm_paciente, 
		obter_nome_pf(a.cd_pessoa_fisica) nm_medico,		 
    SUBSTR(obter_primeiro_nome(coalesce(obter_nome_pf(b.cd_pessoa_fisica),b.nm_paciente)),1,50) primeiro_nome, 
		SUBSTR(obter_nome_especialidade(a.cd_especialidade),1,100) especialidade, 
		SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,255) estab_agenda, 
		TO_CHAR(b.dt_agenda, 'dd/mm/yy hh24:mi') dt_resumida, 
		TO_CHAR(b.dt_agenda, 'dd/mm') dt_dia_mes, 
		TO_CHAR(b.dt_agenda, 'hh24:mi') dt_hor_min, 
		obter_primeiro_nome(obter_nome_pf(a.cd_pessoa_fisica)) nm_medico_resumido, 
		substr(ds_curta,1,30) ds_curta, 
    substr(ds_complemento,1,60) ds_complemento, 
		obter_primeiro_ultimo_Nome(a.cd_pessoa_fisica) nm_sobrenome_med, 
		a.cd_agenda cd_agenda, 
		c.nr_telefone_celular nr_telefone, 
		b.nr_Sequencia nr_seq_agenda 
	FROM	agenda a, 
			agenda_consulta b, 
			pessoa_fisica c 
	WHERE	a.cd_agenda     	= b.cd_agenda 
	and		b.cd_pessoa_fisica		= c.cd_pessoa_fisica 
	and 	nr_sequencia	= nr_Seq_agenda_pc 
	ORDER BY b.dt_agenda;

BEGIN 
 
if (ds_lista_agendas_p IS NOT NULL AND ds_lista_agendas_p::text <> '') and (ds_remetente_p IS NOT NULL AND ds_remetente_p::text <> '') then 
	 
	ds_texto_sms_padrao_w := obter_param_usuario(821, 120, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ds_texto_sms_padrao_w);
	ie_utiliza_sms_padrao_w := obter_param_usuario(821, 301, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_utiliza_sms_padrao_w);
	ds_texto_padrao_antigo_w := obter_param_usuario(898, 75, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ds_texto_padrao_antigo_w);
	 
	 
	ds_lista_agendas_w	:= ds_lista_agendas_p;
	 
	while(ds_lista_agendas_w IS NOT NULL AND ds_lista_agendas_w::text <> '') loop 
		nr_pos_virgula_w	:= position(',' in ds_lista_agendas_w);
		if (nr_pos_virgula_w > 0) then 
			begin 
			nr_seq_agenda_w		:= substr(ds_lista_agendas_w,0,nr_pos_virgula_w-1);
			ds_lista_agendas_w	:= substr(ds_lista_agendas_w,nr_pos_virgula_w+1,length(ds_lista_agendas_w));
			end;
		else 
			begin 
			nr_seq_agenda_w		:= (ds_lista_agendas_w)::numeric;
			ds_lista_agendas_w	:= null;
			end;
		end if;	
		 
		 
		for r_agendamento_w in c01(nr_seq_agenda_w) loop 
			if (ds_mensagem_p IS NOT NULL AND ds_mensagem_p::text <> '') then 
				ds_mensagem_w := ds_mensagem_p;
				ie_tipo_mensagem_w := 'M';
			elsif (ds_texto_sms_padrao_w IS NOT NULL AND ds_texto_sms_padrao_w::text <> '') and (ie_utiliza_sms_padrao_w = 'S') then	 
				ds_mensagem_w := ds_texto_sms_padrao_w;
				ie_tipo_mensagem_w := 'N';
			else 
				ds_mensagem_w := ds_texto_padrao_antigo_w;
				ie_tipo_mensagem_w := 'A';
			end if;
			if (ie_tipo_mensagem_w in ('M','N')) then 
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DT_AGENDA@', r_agendamento_w.dt_agenda);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@NM_PACIENTE@', r_agendamento_w.nm_paciente);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@NM_MEDICO@', r_agendamento_w.nm_medico);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@PRIMEIRO_NOME@', r_agendamento_w.primeiro_nome);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@ESPECIALIDADE@', r_agendamento_w.especialidade);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@ESTAB@', obter_nome_estab(obter_estabelecimento_ativo));
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@ESTAB_AGENDA@', r_agendamento_w.estab_agenda);			
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DT_RESUMIDA@', r_agendamento_w.dt_resumida);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DT_DIA_MES@', r_agendamento_w.dt_dia_mes);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DT_HOR_MIN@', r_agendamento_w.dt_hor_min);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@NM_MEDICO_RESUMIDO@', r_agendamento_w.nm_medico_resumido);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DS_CURTA@', r_agendamento_w.DS_CURTA);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DS_COMPLEMENTO@', r_agendamento_w.ds_complemento);
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@NM_SOBRENOME_MED@', r_agendamento_w.nm_sobrenome_med);
			elsif (ie_tipo_mensagem_w = 'A') then 
				ds_mensagem_w := replace_macro(ds_mensagem_w, '@DT_AGENDA@', r_agendamento_w.dt_agenda);
			end if;
			 
			 
			if (coalesce(r_agendamento_w.cd_agenda,0) > 0) and (r_agendamento_w.nr_telefone IS NOT NULL AND r_agendamento_w.nr_telefone::text <> '') and (r_agendamento_w.nr_seq_agenda IS NOT NULL AND r_agendamento_w.nr_seq_agenda::text <> '')	then 
					ds_erro_w := enviar_sms_agenda_cons(ds_remetente_p, r_agendamento_w.nr_telefone, ds_mensagem_w, r_agendamento_w.cd_agenda, r_agendamento_w.nr_seq_agenda, nm_usuario_p, ds_erro_w);
					if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then 
						ds_retorno_p := wheb_mensagem_pck.get_texto(307461); -- Pode ter ocorrido algum erro no envio de SMS. 
					elsif (coalesce(ds_erro_w::text, '') = '') and (ie_confirmar_p = 'S') then
						update	agenda_consulta 
						set		dt_confirmacao = clock_timestamp(), 
								nm_usuario_confirm = obter_usuario_ativo 
						where	nr_sequencia = r_agendamento_w.nr_seq_agenda;
						commit;
					end if;
			end if;
			 
		end loop;	
		 
		if (coalesce(ds_retorno_p::text, '') = '') then 
			ds_retorno_p := wheb_mensagem_pck.get_texto(307459); -- SMSs enviadas com sucesso! 
		end if;
		 
	end loop;
end if;
 
commit;
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_agenda_cons_js ( ds_lista_agendas_p text, ds_remetente_p text, ds_mensagem_p text, ie_confirmar_p text, ds_retorno_p INOUT text, nm_usuario_p text) FROM PUBLIC;
