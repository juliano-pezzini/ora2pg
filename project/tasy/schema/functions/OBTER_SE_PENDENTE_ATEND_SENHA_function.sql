-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pendente_atend_senha (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select 	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT 	ds_retorno_w
	from	paciente_senha_fila a,
			fila_espera_senha b
	where	b.nr_sequencia = coalesce(a.nr_seq_fila_senha, a.nr_seq_fila_senha_origem)
	and		a.nr_sequencia = nr_sequencia_p
	and		not exists (SELECT 1
					from 	atendimentos_senha z
					where	z.NR_SEQ_PAC_SENHA_FILA = a.nr_sequencia
					and          coalesce(z.dt_inicio_atendimento::text, '') = '');

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pendente_atend_senha (nr_sequencia_p bigint) FROM PUBLIC;

