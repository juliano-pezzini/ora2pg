-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_gerar_reajuste_regra_pagto ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_regra_w	bigint;


BEGIN

update	contrato_regra_pagto
set	dt_final_vigencia = (clock_timestamp() - interval '1 days')
where	nr_sequencia = nr_sequencia_p;


select	nextval('contrato_regra_pagto_seq')
into STRICT	nr_sequencia_regra_w
;

insert 	into	contrato_regra_pagto(
		nr_sequencia,
		nr_seq_contrato,
		dt_atualizacao,
		nm_usuario,
		ie_forma,
		dt_primeiro_vencto,
		ie_tipo_valor,
		vl_pagto,
		cd_moeda,
		cd_indice_reajuste,
		ie_periodo_reajuste,
		cd_conta_financ,
		vl_ir,
		vl_inss,
		vl_iss,
		dt_inicio_vigencia,
		dt_final_vigencia,
		ds_observacao,
		qt_indice_reajuste,
		ds_ref_indice_reajuste,
		ds_regra_vencimento,
		nr_seq_trans_financ,
		nr_seq_trans_fin_baixa,
		ie_centro_contrato,
		tx_desc_antecipacao,
		cd_conta_contabil,
		qt_aviso_reajuste)
SELECT		nr_sequencia_regra_w,
		nr_seq_contrato,
		dt_atualizacao,
		nm_usuario_p,
		ie_forma,
		dt_primeiro_vencto,
		ie_tipo_valor,
		vl_pagto,
		cd_moeda,
		cd_indice_reajuste,
		ie_periodo_reajuste,
		cd_conta_financ,
		vl_ir,
		vl_inss,
		vl_iss,
		clock_timestamp(),
		null,
		ds_observacao,
		qt_indice_reajuste,
		ds_ref_indice_reajuste,
		ds_regra_vencimento,
		nr_seq_trans_financ,
		nr_seq_trans_fin_baixa,
		ie_centro_contrato,
		tx_desc_antecipacao,
		cd_conta_contabil,
		qt_aviso_reajuste
from		contrato_regra_pagto
where		nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_gerar_reajuste_regra_pagto ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
