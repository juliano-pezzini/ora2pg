-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_obs_leito_interditado ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, ds_observacao_p text, cd_motivo_interdicao_p bigint, ie_opcao_p text, qt_dias_interditacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

/* 
I = Interditar leito
L = Liberar leito interditado
*/
nr_seq_interno_w	bigint;
ie_inativar_leito_w	varchar(1);
Log_w			varchar(4000);
ds_mascara_w		varchar(100);


BEGIN

ie_inativar_leito_w := obter_param_usuario(44, 249, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_inativar_leito_w);
ds_mascara_w := pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, nm_usuario_p));

if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') and (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') and (cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '') then
	
	if (ie_opcao_p = 'I') then
		if (coalesce(qt_dias_interditacao_p,0) < 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(203669);
		end if;
		
		update	unidade_atendimento
		set	ie_status_unidade   	= 'I',
			ie_bloqueio_transf	= 'S',
			ds_observacao		= CASE WHEN ds_observacao_p = NULL THEN  ds_observacao  ELSE ds_observacao_p END ,
			dt_atualizacao		= clock_timestamp(),
			dt_interdicao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p,
			cd_motivo_interdicao	= cd_motivo_interdicao_p,
			qt_dias_prev_interd 	= coalesce(qt_dias_interditacao_p,0)
		where	cd_setor_atendimento	= cd_setor_atendimento_p
		and	cd_unidade_basica	= cd_unidade_basica_p
		and	cd_unidade_compl	= cd_unidade_compl_p;
	
		
		Log_w	:= substr(wheb_mensagem_pck.get_texto(803435,
								'NM_USUARIO='||nm_usuario_p||
								';DT_ATUAL='||to_char(clock_timestamp(), ds_mascara_w)||
								';CD_SETOR_ATENDIMENTO='||cd_setor_atendimento_p||
								';CD_UNIDADE_BASICA='||cd_unidade_basica_p||
								';CD_UNIDADE_COMPL='||cd_unidade_compl_p)||chr(13)||chr(10)||
					' call stack: '||dbms_utility.format_call_stack,1,4000);

		insert into log_mov(dt_atualizacao, nm_usuario, ds_log, cd_log)
		values (clock_timestamp(), nm_usuario_p,substr(Log_w,1,4000),789);

		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_interno_w
		from	unidade_atendimento
		where	cd_unidade_basica	=	cd_unidade_basica_p
		and	cd_unidade_compl	=	cd_unidade_compl_p
		and	cd_setor_atendimento	=	cd_setor_atendimento_p;

		if (nr_seq_interno_w > 0) then
			CALL gerar_higienizacao_leito_unid(clock_timestamp(),nm_usuario_p,null,'IL',nr_seq_interno_w,null);
		end if;
		
		if (ie_inativar_leito_w = 'S') then
			update	unidade_atendimento
			set 	ie_situacao = 'I'
			where 	nr_seq_interno = nr_seq_interno_w;
		end if;
		

	elsif (ie_opcao_p = 'L') then
		
		update	unidade_atendimento
		set	ds_observacao		 = NULL,
			dt_atualizacao		= clock_timestamp(),
			dt_interdicao		 = NULL,
			nm_usuario		= nm_usuario_p,
			cd_motivo_interdicao	 = NULL,
			qt_dias_prev_interd	 = NULL,
			ie_bloqueio_transf	= 'N'
		where	cd_setor_atendimento	= cd_setor_atendimento_p
		and	cd_unidade_basica	= cd_unidade_basica_p
		and	cd_unidade_compl	= cd_unidade_compl_p;
		
		if (coalesce((pkg_i18n.get_user_locale), 'pt_BR') in ('de_DE', 'de_AT')) then
			update	unidade_atendimento
			set	ie_status_unidade   	= 'L'
			where	cd_setor_atendimento	= cd_setor_atendimento_p
			and	cd_unidade_basica	= cd_unidade_basica_p
			and	cd_unidade_compl	= cd_unidade_compl_p;
		end if;
		
		Log_w	:= substr(wheb_mensagem_pck.get_texto(803436,
							'NM_USUARIO='||nm_usuario_p||
							';DT_ATUAL='||to_char(clock_timestamp(), ds_mascara_w)||
							';CD_SETOR_ATENDIMENTO='||cd_setor_atendimento_p||
							';CD_UNIDADE_BASICA='||cd_unidade_basica_p||
							';CD_UNIDADE_COMPL='||cd_unidade_compl_p)||chr(13)||chr(10)||
			' call stack: '||dbms_utility.format_call_stack,1,4000);

		insert into log_mov(dt_atualizacao, nm_usuario, ds_log, cd_log)
		values (clock_timestamp(), nm_usuario_p,substr(Log_w,1,4000),789);
		
		
		if (ie_inativar_leito_w = 'S') then
			update	unidade_atendimento
			set 	ie_situacao = 'A'
			where 	nr_seq_interno = nr_seq_interno_w;
		end if;
	end if;
end if;

commit;	

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_obs_leito_interditado ( cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, ds_observacao_p text, cd_motivo_interdicao_p bigint, ie_opcao_p text, qt_dias_interditacao_p bigint, nm_usuario_p text) FROM PUBLIC;
