-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_cd_oper_emp_contr ( nr_seq_contrato_p bigint, cd_operadora_empresa_p text, cd_operadora_empresa_atual_p text, ie_gerar_cartao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_titular_w		pls_segurado.nr_sequencia%type;
dt_contratacao_w		pls_segurado.dt_contratacao%type;
dt_contrato_w			pls_contrato.dt_contrato%type;
dt_validade_w			pls_segurado_carteira.dt_validade_carteira%type;
dt_inicio_vig_cart_w		timestamp;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_seq_titular, 
		a.dt_contratacao, 
		b.dt_contrato 
	from	pls_segurado a, 
		pls_contrato b 
	where	a.nr_seq_contrato = b.nr_sequencia 
	and	b.nr_sequencia = nr_seq_contrato_p 
	and	((a.cd_operadora_empresa = cd_operadora_empresa_atual_p) or (coalesce(a.cd_operadora_empresa::text, '') = ''));


BEGIN 
update	pls_contrato 
set	cd_operadora_empresa	= CASE WHEN cd_operadora_empresa_p='' THEN null  ELSE (cd_operadora_empresa_p)::numeric  END  
where	nr_sequencia		= nr_seq_contrato_p;
 
insert	into	pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, 
			dt_historico, ie_tipo_historico, dt_atualizacao, 
			nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
			ds_historico,ds_observacao) 
		values (	nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p, 
			clock_timestamp(), '67', clock_timestamp(), 
			nm_usuario_p, clock_timestamp(), nm_usuario_p, 
			'Operadora empresa alterada de: ' || coalesce(cd_operadora_empresa_atual_p,'') || '. Para: ' || cd_operadora_empresa_p, 
			'pls_alterar_cd_oper_emp_contr');
 
open C01;
loop 
fetch C01 into 
	nr_seq_segurado_w, 
	nr_seq_titular_w, 
	dt_contratacao_w, 
	dt_contrato_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	update	pls_segurado 
	set	cd_operadora_empresa	= cd_operadora_empresa_p 
	where	nr_sequencia		= nr_seq_segurado_w;
	 
	CALL pls_gerar_segurado_historico(	nr_seq_segurado_w, '67', clock_timestamp(), 'Operadora empresa alterada de: ' || coalesce(cd_operadora_empresa_atual_p,'') || '. Para: ' || cd_operadora_empresa_p, 
					'pls_alterar_cd_oper_emp_contr', null, null, null, 
					null, null, null, null, 
					null, null, null, null, 
					nm_usuario_p, 'N');				
	 
	if (coalesce(ie_gerar_cartao_p,'S') = 'S') then 
		select	max(dt_validade_carteira), 
			max(dt_inicio_vigencia) 
		into STRICT	dt_validade_w, 
			dt_inicio_vig_cart_w 
		from	pls_segurado_carteira 
		where	nr_seq_segurado	= nr_seq_segurado_w;
		 
		CALL pls_gerar_carteira_usuario(nr_seq_segurado_w, nr_seq_titular_w, dt_inicio_vig_cart_w, dt_validade_w, 'P', 'ME',null, nm_usuario_p);
	end if;
	 
	end;
end loop;
close C01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_cd_oper_emp_contr ( nr_seq_contrato_p bigint, cd_operadora_empresa_p text, cd_operadora_empresa_atual_p text, ie_gerar_cartao_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
