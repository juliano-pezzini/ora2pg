-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_ajustar_dados_ndc_560 () AS $body$
DECLARE


nr_nota_debito_w		bigint;
dt_ven_nota_w			timestamp;
ie_ndc_conclusao_w		smallint;
nr_seq_nota_debito_w		bigint;
nr_sequencia_w			bigint;
nr_titulo_w			bigint;
nm_usuario_w			varchar(15);

C01 CURSOR FOR
	SELECT	a.nr_nota_debito,
		a.dt_ven_nota,
		a.ie_conclusao_ndc,
		a.nr_sequencia,
		(substr(pls_obter_dados_nota_a560(a.nr_sequencia,'TR'),1,255))::numeric ,
		a.nm_usuario_nrec
	from	ptu_nota_debito a
	where	not exists (	SELECT	1
				from	ptu_nota_deb_conclusao x
				where	x.nr_seq_nota_debito = a.nr_sequencia);


BEGIN
begin
open C01;
loop
fetch C01 into
	nr_nota_debito_w,
	dt_ven_nota_w,
	ie_ndc_conclusao_w,
	nr_seq_nota_debito_w,
	nr_titulo_w,
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	nextval('ptu_nota_deb_conclusao_seq')
	into STRICT	nr_sequencia_w
	;

	insert into ptu_nota_deb_conclusao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_nota_debito,
		dt_ven_nota,
		id_ndc_conclusao,
		nr_seq,
		tp_reg,
		nr_seq_nota_debito)
	values (	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_w,
		clock_timestamp(),
		nm_usuario_w,
		nr_nota_debito_w,
		dt_ven_nota_w,
		ie_ndc_conclusao_w,
		null,
		'562',
		nr_seq_nota_debito_w);

	-- Boleto
	update	ptu_nota_deb_bol
	set	nr_seq_nota_deb_conclusao	= nr_sequencia_w
	where	nr_seq_nota_debito		= nr_seq_nota_debito_w;

	-- Dados credora/devedora
	update	ptu_nota_deb_credor_deved
	set	nr_seq_nota_deb_conclusao	= nr_sequencia_w
	where	nr_seq_nota_debito		= nr_seq_nota_debito_w;

	-- Dados nota debito
	update	ptu_nota_deb_dados
	set	nr_seq_nota_deb_conclusao	= nr_sequencia_w
	where	nr_seq_nota_debito		= nr_seq_nota_debito_w;

	-- Dados fatura/NDR
	update	ptu_nota_deb_fat_ndr
	set	nr_seq_nota_deb_conclusao	= nr_sequencia_w
	where	nr_seq_nota_debito		= nr_seq_nota_debito_w;

	-- Titulo pagar
	update	titulo_pagar
	set	nr_seq_nota_deb_conclusao	= nr_sequencia_w
	where	nr_seq_nota_debito		= nr_seq_nota_debito_w;

	-- Titulo receber
	update	titulo_receber
	set	nr_seq_nota_deb_conclusao	= nr_sequencia_w
	where	nr_titulo			= nr_titulo_w;
	end;
end loop;
close C01;
exception
when others then
	null;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_ajustar_dados_ndc_560 () FROM PUBLIC;

