-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE enviar_sms_aut_agecons (cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_agenda_w		agenda_paciente.nr_sequencia%type;
nr_telefone_w		varchar(50);
cd_agenda_w		bigint;
dt_agenda_w		timestamp;
nm_estabelecimento_w	varchar(255);
nm_pessoa_fisica_w	varchar(60);
cd_estabelecimento_w	smallint;
ds_remetente_sms_w	varchar(255);
cd_tipo_agenda_w	bigint;
ds_erro_w		varchar(255);
ds_mens_padr_agcons_w	varchar(255);
nm_paciente_w		varchar(80);
ds_agenda_w		varchar(255);
ds_prim_nome_pac_w	varchar(100);
ds_procedimento_w	varchar(255);
ds_estabelecimento_w	varchar(255);
dt_resumida_w		varchar(30);
ie_confirm_agend_sms_cons_w	varchar(1);
nm_medico_simples_w			varchar(50);
ie_classif_agenda_regra_w	varchar(5);
ie_classif_agenda_w			varchar(5);
ie_enviar_se_classif_regra_w varchar(1);
ie_enviar_w					varchar(1);
ie_utilizar_ddi_w			varchar(1);				
	
C02 CURSOR FOR
	/*AGENDA DE CONSULTA*/

	SELECT	a.nr_sequencia,
		a.dt_agenda,
		substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,255),
		b.cd_estabelecimento,
		b.cd_tipo_agenda,
		substr(coalesce(obter_nome_pf(a.cd_pessoa_fisica), a.nm_paciente),1,80),
		substr(CASE WHEN b.cd_tipo_agenda=3 THEN  obter_nome_medico_combo_agcons(b.cd_estabelecimento, b.cd_agenda, 3, 'N') WHEN b.cd_tipo_agenda=5 THEN  b.ds_agenda END ,1,255),
		substr(obter_primeiro_nome(coalesce(obter_nome_pf(a.cd_pessoa_fisica), a.nm_paciente)),1,100),
		substr(obter_nome_especialidade(b.cd_especialidade),1,255),
		substr(obter_nome_estabelecimento(b.cd_estabelecimento),1,255),
		to_char(a.dt_agenda, 'dd/mm/yy hh24:mi'),
		substr(obter_primeiro_nome(obter_nome_pessoa_fisica(b.cd_pessoa_fisica, null)),1,50),
		a.ie_classif_agenda
	from	agenda_consulta a,
			agenda b		
	where	a.cd_agenda 			= b.cd_agenda	
	and		b.ie_situacao			= 'A'
	and		coalesce(b.cd_tipo_agenda, 3)	= 3
	and		trunc(a.dt_agenda)		= trunc(clock_timestamp() + interval '1 days')
	and		ie_status_agenda 		not in ('C','L','B','F','I')
	and		(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '')
	and		(a.dt_agendamento IS NOT NULL AND a.dt_agendamento::text <> '')	
	and		coalesce(b.cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p
	order by 1;
	
--Regra de classificacoes de agendamento para envio de SMS	
C03 CURSOR FOR
	SELECT	ie_classif_agenda
	from	envio_sms_classif_agenda
	where	ie_situacao	= 'A'
	order by 1;
	

BEGIN

/* Setting locale based on client settings */

if coalesce(philips_param_pck.get_nr_seq_idioma::text, '') = '' then
	CALL philips_param_pck.set_nr_seq_idioma(OBTER_NR_SEQ_IDIOMA('Tasy'));
end if;

ie_confirm_agend_sms_cons_w := Obter_Param_Usuario(821, 188, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_confirm_agend_sms_cons_w);
ie_enviar_se_classif_regra_w := Obter_Param_Usuario(821, 442, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_enviar_se_classif_regra_w);
ie_utilizar_ddi_w := obter_param_usuario(0, 214, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_utilizar_ddi_w);

/*AGENDA DE CONSULTAS*/

open C02;
loop
fetch C02 into	
	nr_seq_agenda_w,
	dt_agenda_w,
	nm_estabelecimento_w,
	cd_estabelecimento_w,
	cd_tipo_agenda_w,
	nm_paciente_w,
	ds_agenda_w,
	ds_prim_nome_pac_w,
	ds_procedimento_w,
	ds_estabelecimento_w,
	dt_resumida_w,
	nm_medico_simples_w,
	ie_classif_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	ie_enviar_w	:= 'S';
	
	if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
		/*MENSAGEM PADRAO SMS -> AGENDA DE CONSULTAS*/

		select	coalesce(max(DS_SMS_AGENDA_CONS),'')
		into STRICT	ds_mens_padr_agcons_w	
		from	parametro_agenda
		where	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;
	end if;
	
	
	if (cd_tipo_agenda_w = 3) then		
		select	max(a.cd_agenda),
			CASE WHEN ie_utilizar_ddi_w='N' THEN max(b.nr_ddi_celular)||' '||max(b.nr_telefone_celular)  ELSE max(b.nr_telefone_celular) END ,
			max(substr(obter_nome_pf(b.cd_pessoa_fisica),1,60))
		into STRICT	cd_agenda_w,
			nr_telefone_w,
			nm_pessoa_fisica_w
		from	pessoa_fisica b,
			agenda_consulta a
		where	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
		and	a.nr_sequencia 		= nr_seq_agenda_w;	
	end if;
	
	if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
		select	max(substr(ds_remetente_sms,1,255))
		into STRICT	ds_remetente_sms_w
		from	parametro_agenda
		where	cd_estabelecimento	= cd_estabelecimento_w;
	end if;
	if (coalesce(ds_remetente_sms_w::text, '') = '') then
		ds_remetente_sms_w	:= nm_estabelecimento_w;
	end if;
	
	if (cd_agenda_w IS NOT NULL AND cd_agenda_w::text <> '') and (nr_telefone_w IS NOT NULL AND nr_telefone_w::text <> '') then		
		begin					
		if (cd_tipo_agenda_w = 3) then
			/*AGENDA DE CONSULTAS*/
			
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@DT_AGENDA@', 		dt_agenda_w);
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@NM_PACIENTE@', 		nm_paciente_w);
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@NM_MEDICO@', 		ds_agenda_w);
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@PRIMEIRO_NOME@', 	ds_prim_nome_pac_w);
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@ESPECIALIDADE@', 	ds_procedimento_w);
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@ESTAB@', 			ds_estabelecimento_w);
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@DT_RESUMIDA@', 		dt_resumida_w);		
			ds_mens_padr_agcons_w	:= replace(ds_mens_padr_agcons_w, '@NM_MED_SIMPLES@', 	nm_medico_simples_w);		
		
		if (ie_enviar_se_classif_regra_w = 'S')then
			ie_enviar_w	:= 'N';
			
			open C03;
			loop
			fetch C03 into	
				ie_classif_agenda_regra_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin
				if (ie_classif_agenda_w = ie_classif_agenda_regra_w) and (ie_enviar_w = 'N')then
					ie_enviar_w	:= 'S';
				end if;
				
				end;
			end loop;
			close C03;
		
		end if;
		
			if (ds_mens_padr_agcons_w IS NOT NULL AND ds_mens_padr_agcons_w::text <> '') and (ie_enviar_w <> 'N')then								
				CALL enviar_sms_agenda(ds_remetente_sms_w, nr_telefone_w, ds_mens_padr_agcons_w, cd_agenda_w, nr_seq_agenda_w, 'Tasy');
			elsif (ie_enviar_w <> 'N')then
				CALL enviar_sms_agenda(ds_remetente_sms_w, nr_telefone_w, wheb_mensagem_pck.get_texto(793150,
											'nm_paciente_w='||nm_pessoa_fisica_w||
											';dt_agenda_dest_w='||to_char(dt_agenda_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(cd_estabelecimento_p, nm_usuario_p)))), cd_agenda_w, nr_seq_agenda_w, 'Tasy');				
			end if;
			
			if (ie_confirm_agend_sms_cons_w = 'S')then				
			
				update	agenda_consulta
                                set     dt_confirmacao 		= clock_timestamp(),
                                        nm_usuario_confirm 	= nm_usuario_p
                                where   nr_sequencia   		= nr_seq_agenda_w;				
				commit;				
				
			end if;

			ds_mens_padr_agcons_w	:= '';
			
		end if;
		--enviar_sms_agenda(ds_remetente_sms_w, nr_telefone_w, 'Senhor(a) '||nm_pessoa_fisica_w||' voce possui um agendamento para o dia '||to_char(dt_agenda_w, 'dd/mm/yyyy hh24:mi'), cd_agenda_w, nr_seq_agenda_w, 'Tasy');
		exception
		when others then		
			ds_erro_w := wheb_mensagem_pck.get_texto(793173);					
		end;		
			
	end if;
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_sms_aut_agecons (cd_perfil_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

