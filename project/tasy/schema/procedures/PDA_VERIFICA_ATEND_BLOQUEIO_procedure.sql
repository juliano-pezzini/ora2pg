-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pda_verifica_atend_bloqueio ( nr_documento_p bigint, ie_tipo_documento_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


/*
Esta procedure retorna se uma PROCESSO está bloqueada para determinado usuário.
O bloqueio acontece sempre após a localizacão de um DOCUMENTO pelo usuário, se o usuário localizar outra solicitação a atual é desbloqueada.
Utilizada inicialmente para o tratamento no PALM
*/
nr_sequencia_w			bigint;
nm_usuario_w			varchar(15);
dt_atualizacao_w			timestamp;
dt_tentativa_w			timestamp;
ie_bloqueado_w			varchar(1);
ie_verifica_bloqueio_w		varchar(1) := 'N';
qt_min_controle_w			bigint;
qt_min_controle_usuario_ww		bigint;
qt_min_diferenca_w			double precision;
ds_retorno_w			varchar(255);



BEGIN

ie_bloqueado_w		:= 'N';
qt_min_controle_w	:= 1;  /*Definição padrão do sistema, logo abaixo pega o valor conforme parâmetro []  do usuário que está realizando o atendimento e função em processo*/
if (qt_min_controle_w > 0) then
	begin

	/*Retorna se uma SOLICITAÇÃO DE TRANSFERÊNCIA está bloqueada para determinado usuário.
	    O bloqueio acontece sempre após a localizacão da solicitação de transferência pelo usuário, se o usuário localizar outra solicitação a atual é desbloqueada. Utilizada inicialmente para o tratamento no PALM*/
	if (ie_tipo_documento_p in ('CT','CF','SK')) then -- Controle Transferência PDA
		delete
		from	pda_atend_bloqueio
		where	nm_usuario = nm_usuario_p
		and	ie_tipo_documento = ie_tipo_documento_p
		and	nr_documento <> nr_documento_p;

		select	coalesce(max(nr_sequencia), 0)
		into STRICT	nr_sequencia_w
		from	pda_atend_bloqueio
		where	nr_documento = nr_documento_p
		and	ie_tipo_documento = ie_tipo_documento_p;

		ie_verifica_bloqueio_w := 'S';


	end if;


	if (coalesce(ie_verifica_bloqueio_w,'N') = 'S') and (nr_sequencia_w = 0) then

		insert into pda_atend_bloqueio(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_documento,
			ie_tipo_documento)
		values (	nextval('pda_atend_bloqueio_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_documento_p,
			ie_tipo_documento_p);

		ie_bloqueado_w	:= 'N';
	else
		begin

		select	nm_usuario,
			dt_atualizacao
		into STRICT	nm_usuario_w,
			dt_atualizacao_w
		from	pda_atend_bloqueio
		where	nr_sequencia	= nr_sequencia_w;

		if (nm_usuario_w = nm_usuario_p) then

			update	pda_atend_bloqueio
			set	dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_sequencia_w;

			ie_bloqueado_w	:= 'N';

		elsif (nm_usuario_w <> nm_usuario_p) then
			begin

			/*Pega o tempo para controle do atendimento conforme parâmetro do PalmWeb ( Usuário que está realizando o atendimento )*/

			if (ie_tipo_documento_p in ('CT','SK'))then
				qt_min_controle_usuario_ww := obter_param_usuario(88, 189, null, nm_usuario_w, cd_estabelecimento_p, qt_min_controle_usuario_ww);
			elsif (ie_tipo_documento_p = 'CF') then
				qt_min_controle_usuario_ww := obter_param_usuario(88, 212, null, nm_usuario_w, cd_estabelecimento_p, qt_min_controle_usuario_ww);
			end if;

			dt_tentativa_w		:= clock_timestamp();
			qt_min_diferenca_w		:= ((dt_tentativa_w - dt_atualizacao_w) * 1440);

			if (qt_min_diferenca_w < qt_min_controle_usuario_ww) then
				ie_bloqueado_w	:= 'S';
			else
				update	pda_atend_bloqueio
				set	nm_usuario	= nm_usuario_p,
					dt_atualizacao	= dt_tentativa_w
				where	nr_sequencia	= nr_sequencia_w;

				ie_bloqueado_w	:= 'N';
			end if;

			end;
		end if;
		end;
	end if;
	end;
end if;

if (ie_bloqueado_w = 'S') then

	if (ie_tipo_documento_p = 'CT') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(281072) || nm_usuario_w || ' !' ||  chr(13) || chr(13) ||
					WHEB_MENSAGEM_PCK.get_texto(281074) || to_char(dt_atualizacao_w,'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
					WHEB_MENSAGEM_PCK.get_texto(281075) || to_char(dt_tentativa_w, 'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
					WHEB_MENSAGEM_PCK.get_texto(281077) || qt_min_controle_usuario_ww || 'min';
	elsif (ie_tipo_documento_p = 'CF') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(281079) || nm_usuario_w || ' !' ||  chr(13) || chr(13) ||
					WHEB_MENSAGEM_PCK.get_texto(281074) || to_char(dt_atualizacao_w,'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
					WHEB_MENSAGEM_PCK.get_texto(281075) || to_char(dt_tentativa_w, 'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
					WHEB_MENSAGEM_PCK.get_texto(281077) || qt_min_controle_usuario_ww || 'min';
	elsif (ie_tipo_documento_p = 'SK') then
		ds_erro_p		:= WHEB_MENSAGEM_PCK.get_texto(281080) || nm_usuario_w || ' !' ||  chr(13) || chr(13) ||
					WHEB_MENSAGEM_PCK.get_texto(281074) || to_char(dt_atualizacao_w,'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
					WHEB_MENSAGEM_PCK.get_texto(281075) || to_char(dt_tentativa_w, 'dd/mm/yyyy hh24:mi:ss') || chr(13) || chr(10) ||
					WHEB_MENSAGEM_PCK.get_texto(281077) || qt_min_controle_usuario_ww || 'min';
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pda_verifica_atend_bloqueio ( nr_documento_p bigint, ie_tipo_documento_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

