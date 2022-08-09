-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_seg_zlg_rech ( nr_conta_interna_p conta_paciente.nr_interno_conta%type, nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_301_indic_pag_w	d301_segmento_zlg.nr_seq_301_indic_pag%type;
nr_seq_dataset_ret_w 	d301_segmento_zlg.nr_seq_dataset_ret%type := null;

c01 CURSOR FOR
SELECT 	coalesce(cp.dt_mesano_referencia,cp.dt_acerto_conta) as dt_pagamento,
	coalesce(sum(pp.vl_procedimento),0)                  as vl_coparticipacao,
	cp.ie_status_acerto,
	pp.cd_pessoa_fisica,
	rla.qt_max_taxas
from 	procedimento_paciente pp,
	regra_lanc_automatico rla,
	conta_paciente cp
where 	cp.nr_interno_conta	= nr_conta_interna_p
and 	cp.nr_atendimento    	= pp.nr_atendimento
and 	pp.nr_seq_regra_lanc 	= rla.nr_sequencia
and 	rla.nr_seq_evento    	= 593
group by coalesce(cp.dt_mesano_referencia,cp.dt_acerto_conta),
	cp.ie_status_acerto,
	pp.cd_pessoa_fisica,
	rla.qt_max_taxas;

c01_w c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	nr_seq_301_indic_pag_w := obter_301_pagamento_copart(	c01_w.cd_pessoa_fisica,
								c01_w.dt_pagamento,
								c01_w.vl_coparticipacao,
								c01_w.ie_status_acerto,
								c01_w.qt_max_taxas);

	insert into d301_segmento_zlg(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		vl_coparticipacao,
		nr_seq_301_indic_pag,
		nr_seq_dataset,
		nr_seq_dataset_ret)
	values (nextval('d301_segmento_zlg_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		c01_w.vl_coparticipacao,
		nr_seq_301_indic_pag_w,
		nr_seq_dataset_p,
		nr_seq_dataset_ret_w);

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_seg_zlg_rech ( nr_conta_interna_p conta_paciente.nr_interno_conta%type, nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;
