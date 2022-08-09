-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_email_agenda_regra (()is nr_seq_regra_w regra_agenda_email.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE

RETURN_W	varchar(255);
  agendamento_w RECORD;

BEGIN
	select upper(
		utl_raw.overlay(
			utl_raw.bit_or(
				 utl_raw.bit_and(utl_raw.substr(dbms_crypto.randombytes(32), 7, 1), '0F'), '40'
				 ),dbms_crypto.randombytes(32), 7
			)
		)
	into STRICT RETURN_W
	;
	
	return	RETURN_W;
end;

function obter_email_paciente(	nr_seq_agendamento_p in number,
								cd_tipo_agendamento_p in varchar2) return varchar2 is
return_w	varchar2(100);
ie_agenda_web_w		agenda_paciente.ie_agenda_web%type;
cd_pessoa_fisica_w	agenda_paciente.cd_pessoa_fisica%type;
nm_usuario_orig_w	agenda_paciente.nm_usuario_orig%type;
begin

	if (cd_tipo_agendamento_p = 'E') then
		select 	ie_agenda_web,
				cd_pessoa_fisica,
				nm_usuario_orig
		into STRICT	ie_agenda_web_w,
				cd_pessoa_fisica_w,
				nm_usuario_orig_w
		from 	agenda_paciente
		where 	nr_sequencia = nr_seq_agendamento_p;
	else
		select 	ie_agenda_web,
				cd_pessoa_fisica,
				nm_usuario_origem
		into STRICT	ie_agenda_web_w,
				cd_pessoa_fisica_w,
				nm_usuario_orig_w
		from 	agenda_consulta
		where 	nr_sequencia = nr_seq_agendamento_p;
	end if;
	
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		return_w := OBTER_COMPL_PF(cd_pessoa_fisica_w,1,'M');
	elsif (ie_agenda_web_w = 'S') then
		select	ws.ds_email
		into STRICT	return_w
		from	wsuite_usuario wu,
				wsuite_solic_inclusao_pf ws
		where 	wu.ds_login = nm_usuario_orig_w
		and 	wu.nr_seq_inclusao_pf = ws.nr_sequencia;
	end if;
	
return return_w;

end;


Procedure gravar_log_envio_email(ie_status_envio_p 	in varchar2,
								 nr_seq_agenda_p 	in number, 
								 cd_tipo_agenda_p 	in number,
								 ds_hash_token_p	in varchar2,
								 cd_agenda_p		in number) is 

ds_stack_trace_w	varchar2(4000);
								 
begin
	/*IE_STATUS_ENVIO_P:
	E - Erro
	S - Sucesso*/
	if (ie_status_envio_p = 'E') then
		ds_stack_trace_w := SUBSTR(SQLERRM, 1, 2000);--dbms_utility.format_call_stack;
	end if;

	insert into log_envio_email_agenda(
					nr_sequencia,
					ds_hash_token_wsuite,
					dt_token_utilizado,
					dt_token_valido,
					ds_stack_trace,
					ie_status_envio,
					nr_seq_agenda,	
					cd_tipo_agenda,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_atualizacao,
					nm_usuario,
					cd_agenda
					) values (
					nextval('log_envio_email_agenda_seq'),
					ds_hash_token_p,
					null,
					clock_timestamp() + interval '1 days', --valido por 24 horas
					ds_stack_trace_w,
					ie_status_envio_p,
					nr_seq_agenda_p,
					cd_tipo_agenda_p,
					clock_timestamp(),
					nm_usuario_regra_w,
					clock_timestamp(),
					nm_usuario_regra_w,
					cd_agenda_p);
				
	commit;

end;

procedure formatar_texto_html(ds_mensagem_p in varchar2, ie_confirmar_p in varchar2, ie_reagendar_p in varchar2, ie_cancelar_p in varchar2, ds_hash_token_p in varchar2, ds_texto_html_p out varchar2) is
div_botao_w			varchar2(4000);
ds_link_portal_w 	WSUITE_CONFIGURACAO.DS_LINK_WEB_SUITE%type;
qt_length_link_w	number(10);
begin
	select 	max(DS_LINK_WEB_SUITE)
	into STRICT	ds_link_portal_w
	from 	WSUITE_CONFIGURACAO
	where	ie_aplicacao = 1;
	
	qt_length_link_w := length(ds_link_portal_w);
	if substr(ds_link_portal_w,qt_length_link_w-1,qt_length_link_w) = '/' then
		ds_link_portal_w := substr(ds_link_portal_w,1,qt_length_link_w-1);
	end if;
	
	if (ie_confirmar_p = 'S') then
		
		div_botao_w := div_botao_w || '
        <a
          href="'||ds_link_portal_w||'/public/scheduling-actions/type/C/'||ds_hash_token_p||'"
          style="
            padding: 0.5rem 1rem;
            font-size: 1rem;
            color: #FFFFFF;
            text-decoration: none;
            height: 40px;
            line-height: 40px;
            display: block;
            justify-content: center;
            border-radius: 2px;
            background-color: #1477A9;
            text-align: center;
          "
        >
          Confirm appointment</a>';
	end if;
	if (ie_reagendar_p = 'S') then
		
		div_botao_w := div_botao_w || '
        <a 
          href="'||ds_link_portal_w||'"
          style="
            padding: 0.5rem 1rem;
            font-size: 1rem;
            text-decoration: none;
            height: 40px;
            line-height: 40px;
            display: block;
            border-radius: 2px;
            margin-top: 1.5rem;
            background-color: #A0D4E4;
            color: #1477A9;
            text-align: center;
          "
        >
          Reschedule
        </a>';
	end if;
	if (ie_cancelar_p = 'S') then
		
		div_botao_w := div_botao_w || '
        <a 
          href="'||ds_link_portal_w||'/public/scheduling-actions/type/A/'||ds_hash_token_p||'"
          style="
            padding: 0.5rem 1rem;
            font-size: 1rem;
            text-decoration: none;
            height: 40px;
            line-height: 40px;
            display: block;
            border-radius: 2px;
            margin-top: 1.5rem;
            background-color: #FFFFFF;
            color: #1477A9;
            text-align: center;
          "
        >
          Cancel appointment
        </a>';
	end if;
	if (div_botao_w IS NOT NULL AND div_botao_w::text <> '') then
		div_botao_w := '<div style="margin: 2.5rem 0 2.5rem;">'||div_botao_w||'</div>';
	end if;
	
	ds_texto_html_p := '<!DOCTYPE HTML>
                        <html TASY="HTML5"> 
						<head>
							<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
							<meta name="viewport" content="width=device-width, initial-scale=1.0" />
                            <link rel="preconnect" href="https://fonts.googleapis.com" />
                            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
                            <link href="https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;700'||chr(38)||'display=swap" rel="stylesheet" />
						</head>
						<body style="margin:0;padding:0;background-color: #edebe9;margin: 0 auto;padding: 0;box-sizing: border-box;font-family: "Noto Sans", Verdana;"> 
							<div 
                              style="background-color: #FFFFFF; padding: 5rem 1.5rem 1.5rem;max-width: 600px;margin:0 auto;"
                            >
                                <div 
                                  style="background-color: #FFFFFF;"
                                >
                                  <img 
                                    src="https://svgshare.com/i/d2X.svg" 
                                    alt="Philips Clinical Informatics" width="62"
                                    style="margin: 0 auto; display: block"
                                />
                                </div>
                                <div style="margin-top: 5rem;">
                                    <p style="
                                        line-height: 1.187rem;
                                        font-size: 0.875rem;
                                        color: #000000;"
                                    >'
                                    ||ds_mensagem_p||	
                                    '</p>
                                </div>
                                <div>'
                                    ||div_botao_w||
                                '</div>
							</div>
					   </body> 
					   </html>';	
end;

procedure enviar_agendamento_consulta(ie_botao_confirmar_P in varchar2, ie_botao_cancelar_p in varchar2, ie_botao_reagendar_p in varchar2) is

ds_mensagem_email_w	varchar2(32000);
ds_mensagem_html_w 	varchar2(32000);
ds_hash_token_w		varchar2(255);
ds_email_w			agenda_consulta.ds_email%type;

begin
	for agendamento_w in (SELECT	distinct
									substr(obter_primeiro_nome(coalesce(obter_nome_pf(a.cd_pessoa_fisica), a.nm_paciente)),1,255) nm_paciente,
									to_char(a.dt_agenda, 'dd/mm/yyyy hh24:mi') dt_agenda,				
									substr(coalesce(obter_desc_espec_medica(b.cd_especialidade), obter_nome_medico_combo_agcons(b.cd_estabelecimento, b.cd_agenda, 3, 'N')),1,255) ds_item_agenda,
									a.nr_sequencia nr_sequencia,
									a.cd_pessoa_fisica cd_pessoa_fisica,
									coalesce(obter_nome_especialidade(b.cd_especialidade), wheb_mensagem_pck.get_texto(793293)) ds_especialidade,
									substr(coalesce(obter_nome_medico(a.cd_medico_req,'N'), b.ds_curta),1,60) nm_medico_req,
									substr(coalesce(obter_nome_medico(b.cd_pessoa_fisica,'N'), b.ds_curta),1,60) nm_medico_agenda,
									substr(obter_nome_medico_combo_agcons(b.cd_estabelecimento, b.cd_agenda, 3, 'N'),1,255) ds_agenda,
									substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,255) ds_estab_agenda,
									a.ds_email ds_email_paciente,
									coalesce(b.DS_ENDERECO_AGENDA,PJ.DS_ENDERECO||', '||PJ.NR_ENDERECO||' - '||PJ.DS_BAIRRO||' - '||PJ.DS_MUNICIPIO||' - '||PJ.CD_CEP) ds_endereco_estab,
									b.cd_agenda cod_agenda
							from	agenda_consulta a,
									agenda b,
									ESTABELECIMENTO E,
									PESSOA_JURIDICA PJ
							where	a.cd_agenda		= b.cd_agenda
							and 	b.cd_estabelecimento = e.cd_estabelecimento
							and     e.cd_cgc = pj.cd_cgc
							and		b.cd_tipo_agenda	= 3
							and		b.ie_situacao		= 'A'
							and		a.dt_agenda between trunc(dt_regra_w) and trunc(dt_regra_w) + 86399/86400
							--and		a.cd_pessoa_fisica	is not null
							and		a.ie_status_agenda 	not in ('C', 'L', 'B', 'II', 'F', 'I','E','A','O','LF')
							and		((b.cd_estabelecimento	= cd_estabelecimento_w) or (coalesce(cd_estabelecimento_w::text, '') = ''))
							and (not exists (select	1
												from	log_envio_email_agenda x
												where	x.nr_seq_agenda		= a.nr_sequencia
												and		x.cd_tipo_agenda 	= 3
												and		x.ie_status_envio	<> 'E'))
							and		((b.cd_agenda = cd_agenda_w) or (coalesce(cd_agenda_w::text, '') = ''))
							order by 	1,2) loop

		ds_mensagem_email_w := ds_conteudo_w;
						
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@PACIENTE', agendamento_w.nm_paciente),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@DATA', agendamento_w.dt_agenda),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@ITEM', agendamento_w.ds_item_agenda),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@ESTABELECIMENTO', agendamento_w.ds_estab_agenda),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@ESTAB_ENDERECO', agendamento_w.ds_endereco_estab),1,32000);				
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@ESPECIALIDADE', agendamento_w.ds_especialidade),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@MEDICO_AGENDA', agendamento_w.nm_medico_agenda),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@MEDICO_REQ', agendamento_w.nm_medico_req),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@AGENDA', agendamento_w.ds_agenda),1,32000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@SETOR', ''),1,32000);
		
		--Substitui marcadores de quebra para html
		ds_mensagem_email_w	:= substr(replace(ds_mensagem_email_w, chr(13), '<br>'),1,32000);
		ds_mensagem_email_w	:= substr(replace(ds_mensagem_email_w, chr(10), '<br>'),1,32000);
		
		--gera o token
		ds_hash_token_w := gerar_token;
		
		formatar_texto_html(ds_mensagem_email_w,ie_botao_confirmar_P,ie_botao_reagendar_p,ie_botao_cancelar_p,ds_hash_token_w,ds_mensagem_html_w);
		
		ds_email_w := coalesce(agendamento_w.ds_email_paciente,obter_email_paciente(agendamento_w.nr_sequencia,'C'));
		if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then
			begin
				CALL enviar_email(ds_assunto_w,ds_mensagem_html_w,ds_email_remetente_w, ds_email_w, nm_usuario_regra_w,'M');
				gravar_log_envio_email('S',agendamento_w.nr_sequencia,3,ds_hash_token_w,agendamento_w.cod_agenda);
			exception
			when others then
				gravar_log_envio_email('E',agendamento_w.nr_sequencia,3,ds_hash_token_w,agendamento_w.cod_agenda);
			end;
		end if;
	end loop;
