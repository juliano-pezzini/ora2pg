-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/* ################ End get_ds_estagio ###################################### */

/* ################ Start get_ds_dano_breve ################################# */

CREATE OR REPLACE FUNCTION phi_ordem_servico_pck.get_ds_dano_breve ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


		ds_retorno_w	varchar(4000);

	
BEGIN

		select	substr(mos.ds_dano_breve, 1, 4000)
		into STRICT	ds_retorno_w
		from	man_ordem_servico mos
		where	mos.nr_sequencia	= nr_seq_ordem_serv_p;

	return ds_retorno_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION phi_ordem_servico_pck.get_ds_dano_breve ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type) FROM PUBLIC;
