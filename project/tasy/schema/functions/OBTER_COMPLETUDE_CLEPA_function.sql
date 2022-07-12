-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_completude_clepa (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w double precision;
qt_liberada_w bigint;
qt_nao_liberada bigint;

BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select  count(*)
	into STRICT qt_liberada_w
	from med_avaliacao_paciente
	where nr_seq_atend_checklist = nr_sequencia_p
	and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

	select  count(*)
	into STRICT qt_nao_liberada
	from med_avaliacao_paciente
	where nr_seq_atend_checklist = nr_sequencia_p
	and coalesce(dt_liberacao::text, '') = '';

	nr_retorno_w := coalesce(clepa_obter_perc_valor(qt_liberada_w,qt_liberada_w + qt_nao_liberada),0);
end if;

return nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_completude_clepa (nr_sequencia_p bigint) FROM PUBLIC;
