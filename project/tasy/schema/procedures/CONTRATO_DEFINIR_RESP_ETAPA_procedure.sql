-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE contrato_definir_resp_etapa ( nr_seq_contrato_p bigint, nr_seq_etapa_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_cgc_contratado_w		varchar(14);
cd_pessoa_contratada_w		varchar(10);
nr_seq_contrato_w			bigint;
qt_registro_w			bigint;


BEGIN

nr_seq_contrato_w	:= nr_seq_contrato_p;

select	cd_cgc_contratado,
	cd_pessoa_contratada
into STRICT	cd_cgc_contratado_w,
	cd_pessoa_contratada_w
from	contrato
where	nr_sequencia	= nr_seq_contrato_w;

insert into contrato_resp_etapa(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_contrato,
	nr_seq_etapa,
	cd_pessoa_resp,
	ds_parecer_responsavel,
	ie_comunic_interna,
	ie_email,
	ie_fisico,
	ie_verbal,
	cd_cnpj_resp)
values (	nextval('contrato_resp_etapa_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_contrato_p,
	nr_seq_etapa_p,
	cd_pessoa_contratada_w,
	null,
	'S',
	'N',
	'N',
	'N',
	cd_cgc_contratado_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE contrato_definir_resp_etapa ( nr_seq_contrato_p bigint, nr_seq_etapa_p bigint, nm_usuario_p text) FROM PUBLIC;

