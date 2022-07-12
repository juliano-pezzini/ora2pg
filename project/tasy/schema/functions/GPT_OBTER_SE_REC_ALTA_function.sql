-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_rec_alta (nr_atendimento_p bigint) RETURNS CPOE_RECOMENDACAO.IE_ITEM_ALTA%TYPE AS $body$
DECLARE


ie_alta_w		cpoe_recomendacao.ie_item_alta%type;


BEGIN
	ie_alta_w := 'N';

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

		select	coalesce(max(a.ie_item_alta), 'N')
		into STRICT	ie_alta_w
		from	cpoe_recomendacao a
		where	a.nr_atendimento = nr_atendimento_p
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		coalesce(a.dt_suspensao::text, '') = '';

		if (ie_alta_w = 'N') then

			select	coalesce(max(e.ie_prescricao_alta),'N')
			into STRICT	ie_alta_w
			from	cpoe_recomendacao a,
					prescr_recomendacao d,
					prescr_medica e
			where	a.nr_sequencia = d.nr_seq_rec_cpoe
			and		d.nr_prescricao = e.nr_prescricao
			and		e.nr_atendimento = nr_atendimento_p
			and		coalesce(e.dt_suspensao::text, '') = ''
			and		coalesce(d.dt_suspensao::text, '') = ''
			and		(e.dt_liberacao_medico IS NOT NULL AND e.dt_liberacao_medico::text <> '')
			and		(d.nr_seq_rec_cpoe IS NOT NULL AND d.nr_seq_rec_cpoe::text <> '')
			and		coalesce(e.ie_prescricao_alta,'N') = 'S'
			and		e.cd_estabelecimento = obter_estabelecimento_ativo;

		end if;

	end if;

	return ie_alta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_rec_alta (nr_atendimento_p bigint) FROM PUBLIC;