end;

procedure enviar_agendamento_exame(ie_botao_confirmar_P in varchar2, ie_botao_cancelar_p in varchar2, ie_botao_reagendar_p in varchar2) is

ds_mensagem_email_w	varchar2(32000);	
ds_mensagem_html_w 	varchar2(32000);
ds_hash_token_w		varchar2(255);
ds_email_w			agenda_paciente.ds_email%type;

begin
	for agendamento_w in (SELECT	distinct
									substr(obter_primeiro_nome(coalesce(obter_nome_pf(a.cd_pessoa_fisica), a.nm_paciente)),1,255) nm_paciente,
									to_char(a.hr_inicio, 'dd/mm/yyyy hh24:mi') dt_agenda,		
									substr(Obter_Item_Grid_Ageint(a.nr_seq_proc_interno, a.cd_medico, b.cd_especialidade, b.cd_estabelecimento, d.nr_seq_item_selec),1,255) ds_item_agenda,		
									a.nr_sequencia nr_sequencia,
									a.cd_pessoa_fisica cd_pessoa_fisica,
									b.cd_agenda cd_agenda,
									wheb_mensagem_pck.get_texto(793301) ds_especialidade,
									substr(obter_nome_medico(a.cd_medico,'N'),1,60) nm_medico_req,
									substr(obter_nome_medico(a.cd_medico_exec,'N'),1,60) nm_medico_exec,
									substr(coalesce(obter_desc_setor_atend(a.cd_setor_atendimento),''),1,60) ds_setor_atendimento,
									substr(obter_desc_agenda(b.cd_agenda),1,255) ds_agenda,
									substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,255) ds_estab_agenda,
									a.ds_email ds_email_paciente,
									coalesce(b.DS_ENDERECO_AGENDA,PJ.DS_ENDERECO||', '||PJ.NR_ENDERECO||' - '||PJ.DS_BAIRRO||' - '||PJ.DS_MUNICIPIO||' - '||PJ.CD_CEP) ds_endereco_estab,
									b.cd_agenda cod_agenda
							FROM pessoa_juridica pj, estabelecimento e, agenda b, agenda_paciente a
