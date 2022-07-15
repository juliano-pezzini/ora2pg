-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_tiss_protocolo_envio_ret (nr_sequencia_p bigint, nm_usuario_p text, nr_seq_protocolo_p bigint, nr_protocolo_receb_p text, ds_erro_p text, nr_seq_lote_reap_p bigint, nr_seq_tiss_prot_guia_p tiss_protocolo_envio_ret.nr_seq_tiss_prot_guia%type default null, nr_lote_prestador_p tiss_protocolo_envio_ret.nr_lote_prestador%type default null) AS $body$
DECLARE


nr_sequencia_w 		tiss_protocolo_envio_ret.nr_sequencia%type;

nr_seq_tiss_prot_guia_w  tiss_protocolo_envio_ret.nr_seq_tiss_prot_guia%type := nr_seq_tiss_prot_guia_p;
nr_lote_prestador_w  tiss_protocolo_envio_ret.nr_lote_prestador%type := nr_lote_prestador_p;

BEGIN

nr_sequencia_w := nr_sequencia_p;
if (coalesce(nr_sequencia_w,0) = 0) then
	select	nextval('tiss_protocolo_envio_ret_seq')
	into STRICT	nr_sequencia_w
	;
end if;

insert into tiss_protocolo_envio_ret(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_protocolo,
	nr_protocolo_receb,
	ds_erro,
	dt_evento,
	nr_seq_lote_reap,
    nr_seq_tiss_prot_guia,
    nr_lote_prestador)
values (nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_protocolo_p,
	nr_protocolo_receb_p,
	ds_erro_p,
	clock_timestamp(),
	nr_seq_lote_reap_p,
    nr_seq_tiss_prot_guia_w,
    nr_lote_prestador_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_tiss_protocolo_envio_ret (nr_sequencia_p bigint, nm_usuario_p text, nr_seq_protocolo_p bigint, nr_protocolo_receb_p text, ds_erro_p text, nr_seq_lote_reap_p bigint, nr_seq_tiss_prot_guia_p tiss_protocolo_envio_ret.nr_seq_tiss_prot_guia%type default null, nr_lote_prestador_p tiss_protocolo_envio_ret.nr_lote_prestador%type default null) FROM PUBLIC;

