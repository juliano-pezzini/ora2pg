-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_comp_gaso_rel ( qt_freq_vent_p bigint, qt_vc_prog_p bigint, qt_pip_p bigint, qt_peep_p bigint, qt_ps_p bigint, qt_fluxo_insp_p bigint, qt_tempo_insp_p bigint, qt_acima_peep_p bigint, qt_ti_te_p bigint, qt_sensib_resp_p bigint, ie_tipo_onda_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);


	function obter_valor_gaso_rel(qt_valor bigint, nr_seq_expressao bigint) return text is
	;
BEGIN
		if (coalesce(qt_valor::text, '') = '') then
			return '';
		else
			return ' ' || obter_desc_expressao(nr_seq_expressao, '') || ': ' || qt_valor || '    ';
		end if;
	end;

begin

	ds_retorno_w := (obter_valor_gaso_rel(qt_freq_vent_p, 290481) || obter_valor_gaso_rel(qt_vc_prog_p, 301581) || obter_valor_gaso_rel(qt_pip_p, 314664)
							|| obter_valor_gaso_rel(qt_peep_p, 314679) || obter_valor_gaso_rel(qt_ps_p, 314688) || obter_valor_gaso_rel(qt_fluxo_insp_p, 290192)
							|| obter_valor_gaso_rel(qt_tempo_insp_p, 298999) || obter_valor_gaso_rel(qt_acima_peep_p, 314710) || obter_valor_gaso_rel(qt_ti_te_p, 300086)
							|| obter_valor_gaso_rel(qt_sensib_resp_p, 314761) || obter_valor_dominio(3503,ie_tipo_onda_p));

	return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_comp_gaso_rel ( qt_freq_vent_p bigint, qt_vc_prog_p bigint, qt_pip_p bigint, qt_peep_p bigint, qt_ps_p bigint, qt_fluxo_insp_p bigint, qt_tempo_insp_p bigint, qt_acima_peep_p bigint, qt_ti_te_p bigint, qt_sensib_resp_p bigint, ie_tipo_onda_p text) FROM PUBLIC;
