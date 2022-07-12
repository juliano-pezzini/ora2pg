-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_mot_nao_contab_prov_prod ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_resumo_p bigint, nr_lote_contabil_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tipo_protocolo_w			pls_protocolo_conta.ie_tipo_protocolo%type;
ie_status_conta_w			pls_conta.ie_status%type;
ie_situacao_prot_w			pls_protocolo_conta.ie_situacao%type;
ie_status_item_w			pls_conta_proc.ie_status%type;
dt_mes_competencia_w			pls_protocolo_conta.dt_mes_competencia%type;
vl_provisao_w				pls_conta_proc.vl_provisao%type;
vl_liberado_w				pls_conta_proc.vl_liberado%type;
vl_ajuste_w				pls_conta_proc.vl_provisao%type;
cd_conta_provisao_deb_w			pls_conta_proc.cd_conta_provisao_deb%type;
cd_conta_provisao_cred_w		pls_conta_proc.cd_conta_provisao_cred%type;
cd_estabelecimento_w			pls_conta.cd_estabelecimento%type;
cd_estabelecimento_lote_w		lote_contabil.cd_estabelecimento%type;
dt_referencia_lote_w			lote_contabil.dt_referencia%type;
ie_lote_ajuste_prod_w			pls_parametro_contabil.ie_lote_ajuste_prod%type;
ie_situacao_resumo_w			pls_conta_medica_resumo.ie_situacao%type;
ie_tipo_item_resumo_w			pls_conta_medica_resumo.ie_tipo_item%type;
ie_tipo_item_w				varchar(2);
vl_retorno_w				varchar(4000);


BEGIN

begin
select	dt_referencia,
	cd_estabelecimento
into STRICT	dt_referencia_lote_w,
	cd_estabelecimento_lote_w
from	lote_contabil
where	nr_lote_contabil = nr_lote_contabil_p;
exception when others then
	vl_retorno_w := substr(vl_retorno_w || obter_desc_expressao(968729), 1, 4000);
	return	vl_retorno_w;
end;

select	coalesce(max(ie_lote_ajuste_prod),'R')
into STRICT	ie_lote_ajuste_prod_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_p;


