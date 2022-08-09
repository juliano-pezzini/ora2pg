-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_log_prepedido_me ( nm_usuario_p text, nr_prepedido_me_p bigint, id_fornecedor_me_p text, ds_observacao_p text, nr_solic_compra_p bigint, nr_ordem_compra_p bigint, ds_tag_p text, nr_sequencia_p INOUT bigint, ie_status_p INOUT text) AS $body$
DECLARE


ie_status_w			varchar(3);
ds_observacao_w		varchar(255);
nr_ordem_compra_w		bigint;
nr_sequencia_w		bigint;


BEGIN
nr_ordem_compra_w	:= nr_ordem_compra_p;
ds_observacao_w	:= ds_observacao_p;
ie_status_w		:= 1;

if (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
	ie_status_w		:= 104;
	ds_observacao_w	:= ds_observacao_p;
	nr_ordem_compra_w	:= 0;
end if;

select	nextval('log_prepedido_me_seq')
into STRICT	nr_sequencia_w
;

insert into log_prepedido_me(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_solic_compra,
	nr_prepedido,
	ds_tag,
	id_fornecedor,
	nr_ordem_compra,
	ie_status,
	ds_observacao)
values (nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_solic_compra_p,
	nr_prepedido_me_p,
	ds_tag_p,
	id_fornecedor_me_p,
	CASE WHEN nr_ordem_compra_w=0 THEN  null  ELSE nr_ordem_compra_w END ,
	ie_status_w,
	ds_observacao_p);

nr_sequencia_p	:= nr_sequencia_w;
ie_status_p		:= ie_status_w;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_log_prepedido_me ( nm_usuario_p text, nr_prepedido_me_p bigint, id_fornecedor_me_p text, ds_observacao_p text, nr_solic_compra_p bigint, nr_ordem_compra_p bigint, ds_tag_p text, nr_sequencia_p INOUT bigint, ie_status_p INOUT text) FROM PUBLIC;
