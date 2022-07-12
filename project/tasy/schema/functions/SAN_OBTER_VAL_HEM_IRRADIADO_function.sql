-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_val_hem_irradiado ( nr_seq_prod_p bigint, dt_validade_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_vencimento_w       san_producao.dt_vencimento%type;
ie_tipo_derivado_w    san_derivado.ie_tipo_derivado%type;
dt_fim_coleta_w       san_doacao.dt_fim_coleta%type;
nr_seq_derivado_w     san_producao.nr_seq_derivado%type;
nr_seq_doacao_w       san_producao.nr_seq_doacao%type;


BEGIN

if (nr_seq_prod_p IS NOT NULL AND nr_seq_prod_p::text <> '') then

	select 	max(nr_seq_derivado),
		max(nr_seq_doacao)
	into STRICT  	nr_seq_derivado_w,
		nr_seq_doacao_w
	from 	san_producao
	where 	nr_sequencia = nr_seq_prod_p;

	select 	max(ie_tipo_derivado)
	into STRICT 	ie_tipo_derivado_w
	from 	san_derivado
	where 	nr_sequencia = nr_seq_derivado_w;

	select 	max(dt_fim_coleta)
	into STRICT 	dt_fim_coleta_w
	from 	san_doacao
	where 	nr_sequencia = nr_seq_doacao_w;

	if (upper(ie_tipo_derivado_w) = 'CH') then
	
		if (dt_fim_coleta_w IS NOT NULL AND dt_fim_coleta_w::text <> '') then
			if (PKG_DATE_UTILS.get_DiffDate(dt_fim_coleta_w, clock_timestamp(), 'DAY') > 14) then
				dt_vencimento_w := clock_timestamp() + interval '2 days';
			else
				dt_vencimento_w := clock_timestamp() + interval '28 days';
			end if;
		end if;
		
	elsif (upper(ie_tipo_derivado_w) = 'G') then
		dt_vencimento_w := clock_timestamp() + interval '1 days';
	elsif (upper(ie_tipo_derivado_w) = 'CP') then
		dt_vencimento_w := dt_fim_coleta_w + 5;
	end if;
	
end if;

if (coalesce(dt_vencimento_w::text, '') = '') then
	dt_vencimento_w := dt_validade_p;
end if;

return dt_vencimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_val_hem_irradiado ( nr_seq_prod_p bigint, dt_validade_p timestamp) FROM PUBLIC;

