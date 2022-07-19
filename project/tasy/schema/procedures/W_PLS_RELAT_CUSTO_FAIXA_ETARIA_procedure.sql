-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_pls_relat_custo_faixa_etaria ( nr_seq_contrato_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;

vl_despesa_benef_w		double precision;
vl_despesa_w			double precision;
qt_meses_w			bigint;
qt_idade_w			bigint;
dt_nascimento_w			timestamp;
ie_w				bigint;
qt_idade_inicial_w		bigint;
qt_idade_final_w		bigint;
vl_receita_benef_w		bigint;

vl_despesa_benef_ww		double precision;
vl_tot_despesa_w		double precision;
vl_receita_benef_ww		double precision;
vl_tot_receita_w		double precision;
qt_beneficiarios_w		bigint;
nr_seq_relat_relac_w		bigint;

C02 CURSOR FOR
	SELECT	b.nr_sequencia,
		c.dt_nascimento
	from	pessoa_fisica		c,
		pls_segurado		b,
		pls_contrato		a
	where	b.cd_pessoa_fisica	= c.cd_pessoa_fisica
	and	b.nr_seq_contrato	= a.nr_sequencia
	and	a.nr_contrato		= nr_seq_contrato_p
	and	coalesce(b.dt_rescisao::text, '') = ''
	and	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '');

C03 CURSOR FOR
	SELECT	a.qt_idade_inicial,
		a.qt_idade_final
	from	pls_faixa_etaria	b,
		pls_faixa_etaria_item	a
	where	a.nr_seq_faixa_etaria	= b.nr_sequencia
	and	b.ie_tipo_faixa_etaria	= 'R'
	and	b.cd_estabelecimento	= cd_estabelecimento_p;

C04 CURSOR FOR
	SELECT	nr_sequencia,
		vl_despesa_benef,
		vl_receita_benef
	from	w_pls_relat_relacionamento
	where	ie_tipo_relatorio	= 'CF'
	and	qt_idade between qt_idade_inicial_w and qt_idade_final_w
	and	(vl_despesa_benef IS NOT NULL AND vl_despesa_benef::text <> '');


BEGIN

delete	FROM w_pls_relat_relacionamento
where	ie_tipo_relatorio	= 'CF';

--pls_posicionar_sequence_cache('W_PLS_RELAT_RELACIONAMENTO','NR_SEQUENCIA','R',1000);
qt_meses_w	:= months_between(dt_final_p,dt_inicial_p)+1;


ie_w	:= 0;
open C02;
loop
fetch C02 into
	nr_seq_segurado_w,
	dt_nascimento_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	qt_idade_w		:= trunc(months_between(clock_timestamp(),dt_nascimento_w) / 12);
	vl_despesa_benef_w	:= 0;
	vl_receita_benef_w	:= 0;
	ie_w			:= ie_w + 1;

	select	sum(coalesce(VL_TOTAL,0))
	into STRICT	vl_despesa_benef_w
	from	pls_segurado		a,
		pls_conta		b
	where	b.nr_seq_segurado		= a.nr_sequencia
	and	a.nr_sequencia			= nr_seq_segurado_w
	and	b.ie_status			= 'F'
	and	trunc(b.dt_atendimento_referencia,'Month') between dt_inicial_p and dt_final_p;

	if (coalesce(vl_despesa_benef_w::text, '') = '') then
		vl_despesa_benef_w	:= 0;
	end if;

	select	sum(coalesce(b.vl_mensalidade,0))
	into STRICT	vl_receita_benef_w
	from	pls_segurado			a,
		pls_mensalidade_segurado	b,
		pls_mensalidade			c
	where	b.nr_seq_segurado		= a.nr_sequencia
	and	b.nr_seq_mensalidade		= c.nr_sequencia
	and	a.nr_sequencia			= nr_seq_segurado_w
	and	coalesce(c.ie_cancelamento::text, '') = ''
	and	trunc(b.DT_MESANO_REFERENCIA,'Month') between dt_inicial_p and dt_final_p;

	if (coalesce(vl_receita_benef_w::text, '') = '') then
		vl_receita_benef_w	:= 0;
	end if;

	insert into w_pls_relat_relacionamento(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			nr_seq_contrato,qt_idade,vl_despesa_benef,qt_meses_filtro,IE_TIPO_RELATORIO,vl_receita_benef)
	values (	nextval('w_pls_relat_relacionamento_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			nr_seq_contrato_p,qt_idade_w,vl_despesa_benef_w,qt_meses_w,'CF',vl_receita_benef_w);

	if (ie_w = 1000) then
		commit;
		ie_w	:= 0;
	end if;
	end;
end loop;
close C02;

open C03;
loop
fetch C03 into
	qt_idade_inicial_w,
	qt_idade_final_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin

	vl_tot_despesa_w	:= 0;
	vl_tot_receita_w	:= 0;
	qt_beneficiarios_w	:= 0;

	open C04;
	loop
	fetch C04 into
		nr_seq_relat_relac_w,
		vl_despesa_benef_ww,
		vl_receita_benef_ww;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin

		vl_tot_despesa_w	:= vl_tot_despesa_w + vl_despesa_benef_ww;
		vl_tot_receita_w	:= vl_tot_receita_w + vl_receita_benef_ww;
		qt_beneficiarios_w	:= qt_beneficiarios_w + 1;

		delete	FROM w_pls_relat_relacionamento
		where	nr_sequencia	= nr_seq_relat_relac_w;

		end;
	end loop;
	close C04;

	vl_tot_despesa_w	:= vl_tot_despesa_w;

	insert into w_pls_relat_relacionamento(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
			nr_seq_contrato,vl_custo_total,qt_meses_filtro,IE_TIPO_RELATORIO,qt_beneficiarios,
			qt_idade_inicial,qt_idade_final,vl_receita_total)
	values (	nextval('w_pls_relat_relacionamento_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
			nr_seq_contrato_p,vl_tot_despesa_w,qt_meses_w,'CF',qt_beneficiarios_w,
			qt_idade_inicial_w,qt_idade_final_w,vl_tot_receita_w);

	end;
end loop;
close C03;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_pls_relat_custo_faixa_etaria ( nr_seq_contrato_p bigint, dt_inicial_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

