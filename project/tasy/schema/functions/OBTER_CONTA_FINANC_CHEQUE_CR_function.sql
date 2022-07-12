-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_financ_cheque_cr (nr_seq_cheque_p bigint, ie_status_cheque_p bigint) RETURNS bigint AS $body$
DECLARE


cd_conta_financ_w			bigint := null;
cd_empresa_w				bigint;
cd_estabelecimento_w			bigint;
cd_banco_w				bigint;
nr_seq_produto_w			bigint;
ie_origem_cheque_w			varchar(100);

/*
	0 - A VISTA
	1 - PRÉ-DATADO
	2 - DEPOSITADO
	3 - DEVOLVIDO
	4 - REAPRESENTADO
	5 - SEGUNDA DEVOLUCAO
	6 - DEVOLUCAO PACIENTE
	9 - SEGUNDA REAPRESENTAÇÃO
	10 - TERCEIRA DEVOLUÇAO
	11 - Custódia
*/
c01 CURSOR FOR
SELECT	a.cd_conta_financ
from	conta_financeira b,
	conta_financ_regra_cheque a
where	a.cd_conta_financ					= b.cd_conta_financ
and	b.cd_empresa						= cd_empresa_w
and	coalesce(b.cd_estabelecimento, cd_estabelecimento_w)		= cd_estabelecimento_w
and	coalesce(a.cd_banco, cd_banco_w)				= cd_banco_w
and	coalesce(a.ie_origem_cheque, ie_origem_cheque_w)		= ie_origem_cheque_w
and	coalesce(a.nr_seq_trans_fin_doc::text, '') = ''  -- Edgar 03/11/2008, OS 92431, se tiver este campo informado, será gerada a classificação do cheque no rec de caixa
and	coalesce(a.nr_seq_produto, coalesce(nr_seq_produto_w,0))		= coalesce(nr_seq_produto_w,0)
and	(
	 (ie_cheque_avista	= 'S' AND ie_status_cheque_p = 0) or
	 (ie_cheque_pre	= 'S' AND ie_status_cheque_p = 1) or
	 (ie_cheque_deposito	= 'S' AND ie_status_cheque_p = 2) or
	 (ie_cheque_dev	= 'S' AND ie_status_cheque_p = 3) or
	 (ie_cheque_reap	= 'S' AND ie_status_cheque_p = 4) or
	 (ie_cheque_seg_dev	= 'S' AND ie_status_cheque_p = 5) or
	 (ie_cheque_dev_pac	= 'S' AND ie_status_cheque_p = 6) or
	 (ie_cheque_seg_reap	= 'S' AND ie_status_cheque_p = 9) or
	 (ie_cheque_terc_dev	= 'S' AND ie_status_cheque_p = 10) or
	 (ie_cheque_custodia	= 'S' AND ie_status_cheque_p = 11)
	)
order	by coalesce(a.cd_banco,0),
	coalesce(a.ie_origem_cheque,0),
	coalesce(a.nr_seq_produto,0);


BEGIN

begin
select	b.cd_empresa,
	a.cd_estabelecimento,
	a.cd_banco,
	coalesce(a.ie_origem_cheque, 'X'),
	a.nr_seq_produto
into STRICT	cd_empresa_w,
	cd_estabelecimento_w,
	cd_banco_w,
	ie_origem_cheque_w,
	nr_seq_produto_w
from	estabelecimento b,
	cheque_cr a
where	a.nr_seq_cheque			= nr_seq_cheque_p
and	a.cd_estabelecimento			= b.cd_estabelecimento;
exception
when others then
	cd_empresa_w			:= 0;
	cd_estabelecimento_w		:= 0;
	nr_seq_produto_w		:= 0;
end;

cd_conta_financ_w			:= null;
open c01;
loop
fetch c01 into
	cd_conta_financ_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

return	cd_conta_financ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_financ_cheque_cr (nr_seq_cheque_p bigint, ie_status_cheque_p bigint) FROM PUBLIC;