LEFT OUTER JOIN agenda_integrada_item d ON (a.nr_sequencia = d.nr_seq_agenda_exame)
WHERE a.cd_agenda			= b.cd_agenda  and b.cd_estabelecimento = e.cd_estabelecimento and e.cd_cgc = pj.cd_cgc and b.cd_tipo_agenda		= 2 and b.ie_situacao			= 'A' and a.hr_inicio between trunc(dt_regra_w) and trunc(dt_regra_w) + 86399/86400 --and	a.cd_pessoa_fisica	is not null
  and a.ie_status_agenda 	not in ('C', 'L', 'B', 'II', 'F', 'I','E','A','O','LF') and ((b.cd_estabelecimento	= cd_estabelecimento_w) or (coalesce(cd_estabelecimento_w::text, '') = '')) and (not exists (select	1
											from	log_envio_email_agenda x
											where	x.nr_seq_agenda		= a.nr_sequencia
											and		x.cd_tipo_agenda 	= 2
											and		x.ie_status_envio	<> 'E')) and ((b.cd_agenda = cd_agenda_w) or (coalesce(cd_agenda_w::text, '') = '')) order by 1,2) loop
							
		ds_mensagem_email_w := ds_conteudo_w;
		
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@PACIENTE', agendamento_w.nm_paciente),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@DATA', agendamento_w.dt_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@ITEM', agendamento_w.ds_item_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@ESTABELECIMENTO', agendamento_w.ds_estab_agenda),1,2000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@ESTAB_ENDERECO', agendamento_w.ds_endereco_estab),1,32000);	
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@ESPECIALIDADE', agendamento_w.ds_especialidade),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@MEDICO_AGENDA', agendamento_w.nm_medico_exec),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@MEDICO_REQ', agendamento_w.nm_medico_req),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@AGENDA', agendamento_w.ds_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@SETOR', agendamento_w.ds_setor_atendimento),1,2000);
		
		--Substitui marcadores de quebra para html
		ds_mensagem_email_w	:= substr(replace(ds_mensagem_email_w, chr(13), '<br>'),1,32000);
		ds_mensagem_email_w	:= substr(replace(ds_mensagem_email_w, chr(10), '<br>'),1,32000);
		
		--gera o token
		ds_hash_token_w := gerar_token;
		
		formatar_texto_html(ds_mensagem_email_w,ie_botao_confirmar_P,ie_botao_reagendar_p,ie_botao_cancelar_p,ds_hash_token_w,ds_mensagem_html_w);
		
		ds_email_w := coalesce(agendamento_w.ds_email_paciente,obter_email_paciente(agendamento_w.nr_sequencia,'E'));
		if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then
			begin
				CALL enviar_email(ds_assunto_w,ds_mensagem_html_w,ds_email_remetente_w, ds_email_w, nm_usuario_regra_w,'M');
				gravar_log_envio_email('S',agendamento_w.nr_sequencia,2,ds_hash_token_w,agendamento_w.cod_agenda);
			exception
			when others then
				gravar_log_envio_email('E',agendamento_w.nr_sequencia,2,ds_hash_token_w,agendamento_w.cod_agenda);
			end;
		end if;
	end loop;
