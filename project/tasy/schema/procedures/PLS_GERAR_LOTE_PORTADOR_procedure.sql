-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lote_portador ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_seq_pagador_w		bigint;
nr_seq_forma_cobranca_w		bigint;
cd_tipo_portador_w		bigint;
cd_portador_w			bigint;
cd_banco_w			bigint;
nr_seq_conta_banco_lote_w	bigint;
nr_seq_forma_cobranca_lote_w	varchar(10);
cd_tipo_portador_lote_w		bigint;
cd_portador_lote_w		bigint;
nr_seq_portador_w		bigint;
vl_mensalidade_inicial_w	double precision;
vl_mensalidade_w		double precision;
vl_mensalidade_final_w		double precision;
ie_gerar_pagador_w		varchar(10);
nr_seq_pagador_mensal_w		bigint;
qt_registros_w			bigint;
qt_max_pagadores_w		bigint;
qt_pagadores_contador_w		bigint := 0;
dt_contrato_inicial_w		timestamp;
dt_contrato_final_w		timestamp;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	pls_contrato_pagador		a,
		pls_contrato_pagador_fin	b,
		pls_contrato			c
	where	a.nr_seq_contrato			= c.nr_sequencia
	and	b.nr_seq_pagador			= a.nr_sequencia
	and	coalesce(b.nr_seq_conta_banco,0)		= coalesce(nr_seq_conta_banco_lote_w,coalesce(b.nr_seq_conta_banco,0))
	and	coalesce(b.nr_seq_forma_cobranca,'0')	= coalesce(nr_seq_forma_cobranca_lote_w,coalesce(b.nr_seq_forma_cobranca,'0'))
	and	coalesce(b.cd_tipo_portador,0)		= coalesce(cd_tipo_portador_lote_w,coalesce(b.cd_tipo_portador,0))
	and	coalesce(b.cd_portador,0)			= coalesce(cd_portador_lote_w,coalesce(b.cd_portador,0))
	and	c.dt_contrato between coalesce(dt_contrato_inicial_w,c.dt_contrato) and coalesce(dt_contrato_final_w,c.dt_contrato)
	and	b.ie_portador_exclusivo			= 'S'
	and	coalesce(a.dt_rescisao::text, '') = ''
	and	coalesce(b.dt_fim_vigencia::text, '') = '';


BEGIN

select	nr_seq_forma_cobranca,
	cd_tipo_portador,
	cd_portador,
	nr_seq_conta_banco,
	coalesce(vl_mensalidade_inicial,0),
	coalesce(vl_mensalidade_final,0),
	coalesce(qt_maximo_pagadores,0),
	trunc(dt_contrato_inicial,'dd'),
	fim_dia(dt_contrato_final)
into STRICT	nr_seq_forma_cobranca_lote_w,
	cd_tipo_portador_lote_w,
	cd_portador_lote_w,
	nr_seq_conta_banco_lote_w,
	vl_mensalidade_inicial_w,
	vl_mensalidade_final_w,
	qt_max_pagadores_w,
	dt_contrato_inicial_w,
	dt_contrato_final_w
from	pls_lote_portador_alt
where	nr_sequencia	= nr_seq_lote_p;

open C01;
loop
fetch C01 into
	nr_seq_pagador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	nr_seq_pagador_mensal_w := 0;

	begin
	select	vl_mensalidade
	into STRICT	vl_mensalidade_w
	from	pls_mensalidade a
	where	nr_seq_pagador = nr_seq_pagador_w
	and	dt_referencia = (SELECT	max(dt_referencia)
				from	pls_mensalidade x
				where	a.nr_seq_pagador	= x.nr_seq_pagador)
	and	coalesce(ie_cancelamento::text, '') = '';
	exception
	when others then
		vl_mensalidade_w := 0;
	end;

	if (vl_mensalidade_w between vl_mensalidade_inicial_w and vl_mensalidade_final_w) then
		nr_seq_pagador_mensal_w := nr_seq_pagador_w;
	elsif (coalesce(vl_mensalidade_inicial_w,0) = 0) and (coalesce(vl_mensalidade_final_w,0) = 0) then
		nr_seq_pagador_mensal_w := nr_seq_pagador_w;
	end if;

	select	nextval('pls_portador_alteracao_seq')
	into STRICT	nr_seq_portador_w
	;

	if (nr_seq_pagador_mensal_w <> 0) then
		insert into	pls_portador_alteracao(	nr_sequencia,
				nr_seq_lote,
				nr_seq_pagador,
				dt_atualizacao,
				dt_atualizacao_nrec,
				nm_usuario,
				nm_usuario_nrec,
				cd_estabelecimento)
		values (	nr_seq_portador_w,
				nr_seq_lote_p,
				nr_seq_pagador_mensal_w,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_p,
				cd_estabelecimento_p);
	end if;

	qt_pagadores_contador_w := qt_pagadores_contador_w +1;

	if (qt_max_pagadores_w  = qt_pagadores_contador_w  ) then
		exit;
	end if;
	end;
end loop;
close C01;

select	count(1)
into STRICT	qt_registros_w
from	pls_portador_alteracao
where	nr_seq_lote	= nr_seq_lote_p;

if (qt_registros_w > 1) then
	update	pls_lote_portador_alt
	set	dt_geracao_lote	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lote_portador ( nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
