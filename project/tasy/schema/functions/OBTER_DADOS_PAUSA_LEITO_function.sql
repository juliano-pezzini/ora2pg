-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pausa_leito ( nr_seq_unidade_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
ie_opcao_p
C - Cód. do motivo de pausa
D - Descr. do motivo de pausa
*/
ds_retorno_w			varchar(255);
ds_retorno1_w			varchar(255);
ds_retorno2_w			varchar(255);
ds_erro_w			varchar(255);
nr_seq_motivo_pausa_w		bigint;
nr_sequencia_w			sl_unid_atend.nr_sequencia%type;


BEGIN

if (nr_seq_unidade_p IS NOT NULL AND nr_seq_unidade_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '')then
	begin

	if (ie_opcao_p = 'C') then
		select	max(b.nr_sequencia)
		into STRICT	nr_sequencia_w
		from	sl_unid_atend b
		where	b.nr_seq_unidade = nr_seq_unidade_p
		and	trunc(clock_timestamp()) between trunc(b.dt_inicio) and trunc(coalesce(b.dt_fim, clock_timestamp()))
		and	trunc(b.dt_inicio) >= trunc(clock_timestamp() - interval '1 days')
		and	(b.dt_pausa_servico IS NOT NULL AND b.dt_pausa_servico::text <> '')
		and	coalesce(b.dt_fim_pausa_servico::text, '') = '';

		if (coalesce(nr_sequencia_w,0) > 0) then
			select	max(a.nr_seq_motivo_pausa)
			into STRICT	nr_seq_motivo_pausa_w
			from	sl_unid_atend a
			where	a.nr_sequencia	= nr_sequencia_w;

			if (coalesce(nr_seq_motivo_pausa_w,0) > 0) then
				ds_retorno_w	:= nr_seq_motivo_pausa_w;
			end if;
		end if;
	else
		select	max(b.nr_sequencia)
		into STRICT	nr_sequencia_w
		from	sl_unid_atend b
		where	b.nr_seq_unidade = nr_seq_unidade_p
		and	trunc(clock_timestamp()) between trunc(b.dt_inicio) and trunc(coalesce(b.dt_fim, clock_timestamp()))
		and	trunc(b.dt_inicio) >= trunc(clock_timestamp() - interval '1 days')
		and	(b.dt_pausa_servico IS NOT NULL AND b.dt_pausa_servico::text <> '')
		and	coalesce(b.dt_fim_pausa_servico::text, '') = '';

		if (coalesce(nr_sequencia_w,0) > 0) then
			select	max(a.nr_seq_motivo_pausa),
				substr(max(a.ds_obs_pausa_leito),1,255)
			into STRICT	nr_seq_motivo_pausa_w,
				ds_retorno1_w
			from	sl_unid_atend a
			where	a.nr_sequencia	= nr_sequencia_w;

			if (coalesce(nr_seq_motivo_pausa_w,0) > 0) then

				select	substr(max(ds_motivo),1,255)
				into STRICT	ds_retorno2_w
				from	sl_motivo_pausa
				where	nr_sequencia = nr_seq_motivo_pausa_w;

			end if;

			if (ds_retorno2_w IS NOT NULL AND ds_retorno2_w::text <> '') then
				ds_retorno_w := substr(ds_retorno2_w,1,255);
			elsif (ds_retorno1_w IS NOT NULL AND ds_retorno1_w::text <> '')then
				ds_retorno_w := substr(ds_retorno1_w,1,255);
			else
				ds_retorno_w := '';
			end if;
		end if;
	end if;

	exception
	when others then
		ds_erro_w	:= substr(sqlerrm,1,255);
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pausa_leito ( nr_seq_unidade_p bigint, ie_opcao_p text) FROM PUBLIC;
