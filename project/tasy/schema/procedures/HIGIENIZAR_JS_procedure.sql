-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE higienizar_js ( ie_opcao_p bigint, ie_tipo_p bigint, cd_setor_atual_p text, cd_unidade_basica_p text, cd_unidade_compl_p text, ie_tipo_acomod_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_solicitar_senha_p INOUT text) AS $body$
DECLARE


ie_hig_se_setor_sem_acomod_w	varchar(1);
ie_hig_setor_sem_acomod_w	varchar(1);
ie_aguard_higienizar_transf_w	varchar(1);
ie_considera_estr_atend_w	varchar(1);
ie_considerar_hig_estr_w	varchar(1);
ie_exige_senha_transf_alta_w	varchar(1);
ie_inativa_leito_w		varchar(1);
ie_ativa_leito_agrup_w	varchar(1);
ie_continua_processo_w	varchar(1)	:= 'S';
ds_sql_w			varchar(4000);
ie_sem_acomod_w		varchar(1);
ie_higieniza_leito_w	varchar(1);
nm_usuario_higienizacao_w	varchar(100);
ie_status_unidade_w		varchar(100);
dt_inicio_w		varchar(100);
dt_fim_w			varchar(100);


BEGIN

if (coalesce(ie_opcao_p::text, '') = '') or (ie_opcao_p = 1) then
	begin
	if (ie_tipo_p = 10) then
		begin
		/* Movimentação de Pacientes - Parâmetro [146] - Ao gerar transferência, se o setor escolhido for um setor sem acomodação, gerar higienização para o leito anterior */

		ie_hig_se_setor_sem_acomod_w := obter_param_usuario(3111, 146, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_hig_se_setor_sem_acomod_w);

		if (ie_hig_se_setor_sem_acomod_w = 'N') then
			begin
			ie_sem_acomod_w	:= obter_se_sem_acomodacao(ie_tipo_acomod_p);

			if (ie_sem_acomod_w = 'S') then
				ie_continua_processo_w	:= 'N';
			end if;
			end;
		end if;
		end;
	end if;

	if (ie_continua_processo_w = 'S') then
		begin
		/* Movimentação de Pacientes - Parâmetro [157] - Higienizar setor sem acomodação ao realizar altas ou transferências  */

		ie_hig_setor_sem_acomod_w := obter_param_usuario(3111, 157, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_hig_setor_sem_acomod_w);

		if (ie_hig_setor_sem_acomod_w = 'S')then
			begin
			ie_sem_acomod_w	:= obter_se_sem_acomodacao(obter_tipo_acomod_leito(cd_setor_atual_p, cd_unidade_basica_p, cd_unidade_compl_p, 'C'));

			if (ie_sem_acomod_w = 'S')then
				ie_continua_processo_w	:= 'N';
			end if;
			end;
		end if;
		end;
	end if;

	if (ie_continua_processo_w = 'S') then
		begin
		/* Movimentação de Pacientes - Parâmetro [137] - Utilizar status de aguardando higienização ao registrar a transferência do paciente */

		ie_aguard_higienizar_transf_w := obter_param_usuario(3111, 137, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_aguard_higienizar_transf_w);

		if (ie_aguard_higienizar_transf_w <> 'C') then
			begin
			/* Movimentação de Pacientes - Parâmetro [158] - Ao higienizar, considerar os parâmetros de controle de higienização da estrutura de atendimento para altas, transferências e saída real */

			ie_considera_estr_atend_w := obter_param_usuario(3111, 158, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_considera_estr_atend_w);

			if (ie_considera_estr_atend_w = 'S') then
				begin
				ie_higieniza_leito_w	:= obter_se_higieniza_leito(cd_setor_atual_p, cd_unidade_basica_p, cd_unidade_compl_p);

				if (ie_higieniza_leito_w <> 'H')then
					ie_continua_processo_w	:= 'N';
				end if;
				end;
			end if;
			end;
		else
			/* Movimentação de Pacientes - Parâmetro [167] - Ao transferir o paciente, gerar saída real ou alta, considerar controle de higienização da estrutura de atendimento */

			ie_considerar_hig_estr_w := obter_param_usuario(3111, 167, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_considerar_hig_estr_w);

			if (ie_considerar_hig_estr_w = 'N') then
				begin
				ie_higieniza_leito_w	:= obter_se_higieniza_leito(cd_setor_atual_p, cd_unidade_basica_p, cd_unidade_compl_p);

				if (ie_higieniza_leito_w = 'N')then
					ie_continua_processo_w	:= 'N';
				end if;
				end;
			end if;
		end if;
		end;
	end if;

	if (ie_continua_processo_w = 'S') then
		begin
		/* Movimentação de Pacientes - Parâmetro [179] - Solicitar senha ao alterar o status do leito ao gerar Alta ou Transferência */

		ie_exige_senha_transf_alta_w := obter_param_usuario(3111, 179, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_exige_senha_transf_alta_w);

		if (ie_exige_senha_transf_alta_w = 'S') then
			begin
			ie_continua_processo_w	:= 'N';
			ie_solicitar_senha_p	:= 'S';
			end;
		end if;
		end;
	end if;
	end;
