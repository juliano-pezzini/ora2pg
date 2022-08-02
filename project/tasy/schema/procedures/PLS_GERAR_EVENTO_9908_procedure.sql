-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_evento_9908 ( nm_usuario_p text) AS $body$
DECLARE


nr_seq_glosa_w	bigint;

BEGIN

begin
	select	nr_sequencia
	into STRICT	nr_seq_glosa_w
	from	tiss_motivo_glosa
	where	cd_motivo_tiss = '9908';
exception
when others then
	nr_seq_glosa_w := null;
end;

if (nr_seq_glosa_w IS NOT NULL AND nr_seq_glosa_w::text <> '') then
	insert into pls_glosa_evento(dt_atualizacao, dt_atualizacao_nrec, ie_evento,
					 ie_plano, nm_usuario, nm_usuario_nrec,
					 nr_seq_motivo_glosa, nr_sequencia)
			values (clock_timestamp(), clock_timestamp(), 'DC',
					 'N', nm_usuario_p, nm_usuario_p,
					 nr_seq_glosa_w, nextval('pls_glosa_evento_seq'));
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_evento_9908 ( nm_usuario_p text) FROM PUBLIC;

