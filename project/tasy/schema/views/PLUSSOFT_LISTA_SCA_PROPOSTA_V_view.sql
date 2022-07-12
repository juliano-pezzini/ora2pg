-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW plussoft_lista_sca_proposta_v (nr_seq_proposta, nr_seq_sca, vl_preco_atual) AS select distinct
		b.nr_seq_proposta nr_seq_proposta,
	       a.nr_seq_plano nr_seq_sca,
	       (substr(pls_obter_valor_sca_proposta(null,
							     a.nr_seq_benef_proposta,
							     a.nr_seq_plano),
				1,
				20))::numeric  vl_preco_atual
	  FROM pls_sca_vinculo a, pls_proposta_beneficiario b
	 where a.nr_seq_benef_proposta = b.nr_sequencia
	   and b.dt_cancelamento is null
	 group by a.nr_seq_plano, a.nr_seq_benef_proposta, b.nr_seq_proposta
	 order by a.nr_seq_plano;
