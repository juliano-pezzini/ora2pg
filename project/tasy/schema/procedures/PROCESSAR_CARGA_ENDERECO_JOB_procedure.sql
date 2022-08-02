-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE processar_carga_endereco_job ( nr_seq_catalogo_p end_endereco.nr_seq_catalogo%type, ie_informacao_p end_endereco.ie_informacao%type, nm_usuario_p end_endereco.nm_usuario%type) AS $body$
DECLARE


jobno bigint;

BEGIN

dbms_job.submit(jobno, 'inserir_carga_end_endereco('''||
														nr_seq_catalogo_p || ''',''' ||
														ie_informacao_p || ''',''' ||
														nm_usuario_p   ||''');');



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE processar_carga_endereco_job ( nr_seq_catalogo_p end_endereco.nr_seq_catalogo%type, ie_informacao_p end_endereco.ie_informacao%type, nm_usuario_p end_endereco.nm_usuario%type) FROM PUBLIC;

