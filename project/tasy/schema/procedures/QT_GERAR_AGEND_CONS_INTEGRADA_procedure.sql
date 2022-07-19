-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qt_gerar_agend_cons_integrada ( NR_SEQ_ATENDIMENTO_P bigint, NR_SEQ_PEND_AGENDA_P bigint, CD_PESSOA_FISICA_P text, CD_PROCEDIMENTO_P bigint, NR_SEQ_PROC_INTERNO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, CD_PLANO_P text, CD_ESTABELECIMENTO_P bigint, IE_ACAO_P text, DT_PREVISTA_ITEM_P timestamp, IE_CLASSIF_AGENDA_P text, CD_ESPECIALIDADE_P bigint, NM_USUARIO_P text, DS_OBSERVACAO_P text DEFAULT NULL, DS_COR_P text DEFAULT NULL) AS $body$
DECLARE

/* 
 
IE_ACAO_P 
A - Agendamento 
T - Transferência 
 
*/
											 
											 
NR_SEQ_PROC_INTERNO_W		PACIENTE_ATEND_PROC.NR_SEQ_PROC_INTERNO%TYPE;
IE_ORIGEM_PROCED_W		PACIENTE_ATEND_PROC.IE_ORIGEM_PROCED%TYPE;
CD_PROCEDIMENTO_W		PACIENTE_ATEND_PROC.CD_PROCEDIMENTO%TYPE;
NR_SEQ_AG_INTEGRADA_W		AGENDA_INTEGRADA.NR_SEQUENCIA%TYPE;
NR_SEQ_AG_INT_ITEM_W		AGENDA_INTEGRADA_ITEM.NR_SEQUENCIA%TYPE;
NR_SEQ_STATUS_W			AGENDA_INTEGRADA_STATUS.NR_SEQUENCIA%TYPE;
NR_SEQ_STATUS_CANCELADO_W	AGENDA_INTEGRADA_STATUS.NR_SEQUENCIA%TYPE;
NR_SEQ_STATUS_AGENDADO_W	AGENDA_INTEGRADA_STATUS.NR_SEQUENCIA%TYPE;
IE_GERAR_AGENDA_CONS_W		varchar(1);
CD_MEDICO_W			PARAMETRO_AGENDA_QUIMIO.CD_MEDICO%TYPE;
CD_ESPECIALIDADE_W		PARAMETRO_AGENDA_QUIMIO.CD_ESPECIALIDADE%TYPE;
NR_SEQ_EXAME_ADIC_ITEM_W	AGEINT_EXAME_ADIC_ITEM.NR_SEQUENCIA%TYPE;
NM_PACIENTE_W			AGENDA_INTEGRADA.NM_PACIENTE%TYPE;
DT_PREVISTA_ITEM_W		timestamp;
QT_EXISTE_AG_INTEGRADA_W	bigint;
QT_EXISTE_AG_INT_AGENDADO_W	bigint;
IE_STATUS_INTEGRADA_W		varchar(2);
IE_CLASSIF_AGENDA_W		PARAMETRO_AGENDA_QUIMIO.IE_CLASSIF_AGENDA%TYPE;
DS_ERRO_W			varchar(255);

C01 CURSOR FOR 
	SELECT	a.nr_sequencia 
	from	agenda_integrada a, 
			agenda_integrada_item b, 
			agenda_consulta c 
	where	a.nr_sequencia = b.nr_seq_agenda_int 
	and		b.nr_seq_agenda_cons = c.nr_sequencia 
	and		a.nr_seq_pendencia = nr_seq_pend_agenda_p 
	and		a.nr_seq_status = nr_seq_status_agendado_w 
	and		c.ie_status_agenda <> 'C';	
	 

BEGIN 
 
--Parâmetros da agenda de quimioterapia(Shift + F11) 
select	max(cd_medico), 
		max(cd_especialidade), 
		max(ie_classif_agenda) 
into STRICT	cd_medico_w, 
		cd_especialidade_w, 
		ie_classif_agenda_w 
