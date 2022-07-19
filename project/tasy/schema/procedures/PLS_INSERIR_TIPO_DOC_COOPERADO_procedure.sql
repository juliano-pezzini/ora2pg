-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_inserir_tipo_doc_cooperado ( nr_seq_tipo_documento_p bigint, nr_seq_cooperado_p bigint, ds_arquivo_p text, dt_inicio_vigencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_tipo_documento_w		bigint;
qt_doc_w			bigint;
nr_seq_tipo_documento_ww	bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_tipo_documento_ww
from	pls_cooperado_tipo_doc
where	nr_seq_cooperado		= nr_seq_cooperado_p
and	nr_seq_tipo_documento		= nr_seq_tipo_documento_p
and	trunc(dt_inicio_vigencia)	= trunc(dt_inicio_vigencia_p);

if (nr_seq_tipo_documento_ww = 0) then

	select	nextval('pls_cooperado_tipo_doc_seq')
	into STRICT	nr_seq_tipo_documento_w
	;

	insert	into pls_cooperado_tipo_doc(nr_sequencia, nr_seq_cooperado, nr_seq_tipo_documento,
		 dt_inicio_vigencia, dt_atualizacao, nm_usuario)
	values (nr_seq_tipo_documento_w, nr_seq_cooperado_p, nr_seq_tipo_documento_p,
		 clock_timestamp(), clock_timestamp(), nm_usuario_p);

	insert	into pls_cooperado_documento(nr_sequencia, nr_seq_coop_tipo, dt_atualizacao,
		nm_usuario, ds_arquivo, dt_documento)
	values (nextval('pls_cooperado_documento_seq'), nr_seq_tipo_documento_w, clock_timestamp(),
		nm_usuario_p, ds_arquivo_p, clock_timestamp());
else
	insert	into pls_cooperado_documento(nr_sequencia, nr_seq_coop_tipo, dt_atualizacao,
		nm_usuario, ds_arquivo, dt_documento)
	values (nextval('pls_cooperado_documento_seq'), nr_seq_tipo_documento_ww, clock_timestamp(),
		nm_usuario_p, ds_arquivo_p, clock_timestamp());
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_inserir_tipo_doc_cooperado ( nr_seq_tipo_documento_p bigint, nr_seq_cooperado_p bigint, ds_arquivo_p text, dt_inicio_vigencia_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

