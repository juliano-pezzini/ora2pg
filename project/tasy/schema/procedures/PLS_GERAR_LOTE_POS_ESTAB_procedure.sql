-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_pos_estab ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ie_forma_pagamento_w		pls_parametro_pagamento.ie_forma_pagamento%type;
nr_seq_regra_w			pls_regra_lib_pos_estab.nr_sequencia%type;
dt_competencia_w		pls_lote_pos_estabelecido.dt_competencia%type;
ie_periodo_w			pls_regra_pos_estab_item.ie_periodo%type;
ie_tipo_cobranca_w		pls_regra_pos_estab_item.ie_tipo_cobranca%type;
dt_referencia_regra_w		timestamp;
dt_atendimento_ref_regra_w	timestamp;
ie_proc_mat_w			varchar(1);
nr_seq_conta_pos_estab_w	pls_conta_pos_estabelecido.nr_sequencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_analise_w		pls_conta.nr_seq_analise%type;
nr_seq_regra_pos_estab_w	pls_conta_pos_estabelecido.nr_seq_regra_pos_estab%type;
nr_seq_pos_estab_interc_w	pls_conta_pos_estabelecido.nr_seq_pos_estab_interc%type;
nr_seq_prestador_exec_w		pls_conta.nr_seq_prestador_exec%type;
nr_seq_prestador_atend_w	pls_conta.nr_seq_prestador%type;
qt_item_w			pls_conta_pos_estabelecido.qt_item%type;
vl_beneficiario_w		pls_conta_pos_estabelecido.vl_beneficiario%type;
vl_liberado_w			pls_conta_proc.vl_liberado%type;
cd_procedimento_w		pls_conta_proc.cd_procedimento%type;
ie_origem_proced_w		pls_conta_proc.ie_origem_proced%type;
nr_seq_material_w		pls_conta_mat.nr_seq_material%type;
dt_atendimento_referencia_w	pls_conta.dt_atendimento_referencia%type;
dt_mes_competencia_w		pls_protocolo_conta.dt_mes_competencia%type;
ds_item_w			varchar(255);
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
nr_contrato_w			pls_contrato.nr_contrato%type;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
nr_seq_pagador_w		pls_contrato_pagador.nr_sequencia%type;
qt_registro_w			integer;
nr_seq_conta_co_w		pls_conta_co.nr_sequencia%type;
nr_dia_max_w			pls_regra_pos_estab_item.nr_dia_max%type;

C01 CURSOR FOR 
	SELECT	'P' ie_proc_mat, 
		a.nr_sequencia nr_seq_conta_pos_estab, 
		null nr_seq_conta_co, 
		b.nr_sequencia nr_seq_conta, 
		b.nr_seq_segurado, 
		b.nr_seq_analise, 
		a.nr_seq_regra_pos_estab, 
		a.nr_seq_pos_estab_interc, 
		b.nr_seq_prestador_exec, 
		b.nr_seq_prestador, 
		a.qt_item, 
		a.vl_beneficiario, 
		coalesce(c.vl_liberado,0), 
		c.cd_procedimento, 
		c.ie_origem_proced, 
		null, 
		b.dt_atendimento_referencia, 
		d.dt_mes_competencia 
	from	pls_conta_proc			c, 
		pls_conta			b, 
		pls_conta_pos_estabelecido	a, 
		pls_protocolo_conta		d 
	where	c.nr_sequencia	= a.nr_seq_conta_proc 
	and	b.nr_sequencia	= c.nr_seq_conta 
	and	d.nr_sequencia	= b.nr_seq_protocolo 
	and	coalesce(a.nr_seq_mensalidade_seg::text, '') = '' 
	and	coalesce(a.ie_cobrar_mensalidade,'P') = 'P' -- Pendente de liberação 
	and	(((ie_forma_pagamento_w = 'P') and (d.ie_status in ('3','6') )) or 
		(ie_forma_pagamento_w = 'C' AND b.ie_status = 'F')) 
	and	coalesce(d.ie_tipo_protocolo,'C') in ('C','I') 
	and	a.ie_tipo_segurado in ('B','A','R') 
	and	d.dt_mes_competencia <= dt_referencia_regra_w 
	and	((b.dt_atendimento_referencia <= dt_atendimento_ref_regra_w) or (coalesce(nr_dia_max_w,0) = 0)) 
	and	ie_tipo_cobranca_w in ('P','A') 
	and	b.cd_estabelecimento	= cd_estabelecimento_p 
	