end if;

if (coalesce(ie_opcao_p::text, '') = '') or
	(ie_opcao_p = 1 AND ie_continua_processo_w = 'S') or (ie_opcao_p = 2) then
	begin
	nm_usuario_higienizacao_w	:= ', nm_usuario_higienizacao = ' || nm_usuario_p;
	if (ie_tipo_p = 10)then
		begin
		ie_status_unidade_w	:= ' ie_status_unidade = ''H';
		dt_inicio_w	:= ', dt_inicio_higienizacao = ' || clock_timestamp();
		dt_fim_w		:= ', dt_higienizacao = null ';
		end;
	elsif (ie_tipo_p = 9)then
		begin
		ie_status_unidade_w	:= ' ie_status_unidade = ''A';
		dt_inicio_w	:= ', dt_inicio_higienizacao = null ';
		dt_fim_w		:= ', dt_higienizacao = null ';
		end;
	elsif (ie_tipo_p = 8)then
		begin
		ie_status_unidade_w	:= ' ie_status_unidade = ''G';
		dt_inicio_w	:= ', dt_inicio_higienizacao = null ';
		dt_fim_w		:= ', dt_higienizacao = null ';
		end;
	else
		begin
		ie_status_unidade_w		:= ' ie_status_unidade = ''L ';
		nm_usuario_higienizacao_w	:= ', nm_usuario_fim_higienizacao = ' || nm_usuario_p;
		dt_inicio_w		:= '';
		dt_fim_w			:= ', dt_higienizacao = ' || clock_timestamp();
		end;
	end if;

	if (cd_setor_atual_p <> '') and (cd_setor_atual_p > '0')then
		begin
		ds_sql_w	:=
			' update	unidade_atendimento ' ||
			' set	'|| ie_status_unidade_w ||
				nm_usuario_higienizacao_w ||
				dt_inicio_w ||
				dt_fim_w ||
				', nm_usuario	= ' || nm_usuario_p ||
				', dt_atualizacao	= ' || clock_timestamp() ||
			' where 	cd_unidade_basica	= ' || cd_unidade_basica_p ||
			' and 	cd_unidade_compl	= ' || cd_unidade_compl_p ||
			' and 	cd_setor_atendimento = ' || cd_setor_atual_p;

		CALL exec_sql_dinamico_bv('PROCEDURE_25328', ds_sql_w, '');
		commit;
		end;
	end if;

	if (ie_tipo_p = 11)then
		begin
		/* Movimentação de Pacientes - Parâmetro [122] - Inativar leito temporário ao terminar a higienização */

		ie_inativa_leito_w := obter_param_usuario(3111, 122, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_inativa_leito_w);

		if (ie_inativa_leito_w = 'S')then
			CALL desativa_unidade_temp(cd_setor_atual_p, cd_unidade_basica_p, cd_unidade_compl_p, nm_usuario_p);
		end if;

		/* Movimentação de Pacientes - Parâmetro [123] - Ao finalizar a higienização do leito temporário e inativá-lo automaticamente, ativar os leitos do agrupamento */

		ie_ativa_leito_agrup_w := obter_param_usuario(3111, 123, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_ativa_leito_agrup_w);

		if (ie_ativa_leito_agrup_w = 'S')then
			CALL ativar_leitos_agrupamento(cd_setor_atual_p, cd_unidade_basica_p, cd_unidade_compl_p, nm_usuario_p);
		end if;
		end;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE higienizar_js ( ie_opcao_p bigint, ie_tipo_p bigint, cd_setor_atual_p text, cd_unidade_basica_p text, cd_unidade_compl_p text, ie_tipo_acomod_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_solicitar_senha_p INOUT text) FROM PUBLIC;

