-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_gerar_atend_agenda ( nr_seq_agendamento_p mprev_agendamento.nr_sequencia%type, dt_atendimento_p timestamp, /* data de execução informada no wdlg */
 nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p bigint, nr_seq_atend_mprev_p INOUT bigint) AS $body$
DECLARE

 
 
ie_individual_coletivo_w 	varchar(1);
ie_forma_atendimento_w 		varchar(2);
nr_seq_turma_w 				bigint;
nr_seq_atendimento_w 		bigint;
nr_seq_participante_w 		bigint;
dt_agenda_w					timestamp;
cd_profissional_w 			varchar(10);
nr_seq_regra_eup_w 			bigint;
cd_agenda_w					agenda.cd_agenda%type;
cd_agenda_profissional_w	agenda.cd_agenda%type;
nr_seq_horario_turma_w		mprev_agendamento.nr_seq_horario_turma%type;
ie_possui_regra_w 			varchar(1) := 'N';
nr_seq_captacao_w			mprev_captacao.nr_sequencia%type;
nr_seq_segurado_w			pls_segurado.nr_sequencia%type;

C01 CURSOR FOR 
	SELECT	nr_seq_participante 
	from	mprev_sel_partic_agenda 
	where  nr_seq_agendamento = nr_seq_agendamento_p 
	and		ie_selecionado = 'S' 
	and		ie_individual_coletivo_w = 'C' -- Agendamento Coletivo. 
	
union
 
	SELECT	nr_seq_participante_w 
	 
	where	ie_individual_coletivo_w in ('I','P');--Agendamento Individual ou Captação. 
					

BEGIN	 
	 
select	ie_tipo_atendimento, 
		ie_forma_atendimento, 
		nr_seq_turma, 
		nr_seq_horario_turma, 
		cd_agenda, 
		cd_agenda_profissional, 
		nr_seq_participante, 
		dt_agenda, 
		nr_seq_captacao 
into STRICT	ie_individual_coletivo_w, 
		ie_forma_atendimento_w, 
		nr_seq_turma_w, 
		nr_seq_horario_turma_w, 
		cd_agenda_w, 
		cd_agenda_profissional_w, 
		nr_seq_participante_w, 
		dt_agenda_w, 
		nr_seq_captacao_w 
from	mprev_agendamento a 
where	nr_sequencia = nr_seq_agendamento_p;
 
if (cd_agenda_profissional_w IS NOT NULL AND cd_agenda_profissional_w::text <> '') then 
	select	max(a.cd_pessoa_fisica) 
	into STRICT	cd_profissional_w 
	from	agenda a 
	where	a.cd_agenda	= cd_agenda_profissional_w;
else 
	select	max(a.cd_pessoa_fisica) 
	into STRICT	cd_profissional_w 
	from	agenda a 
	where	a.cd_agenda	= cd_agenda_w;
end if;
 
/* Procurar primeiro se já foi gerado atendimento (no caso de turma) 
Pode haver duas agendas de profissionais diferentes para a mesma turma */
 
if (ie_individual_coletivo_w = 'C') then 
	nr_seq_atendimento_w	:= mprev_obter_atend_turma_hor(coalesce(cd_agenda_profissional_w,cd_agenda_w),nr_seq_turma_w,dt_agenda_w);
else 
	nr_seq_atendimento_w	:= null;
end if;
	 
/* Se não achou, aí sim cria, senão só volta o número do atendimento */
 
if (coalesce(nr_seq_atendimento_w::text, '') = '') then 
 
	/*Agendamento de local de atendimento precisa ter uma agenda de profissional informada no agendamento ou profissional cadastrado na pasta "Configurações/Conf Agenda/Agenda" campo "Profissional".*/
 
	if (coalesce(cd_profissional_w::text, '') = '') then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(449437);
	end if;
 
	select	nextval('mprev_atendimento_seq') 
	into STRICT	nr_seq_atendimento_w 
	;
 
	insert into mprev_atendimento(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_individual_coletivo, 
		ie_forma_atendimento, 
		nr_seq_turma, 
		cd_profissional, 
		dt_inicio, 
		ie_urgencia, 
		cd_estabelecimento) 
	values (nr_seq_atendimento_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		ie_individual_coletivo_w, 
		ie_forma_atendimento_w, 
		nr_seq_turma_w, 
		cd_profissional_w, 
		dt_atendimento_p, 
		'N', 
		cd_estabelecimento_p);
	 
	/*Se for agendamento de captação deve buscar o segurado vínculado na origem da captação na HDM - Captação*/
 
	if (nr_seq_captacao_w IS NOT NULL AND nr_seq_captacao_w::text <> '') then 
		nr_seq_segurado_w := mprev_obter_dados_captacao(nr_seq_captacao_w, clock_timestamp(), 'BN');
	end if;
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_participante_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		 
		if (coalesce(nr_seq_captacao_w::text, '') = '') then 
			/*Se não for captação vai buscar o segurado vínculado na origem da captação aceita do participante . */
 
			nr_seq_segurado_w := mprev_obter_benef_partic(nr_seq_participante_w);
		end if;
		 
		/*Obtem a regra da função HDM - Atendimento aba Regras\Geração atendimento paciente*/
 
		nr_seq_regra_eup_w := mprev_obter_regra_ger_atend(nr_seq_atendimento_w, nr_seq_segurado_w);
		 
		/*Se retornar uma regra gera atendimento para o participante*/
 
		if (nr_seq_regra_eup_w IS NOT NULL AND nr_seq_regra_eup_w::text <> '') then 
			ie_possui_regra_w := 'S';		
			CALL mprev_inserir_atend_part(nr_seq_atendimento_w, cd_profissional_w, nr_seq_participante_w, nr_seq_regra_eup_w, nm_usuario_p, nr_seq_segurado_w);
		end if;	
		 
		end;
	end loop;
	close C01;
 
	if (ie_possui_regra_w = 'S') then		 
		update	mprev_agendamento 
		set		nr_seq_mprev_atend	= nr_seq_atendimento_w 
		where	nr_sequencia	 	= nr_seq_agendamento_p;	
		nr_seq_atend_mprev_p	:= nr_seq_atendimento_w;
	else 
		/* Rollback necessário para não ficar salvo o atendimento sem paciente */
 
		rollback;
		nr_seq_atend_mprev_p:= null;
	end if;
else 
	/* Incluir profissional adicional */
 
	CALL mprev_adic_prof_evento_atend(nr_seq_atendimento_w,null, cd_profissional_w,nm_usuario_p);	
	nr_seq_atend_mprev_p	:= nr_seq_atendimento_w;
end if;
 
/* Não pode ter commit aqui, tem na procedure anterior */
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_gerar_atend_agenda ( nr_seq_agendamento_p mprev_agendamento.nr_sequencia%type, dt_atendimento_p timestamp,  nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p bigint, nr_seq_atend_mprev_p INOUT bigint) FROM PUBLIC;