from	parametro_agenda_quimio 
where	cd_estabelecimento = cd_estabelecimento_p;
 
--Status "Em agendamento"(lançar nos novos agendamentos) 
select	max(nr_sequencia) 
into STRICT	nr_seq_status_w 
from	agenda_integrada_status 
where	ie_status_tasy = 'EA' 
and		ie_situacao = 'A';
 
--Status "Cancelado" 
select	max(nr_sequencia) 
into STRICT	nr_seq_status_cancelado_w 
from	agenda_integrada_status 
where	ie_status_tasy = 'CA' 
and		ie_situacao = 'A';
 
--Status "Agendado" 
select	max(nr_sequencia) 
into STRICT	nr_seq_status_agendado_w 
from	agenda_integrada_status 
where	ie_status_tasy = 'AG' 
and		ie_situacao = 'A';
 
--Validar se o agendamento já foi inserido préviamente 
select	count(*) 
into STRICT	qt_existe_ag_integrada_w 
from	agenda_integrada 
where	nr_seq_pendencia = nr_seq_pend_agenda_p 
and		nr_seq_status = nr_seq_status_w;
 
dt_prevista_item_w	:= dt_prevista_item_P;
 
--Gerar agendamento de consulta na Ag. Integrada		 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then	 
	begin 
	 
	select	substr(obter_nome_pf(cd_pessoa_fisica_p),1,60) 
	into STRICT	nm_paciente_w 
	;	
	 
	--Confirmação da marcação de quimio	 
	if (ie_acao_p = 'A') and (qt_existe_ag_integrada_w = 0) then		 
		select	nextval('agenda_integrada_seq') 
		into STRICT	nr_seq_ag_integrada_w 
		;			
		 
		--Agendamento novo 
		insert into agenda_integrada(	 
									cd_pessoa_fisica, 
									dt_inicio_agendamento, 
									nr_seq_status, 
									nr_sequencia, 
									nm_usuario, 
									nm_usuario_nrec, 
									dt_atualizacao, 
									nr_seq_pendencia, 
									cd_estabelecimento, 
									cd_convenio, 
									cd_categoria, 
									cd_plano, 
									nm_paciente, 
									ie_turno 
									) 
		values ( 
									cd_pessoa_fisica_p, 
									clock_timestamp(), 
									nr_seq_status_w, 
									nr_seq_ag_integrada_w, 
									nm_usuario_p, 
									nm_usuario_p, 
									clock_timestamp(), 
									nr_seq_pend_agenda_p, 
									cd_estabelecimento_p, 
									cd_convenio_p, 
									cd_categoria_p, 
									cd_plano_p, 
									nm_paciente_w, 
									2 
									);
		commit;
	elsif (ie_acao_p = 'A') and (qt_existe_ag_integrada_w > 0) then		 
		--Em agendamento 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_ag_integrada_w 
		from	agenda_integrada 
		where	nr_seq_pendencia = nr_seq_pend_agenda_p 
		and		nr_seq_status = nr_seq_status_w;			
		 
		 
	/*--Reconfirmação da marcação de quimio 
	elsif	(ie_acao_p = 'A') and (qt_existe_ag_integrada_w > 0) then 
		select	max(nr_sequencia) 
		into	nr_seq_ag_integrada_w 
		from	agenda_integrada 
		where	nr_seq_pendencia = nr_seq_pend_agenda_p 
		and		nr_seq_status = nr_seq_status_w;	 
	 
		--Cancelar último agendamento 
		if	(nr_seq_ag_integrada_w is not null) then 
			Ageint_Alterar_Status(nr_seq_status_cancelado_w, nr_seq_ag_integrada_w, 'Reconfirmação das pendências da Ag. de Quimioterapia', nm_usuario_p, cd_estabelecimento_p); 
			 
			--Lançar o agendamento novamente 
			select	agenda_integrada_seq.nextval 
			into	nr_seq_ag_integrada_w 
			from	dual;					 
			 
			insert into agenda_integrada(	 
										cd_pessoa_fisica, 
										dt_inicio_agendamento, 
										nr_seq_status, 
										nr_sequencia, 
										nm_usuario, 
										nm_usuario_nrec, 
										dt_atualizacao, 
										nr_seq_pendencia, 
										cd_estabelecimento, 
										cd_convenio, 
										cd_categoria, 
										cd_plano, 
										nm_paciente, 
										ie_turno 
										) 
			values						( 
										cd_pessoa_fisica_p, 
										sysdate, 
										nr_seq_status_w, 
										nr_seq_ag_integrada_w, 
										nm_usuario_p, 
										nm_usuario_p, 
										sysdate, 
										nr_seq_pend_agenda_p, 
										cd_estabelecimento_p, 
										cd_convenio_p, 
										cd_categoria_p, 
										cd_plano_p, 
										nm_paciente_w, 
										2 
										); 
			commit; 
		 
		end if; 
	*/
 
	--Transferência 
	elsif (ie_acao_p = 'T') then 
		--Status Em agendamento 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_ag_integrada_w 
		from	agenda_integrada 
		where	nr_seq_pendencia = nr_seq_pend_agenda_p 
		and		nr_seq_status = nr_seq_status_w;	
		 
		--Obter o item a ser cancelado 
		select	max(a.nr_sequencia) 
		into STRICT	nr_seq_ag_int_item_w 
		from	agenda_integrada_item a 
		where	a.nr_seq_agenda_int = nr_seq_ag_integrada_w 
		and		a.nr_seq_atendimento = nr_seq_atendimento_p;
		 
		--Cancelar último agendamento 
		if (nr_seq_ag_integrada_w IS NOT NULL AND nr_seq_ag_integrada_w::text <> '') then 
			CALL AGEINT_CANCELAR_ITEM(nr_seq_ag_integrada_w, nr_seq_ag_int_item_w, wheb_mensagem_pck.get_texto(795013), null, nm_usuario_p, cd_estabelecimento_p);
			 
			--Ageint_Alterar_Status(nr_seq_status_cancelado_w, nr_seq_ag_integrada_w, 'Transferência das pendências da Ag. de Quimioterapia', nm_usuario_p, cd_estabelecimento_p); 
		else 
			--Status Agendado 
			open C01;
			loop 
			fetch C01 into	 
				nr_seq_ag_integrada_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				 
				--Obter o item a ser cancelado 
				select	a.nr_sequencia 
				into STRICT	nr_seq_ag_int_item_w 
				from	agenda_integrada_item a 
				where	a.nr_seq_agenda_int = nr_seq_ag_integrada_w 
				and		a.nr_seq_atendimento = nr_seq_atendimento_p;
				 
				if (nr_seq_ag_integrada_w IS NOT NULL AND nr_seq_ag_integrada_w::text <> '')then 
					CALL AGEINT_CANCELAR_ITEM(nr_seq_ag_integrada_w, nr_seq_ag_int_item_w, wheb_mensagem_pck.get_texto(795013), null, nm_usuario_p, cd_estabelecimento_p);
					 
					--Ageint_Alterar_Status(nr_seq_status_cancelado_w, nr_seq_ag_integrada_w, 'Transferência das pendências da Ag. de Quimioterapia', nm_usuario_p, cd_estabelecimento_p); 
				end if;
				 
				end;
			end loop;
			close C01;					
		 
		end if;
		 
	--Lançar o agendamento novamente 
	select	nextval('agenda_integrada_seq') 
	into STRICT	nr_seq_ag_integrada_w 
	;					
	 
	insert into agenda_integrada(	 
								cd_pessoa_fisica, 
								dt_inicio_agendamento, 
								nr_seq_status, 
								nr_sequencia, 
								nm_usuario, 
								nm_usuario_nrec, 
								dt_atualizacao, 
								nr_seq_pendencia, 
								cd_estabelecimento, 
								cd_convenio, 
								cd_categoria, 
								cd_plano, 
								nm_paciente, 
								ie_turno 
								) 
	values ( 
								cd_pessoa_fisica_p, 
								clock_timestamp(), 
								nr_seq_status_w, 
								nr_seq_ag_integrada_w, 
								nm_usuario_p, 
								nm_usuario_p, 
								clock_timestamp(), 
								nr_seq_pend_agenda_p, 
								cd_estabelecimento_p, 
								cd_convenio_p, 
								cd_categoria_p, 
								cd_plano_p, 
								nm_paciente_w, 
								2 
								);
	commit;	
	 
	end if;		
	 
 
	--Item 
	if (nr_seq_ag_integrada_w IS NOT NULL AND nr_seq_ag_integrada_w::text <> '') then 
	 
		select	nextval('agenda_integrada_item_seq') 
		into STRICT	nr_seq_ag_int_item_w 
		;
	 
	 
		INSERT INTO AGENDA_INTEGRADA_ITEM(	NR_SEQUENCIA, 
							NR_SEQ_AGENDA_INT, 
							NM_USUARIO, 
							DT_ATUALIZACAO, 
							IE_TIPO_AGENDAMENTO, 
							CD_ESPECIALIDADE, 
							CD_MEDICO, 
							DT_PREVISTA_ITEM, 
							NR_SEQ_ATENDIMENTO, 
							IE_CLASSIF_AGENDA, 
							DS_OBSERVACAO, 
							DS_COR) 
		VALUES (NR_SEQ_AG_INT_ITEM_W, 
			NR_SEQ_AG_INTEGRADA_W, 
			NM_USUARIO_P, 
			clock_timestamp(), 
			'C', 
			coalesce(CD_ESPECIALIDADE_P, CD_ESPECIALIDADE_W), 
			CD_MEDICO_W, 
			DT_PREVISTA_ITEM_W, 
			NR_SEQ_ATENDIMENTO_P, 
			coalesce(IE_CLASSIF_AGENDA_P, IE_CLASSIF_AGENDA_W), 
			DS_OBSERVACAO_P, 
			DS_COR_P);
		COMMIT;
	 
		--Item adicional 
		if (nr_seq_ag_int_item_w IS NOT NULL AND nr_seq_ag_int_item_w::text <> '') then 
		 
			select	nextval('ageint_exame_adic_item_seq') 
			into STRICT	nr_seq_exame_adic_item_w 
			;
		 
			insert into ageint_exame_adic_item(	 
												nr_sequencia, 
												nr_seq_proc_interno,															 
												nr_seq_item, 
												nm_usuario, 
												dt_atualizacao, 
												cd_procedimento, 
												ie_origem_proced 
												) 
			values ( 
												nr_seq_exame_adic_item_w, 
												nr_seq_proc_interno_p, 
												nr_seq_ag_int_item_w, 
												nm_usuario_p, 
												clock_timestamp(), 
												cd_procedimento_p, 
												ie_origem_proced_p 
												);
												 
			commit;
		 
		end if;
	 
	end if;
 
	exception 
	when others then 
		ds_erro_w := SUBSTR(	wheb_mensagem_pck.get_texto(795015) ||CHR(10)|| 
								wheb_mensagem_pck.get_texto(794873) || ': ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE(),1,255);
								 
								 
	 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qt_gerar_agend_cons_integrada ( NR_SEQ_ATENDIMENTO_P bigint, NR_SEQ_PEND_AGENDA_P bigint, CD_PESSOA_FISICA_P text, CD_PROCEDIMENTO_P bigint, NR_SEQ_PROC_INTERNO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, CD_PLANO_P text, CD_ESTABELECIMENTO_P bigint, IE_ACAO_P text, DT_PREVISTA_ITEM_P timestamp, IE_CLASSIF_AGENDA_P text, CD_ESPECIALIDADE_P bigint, NM_USUARIO_P text, DS_OBSERVACAO_P text DEFAULT NULL, DS_COR_P text DEFAULT NULL) FROM PUBLIC;

