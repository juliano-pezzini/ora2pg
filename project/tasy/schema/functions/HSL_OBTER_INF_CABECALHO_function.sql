-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hsl_obter_inf_cabecalho (nr_atendimento_p bigint, nr_atendimento_mae_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w    	varchar(2000);
qt_peso_atend_w 	double precision;
qt_peso_atend_mae_w 	double precision;


BEGIN

if (ie_opcao_p = 'PesoNasc') then
	select 	max(qt_peso)
	into STRICT 	ds_retorno_w
	from 	nascimento
	where	nr_sequencia = (SELECT	coalesce(max(nr_sequencia),-1)
				from	nascimento
				where	(qt_peso IS NOT NULL AND qt_peso::text <> '')
				and	nr_atendimento	= nr_atendimento_mae_p)
	and nr_atendimento = nr_atendimento_mae_p;

	if (coalesce(ds_retorno_w::text, '') = '') and (obter_se_Atend_rn(nr_atendimento_p) = 'S') then
		select 	max(qt_peso)
		into STRICT 	ds_retorno_w
		from 	nascimento
		where	nr_sequencia = (SELECT	coalesce(max(nr_sequencia),-1)
					from	nascimento
					where	(qt_peso IS NOT NULL AND qt_peso::text <> '')
					and	nr_atendimento	= nr_atendimento_p)
		and nr_atendimento = nr_atendimento_p;
	end if;

elsif (ie_opcao_p = 'PesoAtual') then
	select	max(qt_peso_atual)
	into STRICT 	ds_retorno_w
	from	atendimento_sinal_vital
	where	nr_sequencia = (SELECT	coalesce(max(nr_sequencia),-1)
				from	atendimento_sinal_vital
				where	(qt_peso_atual IS NOT NULL AND qt_peso_atual::text <> '')
				and	nr_atendimento	= nr_atendimento_p
				and	ie_situacao = 'A');
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hsl_obter_inf_cabecalho (nr_atendimento_p bigint, nr_atendimento_mae_p text, ie_opcao_p text) FROM PUBLIC;