union all
 
	SELECT	'M' ie_proc_mat, 
		a.nr_sequencia nr_seq_conta_pos_estab, 
		null nr_seq_conta_co, 
		b.nr_sequencia nr_seq_conta, 
		b.nr_seq_segurado, 
		b.nr_seq_analise, 
		a.nr_seq_regra_pos_estab, 
		a.nr_seq_pos_estab_interc, 
		b.nr_seq_prestador_exec, 
		b.nr_seq_prestador, 
		a.qt_item, 
		a.vl_beneficiario, 
		coalesce(c.vl_liberado,0), 
		null, 
		null, 
		c.nr_seq_material, 
		b.dt_atendimento_referencia, 
		d.dt_mes_competencia 
	from	pls_conta_mat			c, 
		pls_conta			b, 
		pls_conta_pos_estabelecido	a, 
		pls_protocolo_conta		d 
	where	c.nr_sequencia	= a.nr_seq_conta_mat 
	and	b.nr_sequencia	= c.nr_seq_conta 
	and	d.nr_sequencia	= b.nr_seq_protocolo 
	and	coalesce(a.nr_seq_mensalidade_seg::text, '') = '' 
	and	coalesce(a.ie_cobrar_mensalidade,'P') = 'P' -- Pendente de liberação 
	and	(((ie_forma_pagamento_w = 'P') and (d.ie_status in ('3','6') )) or 
		(ie_forma_pagamento_w = 'C' AND b.ie_status = 'F')) 
	and	coalesce(d.ie_tipo_protocolo,'C') in ('C','I') 
	and	a.ie_tipo_segurado in ('B','A','R') 
	and	d.dt_mes_competencia <= dt_referencia_regra_w 
	and	((b.dt_atendimento_referencia <= dt_atendimento_ref_regra_w) or (coalesce(nr_dia_max_w,0) = 0)) 
	and	ie_tipo_cobranca_w in ('P','A') 
	and	b.cd_estabelecimento	= cd_estabelecimento_p 
	
union all
 
	select	'P' ie_proc_mat, 
		null nr_seq_conta_pos_estab, 
		a.nr_sequencia nr_seq_conta_co, 
		b.nr_sequencia nr_seq_conta, 
		b.nr_seq_segurado, 
		b.nr_seq_analise, 
		null nr_seq_regra_pos_estab, 
		null nr_seq_pos_estab_interc, 
		b.nr_seq_prestador_exec, 
		b.nr_seq_prestador, 
		c.qt_procedimento qt_item, 
		a.vl_beneficiario, 
		coalesce(c.vl_liberado,0), 
		c.cd_procedimento, 
		c.ie_origem_proced, 
		null, 
		b.dt_atendimento_referencia, 
		d.dt_mes_competencia 
	from	pls_conta_proc			c, 
		pls_conta			b, 
		pls_conta_co			a, 
		pls_protocolo_conta		d 
	where	c.nr_sequencia	= a.nr_seq_conta_proc 
	and	b.nr_sequencia	= c.nr_seq_conta 
	and	d.nr_sequencia	= b.nr_seq_protocolo 
	and	coalesce(a.nr_seq_mensalidade_seg::text, '') = '' 
	and	coalesce(a.ie_cobrar_mensalidade,'P') = 'P' -- Pendente de liberação 
	and	(((ie_forma_pagamento_w = 'P') and (d.ie_status in ('3','6') )) or 
		(ie_forma_pagamento_w = 'C' AND b.ie_status = 'F')) 
	and	coalesce(d.ie_tipo_protocolo,'C') in ('C','I') 
	and	a.ie_tipo_segurado in ('B','A','R') 
	and	d.dt_mes_competencia <= dt_referencia_regra_w 
	and	((b.dt_atendimento_referencia <= dt_atendimento_ref_regra_w) or (coalesce(nr_dia_max_w,0) = 0)) 
	and	ie_tipo_cobranca_w in ('C','A') 
	and	b.cd_estabelecimento	= cd_estabelecimento_p 
	
