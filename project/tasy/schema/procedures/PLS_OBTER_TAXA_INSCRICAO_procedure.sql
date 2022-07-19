-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_taxa_inscricao ( nr_seq_segurado_p bigint, nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, nr_seq_plano_p bigint, nr_seq_proposta_p bigint, nr_parcela_segurado_p bigint, dt_referencia_p timestamp, nr_seq_subestipulante_p bigint, ie_acao_contrato_p text, nr_seq_regra_p INOUT bigint, vl_inscricao_p INOUT bigint, tx_inscricao_p INOUT bigint) AS $body$
DECLARE


nr_seq_mensalidade_seg_w	bigint;
ie_taxa_inscricao_w		bigint;
qt_registros_w			bigint;
nr_seq_subestipulante_w		bigint;
ie_tipo_proposta_w		bigint;
ie_grau_dependencia_w		varchar(2);

c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.vl_inscricao,
		a.tx_inscricao,
		a.nr_seq_subestipulante
	from	pls_regra_inscricao a
	where	a.nr_seq_contrato	= nr_seq_contrato_p
	and	nr_parcela_segurado_p	>= a.qt_parcela_inicial
	and	nr_parcela_segurado_p	<= a.qt_parcela_final
	and	(((coalesce(a.ie_grau_dependencia,ie_grau_dependencia_w) = ie_grau_dependencia_w) or (a.ie_grau_dependencia = 'A')) or (ie_grau_dependencia_w = 'A'))
	and	trunc(dt_referencia_p,'month') between trunc(coalesce(dt_inicio_vigencia,dt_referencia_p),'month') and trunc(coalesce(dt_fim_vigencia,dt_referencia_p),'month')
	and	((a.nr_seq_subestipulante = nr_seq_subestipulante_p) or (coalesce(a.nr_seq_subestipulante::text, '') = ''))
	and	((a.ie_acao_contrato = ie_acao_contrato_p) or (coalesce(a.ie_acao_contrato::text, '') = ''))
	and	((a.ie_tipo_proposta = ie_tipo_proposta_w) or (coalesce(a.ie_tipo_proposta::text, '') = ''))
	
union

	SELECT	a.nr_sequencia,
		a.vl_inscricao,
		a.tx_inscricao,
		a.nr_seq_subestipulante
	from	pls_regra_inscricao a
	where	a.nr_seq_plano		= nr_seq_plano_p
	and	nr_parcela_segurado_p	>= a.qt_parcela_inicial
	and	nr_parcela_segurado_p	<= a.qt_parcela_final
	and	(((coalesce(a.ie_grau_dependencia,ie_grau_dependencia_w) = ie_grau_dependencia_w) or (a.ie_grau_dependencia = 'A')) or (ie_grau_dependencia_w = 'A'))
	and	trunc(dt_referencia_p,'month') between trunc(coalesce(dt_inicio_vigencia,dt_referencia_p),'month') and trunc(coalesce(dt_fim_vigencia,dt_referencia_p),'month')
	and	((a.ie_acao_contrato = ie_acao_contrato_p) or (coalesce(a.ie_acao_contrato::text, '') = '') or (coalesce(ie_acao_contrato_p::text, '') = ''))
	and	((a.ie_tipo_proposta = ie_tipo_proposta_w) or (coalesce(a.ie_tipo_proposta::text, '') = ''))
	and	not exists (select	1
				from	pls_regra_inscricao x
				where	x.nr_seq_contrato	= nr_seq_contrato_p)
	
union

	select	a.nr_sequencia,
		a.vl_inscricao,
		a.tx_inscricao,
		a.nr_seq_subestipulante
	from	pls_regra_inscricao a
	where	a.nr_seq_proposta	= nr_seq_proposta_p
	and	(((coalesce(a.ie_grau_dependencia,ie_grau_dependencia_w) = ie_grau_dependencia_w) or (a.ie_grau_dependencia = 'A')) or (ie_grau_dependencia_w = 'A'))
	and	trunc(dt_referencia_p,'month') between trunc(coalesce(dt_inicio_vigencia,dt_referencia_p),'month') and trunc(coalesce(dt_fim_vigencia,dt_referencia_p),'month')
	and	((a.ie_tipo_proposta = ie_tipo_proposta_w) or (coalesce(a.ie_tipo_proposta::text, '') = ''))
	
