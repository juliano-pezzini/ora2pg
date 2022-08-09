-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_vendedor_cliente ( nr_seq_vendedor_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_tipo_vendedor_w		varchar(2);
nr_seq_vendedor_w		bigint;
nr_seq_regra_dias_w		bigint;
qt_dias_efetivacao_w		bigint := 0;
dt_inicio_vigencia_w		timestamp;
nr_seq_cliente_w		bigint;
qt_vidas_w			bigint;
nr_seq_classificacao_w		bigint;
nr_seq_solicitacao_w		bigint;
ie_tipo_contratacao_w		varchar(2);
dt_aprovacao_w			timestamp;
nr_seq_vendedor_aux_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_vendedor_aux
	from	pls_regra_vendedor_aux
	where	nr_seq_vendedor = nr_seq_vendedor_w
	and	nr_seq_vendedor_aux <> nr_seq_vendedor_w;


BEGIN

select	nr_seq_vendedor_canal,
	dt_inicio_vigencia,
	nr_seq_cliente
into STRICT	nr_seq_vendedor_w,
	dt_inicio_vigencia_w,
	nr_seq_cliente_w
from	pls_solicitacao_vendedor
where	nr_sequencia	= nr_seq_vendedor_p;

update	pls_solicitacao_vendedor
set	dt_fim_vigencia	= clock_timestamp()
where	nr_seq_cliente	= nr_seq_cliente_w
and	nr_sequencia <> nr_seq_vendedor_p;

select	CASE WHEN coalesce(cd_pessoa_fisica::text, '') = '' THEN 'PJ'  ELSE 'PF' END
into STRICT	ie_tipo_vendedor_w
from	pls_vendedor
where	nr_sequencia	= nr_seq_vendedor_w;

select	max(coalesce(a.qt_funcionarios, 0))
into STRICT	qt_vidas_w
from	pls_solicitacao_vendedor	c,
	pls_comercial_cliente		b,
	pls_solicitacao_comercial	a
where	b.nr_seq_solicitacao = a.nr_sequencia
and	b.nr_sequencia = c.nr_seq_cliente
and	c.nr_sequencia = nr_seq_vendedor_p;

if (coalesce(qt_vidas_w::text, '') = '') then
	qt_vidas_w := 0;
end if;

select	a.nr_seq_classificacao,
	a.nr_seq_solicitacao
into STRICT	nr_seq_classificacao_w,
	nr_seq_solicitacao_w
from	pls_comercial_cliente		a,
	pls_solicitacao_vendedor	b
where	a.nr_sequencia = b.nr_seq_cliente
and	b.nr_sequencia	= nr_seq_vendedor_p;

if (nr_seq_solicitacao_w IS NOT NULL AND nr_seq_solicitacao_w::text <> '') then
	select	max(ie_tipo_contratacao)
	into STRICT	ie_tipo_contratacao_w
	from	pls_solicitacao_vendedor	c,
		pls_comercial_cliente		b,
		pls_solicitacao_comercial	a
	where	b.nr_seq_solicitacao = a.nr_sequencia
	and	b.nr_sequencia = c.nr_seq_cliente
	and	c.nr_sequencia = nr_seq_vendedor_p;
end if;

if (qt_vidas_w <> 0) then
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_regra_dias_w
	from	pls_solicitacao_regra_vend
	where	ie_tipo_canal_venda	= ie_tipo_vendedor_w
	and	((coalesce(nr_seq_classificacao,nr_seq_classificacao_w)	= nr_seq_classificacao_w
	and	(nr_seq_classificacao IS NOT NULL AND nr_seq_classificacao::text <> ''))
	or	coalesce(nr_seq_classificacao::text, '') = '')
	and	((coalesce(ie_tipo_contratacao,ie_tipo_contratacao_w)	= ie_tipo_contratacao_w
	and	(ie_tipo_contratacao IS NOT NULL AND ie_tipo_contratacao::text <> ''))
	or	coalesce(ie_tipo_contratacao::text, '') = '')
	and (ie_aplicacao_regra	= 'P'
	or	ie_aplicacao_regra	= 'A')
	and	ie_situacao		= 'A'
	and	((qt_vidas_w between coalesce(qt_vidas,0) and coalesce(qt_vidas_final,qt_vidas_w) and (qt_vidas_w IS NOT NULL AND qt_vidas_w::text <> ''))
	or (coalesce(qt_vidas_w::text, '') = ''))
	order by ie_tipo_contratacao,coalesce(qt_vidas,0);
	exception
	when others then
		nr_seq_regra_dias_w	:= 0;
	end;
	elsif (qt_vidas_w = 0) then
		nr_seq_regra_dias_w	:= 0;
	end if;

if (coalesce(nr_seq_regra_dias_w::text, '') = '') then
	nr_seq_regra_dias_w	:= 0;
end if;

if (nr_seq_regra_dias_w <> 0) then
	select	coalesce(qt_dias_efetivacao,0)
	into STRICT	qt_dias_efetivacao_w
	from	pls_solicitacao_regra_vend
	where	nr_sequencia	= nr_seq_regra_dias_w;

	update	pls_solicitacao_vendedor
	set	qt_dias_efetivacao = coalesce(qt_dias_efetivacao_w,0)
	where	nr_sequencia = nr_seq_vendedor_p;
else
	update	pls_solicitacao_vendedor
	set	qt_dias_efetivacao = 0
	where	nr_sequencia = nr_seq_vendedor_p;

	qt_dias_efetivacao_w := 0;
end if;

open C01;
loop
fetch C01 into
	nr_seq_vendedor_aux_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	insert into pls_solic_vendedor_compl(	nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_cliente,
						nr_seq_vendedor_canal,
						nr_seq_vendedor_vinculado,
						cd_estabelecimento )
					values (	nextval('pls_solic_vendedor_compl_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_cliente_w,
						nr_seq_vendedor_aux_w,
						null,
						cd_estabelecimento_p );

	end;
end loop;
close C01;

if (nr_seq_regra_dias_w <> 0) then
	select	max(a.dt_aprovacao)
	into STRICT	dt_aprovacao_w
	from	pls_solicitacao_vendedor	c,
		pls_comercial_cliente		b,
		pls_solicitacao_comercial	a
	where	b.nr_seq_solicitacao = a.nr_sequencia
	and	b.nr_sequencia = c.nr_seq_cliente
	and	b.nr_sequencia = nr_seq_cliente_w;

	if (dt_aprovacao_w IS NOT NULL AND dt_aprovacao_w::text <> '') then
		update	pls_solicitacao_vendedor
		set	dt_inicio_vigencia = dt_aprovacao_w
		where	nr_sequencia	= nr_seq_vendedor_p;
	else
		update	pls_solicitacao_vendedor
		set	dt_inicio_vigencia = clock_timestamp()
		where	nr_sequencia	= nr_seq_vendedor_p;
	end if;
end if;

update	pls_comercial_cliente
set	dt_efetivacao	= dt_inicio_vigencia_w + coalesce(qt_dias_efetivacao_w,0),
	ie_status	= 'R'
where	nr_sequencia	= nr_seq_cliente_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_vendedor_cliente ( nr_seq_vendedor_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
