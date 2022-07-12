-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_atend_senha (nr_sequencia_p bigint, ie_opcao_p text, nr_seq_fila_p bigint default 0) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp := null;
dt_alta_w		timestamp;
dt_inutilizacao_w	timestamp;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	if (coalesce(ie_opcao_p,'I') = 'I') then
		
		select 	max(c.dt_inicio_atendimento)
		into STRICT	dt_retorno_w	
		from	paciente_senha_fila a,			
			atendimentos_senha c
		where	1 = 1
		and	c.NR_SEQ_PAC_SENHA_FILA = a.nr_sequencia
		and	c.nr_seq_fila_espera = coalesce(a.nr_seq_fila_senha, nr_seq_fila_senha_origem)
		and	c.dt_inicio_atendimento > a.dt_entrada_fila
		and	a.nr_sequencia = nr_sequencia_p;		
		
	elsif (ie_opcao_p = 'A') then
	
		select	max(dt_alta)
		into STRICT	dt_retorno_w
		from	atendimento_paciente
		where	nr_seq_pac_senha_fila = nr_sequencia_p;		
	
	elsif (ie_opcao_p = 'AF') and (nr_seq_fila_p IS NOT NULL AND nr_seq_fila_p::text <> '')then
	
		select 	coalesce(max(z.dt_inicio_atendimento),clock_timestamp())
		into STRICT	dt_retorno_w	
		from   	atendimentos_senha z	
		where 	1 = 1
		and	z.nr_seq_fila_espera = CASE WHEN nr_seq_fila_p=0 THEN  z.nr_seq_fila_espera  ELSE nr_seq_fila_p END 
		and	z.nr_seq_pac_senha_fila = nr_sequencia_p;
		
		select	max(coalesce(dt_inutilizacao, dt_retorno_w))
		into STRICT	dt_inutilizacao_w
		from	paciente_senha_fila a
		where	nr_sequencia = nr_sequencia_p;
		
		dt_retorno_w := least(dt_retorno_w, dt_inutilizacao_w);
		
	elsif (ie_opcao_p = 'F') then
		
		select 	max(c.dt_fim_atendimento)
		into STRICT	dt_retorno_w	
		from	paciente_senha_fila a,			
			atendimentos_senha c
		where	1 = 1
		and	c.NR_SEQ_PAC_SENHA_FILA = a.nr_sequencia
		and	c.nr_seq_fila_espera = coalesce(a.nr_seq_fila_senha, nr_seq_fila_senha_origem)
		and	a.nr_sequencia = nr_sequencia_p;
		
	end if;
end if;

if (coalesce(dt_retorno_w::text, '') = '') then
	dt_retorno_w := clock_timestamp();
end if;	
	
return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_atend_senha (nr_sequencia_p bigint, ie_opcao_p text, nr_seq_fila_p bigint default 0) FROM PUBLIC;

