-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_tooltip_details_hist_suep ( nr_pontuacao_p bigint, dt_pontuacao_p text, nr_sequencia_p text, ie_algorithm_type_p text) RETURNS varchar AS $body$
DECLARE


ds_return_w						varchar(1000) := null;


BEGIN

if (dt_pontuacao_p IS NOT NULL AND dt_pontuacao_p::text <> '' AND nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	if (ie_algorithm_type_p = 'AA') then

		ds_return_w := '<div class="text-tooltip-details-suep">' || coalesce(to_char(nr_pontuacao_p), '--') || ' (' || dt_pontuacao_p || ') ' || '<br><ul>' ||
					'<li>' || obter_desc_expressao_idioma(284616,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'AA', 'CAR') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(297723,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'AA', 'RES') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(487971,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'AA', 'HEM') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(297629,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'AA', 'REN') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(1032264,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'AA', 'DOE') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(1003477,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'AA', 'NEU') || ' ' || '<br></li></ul>';

	else

		ds_return_w := '<div class="text-tooltip-details-suep">' || coalesce(to_char(nr_pontuacao_p), '--') || ' (' || dt_pontuacao_p || ') ' || '<br><ul>' ||
					'<li>' || obter_desc_expressao_idioma(1002424,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'EWS', 'BP') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(1008847,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'EWS', 'HR') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(299207,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'EWS', 'TEMP') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(557498,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'EWS', 'RR') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(600755,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'EWS', 'O2S') || ' ' || '<br></li>' ||
					'<li>' || obter_desc_expressao_idioma(291539,null,wheb_usuario_pck.get_nr_seq_idioma) || ': ' || get_score_body_systems_suep(nr_sequencia_p, 'EWS', 'AGE') || ' ' || '<br></li></ul>';

	end if;

end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_tooltip_details_hist_suep ( nr_pontuacao_p bigint, dt_pontuacao_p text, nr_sequencia_p text, ie_algorithm_type_p text) FROM PUBLIC;
