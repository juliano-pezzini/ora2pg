-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajusta_status_ag_int_opmenexo ( nr_seq_agenda_p bigint, cd_evento_log_p text, ds_descricao_p text, nm_usuario_p text, ie_commit_p text default 'S', cd_estabelecimento_p bigint default null) AS $body$
DECLARE


ie_status_atual_w		varchar(15);

/*Dominio 3095   e  3087  */

ie_opme_integracao_w	varchar(1);
nr_sequencia_w		bigint;
nr_seq_anterior_w		agenda_paciente.nr_seq_anterior%type;
ds_descricao_w		varchar(4000);
ie_status_w		varchar(15);
qt_existe_w		bigint;
cd_sistema_externo_w	agenda_paciente.cd_sistema_externo%type;


BEGIN

select	count(1)
into STRICT	qt_existe_w
from	cot_compra
where	nr_seq_agenda_pac = nr_seq_agenda_p;

select	cd_sistema_externo
into STRICT	cd_sistema_externo_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_p;

if (cd_evento_log_p = '0') or ((coalesce(cd_sistema_externo_w::text, '') = '') and (cd_evento_log_p = '9')) then
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
			ie_opme_int_status		= ie_status_w,
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_agenda_p;

		end;
	end if;

	select	count(1)
	into STRICT	qt_existe_w
	from	cot_compra
	where	nr_seq_agenda_pac = nr_seq_agenda_p;
	
	if (qt_existe_w = 0)then
		CALL gerar_cot_compra_int_opme(nm_usuario_p, cd_estabelecimento_p, nr_seq_agenda_p,ie_commit_p);
	end if;
	
	CALL gravar_agend_integracao(97,'nr_sequencia=' || nr_seq_agenda_p || ';');
		
	end;
elsif (cd_evento_log_p <> '0') then
	begin
	
	if (cd_evento_log_p = '8') then
		CALL gravar_agend_integracao(97,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '9') then	
	
		select count(*)
		into STRICT qt_existe_w
		from cliente_integracao a,
			informacao_integracao b
		where a.nr_seq_inf_integracao = b.nr_sequencia
		and b.nr_seq_evento = 771
		and b.ie_situacao = 'A'
		and a.ie_situacao <> 'I';
		
		if (qt_existe_w > 0) then
			CALL gravar_agend_integracao(771,'nr_sequencia=' || nr_seq_agenda_p || ';');
		else
			CALL gravar_agend_integracao(97,'nr_sequencia=' || nr_seq_agenda_p || ';');
		end if;
		
	elsif (cd_evento_log_p = '140') then
		CALL gravar_agend_integracao(100,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '130') then
		CALL gravar_agend_integracao(101,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '100') then
		CALL gravar_agend_integracao(99,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '60') then
		CALL gravar_agend_integracao(102,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '120') then
		CALL gravar_agend_integracao(103,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '220') then			
		CALL gravar_agend_integracao(793,'nr_sequencia=' || nr_seq_agenda_p || ';');
	elsif (cd_evento_log_p = '230') then			
		CALL gravar_agend_integracao(777,'nr_sequencia=' || nr_seq_agenda_p || ';');
	end if;

	ds_descricao_w	:= '';
	if (cd_evento_log_p = '3') or (cd_evento_log_p = '2') or (cd_evento_log_p = '10') or (cd_evento_log_p = '42') or (cd_evento_log_p = '62') or (cd_evento_log_p = '82') or (cd_evento_log_p = '83') or (cd_evento_log_p = '93') or (cd_evento_log_p = '97') or (cd_evento_log_p = '101') or (cd_evento_log_p = '102') or (cd_evento_log_p = '121') or (cd_evento_log_p = '122') or (cd_evento_log_p = '131') or (cd_evento_log_p = '132') or (cd_evento_log_p = '215') or (cd_evento_log_p = '221') or (cd_evento_log_p = '222') or (cd_evento_log_p = '231') or (cd_evento_log_p = '232') then
		ds_descricao_w	:= substr(ds_descricao_p,1,4000);
	end if;

	select	nextval('agenda_pac_int_opme_log_seq')
	into STRICT	nr_sequencia_w
	;

	insert into agenda_pac_int_opme_log(
		nr_sequencia,		dt_atualizacao,
		nm_usuario,		dt_atualizacao_nrec,
		nm_usuario_nrec,	nr_seq_agenda,
		ds_descricao,		cd_evento_log)
	values (	nr_sequencia_w,		clock_timestamp(),
		nm_usuario_p,		clock_timestamp(),
		nm_usuario_p,		nr_seq_agenda_p,
		ds_descricao_w,		cd_evento_log_p);

	if (cd_evento_log_p = '7') or (cd_evento_log_p = '10') or (cd_evento_log_p = '20') or (cd_evento_log_p = '30') or (cd_evento_log_p = '48') or (cd_evento_log_p = '49') or (cd_evento_log_p = '50') or (cd_evento_log_p = '60') or (cd_evento_log_p = '99') or (cd_evento_log_p = '100') or (cd_evento_log_p = '110') or (cd_evento_log_p = '120') or (cd_evento_log_p = '130') or (cd_evento_log_p = '140') or (cd_evento_log_p = '220') or (cd_evento_log_p = '230') then
		begin

		ie_status_w	:= cd_evento_log_p;

		/*tratamento especial para cancelamento*/

		if (cd_evento_log_p = '99') then
			begin
			select	ie_opme_int_status
			into STRICT	ie_status_atual_w
			from	agenda_paciente
			where	nr_sequencia	= nr_seq_agenda_p;
			end;
		end if;
		
		update agenda_paciente
		set	ie_opme_int_status = ie_status_w,
			nm_usuario = nm_usuario_p
		where nr_sequencia = nr_seq_agenda_p;
				
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
-- REVOKE ALL ON PROCEDURE ajusta_status_ag_int_opmenexo ( nr_seq_agenda_p bigint, cd_evento_log_p text, ds_descricao_p text, nm_usuario_p text, ie_commit_p text default 'S', cd_estabelecimento_p bigint default null) FROM PUBLIC;

