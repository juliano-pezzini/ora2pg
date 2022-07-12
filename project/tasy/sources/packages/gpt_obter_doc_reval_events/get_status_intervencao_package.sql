-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gpt_obter_doc_reval_events.get_status_intervencao (nr_atendimento_p cpoe_revalidation_events.nr_atendimento%type) RETURNS varchar AS $body$
DECLARE


	qt_itens_pend_w				integer;
	qt_itens_reval_w			integer;
	ie_status_intervencao_w		varchar(2);
	dt_inicio_w					cpoe_revalidation_events.dt_validacao%type;

	
BEGIN

		if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

			dt_inicio_w	:=	gpt_get_doc_reval_period();

			select		count(1)
			into STRICT		qt_itens_pend_w
			from		gpt_doc_reval_events_v a
			where		a.ie_pendente_reval = 'S'
			and			gpt_se_item_doc_reval(a.nm_tabela, a.nr_seq_cpoe, null, 2) = 'S'
			and			a.nr_atendimento = nr_atendimento_p;
			
			select	count(1)
			into STRICT	qt_itens_reval_w
			from	gpt_doc_reval_events_v a
			where	a.ie_pendente_reval = 'S'
			and		gpt_se_item_doc_reval(a.nm_tabela, a.nr_seq_cpoe, null, 2) = 'S'
			and		a.nr_atendimento = nr_atendimento_p
			and		a.nr_sequencia = (SELECT max(x.nr_seq_reval_events) from gpt_hist_reval_events_doc x where a.nr_seq_cpoe = x.nr_seq_cpoe);

			if (qt_itens_pend_w = qt_itens_reval_w AND qt_itens_pend_w <> 0) then
				ie_status_intervencao_w := 'CO'; -- Completa
			elsif (qt_itens_pend_w > qt_itens_reval_w AND qt_itens_reval_w <> 0) then
				ie_status_intervencao_w := 'PA'; -- Parcial
			elsif (qt_itens_pend_w > 0 AND qt_itens_reval_w = 0) then
				ie_status_intervencao_w := 'PE'; -- Pendente
			end if;

		end if;

		return ie_status_intervencao_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gpt_obter_doc_reval_events.get_status_intervencao (nr_atendimento_p cpoe_revalidation_events.nr_atendimento%type) FROM PUBLIC;
