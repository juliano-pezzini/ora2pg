-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_edicao (CD_ESTABELECIMENTO_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, DT_VIGENCIA_P timestamp, cd_procedimento_p bigint) RETURNS bigint AS $body$
DECLARE



cd_edicao_amb_w			integer;
ie_prioridade_edicao_w		varchar(01);
VL_CH_HONORARIOS_W		double precision;
vL_CH_CUSTO_OPER_W		double precision;
VL_M2_FILME_W			double precision;
dt_inicio_vigencia_w		timestamp;
TX_AJUSTE_GERAL_w		double precision;
nr_seq_cbhpm_edicao_w		bigint;


BEGIN

select	coalesce(max(ie_prioridade_edicao_amb), 'N')
into STRICT	ie_prioridade_edicao_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;


if (ie_prioridade_edicao_w = 'N') then
	select	obter_edicao_amb(CD_ESTABELECIMENTO_P,
			CD_CONVENIO_P,
			CD_CATEGORIA_P,
			DT_VIGENCIA_P)
	into STRICT	cd_edicao_amb_w
	;
else
	SELECT * FROM Obter_Edicao_Proc_Conv(cd_estabelecimento_p, CD_CONVENIO_P, CD_CATEGORIA_p, DT_VIGENCIA_P, cd_procedimento_p, CD_EDICAO_AMB_W, VL_CH_HONORARIOS_W, VL_CH_CUSTO_OPER_W, VL_M2_FILME_W, dt_inicio_vigencia_w, TX_AJUSTE_GERAL_w, nr_seq_cbhpm_edicao_w) INTO STRICT CD_EDICAO_AMB_W, VL_CH_HONORARIOS_W, VL_CH_CUSTO_OPER_W, VL_M2_FILME_W, dt_inicio_vigencia_w, TX_AJUSTE_GERAL_w, nr_seq_cbhpm_edicao_w;

	if (coalesce(CD_EDICAO_AMB_W::text, '') = '') then
		select	obter_edicao_amb(CD_ESTABELECIMENTO_P,
			CD_CONVENIO_P,
			CD_CATEGORIA_P,
			DT_VIGENCIA_P)
		into STRICT	cd_edicao_amb_w
		;
	end if;


end if;

return	cd_edicao_amb_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_edicao (CD_ESTABELECIMENTO_P bigint, CD_CONVENIO_P bigint, CD_CATEGORIA_P text, DT_VIGENCIA_P timestamp, cd_procedimento_p bigint) FROM PUBLIC;