end;

procedure enviar_agendamento_servico(ie_botao_confirmar_P in varchar2, ie_botao_cancelar_p in varchar2, ie_botao_reagendar_p in varchar2) is

ds_mensagem_email_w	varchar2(32000);
ds_mensagem_html_w 	varchar2(32000);
ds_hash_token_w		varchar2(255);
ds_email_w			agenda_consulta.ds_email%type;

begin
	for agendamento_w in (SELECT	distinct
									substr(obter_primeiro_nome(coalesce(obter_nome_pf(a.cd_pessoa_fisica), a.nm_paciente)),1,255) nm_paciente,
									to_char(a.dt_agenda, 'dd/mm/yyyy hh24:mi') dt_agenda,		
									substr(Obter_Item_Grid_Ageint(a.nr_seq_proc_interno, a.cd_medico, b.cd_especialidade, b.cd_estabelecimento, d.nr_seq_item_selec),1,255) ds_item_agenda,		
									a.nr_sequencia nr_sequencia,
									a.cd_pessoa_fisica cd_pessoa_fisica,
									b.cd_agenda cd_agenda,
									coalesce(obter_nome_especialidade(b.cd_especialidade), wheb_mensagem_pck.get_texto(793292)) ds_especialidade,
									substr(obter_nome_medico(a.cd_medico_solic, 'N'),1,60) nm_medico_req,
									substr(obter_nome_medico(a.cd_medico, 'N'),1,60) nm_medico_agenda,
									substr(obter_desc_agenda_servico(b.cd_estabelecimento, b.cd_agenda, 'DEC'),1,255) ds_agenda,
									substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,255) ds_estab_agenda,
									a.ds_email ds_email_paciente,
									coalesce(b.DS_ENDERECO_AGENDA,PJ.DS_ENDERECO||', '||PJ.NR_ENDERECO||' - '||PJ.DS_BAIRRO||' - '||PJ.DS_MUNICIPIO||' - '||PJ.CD_CEP) ds_endereco_estab,
									b.cd_agenda cod_agenda
							FROM pessoa_juridica pj, estabelecimento es, agenda b, agenda_consulta a
