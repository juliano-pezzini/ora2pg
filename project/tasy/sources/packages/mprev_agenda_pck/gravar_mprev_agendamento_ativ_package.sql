-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/*---------------------------------------------------------------------------------------------------------------------------------------------
	| GRAVAR OS DADOS DA TABELA w_mprev_agendamento_ativ e w_mprev_ag_ativ_item na mprev_agendamento_ativ
	*/
CREATE OR REPLACE PROCEDURE mprev_agenda_pck.gravar_mprev_agendamento_ativ (nr_seq_w_agendamento_p bigint, nr_seq_agendamento_p bigint) AS $body$
DECLARE


	C01 CURSOR FOR
		SELECT	a.nr_sequencia,
			a.nr_seq_atividade,
			a.nr_seq_part_cic_item_ativ
		from	w_mprev_agendamento_ativ a
		where	a.nr_seq_w_agendamento = nr_seq_w_agendamento_p
		order by a.nr_sequencia;

	C02 CURSOR(nr_seq_w_agendamento_ativ_pc w_mprev_agendamento_ativ.nr_sequencia%type) FOR
		/* Atividades sem subitens vinculados */

		SELECT	a.dt_atualizacao,
			a.dt_atualizacao_nrec,
			a.ie_executado,
			a.nm_usuario,
			a.nm_usuario_nrec,
			null nr_seq_ativ_plano_aval,
			null nr_seq_ativ_plano_exame,
			null nr_seq_w_agendamento_ativ
		from	w_mprev_agendamento_ativ a
		where	a.nr_sequencia	= nr_seq_w_agendamento_ativ_pc
		and	not exists (SELECT	1
					from	w_mprev_ag_ativ_item x
					where	x.nr_seq_w_agendamento_ativ = a.nr_sequencia)
		
union all

		/* Atividades com subitens vinculados */

		select	a.dt_atualizacao,
			a.dt_atualizacao_nrec,
			a.ie_executado,
			a.nm_usuario,
			a.nm_usuario_nrec,
			a.nr_seq_ativ_plano_aval,
			a.nr_seq_ativ_plano_exame,
			a.nr_seq_w_agendamento_ativ
		from	w_mprev_ag_ativ_item a
		where	nr_seq_w_agendamento_ativ = nr_seq_w_agendamento_ativ_pc;

	
BEGIN

		delete	from	mprev_agendamento_ativ
		where	nr_seq_agendamento = nr_seq_agendamento_p;

		for r_C01 in C01 loop
			begin
				for r_C02 in C02(r_C01.nr_sequencia) loop
					begin
						insert into mprev_agendamento_ativ(nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_agendamento,
							nr_seq_atividade,
							ie_executado,
							nr_seq_ativ_plano_aval,
							nr_seq_ativ_plano_exame,
							nr_seq_part_cic_item_ativ)
						values (nextval('mprev_agendamento_ativ_seq'),
							r_C02.dt_atualizacao,
							r_C02.nm_usuario,
							r_C02.dt_atualizacao_nrec,
							r_C02.nm_usuario_nrec,
							nr_seq_agendamento_p,
							r_C01.nr_seq_atividade,
							r_C02.ie_executado,
							r_C02.nr_seq_ativ_plano_aval,
							r_C02.nr_seq_ativ_plano_exame,
							r_C01.nr_seq_part_cic_item_ativ);
					end;
				end loop;
			end;
		end loop;


	delete	from w_mprev_ag_ativ_item a
	where	exists (SELECT 1
			from	w_mprev_agendamento x,
				w_mprev_agendamento_ativ y
			where	x.nr_sequencia = y.nr_seq_w_agendamento
			and	y.nr_sequencia = a.nr_seq_w_agendamento_ativ
			and	x.nr_seq_agendamento = nr_seq_agendamento_p);

	delete	from w_mprev_agendamento_ativ a
	where	exists (SELECT	1
			from	w_mprev_agendamento x
			where	x.nr_sequencia	= a.nr_seq_w_agendamento
			and	x.nr_seq_agendamento = nr_seq_agendamento_p);


	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_agenda_pck.gravar_mprev_agendamento_ativ (nr_seq_w_agendamento_p bigint, nr_seq_agendamento_p bigint) FROM PUBLIC;