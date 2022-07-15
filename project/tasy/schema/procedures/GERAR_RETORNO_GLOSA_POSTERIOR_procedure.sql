-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_glosa_posterior (nr_seq_ret_item_p bigint, nm_usuario_p text, nr_seq_retorno_novo_p INOUT bigint, nr_seq_ret_item_novo_p INOUT bigint) AS $body$
DECLARE


nr_seq_retorno_w	bigint;
nr_seq_retorno_novo_w	bigint;
nr_seq_ret_item_novo_w	bigint;


BEGIN

select	nr_seq_retorno
into STRICT	nr_seq_retorno_w
from	convenio_retorno_item
where	nr_sequencia	= nr_seq_ret_item_p;

select	max(nr_sequencia)
into STRICT	nr_seq_retorno_novo_w
from	convenio_retorno
where	nr_seq_ret_origem	= nr_seq_retorno_w
and	ie_status_retorno	<> 'F';

select	max(nr_sequencia)
into STRICT	nr_seq_ret_item_novo_w
from	convenio_retorno_item
where	nr_seq_ret_item_orig	= nr_seq_ret_item_p;

if (coalesce(nr_seq_retorno_novo_w::text, '') = '') then
	select	nextval('convenio_retorno_seq')
	into STRICT	nr_seq_retorno_novo_w
	;

	insert	into	convenio_retorno(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		cd_convenio,
		dt_retorno,
		ie_status_retorno,
		nm_usuario_retorno,
		cd_estabelecimento,
		dt_inicial,
		dt_final,
		ie_tipo_glosa,
		nr_seq_ret_origem)
	SELECT	nr_seq_retorno_novo_w,
		nm_usuario_p,
		clock_timestamp(),
		cd_convenio,
		trunc(clock_timestamp(),'dd'),
		'R',
		nm_usuario_p,
		cd_estabelecimento,
		dt_inicial,
		dt_final,
		'P',
		nr_sequencia
	from	convenio_retorno
	where	nr_sequencia	= nr_seq_retorno_w;
end if;

if (coalesce(nr_seq_ret_item_novo_w::text, '') = '') then
	select	nextval('convenio_retorno_item_seq')
	into STRICT	nr_seq_ret_item_novo_w
	;

	insert	into	convenio_retorno_item(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nr_seq_retorno,
		vl_pago,
		vl_glosado,
		vl_amenor,
		vl_adicional,
		vl_amenor_post,
		vl_glosado_post,
		vl_guia,
		vl_perdas,
		vl_adequado,
		vl_desconto,
		ie_glosa,
		nr_titulo,
		nr_interno_conta,
		cd_autorizacao,
		cd_autorizacao_conv,
		ie_autorizacao,
		ie_libera_repasse,
		ie_analisada,
		nr_seq_ret_item_orig)
	SELECT	nr_seq_ret_item_novo_w,
		nm_usuario_p,
		clock_timestamp(),
		nr_seq_retorno_novo_w,
		0,
		0,
		0,
		0,
		0,
		0,
		vl_guia,
		0,
		0,
		0,
		'P',
		nr_titulo,
		nr_interno_conta,
		cd_autorizacao,
		cd_autorizacao_conv,
		ie_autorizacao,
		'N',
		'N',
		nr_sequencia
	from	convenio_retorno_item
	where	nr_sequencia	= nr_seq_ret_item_p;
end if;

nr_seq_retorno_novo_p	:= nr_seq_retorno_novo_w;
nr_seq_ret_item_novo_p	:= nr_seq_ret_item_novo_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_glosa_posterior (nr_seq_ret_item_p bigint, nm_usuario_p text, nr_seq_retorno_novo_p INOUT bigint, nr_seq_ret_item_novo_p INOUT bigint) FROM PUBLIC;

