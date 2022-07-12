-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	/*---------------------------------------------------------------------------------------------------------------------------------------------
	| GRAVAR OS DADOS DA TABELA W_MPREV_SEL_PARTIC_AGENDA PARA MPREV_SEL_PARTIC_AGENDA                 |
	*/
CREATE OR REPLACE PROCEDURE mprev_agenda_pck.gravar_mprev_sel_partic_agenda (nr_seq_agendamento_p bigint) AS $body$
DECLARE


	C01 CURSOR FOR
		SELECT	a.ds_justificativa_falta,
			a.dt_atualizacao,
			a.dt_atualizacao_nrec,
			a.ie_origem,
			a.ie_selecionado,
			a.nm_usuario,
			a.nm_usuario_nrec,
			a.nr_seq_participante,
			a.ie_confirmado,
			a.nr_seq_motivo_falta
		from	w_mprev_sel_partic_agenda a,
			w_mprev_agendamento b
		where	b.nr_sequencia = a.nr_seq_w_agendamento
		and	b.nr_seq_agendamento = nr_seq_agendamento_p
		order by a.nr_sequencia;

	
BEGIN

	delete	from	mprev_sel_partic_agenda
	where	nr_seq_agendamento = nr_seq_agendamento_p;

	for r_C01 in C01 loop
		insert into mprev_sel_partic_agenda(nr_sequencia,
			ds_justificativa_falta,
			dt_atualizacao,
			dt_atualizacao_nrec,
			ie_origem,
			ie_selecionado,
			nm_usuario,
			nm_usuario_nrec,
			nr_seq_participante,
			nr_seq_agendamento,
			ie_confirmado,
			nr_seq_motivo_falta)
		values (nextval('mprev_sel_partic_agenda_seq'),
			r_C01.ds_justificativa_falta,
			r_C01.dt_atualizacao,
			r_C01.dt_atualizacao_nrec,
			r_C01.ie_origem,
			r_C01.ie_selecionado,
			r_C01.nm_usuario,
			r_C01.nm_usuario_nrec,
			r_C01.nr_seq_participante,
			nr_seq_agendamento_p,
			r_C01.ie_confirmado,
			r_C01.nr_seq_motivo_falta);

		commit;

	end loop;

	delete from w_mprev_sel_partic_agenda a
	where exists (SELECT	1
			from	w_mprev_agendamento x
			where	x.nr_sequencia	= a.nr_seq_w_agendamento
			and	x.nr_seq_agendamento = nr_seq_agendamento_p);

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_agenda_pck.gravar_mprev_sel_partic_agenda (nr_seq_agendamento_p bigint) FROM PUBLIC;
