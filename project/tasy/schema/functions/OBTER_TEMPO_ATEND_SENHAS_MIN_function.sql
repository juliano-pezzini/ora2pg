-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_atend_senhas_min (nr_seq_pac_senha_fila_p bigint) RETURNS bigint AS $body$
DECLARE


qt_minuto_w 	bigint;


BEGIN
	select 	round(sum(coalesce(dt_fim_atendimento,clock_timestamp()) - dt_inicio_atendimento) * 1440)
	into STRICT 	qt_minuto_w
	from	atendimentos_senha
	where	nr_seq_pac_senha_fila = nr_seq_pac_senha_fila_p;


return	qt_minuto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_atend_senhas_min (nr_seq_pac_senha_fila_p bigint) FROM PUBLIC;
