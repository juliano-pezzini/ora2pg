-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajusta_status_agenda_int_opme ( nr_seq_agenda_p text, cd_evento_log_p text, ds_descricao_p text, nm_usuario_p text, ie_commit_p text default 'S', cd_estabelecimento_p bigint default null) AS $body$
DECLARE




ie_status_atual_w		varchar(15);

/*Dominio 3095
  cd_evento_log_p
0	= Tasy.				Identificacao da necessidade de OPME

1	= Tasy => Integracao externa.		Envio do agendamento
2	= Integracao externa => Tasy.		Retorno do envio do agendamento - OK
3	= Integracao externa => Tasy.		Retorno do envio do agendamento - C/Erros

9	= Tasy.				Pedido de reenvio do agendamento

10	= Integracao externa => Tasy.		Recebimento log = Triado
20	= Integracao externa => Tasy.		Recebimento log = Em cotacao
30	= Integracao externa => Tasy.		Recebimento log = Cotado
31	= Integracao externa => Tasy.		Recebimento log = Cotado - C/Erro
35	= Tasy => Integracao externa.		Resposta ao recebimento log = Cotado

40	= Tasy => Integracao externa.		Envio dos itens entregues
41	= Integracao externa => Tasy.		Retorno dos itens entregues - OK
42	= Integracao externa => Tasy.		Retorno dos itens entregues - C/Erros
48	= Tasy.				Calculo da nota fiscal - Entrega parcial dos itens
49	= Tasy.				Calculo da nota fiscal - Entrega total dos itens


50	= Integracao externa => Tasy.		Recebimento da Ordem de compras
51	= Tasy.				Importacao da Ordem de compras - OK
52	= Tasy.				Importacao da Ordem de compras - C/Erros
55	= Tasy => Integracao externa.		Resposta ao recebimento da Ordem compras

60	= Tasy => Integracao externa.		Envio dos itens utilizados
61	= Integracao externa => Tasy.		Retorno dos itens utilizados - OK
62	= Integracao externa => Tasy.		Retorno dos itens utilizados - C/Erros

99	= Tasy => Integracao externa.		Envio do cancelamento do agendamento



ie_status_w
0	Identificacao da necessidade de OPME
1	Enviado
10	Triado
20	Em cotacao
30	Cotado - recebimento itens
48	Entrega parcial
49	Totalmente entregue
50	Aprovado
98	Em devolucao
99	Cancelado
*/
ie_opme_integracao_w		varchar(1);
nr_sequencia_w			bigint;
nr_seq_anterior_w		bigint;
ds_descricao_w			varchar(4000);
ie_status_w			varchar(15);
ie_sistema_integracao_w		varchar(1);
nr_atendimento_w		bigint;
qt_existe_cirurgia_w		bigint;
nr_seq_pac_int_opme_w		bigint;
qt_existe_w			integer;
cd_estabelecimento_w estabelecimento.cd_estabelecimento%type;


BEGIN

select coalesce(cd_estabelecimento_p, wheb_usuario_pck.get_cd_estabelecimento)
  into STRICT cd_estabelecimento_w
;