if ((nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') and coalesce(nr_seq_conta_resumo_p::text, '') = '') then
	ie_tipo_item_w := 'P';

	begin
	select	a.ie_tipo_protocolo,
		b.ie_status ie_status_conta,
		a.ie_situacao,
		c.ie_status ie_status_item,
		a.dt_mes_competencia,
		c.vl_provisao,
		c.vl_liberado,
		c.cd_conta_provisao_deb,
		c.cd_conta_provisao_cred,
		b.cd_estabelecimento
	into STRICT	ie_tipo_protocolo_w,
		ie_status_conta_w,
		ie_situacao_prot_w,
		ie_status_item_w,
		dt_mes_competencia_w,
		vl_provisao_w,
		vl_liberado_w,
		cd_conta_provisao_deb_w,
		cd_conta_provisao_cred_w,
		cd_estabelecimento_w
	from	pls_protocolo_conta a,
		pls_conta b,
		pls_conta_proc c
	where	b.nr_sequencia = nr_seq_conta_p
	and	c.nr_sequencia = nr_seq_conta_proc_p
	and	c.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = a.nr_sequencia;
	exception when others then
		vl_retorno_w := substr(vl_retorno_w || obter_desc_expressao(968731), 1, 4000);
		return	vl_retorno_w;
	end;

elsif ((nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') and coalesce(nr_seq_conta_resumo_p::text, '') = '') then
	ie_tipo_item_w := 'M';

	begin
	select	a.ie_tipo_protocolo,
		b.ie_status ie_status_conta,
		a.ie_situacao,
		c.ie_status ie_status_item,
		a.dt_mes_competencia,
		c.vl_provisao,
		c.vl_liberado,
		c.cd_conta_provisao_deb,
		c.cd_conta_provisao_cred,
		b.cd_estabelecimento
	into STRICT	ie_tipo_protocolo_w,
		ie_status_conta_w,
		ie_situacao_prot_w,
		ie_status_item_w,
		dt_mes_competencia_w,
		vl_provisao_w,
		vl_liberado_w,
		cd_conta_provisao_deb_w,
		cd_conta_provisao_cred_w,
		cd_estabelecimento_w
	from	pls_protocolo_conta a,
		pls_conta b,
		pls_conta_mat c
	where	b.nr_sequencia = nr_seq_conta_p
	and	c.nr_sequencia = nr_seq_conta_mat_p
	and	c.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = a.nr_sequencia;
	exception when others then
		vl_retorno_w := substr(vl_retorno_w || obter_desc_expressao(968731), 1, 4000);
		return	vl_retorno_w;
	end;
elsif (nr_seq_conta_resumo_p IS NOT NULL AND nr_seq_conta_resumo_p::text <> '' AND nr_seq_conta_proc_p IS NOT NULL AND nr_seq_conta_proc_p::text <> '') then
	ie_tipo_item_w := 'R';

	begin
	select	a.ie_tipo_protocolo,
		b.ie_status ie_status_conta,
		a.ie_situacao,
		c.ie_status ie_status_item,
		a.dt_mes_competencia,
		CASE WHEN coalesce(d.nr_seq_esquema_prov,0)=0 THEN c.cd_conta_provisao_deb  ELSE d.cd_conta_prov_deb END  cd_conta_debito,
		CASE WHEN coalesce(d.nr_seq_esquema_prov,0)=0 THEN c.cd_conta_provisao_cred  ELSE d.cd_conta_prov_cred END  cd_conta_credito,
		d.ie_situacao,
		d.ie_tipo_item
	into STRICT	ie_tipo_protocolo_w,
		ie_status_conta_w,
		ie_situacao_prot_w,
		ie_status_item_w,
		dt_mes_competencia_w,
		cd_conta_provisao_deb_w,
		cd_conta_provisao_cred_w,
		ie_situacao_resumo_w,
		ie_tipo_item_resumo_w
	from	pls_protocolo_conta a,
		pls_conta b,
		pls_conta_proc c,
		pls_conta_medica_resumo d
	where	b.nr_sequencia = nr_seq_conta_p
	and	c.nr_sequencia = nr_seq_conta_proc_p
	and	d.nr_sequencia = nr_seq_conta_resumo_p
	and	c.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = a.nr_sequencia
	and	d.nr_seq_conta = b.nr_sequencia
	and	d.nr_seq_conta_proc = c.nr_sequencia;
	exception when others then
		vl_retorno_w := substr(vl_retorno_w || obter_desc_expressao(968731), 1, 4000);
		return	vl_retorno_w;
	end;
elsif (nr_seq_conta_resumo_p IS NOT NULL AND nr_seq_conta_resumo_p::text <> '' AND nr_seq_conta_mat_p IS NOT NULL AND nr_seq_conta_mat_p::text <> '') then
	ie_tipo_item_w := 'R';

	begin
	select	a.ie_tipo_protocolo,
		b.ie_status ie_status_conta,
		a.ie_situacao,
		c.ie_status ie_status_item,
		a.dt_mes_competencia,
		CASE WHEN coalesce(d.nr_seq_esquema_prov,0)=0 THEN c.cd_conta_provisao_deb  ELSE d.cd_conta_prov_deb END  cd_conta_debito,
		CASE WHEN coalesce(d.nr_seq_esquema_prov,0)=0 THEN c.cd_conta_provisao_cred  ELSE d.cd_conta_prov_cred END  cd_conta_credito,
		d.ie_situacao,
		d.ie_tipo_item
	into STRICT	ie_tipo_protocolo_w,
		ie_status_conta_w,
		ie_situacao_prot_w,
		ie_status_item_w,
		dt_mes_competencia_w,
		cd_conta_provisao_deb_w,
		cd_conta_provisao_cred_w,
		ie_situacao_resumo_w,
		ie_tipo_item_resumo_w
	from	pls_protocolo_conta a,
		pls_conta b,
		pls_conta_mat c,
		pls_conta_medica_resumo d
	where	b.nr_sequencia = nr_seq_conta_p
	and	c.nr_sequencia = nr_seq_conta_mat_p
	and	d.nr_sequencia = nr_seq_conta_resumo_p
	and	c.nr_seq_conta = b.nr_sequencia
	and	b.nr_seq_protocolo = a.nr_sequencia
	and	d.nr_seq_conta = b.nr_sequencia
	and	d.nr_seq_conta_mat = c.nr_sequencia;
	exception when others then
		vl_retorno_w := substr(vl_retorno_w || obter_desc_expressao(968731), 1, 4000);
		return	vl_retorno_w;
	end;
end if;

if (ie_tipo_item_w in ('P', 'M')) then
	if (ie_tipo_protocolo_w not in ('C', 'F')) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressaO(968737), 1, 4000);
	end if;

	if (ie_status_conta_w in ('C', 'U')) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968739), 1, 4000);
	end if;

	if (ie_situacao_prot_w in ('RE', 'I')) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968741), 1, 4000);
	end if;

	if (ie_status_item_w in ('D', 'M')) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968743), 1, 4000);
	end if;

	if (dt_mes_competencia_w not between trunc(dt_referencia_lote_w, 'MONTH') and fim_dia(dt_referencia_lote_w)) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968745), 1, 4000);
	end if;

	if (coalesce(cd_conta_provisao_cred_w::text, '') = '') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968747), 1, 4000);
	end if;

	if (coalesce(cd_conta_provisao_deb_w::text, '') = '') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968749), 1, 4000);
	end if;

	if (vl_provisao_w = 0 and vl_liberado_w = 0) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968751), 1, 4000);
	end if;

	if (cd_estabelecimento_w <> cd_estabelecimento_lote_w) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968753), 1, 4000);
	end if;

elsif (ie_tipo_item_w = 'R') then
	if (ie_tipo_protocolo_w <> 'C') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968755), 1, 4000);
	end if;

	if (ie_status_conta_w <> 'F') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968757), 1, 4000);
	end if;

	if (ie_situacao_prot_w in ('RE', 'I')) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968741), 1, 4000);
	end if;

	if (ie_status_item_w in ('D', 'M')) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968743), 1, 4000);
	end if;

	if (ie_tipo_item_resumo_w = 'I') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968761), 1, 4000);
	end if;

	if (dt_mes_competencia_w not between trunc(dt_referencia_lote_w, 'MONTH') and fim_dia(dt_referencia_lote_w)) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968745), 1, 4000);
	end if;

	if (coalesce(cd_conta_provisao_cred_w::text, '') = '') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968747), 1, 4000);
	end if;

	if (coalesce(cd_conta_provisao_deb_w::text, '') = '') then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968749), 1, 4000);
	end if;

	if (cd_estabelecimento_w <> cd_estabelecimento_lote_w) then
		vl_retorno_w := substr(vl_retorno_w || ' ' || obter_desc_expressao(968753), 1, 4000);
	end if;
end if;

if (coalesce(length(vl_retorno_w), 0) = 0) then
  	vl_retorno_w := obter_desc_expressao(968763);
end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_mot_nao_contab_prov_prod ( nr_seq_conta_p bigint, nr_seq_conta_proc_p bigint, nr_seq_conta_mat_p bigint, nr_seq_conta_resumo_p bigint, nr_lote_contabil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

