-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

		
/* ################ End get_ds_gerente_des		##################### */

/* ################ Start get_ds_gerente_sup		##################### */

CREATE OR REPLACE FUNCTION phi_ordem_servico_pck.get_ds_gerente_sup (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) RETURNS PESSOA_FISICA.NM_PESSOA_FISICA%TYPE AS $body$
DECLARE

	
	nm_gerente_sup_w	pessoa_fisica.nm_pessoa_fisica%type;

	
BEGIN
	
	select	max(gw.cd_responsavel)
	into STRICT	nm_gerente_sup_w
	from	man_ordem_servico mos,
		grupo_suporte gs,
		gerencia_wheb gw,
		pessoa_fisica pf
	where	mos.nr_seq_grupo_sup = gs.nr_sequencia
	and	gs.nr_seq_gerencia_sup = gw.nr_sequencia
	and	gw.cd_responsavel = pf.cd_pessoa_fisica
	and	mos.nr_sequencia = nr_seq_ordem_serv_p;
	
	return nm_gerente_sup_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION phi_ordem_servico_pck.get_ds_gerente_sup (nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) FROM PUBLIC;