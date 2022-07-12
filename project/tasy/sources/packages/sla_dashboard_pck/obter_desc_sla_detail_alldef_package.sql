-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_desc_sla_detail_alldef (sla_detail_p text) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w		varchar(255);
	nr_seq_idioma_w		bigint := 5;

	
BEGIN
	nr_seq_idioma_w := coalesce(wheb_usuario_pck.get_nr_seq_idioma,5);

	if (sla_detail_p IS NOT NULL AND sla_detail_p::text <> '') then
		if (sla_detail_p in ('CSFC')) then
			ds_retorno_w := substr(obter_desc_expressao_idioma(922839, 'Tempo resposta', nr_seq_idioma_w) ||
				' + ' || obter_desc_expressao_idioma(922841, 'Tempo solucao', nr_seq_idioma_w),1,255);
		elsif	sla_detail_p in ('COSC') then
			ds_retorno_w := substr(obter_desc_expressao_idioma(922839, 'Tempo resposta', nr_seq_idioma_w),1,255);
		elsif	sla_detail_p in ('COFC', 'COSP') then
			ds_retorno_w := substr(obter_desc_expressao_idioma(922841, 'Tempo solucao', nr_seq_idioma_w),1,255);
		end if;
	end if;

	return	ds_retorno_w;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_desc_sla_detail_alldef (sla_detail_p text) FROM PUBLIC;