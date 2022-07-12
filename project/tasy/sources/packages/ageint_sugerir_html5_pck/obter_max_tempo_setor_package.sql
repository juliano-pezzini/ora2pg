-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ageint_sugerir_html5_pck.obter_max_tempo_setor (cd_setor_pri_pp bigint, cd_setor_seg_pp bigint) RETURNS bigint AS $body$
DECLARE


	qt_tempo_item_w	bigint;
	qt_tempo_adic_w	bigint := 0;
	qt_tempo_temporario_w bigint;
	
	C01 CURSOR FOR
		SELECT	a.cd_setor_exclusivo
		from	ageint_exame_adic_item c,
			agenda_integrada_item b,
			agenda_paciente d,
			agenda a
		where	c.nr_seq_item		= b.nr_sequencia
		and	b.nr_sequencia		= nr_seq_ageint_item_seg_w
		and	b.nr_seq_agenda_exame 	= d.nr_sequencia
		and 	a.cd_agenda 		= d.cd_agenda;

	
BEGIN
	qt_tempo_item_w := ageint_sugerir_html5_pck.obter_tempo_setor(cd_setor_pri_pp, cd_setor_seg_pp);
	for exam_adic in c01 loop
		qt_tempo_temporario_w := ageint_sugerir_html5_pck.obter_tempo_setor(cd_setor_pri_pp, exam_adic.cd_setor_exclusivo);
		if qt_tempo_temporario_w > qt_tempo_adic_w then
			qt_tempo_adic_w := qt_tempo_temporario_w;
		end if;
	end loop;
	
	return greatest(qt_tempo_item_w,qt_tempo_adic_w);
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ageint_sugerir_html5_pck.obter_max_tempo_setor (cd_setor_pri_pp bigint, cd_setor_seg_pp bigint) FROM PUBLIC;