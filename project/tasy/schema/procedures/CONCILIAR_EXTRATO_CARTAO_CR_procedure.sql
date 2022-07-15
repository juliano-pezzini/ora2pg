-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE conciliar_extrato_cartao_cr ( nr_seq_extrato_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


qt_regra_w		bigint;
nr_seq_bandeira_w	bigint;
cd_estabelecimento_w	smallint;


BEGIN

select	max(a.nr_seq_bandeira),
	max(a.cd_estabelecimento)
into STRICT	nr_seq_bandeira_w,
	cd_estabelecimento_w
from	extrato_cartao_cr a
where	a.nr_sequencia	= nr_seq_extrato_p;

select	count(*)
into STRICT	qt_regra_w
from	band_cartao_cr_regra_atrib b,
	bandeira_cartao_cr_regra a
where	a.nr_sequencia		= b.nr_seq_regra_bandeira
and	coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_w,0))	= coalesce(cd_estabelecimento_w,0)
and	clock_timestamp()			between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp())
and	a.nr_seq_bandeira	= nr_seq_bandeira_w;

if (coalesce(qt_regra_w,0)	> 0) then
	CALL conciliar_ext_cartao_cr_regra(nr_seq_extrato_p,ie_opcao_p,nm_usuario_p);
else
	CALL conciliar_ext_cartao_cr_comum(nr_seq_extrato_p,ie_opcao_p,nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_extrato_cartao_cr ( nr_seq_extrato_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

