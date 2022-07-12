-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_alerta_bac ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_gerou_evento_w	varchar(1) := 'N';
cd_pessoa_fisica_w	varchar(10);

BEGIN
 
if (coalesce(nr_atendimento_p,0) > 0) then 
	select	obter_pessoa_atendimento(nr_atendimento_p,'C') 
	into STRICT	cd_pessoa_fisica_w 
	;
 
	 
	begin 
		select	'S' 
		into STRICT	ie_gerou_evento_w 
		from	atendimento_precaucao a, 
			atendimento_paciente b 
		where	a.nr_seq_motivo_isol = 4 
		and	a.nr_atendimento = b.nr_atendimento 
		and	b.cd_pessoa_fisica = cd_pessoa_fisica_w 
		and	b.cd_estabelecimento = obter_estabelecimento_ativo 
		and	b.ie_tipo_atendimento in (1,8) 
		and	b.nr_atendimento < nr_atendimento_p 
		and	trunc(trunc(clock_timestamp()) - trunc(a.dt_termino)) <= 90;
 
		SELECT	'S' 
		into STRICT	ie_gerou_evento_w 
		FROM 	ev_evento_paciente a, 
			ev_evento_pac_destino b, 
			ev_evento c 
		WHERE	a.nr_sequencia = b.nr_seq_ev_pac 
		AND	c.nr_sequencia = a.nr_seq_evento  
		AND	a.nr_atendimento = nr_atendimento_p 
		AND	b.ie_forma_ev = 2 
		AND	TRUNC(a.dt_evento) = TRUNC(clock_timestamp()) 
		AND	UPPER(c.ds_evento) LIKE '%BACTÉRIA%' LIMIT 1;
	exception 
	when others then 
			ie_gerou_evento_w := 'N';
	end;
 
end if;
 
return	ie_gerou_evento_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_alerta_bac ( nr_atendimento_p bigint) FROM PUBLIC;
