-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_insere_participante ( nr_seq_captacao_p bigint, nr_seq_capt_destino_p bigint, nr_seq_programa_p bigint, nr_seq_campanha_p bigint, nm_usuario_p text, ie_incluso_p INOUT text, nm_incluso_p INOUT text, dt_inclusao_p timestamp) AS $body$
DECLARE

 		
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Inserir uma pessoa da Medicina Preventiva em alguma campanha ou programa.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
cd_pessoa_fisica_w	mprev_captacao.cd_pessoa_fisica%type;
nr_seq_participante_w	mprev_participante.nr_sequencia%type;
ie_consiste_w		varchar(10);
nr_seq_programa_w	mprev_programa.nr_sequencia%type	:= null;
nr_seq_campanha_w	mprev_campanha.nr_sequencia%type	:= null;
ie_partic_programa_w	varchar(1)	:= 'N';
ie_partic_campanha_w	varchar(1)	:= 'N';
ie_incluso_w		varchar(1)	:= 'N';
nm_incluso_w		varchar(255)	:= null;
ie_status_w		mprev_participante.ie_status%type;
ie_situacao_w		mprev_participante.ie_situacao%type;
nr_seq_eif_escala_w	bigint;
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;
nr_seq_contrato_emp_w	pls_contrato.nr_sequencia%type;
nr_seq_busca_emp_w	mprev_busca_empresarial.nr_sequencia%type;
nr_seq_equipe_w	mprev_captacao_destino.nr_seq_equipe%type;
ie_consiste_programa_w varchar(1)	:= 'N';
nr_seq_programa_partic_w mprev_programa_partic.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	c.nr_atendimento
	from	mprev_atend_paciente c,
		mprev_atendimento b,
		mprev_agendamento a
	where  	a.nr_seq_mprev_atend 	= b.nr_sequencia
	and	c.nr_seq_atendimento	= b.nr_sequencia
	and	a.nr_seq_captacao	= nr_seq_captacao_p;
	
C02 CURSOR FOR
	SELECT	nr_sequencia
	from	escala_eif_ii
	where	nr_atendimento	= nr_atendimento_w;


BEGIN

if (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> '') then
	if (nr_seq_capt_destino_p IS NOT NULL AND nr_seq_capt_destino_p::text <> '') then
		select	a.nr_seq_programa,
			a.nr_seq_campanha
		into STRICT	nr_seq_programa_w,
			nr_seq_campanha_w
		from	mprev_captacao_destino a
		where	a.nr_sequencia = nr_seq_capt_destino_p;
	else
		nr_seq_programa_w	:= nr_seq_programa_p;
		nr_seq_campanha_w	:= nr_seq_campanha_p;
	end if;
end if;	

