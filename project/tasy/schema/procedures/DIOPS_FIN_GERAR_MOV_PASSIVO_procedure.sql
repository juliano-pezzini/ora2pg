-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE diops_fin_gerar_mov_passivo ( nr_seq_operadora_p bigint, nr_seq_transacao_p bigint, nr_seq_periodo_p bigint, ie_parametro_p text, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gerar as informações de valores do passivo conforme as regras de o período 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
	PLS_GERAR_DIOPS_FINANCEIRO 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
ds_conta_w			varchar(255);
ds_desc_conta_w			varchar(255);
cd_conta_contabil_w		varchar(20);
ie_acao_conta_w			varchar(2)	:= 'SO';
ie_parametro_w			varchar(1);
ie_normal_encerramento_w	varchar(1);
vl_saldo_ant_w			double precision	:= 0;
vl_debito_w			double precision	:= 0;
vl_credito_w			double precision	:= 0;
vl_saldo_w			double precision	:= 0;
cd_estabelecimento_w		smallint;
dt_periodo_inicial_w		timestamp;
dt_periodo_final_w		timestamp;
cd_empresa_w			empresa.cd_empresa%type;

C01 CURSOR FOR 
	SELECT	a.ds_conta, 
		b.cd_conta_contabil, 
		CASE WHEN d.dt_referencia=dt_periodo_inicial_w THEN  c.vl_saldo_ant  ELSE 0 END , 
		c.vl_debito, 
		c.vl_credito, 
		CASE WHEN trunc(d.dt_referencia, 'month')=trunc(dt_periodo_final_w, 'month') THEN  c.vl_saldo  ELSE 0 END , 
		a.ds_desc_conta, 
		coalesce(b.ie_acao_conta, 'SO') 
	from	ctb_mes_ref			d, 
		ctb_balancete_v			c, 
		diops_trans_conta_contab	b, 
		diops_trans_conta		a 
	where	a.nr_sequencia			= b.nr_seq_trans_conta 
	and	b.cd_conta_contabil		= c.cd_conta_contabil 
	and	c.nr_seq_mes_ref		= d.nr_sequencia 
	and	a.nr_seq_transacao		= nr_seq_transacao_p 
	and	c.ie_normal_encerramento	= ie_normal_encerramento_w --'N' 
/*	and	c.ie_tipo_conta			= 'P' */
 
	and	a.ie_tipo_conta			= 'C' 
	and	a.ie_plano_conta		= 'P' 
	and	d.dt_referencia between dt_periodo_inicial_w and dt_periodo_final_w 
	and	exists (	SELECT	1 
			from	empresa z, 
				estabelecimento y, 
				diops_estab_adicional x 
			where	x.cd_estabelecimento = a.cd_estabelecimento 
			and	x.cd_estabelecimento = y.cd_estabelecimento 
			and	y.cd_empresa = z.cd_empresa 
			and	z.cd_empresa = cd_empresa_w 
			
union all
 
			select	1 
			 
			where	a.cd_estabelecimento = cd_estabelecimento_w) 
	and	((exists (select	1 
			from	empresa z, 
				estabelecimento y, 
				diops_estab_adicional x 
			where	x.cd_estabelecimento = c.cd_estabelecimento 
			and	x.cd_estabelecimento = y.cd_estabelecimento 
			and	y.cd_empresa = z.cd_empresa 
			and	z.cd_empresa = cd_empresa_w 
			
union all
 
			select	1 
			 
			where	c.cd_estabelecimento = cd_estabelecimento_w)) or (exists (select	1 
												from	empresa z, 
													estabelecimento y, 
													diops_estab_adicional x 
												where	x.cd_estabelecimento = obter_estab_financeiro(c.cd_estabelecimento) 
												and	x.cd_estabelecimento = y.cd_estabelecimento 
												and	y.cd_empresa = z.cd_empresa 
												and	z.cd_empresa = cd_empresa_w 
												
union all
 
												select	1 
												 
												where	obter_estab_financeiro(c.cd_estabelecimento) = cd_estabelecimento_w))) 
	
union all
 
	select	a.ds_conta, 
		b.cd_conta_contabil, 
		0, 
		0, 
		0, 
		0, 
		a.ds_desc_conta, 
		coalesce(b.ie_acao_conta, 'SO') 
	from	diops_trans_conta_contab	b, 
		diops_trans_conta		a 
	where	a.nr_sequencia		= b.nr_seq_trans_conta 
	and	a.nr_seq_transacao	= nr_seq_transacao_p 
	and	a.ie_tipo_conta		= 'C' 
	and	a.ie_plano_conta	= 'P' 
	and	exists (	select	1 
			from	empresa z, 
				estabelecimento y, 
				diops_estab_adicional x 
			where	x.cd_estabelecimento = a.cd_estabelecimento 
			and	x.cd_estabelecimento = y.cd_estabelecimento 
			and	y.cd_empresa = z.cd_empresa 
			and	z.cd_empresa = cd_empresa_w 
			
union all
 
			select	1 
			 
			where	a.cd_estabelecimento = cd_estabelecimento_w) 
	order by 
		ds_conta, 
		cd_conta_contabil;
		
C02 CURSOR FOR 
	SELECT	a.ds_conta, 
		a.ds_desc_conta, 
		coalesce(sum(a.vl_saldo_anterior), 0), 
		coalesce(sum(a.vl_debitos), 0), 
		coalesce(sum(a.vl_creditos), 0), 
		coalesce(sum(a.vl_saldo_final), 0) 
	from	w_diops_fin_mov_passivo	a 
	where	a.nr_seq_periodo	= nr_seq_periodo_p 
	group by 
		a.ds_conta, 
		a.ds_desc_conta;			
		 

BEGIN 
/* Obter o período trimestral do DIOPS */
 
begin 
select	coalesce(a.dt_periodo_inicial, ''), 
	coalesce(a.dt_periodo_final, ''), 
	a.cd_estabelecimento, 
	coalesce(a.ie_normal_encerramento, 'N') 
into STRICT	dt_periodo_inicial_w, 
	dt_periodo_final_w, 
	cd_estabelecimento_w, 
	ie_normal_encerramento_w 
from	diops_periodo	a 
where	a.nr_sequencia	= nr_seq_periodo_p;
exception 
when others then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(174234,'NR_SEQ_OPERADORA=' || nr_seq_operadora_p || ';' || 
							'NR_SEQ_PERIODO=' || nr_seq_periodo_p);
end;
 
select	b.cd_empresa 
into STRICT	cd_empresa_w 
from	empresa b, 
	estabelecimento a 
where	b.cd_empresa = a.cd_empresa 
and	a.cd_estabelecimento = cd_estabelecimento_w;
 
open C01;
loop 
fetch C01 into	 
	ds_conta_w, 
	cd_conta_contabil_w, 
	vl_saldo_ant_w, 
	vl_debito_w, 
	vl_credito_w, 
	vl_saldo_w, 
	ds_desc_conta_w, 
	ie_acao_conta_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	if (ie_parametro_p = 'N') and (vl_saldo_ant_w = 0) and (vl_debito_w = 0) and (vl_credito_w = 0) and (vl_saldo_w = 0) then 
		null;
	else	 
		if (ie_acao_conta_w	= 'SB') then 
			vl_saldo_ant_w	:= (vl_saldo_ant_w * -1);
			vl_debito_w	:= (vl_debito_w * -1);
			vl_credito_w	:= (vl_credito_w * -1);
			vl_saldo_w	:= (vl_saldo_w * -1);
		end if;
		 
		insert into w_diops_fin_mov_passivo(nr_sequencia, 
			nr_seq_operadora, 
			nr_seq_transacao, 
			ds_conta, 
			vl_saldo_anterior, 
			vl_debitos, 
			vl_creditos, 
			vl_saldo_final, 
			cd_conta_contabil, 
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_periodo, 
			ds_desc_conta) 
		values (nextval('w_diops_fin_mov_passivo_seq'), 
			nr_seq_operadora_p, 
			nr_seq_transacao_p, 
			ds_conta_w, 
			vl_saldo_ant_w, 
			vl_debito_w, 
			vl_credito_w, 
			vl_saldo_w, 
			cd_conta_contabil_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_periodo_p, 
			ds_desc_conta_w);
	end if;		
	end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into	 
	ds_conta_w, 
	ds_desc_conta_w, 
	vl_saldo_ant_w, 
	vl_debito_w, 
	vl_credito_w, 
	vl_saldo_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	if (ie_parametro_p = 'N') and (vl_saldo_ant_w = 0) and (vl_debito_w = 0) and (vl_credito_w = 0) and (vl_saldo_w = 0) then 
		null;
	else	 
		insert into diops_fin_mov_passivo(nr_sequencia, 
			cd_estabelecimento, 
			nr_seq_periodo, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ds_conta, 
			vl_saldo_anterior, 
			vl_debitos, 
			vl_creditos, 
			vl_saldo_final, 
			ds_desc_conta, 
			nr_seq_operadora) 
		values (nextval('diops_fin_mov_passivo_seq'), 
			cd_estabelecimento_w, 
			nr_seq_periodo_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			ds_conta_w, 
			vl_saldo_ant_w, 
			vl_debito_w, 
			vl_credito_w, 
			vl_saldo_w, 
			ds_desc_conta_w, 
			nr_seq_operadora_p);
	end if;		
	end;
end loop;
close C02;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE diops_fin_gerar_mov_passivo ( nr_seq_operadora_p bigint, nr_seq_transacao_p bigint, nr_seq_periodo_p bigint, ie_parametro_p text, nm_usuario_p text) FROM PUBLIC;

