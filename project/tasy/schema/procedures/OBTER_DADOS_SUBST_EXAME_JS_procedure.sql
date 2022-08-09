-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_dados_subst_exame_js ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_permite_alterar_p text, qt_resultado_exame_p INOUT bigint, qt_exame_conta_p INOUT bigint, qt_laudo_procedimento_p INOUT bigint) AS $body$
DECLARE


qt_resultado_exame_w	bigint;
qt_exame_conta_w	bigint;
qt_laudo_procedimento_w	bigint := 0;


BEGIN

select 	count(*)
into STRICT	qt_resultado_exame_w
from	exame_lab_result_item a,
        exame_lab_resultado b
where	a.nr_seq_resultado = b.nr_seq_resultado
and	b.nr_prescricao = nr_prescricao_p
and	a.nr_seq_prescr = nr_seq_prescr_p;

select 	count(*)
into STRICT	qt_exame_conta_w
from	procedimento_paciente a
where	a.nr_prescricao = nr_prescricao_p
and	a.nr_sequencia_prescricao = nr_seq_prescr_P;

if (ie_permite_alterar_p = 'S') then--[162]
	select 	count(*)
	into STRICT	qt_laudo_procedimento_w
	from    procedimento_paciente f,
		laudo_paciente d
	where   f.nr_sequencia  = d.nr_seq_proc
	and     f.nr_prescricao = nr_prescricao_p
	and     f.nr_sequencia_prescricao = nr_seq_prescr_p;
end if;

qt_resultado_exame_p	:= qt_resultado_exame_w;
qt_exame_conta_p	:= qt_exame_conta_w;
qt_laudo_procedimento_p := qt_laudo_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_dados_subst_exame_js ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_permite_alterar_p text, qt_resultado_exame_p INOUT bigint, qt_exame_conta_p INOUT bigint, qt_laudo_procedimento_p INOUT bigint) FROM PUBLIC;
