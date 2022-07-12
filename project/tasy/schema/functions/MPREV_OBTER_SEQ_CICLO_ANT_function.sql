-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mprev_obter_seq_ciclo_ant ( nr_seq_prog_partic_mod_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_prog_part_mod_ant_w	mprev_prog_partic_modulo.nr_sequencia%type;
nr_seq_ciclo_ant_w		mprev_prog_partic_modulo.nr_sequencia%type;
nr_retorno_w			mprev_prog_partic_modulo.nr_sequencia%type;
nr_seq_programa_partic_w	mprev_programa_partic.nr_sequencia%type;
nr_seq_modulo_w			mprev_modulo_atend.nr_sequencia%type;
nr_seq_agrupamento_w		mprev_modulo_atend.nr_seq_agrupamento%type;
nr_seq_participante_w		mprev_participante.nr_sequencia%type;


BEGIN

if (nr_seq_prog_partic_mod_p IS NOT NULL AND nr_seq_prog_partic_mod_p::text <> '') then
	
	select 	b.nr_seq_participante,
		c.nr_seq_modulo,
		d.nr_seq_agrupamento
	into STRICT	nr_seq_participante_w,
		nr_seq_modulo_w,
		nr_seq_agrupamento_w
	from	mprev_modulo_atend d,
		mprev_programa_modulo c,
		mprev_programa_partic b,
		mprev_prog_partic_modulo a
	where	a.nr_seq_programa_partic	= b.nr_sequencia
	and	a.nr_seq_prog_modulo		= c.nr_sequencia
	and	c.nr_seq_modulo			= d.nr_sequencia
	and	a.nr_sequencia 			= nr_seq_prog_partic_mod_p;
	
	/*Verifica se  o modulo que esta sendo gerado ja foi gerado para pegar a sequencia da mprev_partic_ciclo_atend */

	select  max(a.nr_sequencia)
	into STRICT	nr_seq_prog_part_mod_ant_w
	from	mprev_programa_partic c,
		mprev_programa_modulo b,
		mprev_prog_partic_modulo a
	where	a.nr_seq_prog_modulo	= b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_programa_partic
	and	b.nr_sequencia 		= nr_seq_modulo_w
	and	c.nr_seq_participante	= nr_seq_participante_w
	and	a.nr_sequencia <> nr_seq_prog_partic_mod_p
	and	coalesce(a.dt_cancelamento::text, '') = '';
		
	if (coalesce(nr_seq_prog_part_mod_ant_w::text, '') = '') and (coalesce(nr_seq_agrupamento_w, 0) > 0) then
		/*Verifica se  o modulo que esta sendo gerado pertence ao mesmo agrupamento dos que ja foram gerados */

		select  max(a.nr_sequencia)
		into STRICT	nr_seq_prog_part_mod_ant_w
		from	mprev_modulo_atend d,
			mprev_programa_partic c,
			mprev_programa_modulo b,
			mprev_prog_partic_modulo a
		where	a.nr_seq_prog_modulo	= b.nr_sequencia
		and	c.nr_sequencia		= a.nr_seq_programa_partic
		and	b.nr_seq_modulo		= nr_seq_modulo_w
		and	d.nr_seq_agrupamento	= nr_seq_agrupamento_w
		and	c.nr_seq_participante	= nr_seq_participante_w
		and	a.nr_sequencia <> nr_seq_prog_partic_mod_p
		and	coalesce(a.dt_cancelamento::text, '') = '';
	end if;
	
	if (nr_seq_prog_part_mod_ant_w IS NOT NULL AND nr_seq_prog_part_mod_ant_w::text <> '') then
		--Pega o ultimo registro do ciclo do atendimento do modulo anterior
		select	max(nr_sequencia)
		into STRICT	nr_seq_ciclo_ant_w
		from	mprev_partic_ciclo_atend
		where	nr_seq_prog_partic_mod = nr_seq_prog_part_mod_ant_w;
	end if;
	
end if;

nr_retorno_w	:= nr_seq_ciclo_ant_w;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mprev_obter_seq_ciclo_ant ( nr_seq_prog_partic_mod_p bigint) FROM PUBLIC;

