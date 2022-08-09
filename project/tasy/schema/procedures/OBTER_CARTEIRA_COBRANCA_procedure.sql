-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_carteira_cobranca ( cd_estabelecimento_p bigint, cd_convenio_p bigint, vl_referencia_p bigint, dt_referencia_p timestamp, nr_seq_conta_banco_p INOUT bigint, nr_seq_carteira_p INOUT bigint, tx_juros_p INOUT bigint, tx_multa_p INOUT bigint) AS $body$
DECLARE


nr_seq_conta_banco_w	bigint;
nr_seq_carteira_w		bigint;
ie_tipo_convenio_w		smallint;
tx_juros_w		double precision := null;
tx_multa_w		double precision := null;

c01 CURSOR FOR
SELECT	nr_seq_conta_banco,
	nr_seq_carteira,
	tx_juros,
	tx_multa
from	banco_carteira_regra
where	coalesce(ie_tipo_convenio,ie_tipo_convenio_w) = ie_tipo_convenio_w
and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))	= coalesce(cd_convenio_p,0)
and	coalesce(vl_referencia_p,0) between coalesce(vl_minimo,0) and coalesce(vl_maximo,9999999)
and	coalesce(dt_referencia_p,clock_timestamp()) between coalesce(dt_inicio_vigencia,to_date('01/01/1900','dd/mm/yyyy'))
			and coalesce(dt_fim_vigencia,to_date('31/12/2300','dd/mm/yyyy'))
and	cd_estabelecimento	= cd_estabelecimento_p;


BEGIN

nr_seq_conta_banco_w	:= null;
nr_seq_carteira_w	:= null;

select	coalesce(max(ie_tipo_convenio),0)
into STRICT	ie_tipo_convenio_w
from	convenio
where	cd_convenio	= cd_convenio_p;

open c01;
loop fetch c01 into
	nr_seq_conta_banco_w,
	nr_seq_carteira_w,
	tx_juros_w,
	tx_multa_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	nr_seq_carteira_w	:= nr_seq_carteira_w;
	nr_seq_conta_banco_w	:= nr_seq_conta_banco_w;
end loop;
close c01;

nr_seq_conta_banco_p	:= nr_seq_conta_banco_w;
nr_seq_carteira_p		:= nr_seq_carteira_w;
tx_juros_p		:= tx_juros_w;
tx_multa_p		:= tx_multa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_carteira_cobranca ( cd_estabelecimento_p bigint, cd_convenio_p bigint, vl_referencia_p bigint, dt_referencia_p timestamp, nr_seq_conta_banco_p INOUT bigint, nr_seq_carteira_p INOUT bigint, tx_juros_p INOUT bigint, tx_multa_p INOUT bigint) FROM PUBLIC;