if (nr_seq_captacao_p IS NOT NULL AND nr_seq_captacao_p::text <> '') then
	
	select	a.cd_pessoa_fisica,
		a.nr_seq_busca_emp
	into STRICT	cd_pessoa_fisica_w,
		nr_seq_busca_emp_w
	from	mprev_captacao a
	where	a.nr_sequencia = nr_seq_captacao_p;
	
	if (nr_seq_busca_emp_w IS NOT NULL AND nr_seq_busca_emp_w::text <> '') then
		begin
			select	a.nr_seq_contrato
			into STRICT	nr_seq_contrato_emp_w
			from	mprev_busca_empresarial a
			where	a.nr_sequencia = nr_seq_busca_emp_w;	
		exception
		when others then
			nr_seq_contrato_emp_w	:= null;
		end;
	end if;

	begin
	select	a.nr_sequencia
	into STRICT	nr_seq_participante_w
	from	mprev_participante a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_w;
	exception
		when others then
		nr_seq_participante_w	:= null;
	end;
	
	/* Se a pessoa ainda nao tem participante na Medicina Preventiva, criar */

	if (coalesce(nr_seq_participante_w::text, '') = '') then
		select	nextval('mprev_participante_seq')
		into STRICT	nr_seq_participante_w
		;
		
		/* Tratamento para quando esta em triagem ainda */

		if (coalesce(nr_seq_programa_w::text, '') = '') and (coalesce(nr_seq_campanha_w::text, '') = '') then
			ie_status_w	:= '2';
			ie_situacao_w	:= 'I';
		end if;
	
		insert into mprev_participante(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			cd_pessoa_fisica,
			ie_status,
			ie_situacao,
			ie_internacao,
			ie_cronico)
		values (nr_seq_participante_w,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica_w,
			ie_status_w,
			ie_situacao_w,
			'N',
			'N');
	else
		/* Consitir se a pessoa ja esta programa ou campanha informado */

		if (nr_seq_programa_w IS NOT NULL AND nr_seq_programa_w::text <> '') then
			select	coalesce(mprev_consiste_data('DT_INCLUSAO',
					trunc(clock_timestamp(),'dd'), 
					'DT_EXCLUSAO', 
					null, 
					'MPREV_PROGRAMA_PARTIC', 
					'NR_SEQ_PARTICIPANTE', 
					nr_seq_participante_w, 
					'NR_SEQ_PROGRAMA', 
					nr_seq_programa_w, 
					0,
					null),'N')
			into STRICT	ie_partic_programa_w
			;
		elsif (nr_seq_campanha_w IS NOT NULL AND nr_seq_campanha_w::text <> '') then
			select	coalesce(mprev_consiste_data('DT_INCLUSAO',
					trunc(clock_timestamp(),'dd'), 
					'DT_EXCLUSAO', 
					null, 
					'MPREV_CAMPANHA_PARTIC', 
					'NR_SEQ_PARTICIPANTE', 
					nr_seq_participante_w, 
					'NR_SEQ_CAMPANHA', 
					nr_seq_campanha_w, 
					0,
					null),'N')
			into STRICT	ie_partic_campanha_w
			;
		else
			/* Tratamento para quando esta em triagem ainda */

			ie_status_w	:= '2';
			ie_situacao_w	:= 'I';

			update	mprev_participante
			set	ie_status	= ie_status_w,
				ie_situacao	= ie_situacao_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_participante_w;
		end if;
	end if;
	/* Se passou na consistencia ou nao chegou a fazer, insere o participante no programa ou campanha */

	if (nr_seq_programa_w IS NOT NULL AND nr_seq_programa_w::text <> '') then
		if (ie_partic_programa_w = 'N') then
			insert into mprev_programa_partic(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_programa,
				nr_seq_participante,
				dt_inclusao,
				nr_seq_capt_destino,
				nr_seq_contrato_emp)
			values (nextval('mprev_programa_partic_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_programa_w,
				nr_seq_participante_w,
				dt_inclusao_p,
				nr_seq_capt_destino_p,
				nr_seq_contrato_emp_w)
			returning nr_sequencia into nr_seq_programa_partic_w;
				
			ie_incluso_w	:= 'S';
			
			/*seleciona a equipe responsavel pelo participante */

			select	max(nr_seq_equipe)
			into STRICT 	nr_seq_equipe_w
			from	mprev_captacao_destino
			where	nr_seq_captacao = nr_seq_captacao_p
			and		nr_seq_programa = nr_seq_programa_w;
			
			/*Verifica se a equipe responsavel no participante pelo programa, ja esta ativa como responsavel plo mesmo */

			select 	max('A')
			into STRICT	ie_consiste_programa_w
			from 	mprev_programa_partic x
			where 	x.nr_sequencia = nr_seq_programa_partic_w
			and		nr_seq_equipe_w not in (SELECT	a.nr_sequencia
					from	mprev_equipe a ,
							mprev_prog_partic_prof c
					where 	a.nr_sequencia = c.nr_seq_equipe
					and		x.nr_sequencia = c.nr_seq_programa_partic
					and 	c.nr_seq_participante = nr_seq_participante_w
					and (dt_fim_acomp > clock_timestamp() or coalesce(dt_fim_acomp::text, '') = ''));
			
			/*Caso  a equipe nao esteja responsavel pelo participante, insere a equipe*/

			if (coalesce(ie_consiste_programa_w, 'X') = 'A') and (nr_seq_equipe_w IS NOT NULL AND nr_seq_equipe_w::text <> '') then
				insert into mprev_prog_partic_prof(nr_sequencia,
					nr_seq_equipe,
					nr_seq_participante,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_inicio_acomp,
					nr_seq_programa_partic)
				values (nextval('mprev_prog_partic_prof_seq'),
					nr_seq_equipe_w,
					nr_seq_participante_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					dt_inclusao_p,
					nr_seq_programa_partic_w);
			end if;
			
			open c01;
			loop
			fetch c01 into	
				nr_atendimento_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				open c02;
				loop
				fetch c02 into	
					nr_seq_eif_escala_w;
				EXIT WHEN NOT FOUND; /* apply on c02 */
					begin
					CALL mprev_alterar_mod_escala(nr_seq_eif_escala_w,nm_usuario_p);
					end;
				end loop;
				close c02;
				
				end;
			end loop;
			close c01;
			
			update	mprev_participante
			set	ie_status	= '3',
				ie_situacao	= 'A',
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp()
			where	nr_sequencia	= nr_seq_participante_w;
		end if;
		nm_incluso_w	:= wheb_mensagem_pck.get_texto(327473) || ' - ' || substr(mprev_obter_desc_programa(nr_seq_programa_w),1,200);
	elsif (nr_seq_campanha_w IS NOT NULL AND nr_seq_campanha_w::text <> '') then
		if (ie_partic_campanha_w = 'N') then
			insert into mprev_campanha_partic(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_campanha,
				nr_seq_participante,
				dt_inclusao,
				nr_seq_capt_destino)
			values (nextval('mprev_campanha_partic_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_campanha_w,
				nr_seq_participante_w,
				dt_inclusao_p,
				nr_seq_capt_destino_p);

			ie_incluso_w	:= 'S';
		end if;
		nm_incluso_w	:= wheb_mensagem_pck.get_texto(327474) || ' - ' || substr(mprev_obter_desc_campanha(nr_seq_campanha_w),1,200);
	end if;
	
end if;

ie_incluso_p := ie_incluso_w;
nm_incluso_p := nm_incluso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_insere_participante ( nr_seq_captacao_p bigint, nr_seq_capt_destino_p bigint, nr_seq_programa_p bigint, nr_seq_campanha_p bigint, nm_usuario_p text, ie_incluso_p INOUT text, nm_incluso_p INOUT text, dt_inclusao_p timestamp) FROM PUBLIC;

