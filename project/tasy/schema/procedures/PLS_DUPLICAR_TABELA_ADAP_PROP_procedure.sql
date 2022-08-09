-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_duplicar_tabela_adap_prop ( nr_seq_plano_prop_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		bigint;
nr_seq_plano_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_tabela_nova_w		bigint;

nm_tabela_w			varchar(255);
dt_inicio_vigencia_w		timestamp;
ie_preco_vidas_contrato_w	varchar(10);
ie_calculo_vidas_w		varchar(10);

nr_seq_preco_w			bigint;
qt_idade_inicial_w		integer;
qt_idade_final_w		integer;
vl_preco_atual_w		double precision;
nr_seq_preco_novo_w		bigint;
ie_grau_titularidade_w		varchar(2);
qt_vidas_inicial_w		bigint;
qt_vidas_final_w		bigint;

qt_titulares_w			bigint;
nr_seq_tabela_prop_w		bigint;
nr_seq_tabela_prop_nova_w	bigint;
nr_seq_faixa_etaria_w		bigint;

C01 CURSOR FOR
	SELECT	distinct b.nr_seq_tabela
	from	pls_plano		c,
		pls_segurado		b,
		pls_contrato		a
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	c.ie_regulamentacao	= 'R'
	and	coalesce(b.dt_rescisao::text, '') = ''
	and	a.nr_sequencia		= nr_seq_contrato_w;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		qt_idade_inicial,
		qt_idade_final,
		vl_preco_atual,
		ie_grau_titularidade,
		qt_vidas_inicial,
		qt_vidas_final
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_w
	order by qt_idade_inicial;


BEGIN
/*Produto e contrato*/

select	b.nr_sequencia,
	c.nr_seq_plano
into STRICT	nr_seq_contrato_w,
	nr_seq_plano_w
from	pls_proposta_adesao	a,
	pls_contrato		b,
	pls_proposta_plano	c
where	a.nr_seq_contrato	= b.nr_contrato
and	a.nr_sequencia		= c.nr_seq_proposta
and	c.nr_sequencia		= nr_seq_plano_prop_p;

/*Tabelas dos beneficiários do contrato*/

open C01;
loop
fetch C01 into
	nr_seq_tabela_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('pls_tabela_preco_seq')
	into STRICT	nr_seq_tabela_nova_w
	;

	select	nm_tabela,
		dt_inicio_vigencia,
		ie_preco_vidas_contrato,
		ie_calculo_vidas,
		nr_seq_faixa_etaria
	into STRICT	nm_tabela_w,
		dt_inicio_vigencia_w,
		ie_preco_vidas_contrato_w,
		ie_calculo_vidas_w,
		nr_seq_faixa_etaria_w
	from	pls_tabela_preco
	where	nr_sequencia	= nr_seq_tabela_w;

	/*Insere a tabela duplicada*/

	insert into pls_tabela_preco(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nm_tabela,
		dt_inicio_vigencia,
		nr_seq_plano,
		ie_tabela_base,
		ie_preco_vidas_contrato,
		ie_calculo_vidas,
		ie_proposta_adesao,
		dt_liberacao,
		nr_seq_tabela_ant,
		nr_seq_faixa_etaria)
	values (nr_seq_tabela_nova_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		'Cópia de '|| nm_tabela_w ||' para adaptação',
		dt_inicio_vigencia_w,
		nr_seq_plano_w,
		'N',
		ie_preco_vidas_contrato_w,
		ie_calculo_vidas_w,
		'S',
		clock_timestamp(),
		nr_seq_tabela_w,
		nr_seq_faixa_etaria_w);

	/*Faixa de preço e valores*/

	open C02;
	loop
	fetch C02 into
		nr_seq_preco_w,
		qt_idade_inicial_w,
		qt_idade_final_w,
		vl_preco_atual_w,
		ie_grau_titularidade_w,
		qt_vidas_inicial_w,
		qt_vidas_final_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */

		select	nextval('pls_plano_preco_seq')
		into STRICT	nr_seq_preco_novo_w
		;

		insert into pls_plano_preco(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_tabela,
			qt_idade_inicial,
			qt_idade_final,
			vl_preco_inicial,
			vl_preco_atual,
			tx_acrescimo,
			ie_grau_titularidade,
			qt_vidas_inicial,
			qt_vidas_final)
		values (nr_seq_preco_novo_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_tabela_nova_w,
			qt_idade_inicial_w,
			qt_idade_final_w,
			vl_preco_atual_w,
			vl_preco_atual_w,
			0,
			ie_grau_titularidade_w,
			qt_vidas_inicial_w,
			qt_vidas_final_w);
	end loop;
	close C02;
	end;
end loop;
close C01;

/*Obter a quantidade de titulares*/

select	count(1)
into STRICT	qt_titulares_w
from	pls_segurado
where	nr_seq_contrato	= nr_seq_contrato_w
and	coalesce(dt_rescisao::text, '') = ''
and	coalesce(nr_seq_titular::text, '') = ''  LIMIT 2;

/*Quando o contrato possuir apenas um titular, a tabela de preços do mesmo será diretamente vinculada à proposta.
    E quando houverem mais titulares, é utilizada a tabela do contrato*/
if (qt_titulares_w = 1) then
	select	max(b.nr_seq_tabela)
	into STRICT	nr_seq_tabela_prop_w
	from	pls_plano		c,
		pls_segurado		b,
		pls_contrato		a
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	c.ie_regulamentacao	= 'R'
	and	coalesce(b.dt_rescisao::text, '') = ''
	and	coalesce(b.nr_seq_titular::text, '') = ''
	and	a.nr_sequencia		= nr_seq_contrato_w;
else
	select	max(b.nr_seq_tabela)
	into STRICT	nr_seq_tabela_prop_w
	from	pls_plano		c,
		pls_contrato_plano	b,
		pls_contrato		a
	where	b.nr_seq_contrato	= a.nr_sequencia
	and	b.nr_seq_plano		= c.nr_sequencia
	and	c.ie_regulamentacao	= 'R'
	and	a.nr_sequencia		= nr_seq_contrato_w;
end if;

/*Busca a tabela duplicada*/

select	max(nr_sequencia)
into STRICT	nr_seq_tabela_prop_nova_w
from	pls_tabela_preco
where	nr_seq_tabela_ant = nr_seq_tabela_prop_w
and	nr_seq_plano	  = nr_seq_plano_w;

/*Insere a tabela na proposta*/

update	pls_proposta_plano
set	nr_seq_tabela	= nr_seq_tabela_prop_nova_w
where	nr_sequencia	= nr_seq_plano_prop_p;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_tabela_adap_prop ( nr_seq_plano_prop_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;
