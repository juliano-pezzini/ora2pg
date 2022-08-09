-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eme_gerar_codigo_conv (nm_usuario_p text, cd_codigo_convenio_p INOUT text, cd_pf_titular_p text, cd_cgc_titular_p text, nr_seq_contrato_p bigint) AS $body$
DECLARE


nr_seq_regra_w		eme_regra_codigo_convenio.nr_sequencia%type;
nr_prod_inicial_w	eme_regra_codigo_convenio.nr_prod_inicial%type;
nr_prod_final_w		eme_regra_codigo_convenio.nr_prod_final%type;
nr_prod_atual_w		eme_regra_codigo_convenio.nr_prod_atual%type;
cd_singular_w		eme_regra_codigo_convenio.cd_singular%type;
cd_tipo_contrato_w	eme_regra_codigo_convenio.cd_tipo_contrato%type;
cd_codigo_convenio_w	eme_pf_contrato.cd_codigo_convenio%type;
cd_produto_w		varchar(6);
cd_dependente_w		varchar(2);
qt_registros_w		integer;


BEGIN

select max(nr_sequencia)
into STRICT   nr_seq_regra_w
from   eme_regra_codigo_convenio
where  coalesce(ie_situacao, 'A') = 'A'
and    clock_timestamp() between trunc(dt_vigencia_ini) and fim_dia(dt_vigencia_fim);

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then

	select 	lpad(cd_singular, 4, '0'),
		lpad(cd_tipo_contrato, 4, '0'),
		nr_prod_inicial,
		nr_prod_final,
		nr_prod_atual
	into STRICT	cd_singular_w,
		cd_tipo_contrato_w,
		nr_prod_inicial_w,
		nr_prod_final_w,
		nr_prod_atual_w
	from	eme_regra_codigo_convenio
	where	nr_sequencia = nr_seq_regra_w;

	if (nr_prod_atual_w = 0) then
		cd_produto_w := nr_prod_inicial_w;
	elsif ((nr_prod_atual_w + 1) <= nr_prod_final_w) then
		cd_produto_w := nr_prod_atual_w + 1;
	end if;

	if ((cd_pf_titular_p IS NOT NULL AND cd_pf_titular_p::text <> '') or (cd_cgc_titular_p IS NOT NULL AND cd_cgc_titular_p::text <> '')) then
		cd_dependente_w := '00';
	else
		select 	lpad(count(*)+1, 2, '0')
		into STRICT 	cd_dependente_w
		from	eme_pf_contrato
		where	nr_seq_contrato = nr_seq_contrato_p
		and	coalesce(cd_pf_titular::text, '') = ''
		and 	coalesce(cd_cgc_titular::text, '') = '';

	end if;

	cd_codigo_convenio_w := cd_singular_w || cd_tipo_contrato_w || lpad(cd_produto_w, 6, '0') || cd_dependente_w;

	update	eme_regra_codigo_convenio
	set	nr_prod_atual = cd_produto_w
	where	nr_sequencia = nr_seq_regra_w;

	select 	count(*)
	into STRICT	qt_registros_w
	from	eme_pf_contrato
	where	cd_codigo_convenio = cd_codigo_convenio_w;

	if (qt_registros_w = 0) then
		cd_codigo_convenio_p := cd_codigo_convenio_w;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eme_gerar_codigo_conv (nm_usuario_p text, cd_codigo_convenio_p INOUT text, cd_pf_titular_p text, cd_cgc_titular_p text, nr_seq_contrato_p bigint) FROM PUBLIC;