union all
 
	select	'M' ie_proc_mat, 
		null nr_seq_conta_pos_estab, 
		a.nr_sequencia nr_seq_conta_co, 
		b.nr_sequencia nr_seq_conta, 
		b.nr_seq_segurado, 
		b.nr_seq_analise, 
		null nr_seq_regra_pos_estab, 
		null nr_seq_pos_estab_interc, 
		b.nr_seq_prestador_exec, 
		b.nr_seq_prestador, 
		c.qt_material qt_item, 
		a.vl_beneficiario, 
		coalesce(c.vl_liberado,0), 
		null, 
		null, 
		c.nr_seq_material, 
		b.dt_atendimento_referencia, 
		d.dt_mes_competencia 
	from	pls_conta_mat			c, 
		pls_conta			b, 
		pls_conta_co			a, 
		pls_protocolo_conta		d 
	where	c.nr_sequencia	= a.nr_seq_conta_mat 
	and	b.nr_sequencia	= c.nr_seq_conta 
	and	d.nr_sequencia	= b.nr_seq_protocolo 
	and	coalesce(a.nr_seq_mensalidade_seg::text, '') = '' 
	and	coalesce(a.ie_cobrar_mensalidade,'P') = 'P' -- Pendente de liberação 
	and	(((ie_forma_pagamento_w = 'P') and (d.ie_status in ('3','6') )) or 
		(ie_forma_pagamento_w = 'C' AND b.ie_status = 'F')) 
	and	coalesce(d.ie_tipo_protocolo,'C') in ('C','I') 
	and	a.ie_tipo_segurado in ('B','A','R') 
	and	d.dt_mes_competencia <= dt_referencia_regra_w 
	and	((b.dt_atendimento_referencia <= dt_atendimento_ref_regra_w) or (coalesce(nr_dia_max_w,0) = 0)) 
	and	ie_tipo_cobranca_w in ('C','A') 
	and	b.cd_estabelecimento	= cd_estabelecimento_p;


BEGIN 
select	max(ie_forma_pagamento) 
into STRICT	ie_forma_pagamento_w 
from	pls_parametro_pagamento 
where	cd_estabelecimento	= cd_estabelecimento_p;
ie_forma_pagamento_w	:= coalesce(ie_forma_pagamento_w,'P');
 
select	nr_seq_regra, 
	dt_competencia 
into STRICT	nr_seq_regra_w, 
	dt_competencia_w 
from	pls_lote_pos_estabelecido 
where	nr_sequencia	= nr_seq_lote_p;
 
select	max(ie_periodo), 
	max(ie_tipo_cobranca), 
	max(nr_dia_max) 
into STRICT	ie_periodo_w, 
	ie_tipo_cobranca_w, 
	nr_dia_max_w 
from	pls_regra_pos_estab_item 
where	nr_seq_regra	= nr_seq_regra_w;
 
if (ie_periodo_w = '1') then /* Considerar protocolos com a competência até o mês de competência do lote */
 
	dt_referencia_regra_w	:= fim_dia(last_day(dt_competencia_w));
	 
	if (coalesce(nr_dia_max_w,0) != 0) then 
	dt_atendimento_ref_regra_w	:= fim_dia(to_date(to_char(nr_dia_max_w) || '/' || to_char(dt_competencia_w, 'mm/yyyy')));
	end if;
	 
elsif (ie_periodo_w = '2') then /* Considerar protocolos com a competência até o mês anterior de competência do lote */
 
	dt_referencia_regra_w	:= fim_dia(last_day(add_months(dt_competencia_w,-1)));
	 
	if (coalesce(nr_dia_max_w,0) != 0) then 
	dt_atendimento_ref_regra_w	:= fim_dia(add_months(to_date(to_char(nr_dia_max_w) || '/' || to_char(dt_competencia_w, 'mm/yyyy')),-1));
	end if;
end if;
 
