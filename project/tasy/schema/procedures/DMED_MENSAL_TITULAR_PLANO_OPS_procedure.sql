-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dmed_mensal_titular_plano_ops ( nr_seq_dmed_p bigint, dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_cpf_p text, ie_idade_p text, ie_estrangeiro_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
	GERAR_DMED_MENSAL_OPERADORA 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
cd_pessoa_fisica_w		varchar(10);
cd_pessoa_benef_w		varchar(10);
conta_w				numeric(20);
dt_ano_calendario_w		varchar(5);
dt_liquidacao_w			timestamp;					
nr_cpf_w			varchar(14);
nr_sequencia_w			bigint;
nr_sequencia_tit_w		bigint;
nr_seq_pagador_w		bigint;
nr_seq_titular_w		bigint;
nr_titulo_w			bigint;
vl_total_w			double precision;
vl_total_mens_w			double precision;
vl_recebido_w			double precision;
vl_mensalidade_w		double precision;
vl_item_w			double precision;
contador_w			bigint	:= 0;
idade_w				bigint	:= 16;
vl_aux_w			double precision;
nr_titulo_anterior_w		bigint	:= 0;
qt_tit_nota_cred_w		bigint;
nr_seq_nota_cred_w		bigint;
dt_nascimento_w			timestamp;
nr_titulo_ant_w			bigint	:= 0;
ie_estorno_w			varchar(1)	:= 'N';
dt_ref_inicial_w		timestamp;
dt_ref_final_w			timestamp;

vl_devolucao_w			pls_mens_detalhe_ir.vl_devolucao%type;

C01 CURSOR FOR 
	SELECT 	coalesce(f.cd_pessoa_fisica, c.cd_pessoa_fisica) cd_pessoa_fisica, -- busca o pagador ou o beneficiário (caso tenha cpf) 
		d.vl_mensalidade vl_recebido,		 
		r.dt_liquidacao, 
		r.nr_titulo, 
		a.cd_pessoa_fisica cd_pessoa_benef		 
	from  titulo_receber 	r, 
		pls_contrato_pagador 	f, 
		pls_segurado  		a, 
		pessoa_fisica  	c, 
		pls_mens_detalhe_ir 	d,	 
		pls_mens_pagador_ir 	p,	 
		pls_mens_beneficiario_ir 	b	 
	where 	p.nr_seq_pagador 	= f.nr_sequencia 
	and 	a.cd_pessoa_fisica	= c.cd_pessoa_fisica 
	and	a.nr_sequencia  	= b.nr_seq_segurado 
	and 	r.nr_titulo  		= d.nr_titulo_rec 
	and 	p.nr_sequencia		= b.nr_seq_pagador_ir 
	and 	d.nr_seq_beneficiario_ir = b.nr_sequencia 
	and 	(a.cd_pessoa_fisica IS NOT NULL AND a.cd_pessoa_fisica::text <> '') 
	and	coalesce(a.nr_seq_titular::text, '') = '' 
	and 	d.vl_mensalidade > 0 
	and 	d.dt_baixa between dt_ref_inicial_w and dt_ref_final_w 
	and 	((a.cd_estabelecimento = coalesce(cd_estabelecimento_p ,a.cd_estabelecimento)) or 
		((coalesce(a.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = ''))) 
	and	((ie_cpf_p = 'AM') or 
		((ie_cpf_p = 'SC') and (coalesce(c.nr_cpf::text, '') = '') 	and (pkg_date_utils.add_month(c.dt_nascimento, ie_idade_p * 12,0) <= Fim_Mes(dt_ref_inicial_w))) or 
		((ie_cpf_p = 'CC') and (((c.nr_cpf IS NOT NULL AND c.nr_cpf::text <> '') and (pkg_date_utils.add_month(c.dt_nascimento, ie_idade_p * 12,0) <= Fim_Mes(dt_ref_inicial_w))) or (pkg_date_utils.add_month(c.dt_nascimento, ie_idade_p * 12,0) >= Fim_Mes(dt_ref_inicial_w))))) 
	and (r.ie_situacao not in ('3','5') or (r.ie_situacao = '5' and 
		exists (SELECT	1			 
			from	titulo_receber_liq k 
			where	k.nr_titulo = r.nr_titulo 
			and 	vl_recebido > 0	 
			and 	not exists (select 1 from titulo_receber_liq x where x.nr_titulo = k.nr_titulo and x.nr_seq_liq_origem = k.nr_sequencia  LIMIT 1)))) 
	
union
 
	select	coalesce(f.cd_pessoa_fisica, c.cd_pessoa_fisica) cd_pessoa_fisica, 
		d.vl_devolucao * -1 vl_recebido,		 
		d.dt_baixa dt_liquidacao, 
		e.nr_titulo nr_titulo, 
		g.cd_pessoa_fisica cd_pessoa_benef		 
	from	pls_mens_detalhe_ir 		d,	 
		pls_mens_pagador_ir 		p,	 
		pls_mens_beneficiario_ir 	b, 
		titulo_pagar 			e, 
		pls_contrato_pagador		f, 
		pls_segurado			g, 
		pessoa_fisica 			c 
	where 	d.nr_seq_beneficiario_ir = b.nr_sequencia	 
	and 	p.nr_sequencia		 = b.nr_seq_pagador_ir	 
	and	d.nr_titulo_pag 	 = e.nr_titulo 
	and	c.cd_pessoa_fisica	 = g.cd_pessoa_fisica 
	and	f.nr_sequencia		 = p.nr_seq_pagador 
	and 	(g.cd_pessoa_fisica IS NOT NULL AND g.cd_pessoa_fisica::text <> '') 
	and	d.vl_devolucao 		 > 0 
	and	coalesce(g.nr_seq_titular::text, '') = '' 
	and	b.nr_seq_segurado	 = g.nr_sequencia 
	and	d.dt_baixa between dt_ref_inicial_w and dt_ref_final_w 
	and 	((g.cd_estabelecimento = coalesce(cd_estabelecimento_p ,g.cd_estabelecimento)) or 
		((coalesce(g.cd_estabelecimento::text, '') = '') and (coalesce(cd_estabelecimento_p::text, '') = ''))) 
	and	((ie_cpf_p = 'AM') or 
		((ie_cpf_p = 'SC') and (coalesce(c.nr_cpf::text, '') = '') 	and (pkg_date_utils.add_month(c.dt_nascimento, ie_idade_p * 12,0) <= Fim_Mes(dt_ref_inicial_w))) or 
		((ie_cpf_p = 'CC') and (((c.nr_cpf IS NOT NULL AND c.nr_cpf::text <> '') and (pkg_date_utils.add_month(c.dt_nascimento, ie_idade_p * 12,0) <= Fim_Mes(dt_ref_inicial_w))) or (pkg_date_utils.add_month(c.dt_nascimento, ie_idade_p * 12,0) >= Fim_Mes(dt_ref_inicial_w))))) 
	and (e.ie_situacao not in ('3','5') or (e.ie_situacao = '5' and 
		exists (select	1			 
			from	titulo_receber_liq k 
			where	k.nr_titulo = e.nr_titulo 
			and 	vl_recebido > 0	 
			and 	not exists (select 1 from titulo_receber_liq x where x.nr_titulo = k.nr_titulo and x.nr_seq_liq_origem = k.nr_sequencia  LIMIT 1))))									 
	order by 5;


BEGIN 
dt_ref_inicial_w	:= pkg_date_utils.start_of(dt_referencia_p, 'MONTH',0);
dt_ref_final_w		:= fim_dia(fim_mes(dt_referencia_p));
 
open c01;
loop 
fetch c01 into	 
	cd_pessoa_fisica_w,		 
	vl_recebido_w,		 
	dt_liquidacao_w,	 
	nr_titulo_w,		 
	cd_pessoa_benef_w;	
EXIT WHEN NOT FOUND; /* apply on c01 */		
	begin		 
		 
	begin 
		select	nr_cpf, 
			dt_nascimento 
		into STRICT	nr_cpf_w, 
			dt_nascimento_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w;		
	exception when others then 
		nr_cpf_w := '';
		dt_nascimento_w := null;
	end;
	 
	if ((ie_cpf_p = 'CC' AND nr_cpf_w IS NOT NULL AND nr_cpf_w::text <> '') or ((ie_cpf_p = 'SC') and (coalesce(nr_cpf_w::text, '') = '')) or (ie_cpf_p = 'AM')) then 
		vl_total_w	:= vl_recebido_w;
		 
		insert into dmed_titulos_mensal(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_dmed_mensal, 
			nr_documento, 
			ie_tipo_documento, 
			cd_pessoa_titular, 
			cd_pessoa_beneficiario, 
			vl_pago, 
			dt_liquidacao, 
			ie_prestadora_ops) 
		values (nextval('dmed_titulos_mensal_seq'), 
			clock_timestamp(), 
			'Tasy11', 
			clock_timestamp(), 
			'Tasy11', 
			nr_seq_dmed_p, 
			nr_titulo_w, 
			'1', --Verificar 
			cd_pessoa_fisica_w, 
			cd_pessoa_benef_w, 
			vl_total_w, 
			dt_liquidacao_w, 
			'O');
		 
		contador_w	:= contador_w + 1;
		 
		if (contador_w mod 100 = 0) then 
			commit;
		end if;
	 
	end if;
	 
	nr_titulo_ant_w	:= nr_titulo_w;
	end;
end loop;
close c01;
 
commit;
 
CALL dmed_mensal_titulos_negociados(	nr_seq_dmed_p, 
				dt_referencia_p, 
				cd_estabelecimento_p);
 
CALL dmed_mensal_depend_titular_ops(	nr_seq_dmed_p, 
				dt_referencia_p, 
				cd_estabelecimento_p, 
				ie_cpf_p, 
				ie_idade_p, 
				ie_estrangeiro_p);
				 
CALL dmed_mensal_reembolso(	    nr_seq_dmed_p, 
				dt_referencia_p, 
				cd_estabelecimento_p, 
				ie_cpf_p, 
				ie_idade_p, 
				ie_estrangeiro_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dmed_mensal_titular_plano_ops ( nr_seq_dmed_p bigint, dt_referencia_p timestamp, cd_estabelecimento_p bigint, ie_cpf_p text, ie_idade_p text, ie_estrangeiro_p text) FROM PUBLIC;
