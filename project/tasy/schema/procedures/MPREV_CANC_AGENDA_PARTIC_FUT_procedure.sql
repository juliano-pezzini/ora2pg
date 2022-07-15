-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_canc_agenda_partic_fut ( nr_seq_participante_p bigint, nr_seq_canc_ativ_p mprev_partic_canc_ativ.nr_sequencia%type, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Cancelar agendamentos individuais futuros
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: HDM - Controle de Participantes
[  ]  Objetos do dicionário [ x ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_agendamento_w		mprev_agendamento.nr_sequencia%type;
nr_seq_agendamento_ref_w	mprev_agendamento.nr_seq_agendamento_ref%type;
nr_seq_partic_ciclo_item_w	mprev_partic_ciclo_item.nr_sequencia%type;
nr_seq_motivo_canc_w		agenda_motivo_cancelamento.nr_sequencia%type;
dt_prevista_w			mprev_partic_ciclo_item.dt_prevista%type;

c01 CURSOR FOR
	SELECT 	nr_sequencia,
		nr_seq_agendamento_ref,
		nr_seq_partic_ciclo_item,
		nr_seq_motivo_canc
	from    mprev_agendamento
	where   nr_seq_participante = nr_seq_participante_p
	and     ie_status_agenda in ('A','CN')
	and     dt_agenda >= clock_timestamp();

BEGIN
if (nr_seq_participante_p IS NOT NULL AND nr_seq_participante_p::text <> '') then
	open c01;
	loop
	fetch c01 into
		nr_seq_agendamento_w,
		nr_seq_agendamento_ref_w,
		nr_seq_partic_ciclo_item_w,
		nr_seq_motivo_canc_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		CALL mprev_agenda_pck.cancelar_agendamento(	nr_seq_agendamento_w,
							nr_seq_agendamento_ref_w,
							nr_seq_partic_ciclo_item_w,
							nr_seq_motivo_canc_w,
							obter_texto_tasy(333300,null),
							'N',
							nr_seq_canc_ativ_p,
							nm_usuario_p);
		end;
		if (coalesce(ie_commit_p, 'S') = 'S') then
			commit;
		end if;
	end loop;
	close c01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_canc_agenda_partic_fut ( nr_seq_participante_p bigint, nr_seq_canc_ativ_p mprev_partic_canc_ativ.nr_sequencia%type, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;

