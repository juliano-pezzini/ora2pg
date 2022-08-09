-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_deposito_ident_atend ( ds_titulos_p text, nm_usuario_p text, nr_seq_conta_banco_p bigint, cd_estabelecimento_p bigint, dt_validade_dep_p timestamp, ds_retorno_p INOUT text, ds_retorno_dep_p INOUT text) AS $body$
DECLARE


ds_retorno_w			varchar(4000)	:= null;
ds_titulos_w			varchar(255)	:= null;
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
vl_saldo_titulo_w		double precision;
vl_total_deposito_w		double precision	:= 0;
nr_titulo_w			bigint;
nr_seq_deposito_w		bigint;
nr_seq_deposito_ant_w		bigint;
nr_identificacao_w		bigint;
qt_lotes_w			bigint := 0;
nr_identific_dep_w		varchar(30);
dt_referencia_w			timestamp;
nr_seq_lote_deposito_w		bigint;

C01 CURSOR FOR
	SELECT	a.cd_pessoa_fisica,
		a.cd_cgc,
		a.nr_titulo,
		a.vl_saldo_titulo +
			coalesce(obter_juros_multa_titulo(a.nr_titulo,dt_referencia_w,'R','J'),0) +
			coalesce(obter_juros_multa_titulo(a.nr_titulo,dt_referencia_w,'R','M'),0) vl_saldo_titulo
	from	titulo_receber	a
	where	a.nr_titulo in (SELECT	b.nr_titulo
				from	w_titulo_selecionado b
				where	b.nm_usuario = nm_usuario_p)
	order by
		coalesce(a.cd_pessoa_fisica,' '),
		coalesce(a.cd_cgc,' ');


BEGIN
dt_referencia_w := trunc(coalesce(dt_validade_dep_p,clock_timestamp()));

open C01;
loop
fetch C01 into
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_titulo_w,
	vl_saldo_titulo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		select	max(nr_sequencia)
		into STRICT	nr_seq_deposito_w
		from	deposito_identificado	a
		where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	a.nr_seq_conta_banco	= nr_seq_conta_banco_p
		and	a.ie_status <> 'C';
	else
		select	max(nr_sequencia)
		into STRICT	nr_seq_deposito_w
		from	deposito_identificado	a
		where	a.cd_cgc		= cd_cgc_w
		and	a.nr_seq_conta_banco	= nr_seq_conta_banco_p
		and	a.ie_status <> 'C';
	end if;

	select	max(b.nr_sequencia)
	into STRICT	nr_seq_lote_deposito_w
	from	deposito_identificado	b,
		deposito_ident_titulo	a
	where	a.nr_seq_deposito	= b.nr_sequencia
	and	b.ie_status <> 'C'
	and	b.nr_sequencia		= nr_seq_deposito_w
	and	a.nr_titulo		= nr_titulo_w;

	if (nr_seq_lote_deposito_w IS NOT NULL AND nr_seq_lote_deposito_w::text <> '') then
		update	deposito_identificado
		set	ie_status = 'C'
		where	nr_sequencia = nr_seq_lote_deposito_w;
	end if;

	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		begin
		ds_retorno_w	:= ds_retorno_w	|| ', no valor de ' || campo_mascara_virgula(vl_total_deposito_w) || ', ' || chr(10);
		exception
		when others then
			null;
		end;

		vl_total_deposito_w	:= 0;
	end if;

	select	nextval('deposito_identificado_seq')
	into STRICT	nr_seq_deposito_w
	;

	insert into deposito_identificado(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		dt_inclusao,
		ie_status,
		vl_deposito,
		nr_seq_conta_banco,
		cd_estabelecimento,
		cd_pessoa_fisica,
		cd_cgc,
		dt_limite_deposito)
	values (nr_seq_deposito_w,
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		clock_timestamp(),
		'AD',
		0,
		nr_seq_conta_banco_p,
		cd_estabelecimento_p,
		cd_pessoa_fisica_w,
		cd_cgc_w,
		dt_validade_dep_p);

	nr_seq_deposito_ant_w	:= nr_seq_deposito_w;

	begin
	ds_retorno_w	:= ds_retorno_w	|| 'Gerado o depósito ' || nr_seq_deposito_w;
	exception
	when others then
		null;
	end;

	insert into deposito_ident_titulo(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_seq_deposito,
		vl_depositar,
		nr_titulo)
	values (nextval('deposito_ident_titulo_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_deposito_w,
		vl_saldo_titulo_w,
		nr_titulo_w);

	ds_titulos_w	:= ds_titulos_w || nr_titulo_w || ', ';

	vl_total_deposito_w	:= vl_total_deposito_w + vl_saldo_titulo_w;

	if (nr_seq_deposito_ant_w IS NOT NULL AND nr_seq_deposito_ant_w::text <> '') then
		update	deposito_identificado
		set	vl_deposito		= vl_total_deposito_w,
			dt_limite_deposito	= coalesce(dt_limite_deposito,dt_validade_dep_p)
		where	nr_sequencia		= nr_seq_deposito_ant_w;
	end if;

	if (nr_seq_deposito_w IS NOT NULL AND nr_seq_deposito_w::text <> '') and (qt_lotes_w = 0) then
		ds_retorno_dep_p := nr_seq_deposito_w;
		qt_lotes_w := 1;

	elsif (nr_seq_deposito_w IS NOT NULL AND nr_seq_deposito_w::text <> '') and (qt_lotes_w > 0) then

		if (qt_lotes_w = 1) and (ds_retorno_dep_p <> nr_seq_deposito_w) then
			ds_retorno_dep_p := ds_retorno_dep_p || ', ' || nr_seq_deposito_w;
			qt_lotes_w := qt_lotes_w + 1;

		elsif (qt_lotes_w > 1) then
			ds_retorno_dep_p := replace(ds_retorno_dep_p,', ' || nr_seq_deposito_w,'') || ', ' || nr_seq_deposito_w;
			qt_lotes_w := qt_lotes_w + 1;
		end if;
	end if;

	select	max(nr_identificacao)
	into STRICT	nr_identific_dep_w
	from	deposito_identificado
	where	nr_sequencia	= nr_seq_deposito_w;

	if (coalesce(nr_identific_dep_w::text, '') = '') then -- Gerar o número de identificação
		CALL gerar_numero_ident_deposito(nr_seq_deposito_w,'N',nm_usuario_p);
	end if;
	end;
end loop;
close C01;

if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
	begin
	ds_retorno_w	:= ds_retorno_w	|| ', no valor de ' || vl_total_deposito_w || ', para os títulos ' || ds_titulos_w;
	exception
	when others then
		null;
	end;
end if;

ds_retorno_p	:= substr(ds_retorno_w,1,length(ds_retorno_w)-2);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_deposito_ident_atend ( ds_titulos_p text, nm_usuario_p text, nr_seq_conta_banco_p bigint, cd_estabelecimento_p bigint, dt_validade_dep_p timestamp, ds_retorno_p INOUT text, ds_retorno_dep_p INOUT text) FROM PUBLIC;
