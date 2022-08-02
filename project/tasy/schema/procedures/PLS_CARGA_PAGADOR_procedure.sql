-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_carga_pagador ( cd_pagador_pj_p text, nr_cpf_pagador_pf_p text, cd_contrato_ant_p text, dt_dia_vencimento_p bigint, ie_tipo_pagador_p text, ie_envia_cobranca_p text, ie_endereco_boleto_p text, cd_condicao_pagamento_p bigint, nr_seq_forma_cobranca_p text, dt_primeira_mensalidade_p timestamp, ie_calc_primeira_mens_p text, ie_calculo_proporcional_p text, cd_carteira_benef_p text, cd_codigo_anterior_p text, cd_banco_p bigint, cd_agencia_bancaria_p text, ie_digito_agencia_p text, cd_conta_p text, ie_digito_conta_p text, ie_pessoa_comprovante_p text, dt_rescisao_p timestamp, dt_reativacao_p timestamp, cd_tipo_portador_p text, cd_portador_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_contrato_w		bigint;
cd_pessoa_fisica_w		varchar(10);
qt_registro_w			integer	:= 0;
ie_erro_w			varchar(1)	:= 'N';
nr_seq_conta_banco_w		bigint;
nr_seq_motivo_cancelamento_w	bigint;
ie_notificacao_w		varchar(2);
cd_tipo_portador_w		integer;
qt_tipo_portador_w		bigint;
cd_portador_w			bigint;
qt_portador_w			bigint;


BEGIN

/* Obter o número do contrato  e o nr_sequencia do motivo cancelamento */

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_contrato_w
from	pls_contrato
where	cd_cod_anterior	= cd_contrato_ant_p;

/* Obter o nr_sequencia do motivo cancelamento */

select	max(b.nr_sequencia)
into STRICT	nr_seq_motivo_cancelamento_w
from	pls_contrato		a,
	pls_motivo_cancelamento	b
where	a.nr_sequencia	= nr_seq_contrato_w
and	a.nr_seq_motivo_rescisao = b.nr_sequencia;

/* Obter o número da Agência/Conta Estab. */

select	max(nr_sequencia)
into STRICT	nr_seq_conta_banco_w
from	banco_estabelecimento
where	cd_conta = cd_conta_p;

/* Obter o ie_notificação */

select	coalesce(max(ie_notificacao),0)
into STRICT	ie_notificacao_w
from	pls_contrato_pagador	a,
	pls_contrato		b
where	a.nr_seq_contrato = b.nr_sequencia
and	b.nr_sequencia = nr_seq_contrato_w;

if (nr_seq_contrato_w	= 0) then
	ie_erro_w	:= 'S';
	CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Não foi localizado o contrato através do código anterior informado (' || cd_contrato_ant_p || ')', nm_usuario_p);
end if;

if (ie_tipo_pagador_p = '') then
	ie_erro_w	:= 'S';
	CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Tipo pagador não informado', nm_usuario_p);
end if;

if (ie_envia_cobranca_p = '') then
	ie_erro_w	:= 'S';
	CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Envia cobrança por e-mail não informada', nm_usuario_p);
end if;

if (dt_dia_vencimento_p = '') then
	ie_erro_w	:= 'S';
	CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Data do dia de vencimento não informada', nm_usuario_p);
end if;

if (ie_endereco_boleto_p = '') then
	ie_erro_w	:= 'S';
	CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Endereço de correspondência não informado', nm_usuario_p);
end if;

if (ie_calc_primeira_mens_p = '') then
	ie_erro_w	:= 'S';
	CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Forma de cálculo da primeira mensalidade não informado', nm_usuario_p);
end if;

if (cd_tipo_portador_p IS NOT NULL AND cd_tipo_portador_p::text <> '') then
	select	count(*)
	into STRICT	qt_tipo_portador_w
	from	valor_dominio
	where	vl_dominio	= cd_tipo_portador_p;

	if (qt_tipo_portador_w	> 0) then
		cd_tipo_portador_w	:= cd_tipo_portador_p;
	else
		cd_tipo_portador_w	:= null;
	end if;
end if;

if (cd_portador_p IS NOT NULL AND cd_portador_p::text <> '') then
	select	count(*)
	into STRICT	qt_portador_w
	from	portador
	where	cd_portador	= cd_portador_p;

	if (qt_portador_w	> 0) then
		cd_portador_w	:= cd_portador_p;
	else
		cd_portador_w	:= null;
	end if;
end if;

if (cd_pagador_pj_p <> '') then
	begin
	select	'N'
	into STRICT	ie_erro_w
	from	pessoa_juridica
	where	cd_cgc	= cd_pagador_pj_p;
	exception
		when others then
		ie_erro_w	:= 'S';
		CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			'Pessoa jurídica não encontrada na base (' || cd_pagador_pj_p || ')', nm_usuario_p);
	end;
