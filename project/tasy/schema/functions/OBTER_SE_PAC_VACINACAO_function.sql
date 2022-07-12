-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pac_vacinacao ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


dt_execucao_w		timestamp;
dt_cancelamento_w	timestamp;
ds_retorno_w		varchar(1) := 'N';
ie_registro_w		varchar(1) := 'N';
ie_serviço_vacina_w	varchar(1) := 'N';


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	begin

	select	coalesce(max('S'),'N')
	into STRICT	ie_serviço_vacina_w
	from	vacina_lista_espera
	where	nr_atendimento = nr_atendimento_p;

	select	coalesce(max('S'),'N')
	into STRICT	ie_serviço_vacina_w
	from  	atendimento_servico a,
			tipo_servico_atend b
	where 	a.nr_atendimento = 3367991
	and   	a.NR_SEQ_SERVICO = b.nr_sequencia
	and   	b.ie_tipo_servico = 'VI';

	if (ie_serviço_vacina_w = 'S') then


		select	coalesce(max('S'),'N')
		into STRICT	ie_registro_w
		from	vacina_lista_espera
		where	nr_atendimento = nr_atendimento_p;

		if (ie_registro_w = 'S') then

			select	max(dt_execucao),
					max(dt_cancelamento)
			into STRICT	dt_execucao_w,
					dt_cancelamento_w
			from	vacina_lista_espera
			where	nr_atendimento = nr_atendimento_p;

			if (coalesce(dt_execucao_w::text, '') = '' and coalesce(dt_cancelamento_w::text, '') = '') then
				ds_retorno_w := 'S';
			end if;

		end if;

	end if;

	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pac_vacinacao ( nr_atendimento_p bigint) FROM PUBLIC;
