-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ageint_sugerir_html5_pck.adicionar_agenda_vetor (dt_incio_sug_p timestamp, dt_fim_sug_p timestamp, nr_minuto_duracao_p bigint, nr_seq_ageint_item_p bigint, cd_pessoa_fisica_p text) AS $body$
DECLARE


nr_contador_w integer := 1;

C01 CURSOR FOR
	SELECT 	b.hr_inicio hr_agenda,
		b.nr_minuto_duracao,
		b.cd_agenda,
		c.nr_sequencia nr_seq_ageint_item,
		c.nr_seq_grupo_selec,
		a.cd_estabelecimento,
		b.nr_seq_proc_interno,
		a.cd_setor_exclusivo
	FROM agenda a, agenda_paciente b
LEFT OUTER JOIN agenda_integrada_item c ON (b.nr_sequencia = c.nr_seq_agenda_exame)
WHERE a.cd_agenda = b.cd_agenda and b.cd_pessoa_fisica = cd_pessoa_fisica_p and c.nr_sequencia <> nr_seq_ageint_item_p and b.ie_status_agenda not in ('C', 'F', 'II') and b.hr_inicio between dt_incio_sug_p - (nr_minuto_duracao_p+qt_tempo_regras_w+b.nr_minuto_duracao)/60/24 and dt_fim_sug_p + (nr_minuto_duracao_p+qt_tempo_regras_w+b.nr_minuto_duracao-1/24/60/60)/60/24
	 
union all

-- Tipo Agenda in (3,4,5) - Consultas e Servicos

	SELECT 	b.dt_agenda hr_agenda,
		b.nr_minuto_duracao,
		b.cd_agenda,
		c.nr_sequencia nr_seq_ageint_item,
		c.nr_seq_grupo_selec,
		a.cd_estabelecimento,
		b.nr_seq_proc_interno,
		a.cd_setor_exclusivo
	FROM agenda a, agenda_consulta b
LEFT OUTER JOIN agenda_integrada_item c ON (b.nr_sequencia = c.nr_seq_agenda_cons)
WHERE a.cd_agenda = b.cd_agenda and b.cd_pessoa_fisica = cd_pessoa_fisica_p and c.nr_sequencia <> nr_seq_ageint_item_p and b.ie_status_agenda not in ('C', 'F', 'II') and b.dt_agenda between dt_incio_sug_p - (nr_minuto_duracao_p+qt_tempo_regras_w+b.nr_minuto_duracao)/60/24 and dt_fim_sug_p + (nr_minuto_duracao_p+qt_tempo_regras_w+b.nr_minuto_duracao-1/24/60/60)/60/24;


BEGIN

  if nr_minuto_duracao_p > current_setting('ageint_sugerir_html5_pck.nr_maior_duracao_w')::bigint then
    PERFORM set_config('ageint_sugerir_html5_pck.nr_maior_duracao_w', nr_minuto_duracao_p, false);
    current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table.delete();

    for c_01 in c01 loop
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].hr_agenda := c_01.hr_agenda;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].nr_minuto_duracao := c_01.nr_minuto_duracao;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].cd_agenda := c_01.cd_agenda;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].nr_seq_ageint_item := c_01.nr_seq_ageint_item;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].nr_seq_grupo_selec := c_01.nr_seq_grupo_selec;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].cd_estabelecimento := c_01.cd_estabelecimento;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].nr_seq_proc_interno := c_01.nr_seq_proc_interno;
      current_setting('ageint_sugerir_html5_pck.agendamento_w')::agendamento_table[nr_contador_w].cd_setor_exclusivo := c_01.cd_setor_exclusivo;
      nr_contador_w := nr_contador_w + 1;
    end loop;
  end if;
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_sugerir_html5_pck.adicionar_agenda_vetor (dt_incio_sug_p timestamp, dt_fim_sug_p timestamp, nr_minuto_duracao_p bigint, nr_seq_ageint_item_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;