select	max(ie_sistema_integracao)
into STRICT	ie_sistema_integracao_w
from	parametros_opme
where   (((cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') and cd_estabelecimento = cd_estabelecimento_w)
		  or coalesce(cd_estabelecimento_w::text, '') = '');
	
if (ie_sistema_integracao_w = 'P') then
	begin
	CALL ajusta_status_ag_int_OPMEnexo(nr_seq_agenda_p, cd_evento_log_p, ds_descricao_p, nm_usuario_p,ie_commit_p, cd_estabelecimento_w);
	end;
elsif (ie_sistema_integracao_w = 'I') then
	begin
	if (cd_evento_log_p = '0') then
		begin
			
		select	coalesce(max(nr_seq_anterior), 0)
		into STRICT	nr_seq_anterior_w
		from	agenda_paciente
		where	nr_sequencia	= nr_seq_agenda_p;
		
		select	coalesce(max(ie_opme_integracao),'N')
		into STRICT	ie_opme_integracao_w
		from 	agenda_paciente 
		where 	nr_sequencia = nr_seq_anterior_w;
		
		
		if (nr_seq_anterior_w > 0) and (ie_opme_integracao_w = 'S') then
			begin
			/*Se e uma copia de agendamento, elimina a sequencia anterior da integracao, e copia os logs da anterior para a nova*/

			insert into agenda_pac_int_opme_log(
				nr_sequencia,		dt_atualizacao,
				nm_usuario,		dt_atualizacao_nrec,
				nm_usuario_nrec,		nr_seq_agenda,
				ds_descricao,		cd_evento_log)
			SELECT	nextval('agenda_pac_int_opme_log_seq'),	dt_atualizacao,
				nm_usuario_p,		dt_atualizacao_nrec,
				nm_usuario_p,		nr_seq_agenda_p,
				ds_descricao,		cd_evento_log
			from	agenda_pac_int_opme_log
			where	nr_seq_agenda		= nr_seq_anterior_w;

			update	agenda_paciente
			set	ie_opme_integracao	= 'N'
			where	nr_sequencia		= nr_seq_anterior_w;

			end;
		else
			begin
			/*Se e um agendamento novo, somente gera o log de incicio*/

			select	nextval('agenda_pac_int_opme_log_seq')
			into STRICT	nr_sequencia_w
			;

			insert into agenda_pac_int_opme_log(
				nr_sequencia,		dt_atualizacao,
				nm_usuario,		dt_atualizacao_nrec,
				nm_usuario_nrec,		nr_seq_agenda,
				ds_descricao,		cd_evento_log)
			values (	nr_sequencia_w,		clock_timestamp(),
				nm_usuario_p,		clock_timestamp(),
				nm_usuario_p,		nr_seq_agenda_p,
				null,			cd_evento_log_p);

			ie_status_w			:= cd_evento_log_p;
			update	agenda_paciente
			set	ie_opme_integracao	= 'S',
				ie_opme_int_status	= ie_status_w,
				nm_usuario		= nm_usuario_p
			where	nr_sequencia		= nr_seq_agenda_p;
			
			
			select 	count(*)
			into STRICT  	qt_existe_cirurgia_w
			from	agenda_paciente
			where	nr_sequencia = nr_seq_agenda_p
			and 	(nr_cirurgia IS NOT NULL AND nr_cirurgia::text <> '');
			
			if (coalesce(qt_existe_cirurgia_w,0) > 0) then
			
				update	cirurgia
				set	ie_integracao_opme	= 'S'
				where	nr_seq_agenda		= nr_seq_agenda_p;

			end if;
			
			end;
		end if;

		CALL gravar_agend_integracao(37,'nr_sequencia=' || nr_seq_agenda_p || ';');
		CALL gravar_agend_integracao(309,'nr_sequencia=' || nr_seq_agenda_p || ';');
		
		end;
	end if;


	if (cd_evento_log_p <> '0') then
		begin

		if (cd_evento_log_p = '1') then
			CALL gravar_agend_integracao(37,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '7') then
			CALL gravar_agend_integracao(56,'nr_sequencia=' || nr_seq_agenda_p || ';');
			CALL gravar_agend_integracao(309,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '8') then
			CALL gravar_agend_integracao(57,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '9') then
			if (substr(nr_seq_agenda_p,1,1) = 'T') then
				begin
				nr_atendimento_w := substr(nr_seq_agenda_p,2,10);
				CALL gravar_agend_integracao(58,'nr_atendimento=' || nr_atendimento_w || ';');
				end;
			else	
				CALL gravar_agend_integracao(58,'nr_sequencia=' || nr_seq_agenda_p || ';');
				CALL gravar_agend_integracao(309,'nr_sequencia=' || nr_seq_agenda_p || ';');
			end if;			
		elsif (cd_evento_log_p = '99') then
			CALL gravar_agend_integracao(59,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '40') then
			CALL gravar_agend_integracao(45,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '60') then
			CALL gravar_agend_integracao(46,'nr_sequencia=' || nr_seq_agenda_p || ';');
			CALL gravar_agend_integracao(310,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '060') then
			begin
			nr_atendimento_w := nr_seq_agenda_p;
			CALL gravar_agend_integracao(46,'nr_atendimento=' || nr_atendimento_w || ';');
			end;
		elsif (cd_evento_log_p = '00') then
				begin
				nr_atendimento_w := nr_seq_agenda_p;
				CALL gravar_agend_integracao(37,'nr_atendimento=' || nr_atendimento_w || ';');
				end;
		elsif (cd_evento_log_p = '107') then
			CALL gravar_agend_integracao(196,'nr_sequencia=' || nr_seq_agenda_p || ';');
		elsif (cd_evento_log_p = '100') then
			CALL gravar_agend_integracao(521,'nr_sequencia=' || nr_seq_agenda_p || ';');					
		end if;
		
		ds_descricao_w	:= '';
		if (cd_evento_log_p = '3') or (cd_evento_log_p = '42') or (cd_evento_log_p = '11') or (cd_evento_log_p = '21') or (cd_evento_log_p = '31') or (cd_evento_log_p = '51') or (cd_evento_log_p = '62') or (cd_evento_log_p = '73') or (cd_evento_log_p = '83') or (cd_evento_log_p = '93') or (cd_evento_log_p = '97') or (cd_evento_log_p = '102') then
			ds_descricao_w	:= substr(ds_descricao_p,1,4000);
		end if;
		
		if (cd_evento_log_p = '50') and (substr(nr_seq_agenda_p,1,1) = 'T') then
			nr_atendimento_w := substr(nr_seq_agenda_p,2,10);
			ie_status_w	 := cd_evento_log_p;
			
			if (cd_evento_log_p = '51') then
				ds_descricao_w	:= substr(ds_descricao_p,1,4000);
			end if;
			
		end if;	

		if (cd_evento_log_p = '50') and (substr(nr_seq_agenda_p,9,1) = '-') then
			nr_atendimento_w := substr(nr_seq_agenda_p,10,length(nr_seq_agenda_p));
			ie_status_w	 := cd_evento_log_p;
			
			if (cd_evento_log_p = '51') then
				ds_descricao_w	:= substr(ds_descricao_p,1,4000);
			end if;
		
		end if;			
				
		select	nextval('agenda_pac_int_opme_log_seq')
		into STRICT	nr_sequencia_w
		;
		
		if (substr(nr_seq_agenda_p,1,1) = 'T') then
			nr_atendimento_w := substr(nr_seq_agenda_p,2,10);
		elsif (substr(nr_seq_agenda_p,9,1) = '-') then
			nr_atendimento_w := substr(nr_seq_agenda_p,10,length(nr_seq_agenda_p));
		end if;
		
		/*SO-2225714*/

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_pac_int_opme_w
		from	atend_pac_int_opme
		where	nr_atendimento = nr_atendimento_w
		and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_atualizacao) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(clock_timestamp());
		
		if (nr_seq_pac_int_opme_w = 0) then
		
			select	max(nr_sequencia)
			into STRICT	nr_seq_pac_int_opme_w
			from	atend_pac_int_opme
			where	nr_atendimento = nr_atendimento_w
			order by dt_atualizacao desc;
		
		end if;
		
		if	(((cd_evento_log_p = '2') or (cd_evento_log_p = '3')) and
			((substr(nr_seq_agenda_p,1,1) <> 'T') and (substr(nr_seq_agenda_p,9,1) <> '-')))then
			begin
			select	count(*)
			into STRICT	qt_existe_w
			from	agenda_pac_consignado_hist
			where	nr_seq_agenda = nr_seq_agenda_p;
			
			if (qt_existe_w > 0) then
				CALL gravar_hist_planeja_consig(	nr_seq_agenda_p,
								wheb_mensagem_pck.get_texto(306997, null), -- Retorno integracao
								ds_descricao_w,
								nm_usuario_p);
			end if;
			end;
		end if;
		
		insert into agenda_pac_int_opme_log(
			nr_sequencia,		dt_atualizacao,
			nm_usuario,		dt_atualizacao_nrec,
			nm_usuario_nrec,	nr_seq_agenda,
			ds_descricao,		cd_evento_log,
			nr_atendimento,		nr_seq_atend_opme)
		values (	nr_sequencia_w,		clock_timestamp(),
			nm_usuario_p,		clock_timestamp(),
			nm_usuario_p,		CASE WHEN coalesce(nr_atendimento_w,0)=0 THEN  nr_seq_agenda_p  ELSE null END  ,
			ds_descricao_w,		CASE WHEN cd_evento_log_p='00' THEN  '0'  ELSE cd_evento_log_p END ,
			nr_atendimento_w,	nr_seq_pac_int_opme_w);
			
		if (cd_evento_log_p = '1') or (cd_evento_log_p = '7') or (cd_evento_log_p = '10') or (cd_evento_log_p = '20') or (cd_evento_log_p = '30') or (cd_evento_log_p = '48') or (cd_evento_log_p = '49') or (cd_evento_log_p = '50') or (cd_evento_log_p = '60') or (cd_evento_log_p = '99') then
			begin

			ie_status_w			:= cd_evento_log_p;
			/*tratamento especial para cancelamento*/

			if (cd_evento_log_p = '99') and (coalesce(nr_atendimento_w,0) = 0)then
				begin
				select	ie_opme_int_status
				into STRICT	ie_status_atual_w
				from	agenda_paciente
				where	nr_sequencia	= nr_seq_agenda_p;
				if (ie_status_atual_w in ('48','49')) then
					ie_status_w	:= '98';
				end if;
				end;
			end if;
			
			if (coalesce(nr_atendimento_w,0) = 0) then
				update	agenda_paciente
				set	ie_opme_int_status	= ie_status_w,
					nm_usuario		= nm_usuario_p
				where	nr_sequencia		= nr_seq_agenda_p;
				
				CALL ajustar_status_anexo_opme(nr_seq_agenda_p,ie_status_w,nm_usuario_p,ie_commit_p);
			end if;	
			
			if (coalesce(nr_atendimento_w,0) > 0) then
				update	atend_pac_int_opme
				set	ie_opme_int_status	= ie_status_w,
					nm_usuario		= nm_usuario_p
				where	nr_atendimento		= nr_atendimento_w;
			
			end if;	
			
			end;
		end if;
		end;
	end if;
	end;
end if;

if (coalesce(ie_commit_p,'S') = 'S') then
	Commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajusta_status_agenda_int_opme ( nr_seq_agenda_p text, cd_evento_log_p text, ds_descricao_p text, nm_usuario_p text, ie_commit_p text default 'S', cd_estabelecimento_p bigint default null) FROM PUBLIC;
