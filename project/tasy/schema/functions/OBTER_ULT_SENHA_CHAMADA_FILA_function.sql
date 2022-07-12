-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_senha_chamada_fila (nr_seq_fila_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS varchar AS $body$
DECLARE




cd_senha_chamada_w	varchar(30);

nr_sequencia_w		bigint;


BEGIN



if (coalesce(nr_seq_fila_p,0) > 0) then



	select	max(a.nr_seq_pac_senha_fila)

	into STRICT	nr_sequencia_w

	from	atendimentos_senha a

	where	a.nr_seq_fila_espera = nr_seq_fila_p

	and	a.dt_inicio_atendimento = (SELECT max(b.dt_inicio_atendimento)

					   from	  atendimentos_senha b

					   where  b.nr_seq_fila_espera = nr_seq_fila_p

					   and    trunc(b.dt_inicio_atendimento) between trunc(dt_inicio_p) and (dt_fim_p));



	if (coalesce(nr_sequencia_w,0) > 0) then



		select	substr(obter_letra_verifacao_senha(coalesce(nr_seq_fila_senha_origem, nr_seq_fila_senha)),1,10) || cd_senha_gerada

		into STRICT	cd_senha_chamada_w

		from	paciente_senha_fila

		where	nr_sequencia = nr_sequencia_w;

	end if;

end if;



return	cd_senha_chamada_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_senha_chamada_fila (nr_seq_fila_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;

