-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rep_get_justif_medispan ( nr_prescricao_p prescr_medica.nr_prescricao%type, cd_api_p alerta_api.cd_api%type, nr_agrupamento_p alerta_api.nr_agrupamento%type, ds_itens_interacao_p alerta_api.ds_itens_interacao%type, ds_resultado_curto_p alerta_api.ds_resultado_curto%type ) RETURNS varchar AS $body$
DECLARE


	ds_justificativa_w	prescr_material.ds_justificativa%type;


BEGIN

	if ((nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_api_p IS NOT NULL AND cd_api_p::text <> '') and (nr_agrupamento_p IS NOT NULL AND nr_agrupamento_p::text <> '')
		and (ds_itens_interacao_p IS NOT NULL AND ds_itens_interacao_p::text <> '') and (ds_resultado_curto_p IS NOT NULL AND ds_resultado_curto_p::text <> '')) then

		select max(b.ds_justificativa)
		  into STRICT ds_justificativa_w
		  from alerta_api a,
			   prescr_material b
		 where a.nr_prescricao = b.nr_prescricao
		   and a.nr_seq_material = b.nr_sequencia
		   and a.nr_prescricao = nr_prescricao_p
		   and a.ie_justificado = 'S'
		   and a.nr_agrupamento = nr_agrupamento_p
		   and a.cd_api = cd_api_p
		   and a.ds_itens_interacao = ds_itens_interacao_p
		   and a.ds_resultado_curto = ds_resultado_curto_p;

	end if;

	return ds_justificativa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rep_get_justif_medispan ( nr_prescricao_p prescr_medica.nr_prescricao%type, cd_api_p alerta_api.cd_api%type, nr_agrupamento_p alerta_api.nr_agrupamento%type, ds_itens_interacao_p alerta_api.ds_itens_interacao%type, ds_resultado_curto_p alerta_api.ds_resultado_curto%type ) FROM PUBLIC;