LEFT OUTER JOIN autorizacao_convenio c ON (a.nr_sequencia = c.nr_seq_agenda_consulta)
LEFT OUTER JOIN agenda_integrada_item d ON (a.nr_sequencia = d.nr_seq_agenda_cons)
LEFT OUTER JOIN proc_interno f ON (a.nr_seq_proc_interno = f.nr_sequencia)
LEFT OUTER JOIN proc_interno e ON (d.nr_seq_proc_interno = e.nr_sequencia)
WHERE a.cd_agenda			= b.cd_agenda     and b.cd_estabelecimento 	= es.cd_estabelecimento and es.cd_cgc = pj.cd_cgc and b.cd_tipo_agenda		= 5 and b.ie_situacao			= 'A' and a.dt_agenda between trunc(dt_regra_w) and trunc(dt_regra_w) + 86399/86400 --and		a.cd_pessoa_fisica	is not null
  and a.ie_status_agenda 	not in ('C', 'L', 'B', 'II', 'F', 'I','E','A','O','LF') and ((b.cd_estabelecimento	= cd_estabelecimento_w) or (coalesce(cd_estabelecimento_w::text, '') = '')) and (not exists (select	1
												from	log_envio_email_agenda x
												where	x.nr_seq_agenda		= a.nr_sequencia
												and		x.cd_tipo_agenda 	= 5
												and		x.ie_status_envio	<> 'E')) and ((b.cd_agenda = cd_agenda_w) or (coalesce(cd_agenda_w::text, '') = '')) order by 	1,2) loop
	
	
		ds_mensagem_email_w := ds_conteudo_w;
		
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@PACIENTE', agendamento_w.nm_paciente),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@DATA', agendamento_w.dt_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@ITEM', agendamento_w.ds_item_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@ESTABELECIMENTO', agendamento_w.ds_estab_agenda),1,2000);
		ds_mensagem_email_w	:= substr(replace_macro(ds_mensagem_email_w, '@ESTAB_ENDERECO', agendamento_w.ds_endereco_estab),1,32000);	
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@ESPECIALIDADE', agendamento_w.ds_especialidade),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@MEDICO_AGENDA', agendamento_w.nm_medico_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@MEDICO_REQ', agendamento_w.nm_medico_req),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@AGENDA', agendamento_w.ds_agenda),1,2000);
		ds_mensagem_email_w	:= subStr(replace_macro(ds_mensagem_email_w, '@SETOR', ''),1,2000);
		
		--Substitui marcadores de quebra para html
		ds_mensagem_email_w	:= substr(replace(ds_mensagem_email_w, chr(13), '<br>'),1,32000);
		ds_mensagem_email_w	:= substr(replace(ds_mensagem_email_w, chr(10), '<br>'),1,32000);
		
		--gera o token
		ds_hash_token_w := gerar_token;
		
		formatar_texto_html(ds_mensagem_email_w,ie_botao_confirmar_P,ie_botao_reagendar_p,ie_botao_cancelar_p,ds_hash_token_w,ds_mensagem_html_w);
		
		ds_email_w := coalesce(agendamento_w.ds_email_paciente,obter_email_paciente(agendamento_w.nr_sequencia,'S'));
		if (ds_email_w IS NOT NULL AND ds_email_w::text <> '') then
			begin
				CALL enviar_email(ds_assunto_w,ds_mensagem_html_w,ds_email_remetente_w, ds_email_w, nm_usuario_regra_w,'M');
				gravar_log_envio_email('S',agendamento_w.nr_sequencia,5,ds_hash_token_w,agendamento_w.cod_agenda);
			exception
			when others then
				gravar_log_envio_email('E',agendamento_w.nr_sequencia,5,ds_hash_token_w,agendamento_w.cod_agenda);
			end;
		end if;
	end loop;
