-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_retorno_checkup (nr_seq_checkup_p bigint, nr_seq_tipo_avaliacao_p bigint, nm_usuario_p text, nr_seq_checkup_ret_p INOUT bigint, cd_profissional_p text default null) AS $body$
DECLARE

 
nr_seq_checkup_ret_w	bigint;


BEGIN 
 
select	nextval('checkup_retorno_seq') 
into STRICT	nr_seq_checkup_ret_w
;
 
insert into checkup_retorno(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_checkup, 
				dt_retorno, 
				nr_seq_tipo_avaliacao, 
				cd_profissional) 
values (			nr_seq_checkup_ret_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_checkup_p, 
				clock_timestamp(), 
				nr_seq_tipo_avaliacao_p, 
				coalesce(cd_profissional_p,obter_pf_usuario(nm_usuario_p,'C')));
 
commit;
 
nr_seq_checkup_ret_p	:= nr_seq_checkup_ret_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_retorno_checkup (nr_seq_checkup_p bigint, nr_seq_tipo_avaliacao_p bigint, nm_usuario_p text, nr_seq_checkup_ret_p INOUT bigint, cd_profissional_p text default null) FROM PUBLIC;

