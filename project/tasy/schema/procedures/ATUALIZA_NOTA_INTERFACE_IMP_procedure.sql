-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_nota_interface_imp ( nm_usuario_p text, ds_arquivo_p text, ds_xml_p text, nr_seq_lote_p INOUT bigint) AS $body$
DECLARE



nr_seq_nota_fiscal_w		bigint;
nr_seq_lote_w			bigint;
nr_sequencia_w			bigint;
ds_xml_w				text;


BEGIN

select	nextval('nota_fiscal_importada_seq')
into STRICT	nr_sequencia_w
;

ds_xml_w	:=	ds_xml_p;

insert into nota_fiscal_importada(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_arquivo,
	ds_conteudo,
	ie_geracao)
values (	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	substr(ds_arquivo_p,1,80),
	ds_xml_w,
	'S');


nr_seq_lote_p	:= nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_nota_interface_imp ( nm_usuario_p text, ds_arquivo_p text, ds_xml_p text, nr_seq_lote_p INOUT bigint) FROM PUBLIC;
