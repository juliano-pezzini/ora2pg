-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION retorna_data_inicio_fim_port (nr_seq_port_p bigint, ie_tipo_p text) RETURNS timestamp AS $body$
DECLARE


ie_retorno_date  timestamp;
ie_inicio_prev_w  timestamp;
ie_inicio_real_w  timestamp;

/*
	Esta function tem como objetivo retornar a data prevista de início OU fim de um portifolio.

	ie_tipo_p = 'I'  irá retornar a data de Inicio do portifolio
	ie_tipo_p = 'F'  irá retornar a data de Fim do portifolio

*/
BEGIN

if (ie_tipo_p = 'I')then
	select   trunc(min(e.dt_inicio_prev)),
			 trunc(min(e.dt_inicio_real))
	into STRICT  	 ie_inicio_prev_w,
			 ie_inicio_real_w
	from     proj_portifolio pf,
			 proj_programa pr,
			 proj_projeto p,
			 proj_cronograma c,
			 proj_cron_etapa e
	where    pf.nr_sequencia = pr.nr_seq_portifolio
	and		 pr.nr_sequencia = p.nr_seq_programa
	and		 p.nr_sequencia = c.nr_seq_proj
	and      c.nr_sequencia = e.nr_seq_cronograma
	and      c.ie_situacao  = 'A'
	and		 pf.nr_sequencia = nr_seq_port_p
	and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
	and  	 not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia);

	--Se o portifoliocomeçar antes da data prevista, então deve ser retornado o valor de inicio realizado do portifolio
	if (ie_inicio_real_w < ie_inicio_prev_w)then
		ie_retorno_date := ie_inicio_real_w;
	else
		ie_retorno_date := ie_inicio_prev_w;
	end if;

end if;


if (ie_tipo_p = 'F') then
	select   trunc(max(e.dt_fim_prev))
	into STRICT  	ie_retorno_date
	from     proj_portifolio pf,
			 proj_programa pr,
			 proj_projeto p,
			 proj_cronograma c,
			 proj_cron_etapa e
	where    pf.nr_sequencia = pr.nr_seq_portifolio
	and		 pr.nr_sequencia = p.nr_seq_programa
	and		 p.nr_sequencia = c.nr_seq_proj
	and      c.nr_sequencia = e.nr_seq_cronograma
	and      c.ie_situacao  = 'A'
	and	(c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '')
	and		 pf.nr_sequencia = nr_seq_port_p
	and  	 not exists (SELECT 1 from proj_cron_etapa xx where xx.nr_seq_superior =  e.nr_sequencia);
end if;

return	ie_retorno_date;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION retorna_data_inicio_fim_port (nr_seq_port_p bigint, ie_tipo_p text) FROM PUBLIC;