end;

-------------------	
begin

	if coalesce(philips_param_pck.get_nr_seq_idioma::text, '') = '' then
		CALL philips_param_pck.set_nr_seq_idioma(OBTER_NR_SEQ_IDIOMA('Tasy'));
	end if;

	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w,
		cd_estabelecimento_w,	
		qt_dia_envio_w,			
		ie_tipo_agendamento_w,	
		cd_agenda_w,			
		ds_assunto_w,			
		ds_conteudo_w,
		ds_email_remetente_w,
		nm_usuario_regra_w,
		ie_botao_confirmar_w,
		ie_botao_cancelar_w,
		ie_botao_reagendar_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			CALL wheb_usuario_pck.set_cd_estabelecimento(cd_estabelecimento_w);
			dt_regra_w := trunc(clock_timestamp() + qt_dia_envio_w);	
					
			if (ie_tipo_agendamento_w = 'C') then
				enviar_agendamento_consulta(ie_botao_confirmar_w,ie_botao_cancelar_w,ie_botao_reagendar_w);
			elsif (ie_tipo_agendamento_w = 'E') then
				enviar_agendamento_exame(ie_botao_confirmar_w,ie_botao_cancelar_w,ie_botao_reagendar_w);
			elsif (ie_tipo_agendamento_w = 'S') then
				enviar_agendamento_servico(ie_botao_confirmar_w,ie_botao_cancelar_w,ie_botao_reagendar_w);		
			else
				enviar_agendamento_consulta(ie_botao_confirmar_w,ie_botao_cancelar_w,ie_botao_reagendar_w);
				enviar_agendamento_exame(ie_botao_confirmar_w,ie_botao_cancelar_w,ie_botao_reagendar_w);
				enviar_agendamento_servico(ie_botao_confirmar_w,ie_botao_cancelar_w,ie_botao_reagendar_w);
			end if;
		end;
	end loop;
	close C01;

	commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_agenda_regra (()is nr_seq_regra_w regra_agenda_email.nr_sequencia%type) FROM PUBLIC;
