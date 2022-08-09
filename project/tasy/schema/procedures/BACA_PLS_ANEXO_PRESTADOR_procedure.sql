-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pls_anexo_prestador ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_tipo_doc_w		bigint;
dt_anexo_w			timestamp;
nr_seq_tipo_documento_w		bigint;
ds_anexo_w			varchar(255);
nr_seq_prestador_doc_w		bigint;
nr_seq_prestador_w		bigint;
ie_tipo_doc_w			bigint;

C01 CURSOR FOR
	SELECT	distinct coalesce(nr_seq_tipo_documento,ie_tipo_doc_w),
		nr_seq_prestador
	from	pls_prestador_anexo
	group by nr_seq_tipo_documento,
		 nr_seq_prestador;

C02 CURSOR FOR
	SELECT	dt_anexo,
		ds_anexo
	from	pls_prestador_anexo
	where	coalesce(nr_seq_tipo_documento,ie_tipo_doc_w)	= nr_seq_tipo_documento_w
	and	nr_seq_prestador				= nr_seq_prestador_w;


BEGIN

select	min(nr_sequencia)
into STRICT	ie_tipo_doc_w
from	pls_tipo_documento
where	ie_situacao		= 'A'
and	ie_prestador		= 'S'
and	cd_estabelecimento	= cd_estabelecimento_p;

open C01;
loop
fetch C01 into
	nr_seq_tipo_documento_w,
	nr_seq_prestador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	select	nextval('pls_prestador_tipo_doc_seq')
	into STRICT	nr_seq_tipo_doc_w
	;

	insert	into pls_prestador_tipo_doc(nr_sequencia, dt_inicio_vigencia, nr_seq_tipo_documento,
		nr_seq_prestador, dt_atualizacao, nm_usuario)
	values (nr_seq_tipo_doc_w, clock_timestamp(), nr_seq_tipo_documento_w,
		nr_seq_prestador_w, clock_timestamp(), nm_usuario_p);

	open C02;
	loop
	fetch C02 into
		dt_anexo_w,
		ds_anexo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	nextval('pls_prestador_documento_seq')
		into STRICT	nr_seq_prestador_doc_w
		;

		insert	into pls_prestador_documento(nr_sequencia, dt_documento, ds_arquivo,
			nr_seq_prest_tipo, nm_usuario, dt_atualizacao)
		values (nr_seq_prestador_doc_w, dt_anexo_w, ds_anexo_w,
			nr_seq_tipo_doc_w,nm_usuario_p, clock_timestamp());

		end;
	end loop;
	close C02;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pls_anexo_prestador ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
