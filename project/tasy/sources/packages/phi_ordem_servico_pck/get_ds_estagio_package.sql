-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/* ################ End get_ds_classificacao ################################ */

/* ################ Start get_ds_estagio #################################### */

CREATE OR REPLACE FUNCTION phi_ordem_servico_pck.get_ds_estagio ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, nr_seq_idioma_p idioma.nr_sequencia%type default null) RETURNS varchar AS $body$
DECLARE


		nr_seq_idioma_w	idioma.nr_sequencia%type;
		ds_retorno_w	varchar(4000);

	
BEGIN

		nr_seq_idioma_w := coalesce(nr_seq_idioma_p, wheb_usuario_pck.get_nr_seq_idioma, 1);

		select	substr(coalesce(obter_desc_exp_idioma(mep.cd_exp_estagio, nr_seq_idioma_w), mep.ds_estagio), 1, 4000)
		into STRICT	ds_retorno_w
		from	man_estagio_processo mep,
			man_ordem_servico mos
		where	mep.nr_sequencia	= mos.nr_seq_estagio
		and	mos.nr_sequencia	= nr_seq_ordem_serv_p;

	return ds_retorno_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION phi_ordem_servico_pck.get_ds_estagio ( nr_seq_ordem_serv_p man_ordem_servico.nr_sequencia%type, nr_seq_idioma_p idioma.nr_sequencia%type default null) FROM PUBLIC;