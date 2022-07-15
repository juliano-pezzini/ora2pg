-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_reg_lic_anexo_encer ( nr_seq_licitacao_p bigint, ds_titulo_p text, ds_arquivo_p text, nr_seq_tipo_anexo_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_Sequencia_w		bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_Sequencia_w
from	reg_lic_anexo_encer
where	nr_seq_licitacao	= nr_seq_licitacao_p
and	ds_titulo		= ds_titulo_p;

if (nr_Sequencia_w = 0) then

	insert into reg_lic_anexo_encer(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_licitacao,
		ds_titulo,
		ds_arquivo,
		nr_seq_tipo_anexo,
		ie_anexa_zip)
	values (	nextval('reg_lic_anexo_encer_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_licitacao_p,
		substr(ds_titulo_p,1,255),
		substr(ds_arquivo_p,1,255),
		nr_seq_tipo_anexo_p,
		'S');
else
	update	reg_lic_anexo_encer
	set	ie_anexa_zip = 'S'
	where	nr_sequencia = nr_Sequencia_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_reg_lic_anexo_encer ( nr_seq_licitacao_p bigint, ds_titulo_p text, ds_arquivo_p text, nr_seq_tipo_anexo_p bigint, nm_usuario_p text) FROM PUBLIC;