elsif (nr_cpf_pagador_pf_p IS NOT NULL AND nr_cpf_pagador_pf_p::text <> '') then
	/* Se não encontrar pela carteirinha, Buscar a Pessoa Fisica pelo código da pessoa no sistema antigo do Hospital */

	begin
	select	'N',
		cd_pessoa_fisica
	into STRICT	ie_erro_w,
		cd_pessoa_fisica_w
	from	pessoa_fisica
	where	cd_sistema_ant	= cd_codigo_anterior_p;
	exception
		when others then
			/* Se não encontrar pela carteirinha e nem pelo código do sistema antigo, Buscar a Pessoa Fisica pelo CPF */

			begin
			select	'N',
				cd_pessoa_fisica
			into STRICT	ie_erro_w,
				cd_pessoa_fisica_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= nr_cpf_pagador_pf_p;
			exception
				when others then
					begin
					/* Buscar a Pessoa Fisica pelo número da carteirinha */

					select	distinct 'N',
						a.cd_pessoa_fisica
					into STRICT	ie_erro_w,
						cd_pessoa_fisica_w
					from	pessoa_fisica		a,
						pls_segurado		b,
						pls_segurado_carteira	c
					where	c.cd_usuario_plano	= cd_carteira_benef_p
					and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
					and	c.nr_seq_segurado	= b.nr_sequencia;
					exception
						when others then
						ie_erro_w	:= 'S';
						CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
							'Código da pessoa fisíca não existe não existente ou duplicado na base (' || nr_cpf_pagador_pf_p || ')', nm_usuario_p);
					end;
			end;
	end;
end if;

if (ie_erro_w	= 'N') then
	begin
	insert into w_pls_carga_pagador(nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_contrato,
		cd_cgc, cd_pessoa_fisica, ie_tipo_pagador,
		ie_envia_cobranca, nr_seq_forma_cobranca, cd_banco,
		cd_agencia_bancaria, ie_digito_agencia, cd_conta,
		ie_digito_conta, dt_dia_vencimento, ie_endereco_boleto,
		ie_calc_primeira_mens, cd_condicao_pagamento, dt_primeira_mensalidade,
		ie_calculo_proporcional, nr_seq_conta_banco, ie_pessoa_comprovante,
		dt_rescisao, nr_seq_motivo_cancelamento, ie_notificacao,
		dt_reativacao, cd_tipo_portador, cd_portador)
	values (	nextval('w_pls_carga_pagador_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, nr_seq_contrato_w,
		cd_pagador_pj_p, cd_pessoa_fisica_w, ie_tipo_pagador_p,
		ie_envia_cobranca_p, nr_seq_forma_cobranca_p, cd_banco_p,
		cd_agencia_bancaria_p, ie_digito_agencia_p, cd_conta_p,
		ie_digito_conta_p, dt_dia_vencimento_p, ie_endereco_boleto_p,
		ie_calc_primeira_mens_p, cd_condicao_pagamento_p, dt_primeira_mensalidade_p,
		ie_calculo_proporcional_p, nr_seq_conta_banco_w, ie_pessoa_comprovante_p,
		dt_rescisao_p, nr_seq_motivo_cancelamento_w, ie_notificacao_w,
		dt_reativacao_p, cd_tipo_portador_w, cd_portador_w);
	exception
		when others then
		CALL pls_carga_gravar_erro('PAG', 'PJ: ' || cd_pagador_pj_p || '; PF: ' ||  nr_cpf_pagador_pf_p,
			sqlerrm(SQLSTATE), nm_usuario_p);
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_carga_pagador ( cd_pagador_pj_p text, nr_cpf_pagador_pf_p text, cd_contrato_ant_p text, dt_dia_vencimento_p bigint, ie_tipo_pagador_p text, ie_envia_cobranca_p text, ie_endereco_boleto_p text, cd_condicao_pagamento_p bigint, nr_seq_forma_cobranca_p text, dt_primeira_mensalidade_p timestamp, ie_calc_primeira_mens_p text, ie_calculo_proporcional_p text, cd_carteira_benef_p text, cd_codigo_anterior_p text, cd_banco_p bigint, cd_agencia_bancaria_p text, ie_digito_agencia_p text, cd_conta_p text, ie_digito_conta_p text, ie_pessoa_comprovante_p text, dt_rescisao_p timestamp, dt_reativacao_p timestamp, cd_tipo_portador_p text, cd_portador_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

