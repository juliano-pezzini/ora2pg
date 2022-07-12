-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_segurado_preco ( nr_seq_segurado_p bigint) RETURNS bigint AS $body$
DECLARE


nr_seq_seg_preco_w		bigint;

ie_regulamentacao_w		varchar(1);
ie_mes_cobranca_reaj_w		varchar(1);
ie_mes_cobranca_reaj_regulam_w	varchar(1);
ie_mes_cobranca_reaj_cont_w	varchar(1);
ie_mes_cobranca_reajuste_w	varchar(1);


BEGIN

select	max(b.ie_mes_cobranca_reaj),
	max(c.ie_regulamentacao)
into STRICT	ie_mes_cobranca_reaj_cont_w,
	ie_regulamentacao_w
from	pls_segurado	a,
	pls_contrato	b,
	pls_plano	c
where	a.nr_seq_contrato	= b.nr_sequencia
and	a.nr_seq_plano		= c.nr_sequencia
and	a.nr_sequencia		= nr_seq_segurado_p;

ie_regulamentacao_w		:= coalesce(ie_regulamentacao_w,'P');

if (coalesce(ie_mes_cobranca_reaj_cont_w,'R') = 'R') then /* Se no contrato estiver "Conforme regra", pega pela regulamentação */
	select	max(ie_mes_cobranca_reaj),
		max(ie_mes_cobranca_reaj_reg)
	into STRICT	ie_mes_cobranca_reaj_w,
		ie_mes_cobranca_reaj_regulam_w
	from	pls_parametros
	where	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

	if (ie_regulamentacao_w = 'R') then
		ie_mes_cobranca_reajuste_w	:= ie_mes_cobranca_reaj_w;
	else
		ie_mes_cobranca_reajuste_w	:= ie_mes_cobranca_reaj_regulam_w;
	end if;
else
	ie_mes_cobranca_reajuste_w	:= coalesce(ie_mes_cobranca_reaj_cont_w,'P');
end if;
ie_mes_cobranca_reajuste_w	:= coalesce(ie_mes_cobranca_reajuste_w,'P');

select	max(a.nr_sequencia)
into STRICT	nr_seq_seg_preco_w
from	pls_segurado_preco a,
	pls_segurado b
where	a.nr_seq_segurado = b.nr_sequencia
and	b.nr_sequencia = nr_seq_segurado_p
and	(((PKG_DATE_UTILS.start_of(clock_timestamp(), 'MONTH', 0) >= PKG_DATE_UTILS.start_of(a.dt_reajuste, 'MONTH', 0))
and	((a.cd_motivo_reajuste <> 'E') or (ie_mes_cobranca_reajuste_w = 'M')))
or	(((a.cd_motivo_reajuste = 'E') and (PKG_DATE_UTILS.start_of(clock_timestamp(), 'MONTH', 0) >= PKG_DATE_UTILS.start_of(PKG_DATE_UTILS.ADD_MONTH(a.dt_reajuste,1,0), 'MONTH', 0)))
and (ie_mes_cobranca_reajuste_w = 'P')));

return	nr_seq_seg_preco_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_segurado_preco ( nr_seq_segurado_p bigint) FROM PUBLIC;