open C01;
loop 
fetch C01 into	 
	ie_proc_mat_w, 
	nr_seq_conta_pos_estab_w, 
	nr_seq_conta_co_w, 
	nr_seq_conta_w, 
	nr_seq_segurado_w, 
	nr_seq_analise_w, 
	nr_seq_regra_pos_estab_w, 
	nr_seq_pos_estab_interc_w, 
	nr_seq_prestador_exec_w, 
	nr_seq_prestador_atend_w, 
	qt_item_w, 
	vl_beneficiario_w, 
	vl_liberado_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	nr_seq_material_w, 
	dt_atendimento_referencia_w, 
	dt_mes_competencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	select	count(1) 
	into STRICT	qt_registro_w 
	from	pls_lib_pos_estabelecido 
	where	nr_seq_conta_pos_estab	= nr_seq_conta_pos_estab_w;
	 
	if (qt_registro_w = 0) then 
		if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then 
			ds_item_w	:= substr(pls_obter_desc_material(nr_seq_material_w),1,255);
		elsif (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then 
			ds_item_w	:= substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,255);
		end if;
		 
		begin 
		select	nr_seq_contrato, 
			nr_seq_intercambio, 
			nr_seq_pagador 
		into STRICT	nr_seq_contrato_w, 
			nr_seq_intercambio_w, 
			nr_seq_pagador_w 
		from	pls_segurado 
		where	nr_sequencia	= nr_seq_segurado_w;
		exception 
		when others then 
			nr_seq_contrato_w	:= null;
			nr_seq_intercambio_w	:= null;
			nr_seq_pagador_w	:= null;
		end;
		 
		if (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then 
			select	max(nr_contrato) 
			into STRICT	nr_contrato_w 
			from	pls_contrato 
			where	nr_sequencia	= nr_seq_contrato_w;
		else 
			nr_contrato_w	:= null;
		end if;
		 
		insert	into	pls_lib_pos_estabelecido(	nr_sequencia, nr_seq_lote, nr_seq_conta, 
				nr_seq_segurado, nr_seq_conta_pos_estab, nr_seq_conta_co, dt_atualizacao, 
				nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
				cd_procedimento, ie_origem_proced, nr_seq_material, 
				nr_seq_analise, nr_seq_prestador_exec, nr_seq_prestador_atend, 
				ie_proc_mat, nr_seq_regra_pos_estab, nr_seq_pos_estab_interc, 
				qt_item, vl_beneficiario, vl_liberado, 
				ds_item, dt_mes_competencia, dt_atendimento_referencia, 
				nr_contrato, nr_seq_contrato, nr_seq_intercambio, 
				nr_seq_pagador) 
			values (	nextval('pls_lib_pos_estabelecido_seq'), nr_seq_lote_p, nr_seq_conta_w, 
				nr_seq_segurado_w, nr_seq_conta_pos_estab_w, nr_seq_conta_co_w, clock_timestamp(), 
				nm_usuario_p, clock_timestamp(), nm_usuario_p, 
				cd_procedimento_w, ie_origem_proced_w, nr_seq_material_w, 
				nr_seq_analise_w, nr_seq_prestador_exec_w, nr_seq_prestador_atend_w, 
				ie_proc_mat_w, nr_seq_regra_pos_estab_w, nr_seq_pos_estab_interc_w, 
				qt_item_w, vl_beneficiario_w, vl_liberado_w, 
				ds_item_w, dt_mes_competencia_w, dt_atendimento_referencia_w, 
				nr_contrato_w, nr_seq_contrato_w, nr_seq_intercambio_w, 
				nr_seq_pagador_w);
	end if;
	end;
end loop;
close C01;
 
select	count(1) 
into STRICT	qt_registro_w 
from	pls_lib_pos_estabelecido 
where	nr_seq_lote	= nr_seq_lote_p;
 
if (qt_registro_w > 0) then 
	update	pls_lote_pos_estabelecido 
	set	ie_status	= 'G', 
		dt_geracao	= clock_timestamp(), 
		nm_usuario_geracao = nm_usuario_p 
	where	nr_sequencia	= nr_seq_lote_p;
	 
	CALL pls_gravar_hist_lote_pos_estab(	nr_seq_lote_p, 
					'Geração do lote', 
					'N', 
					nm_usuario_p, 
					cd_estabelecimento_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_pos_estab ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

