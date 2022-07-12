-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_verificar_ativacao (nr_seq_participante_p bigint) RETURNS varchar AS $body$
DECLARE


suspensao_sem_termino_w		smallint;
nr_sequencia_program_w		bigint;
nr_sequencia_campanha_w		bigint;
ds_aviso_w			varchar(2);


BEGIN
ds_aviso_w := 'NA';

if (nr_seq_participante_p <> 0) then

	select 	count(nr_sequencia)
	into STRICT	suspensao_sem_termino_w
	from 	mprev_suspensao_atend
	where 	nr_seq_participante = nr_seq_participante_p
	and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	and	dt_inicio <= clock_timestamp()
	and (coalesce(dt_termino::text, '') = '' or dt_termino > clock_timestamp());

	select 	max(nr_sequencia)
	into STRICT 	nr_sequencia_program_w
	from 	mprev_programa_partic
	where 	nr_seq_participante = nr_seq_participante_p
	and	dt_inclusao <= clock_timestamp()
	and (dt_exclusao > clock_timestamp() or coalesce(dt_exclusao::text, '') = '');

	select 	max(nr_sequencia)
	into STRICT 	nr_sequencia_campanha_w
	from 	mprev_campanha_partic
	where 	nr_seq_participante = nr_seq_participante_p
	and	dt_inclusao <= clock_timestamp()
	and (dt_exclusao > clock_timestamp() or coalesce(dt_exclusao::text, '') = '');

	if (suspensao_sem_termino_w >= 1) then
	    ds_aviso_w := 'DT';
	elsif (coalesce(nr_sequencia_program_w::text, '') = '') and (coalesce(nr_sequencia_campanha_w::text, '') = '') then
		 ds_aviso_w := 'NR';
	else
		 ds_aviso_w := 'AT';
	end if;

end if;

return ds_aviso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_verificar_ativacao (nr_seq_participante_p bigint) FROM PUBLIC;
