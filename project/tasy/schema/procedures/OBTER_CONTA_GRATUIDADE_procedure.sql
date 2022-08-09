-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_conta_gratuidade ( dt_referencia_p timestamp, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_setor_atendimento_p bigint, cd_conta_contabil_p INOUT text, ie_trans_financ_p INOUT text, cd_historico_p INOUT bigint, cd_historico_cred_p INOUT bigint) AS $body$
DECLARE



cd_conta_contabil_w			CTB_LOTE_GRATUIDADE_REG.CD_CONTA_CONTABIL%Type;
cd_historico_w				CTB_LOTE_GRATUIDADE_REG.CD_HISTORICO%Type;
ie_tipo_convenio_w			CTB_LOTE_GRATUIDADE_REG.IE_TIPO_CONVENIO%Type;
ie_trans_financeira_w		CTB_LOTE_GRATUIDADE_REG.IE_TRANS_FINANCEIRA%Type;
cd_historico_cred_w			CTB_LOTE_GRATUIDADE_REG.CD_HISTORICO_CRED%Type;

c01 CURSOR FOR
SELECT	coalesce(ie_trans_financeira,'N') ie_trans_financeira,
		cd_conta_contabil,
		cd_historico,
		cd_historico_cred
from	ctb_lote_gratuidade_reg
where	coalesce(ie_tipo_convenio, ie_tipo_convenio_w)	= ie_tipo_convenio_w;


BEGIN
ie_tipo_convenio_w	:= coalesce(ie_tipo_convenio_p,0);

open C01;
loop
fetch C01 into
	ie_trans_financeira_w,
	cd_conta_contabil_w,
	cd_historico_w,
	cd_historico_cred_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ie_trans_financ_p	:= ie_trans_financeira_w;
	cd_conta_contabil_p	:= cd_conta_contabil_w;
	cd_historico_p		:= cd_historico_w;
	cd_historico_cred_p	:= cd_historico_cred_w;
	end;
end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_conta_gratuidade ( dt_referencia_p timestamp, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_setor_atendimento_p bigint, cd_conta_contabil_p INOUT text, ie_trans_financ_p INOUT text, cd_historico_p INOUT bigint, cd_historico_cred_p INOUT bigint) FROM PUBLIC;