union

	select	a.nr_sequencia,
		a.vl_inscricao,
		a.tx_inscricao,
		a.nr_seq_subestipulante
	from	pls_regra_inscricao a
	where	a.nr_seq_intercambio	= nr_seq_intercambio_p
	and	nr_parcela_segurado_p	>= a.qt_parcela_inicial
	and	nr_parcela_segurado_p	<= a.qt_parcela_final
	and	(((coalesce(a.ie_grau_dependencia,ie_grau_dependencia_w) = ie_grau_dependencia_w) or (a.ie_grau_dependencia = 'A')) or (ie_grau_dependencia_w = 'A'))
	and	trunc(dt_referencia_p,'month') between trunc(coalesce(dt_inicio_vigencia,dt_referencia_p),'month') and trunc(coalesce(dt_fim_vigencia,dt_referencia_p),'month')
	and	((a.ie_acao_contrato = ie_acao_contrato_p) or (coalesce(a.ie_acao_contrato::text, '') = ''))
	and	((a.ie_tipo_proposta = ie_tipo_proposta_w) or (coalesce(a.ie_tipo_proposta::text, '') = ''))
	order by nr_seq_subestipulante desc;


BEGIN

if (coalesce(nr_seq_segurado_p,0) <> 0) then
	/*aaschlote 27/02/2012 - Caso tiver contrato nela, verificar se é de proposta*/

	if	((coalesce(nr_seq_contrato_p,0) <> 0) or (coalesce(nr_seq_intercambio_p,0) <> 0)) then
		if (coalesce(nr_seq_proposta_p,0) = 0) then
			begin
			select	CASE WHEN coalesce(nr_seq_titular::text, '') = '' THEN 'T'  ELSE 'D' END ,
				(	select	y.ie_tipo_proposta
					from	pls_proposta_adesao	y
					where	y.nr_sequencia		= a.nr_proposta_adesao) ie_tipo_proposta
			into STRICT	ie_grau_dependencia_w,
				ie_tipo_proposta_w
			from	pls_segurado	a
			where	nr_sequencia	= nr_seq_segurado_p;
			exception
			when others then
				ie_grau_dependencia_w	:= 'A';
			end;
		else
			begin
			select	CASE WHEN coalesce(a.nr_seq_titular::text, '') = '' THEN CASE WHEN coalesce(a.nr_seq_titular_contrato::text, '') = '' THEN 'T'  ELSE 'D' END   ELSE 'D' END ,
				b.ie_tipo_proposta
			into STRICT	ie_grau_dependencia_w,
				ie_tipo_proposta_w
			from	pls_proposta_beneficiario	a,
				pls_proposta_adesao		b
			where	a.nr_seq_proposta	= b.nr_sequencia
			and	a.nr_sequencia	= nr_seq_segurado_p;
			exception
			when others then
				ie_grau_dependencia_w	:= 'A';
			end;
		end if;
	elsif	((coalesce(nr_seq_proposta_p,0) <> 0) or (coalesce(nr_seq_plano_p,0) <> 0)) and (coalesce(nr_seq_contrato_p,0) = 0) then
		begin
		select	CASE WHEN coalesce(a.nr_seq_titular::text, '') = '' THEN CASE WHEN coalesce(a.nr_seq_titular_contrato::text, '') = '' THEN 'T'  ELSE 'D' END   ELSE 'D' END ,
			b.ie_tipo_proposta
		into STRICT	ie_grau_dependencia_w,
			ie_tipo_proposta_w
		from	pls_proposta_beneficiario	a,
			pls_proposta_adesao		b
		where	a.nr_seq_proposta	= b.nr_sequencia
		and	a.nr_sequencia	= nr_seq_segurado_p;
		exception
		when others then
			ie_grau_dependencia_w	:= 'A';
		end;
	end if;
else
	ie_grau_dependencia_w	:= 'A';
end if;

open c01;
loop
fetch c01 into
	nr_seq_regra_p,
	vl_inscricao_p,
	tx_inscricao_p,
	nr_seq_subestipulante_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

/* Não pode dar commit */

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_taxa_inscricao ( nr_seq_segurado_p bigint, nr_seq_contrato_p bigint, nr_seq_intercambio_p bigint, nr_seq_plano_p bigint, nr_seq_proposta_p bigint, nr_parcela_segurado_p bigint, dt_referencia_p timestamp, nr_seq_subestipulante_p bigint, ie_acao_contrato_p text, nr_seq_regra_p INOUT bigint, vl_inscricao_p INOUT bigint, tx_inscricao_p INOUT bigint) FROM PUBLIC;

