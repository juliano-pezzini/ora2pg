-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE remover_titulo_dirf ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_darf_w		varchar(10);
cd_tributo_w		smallint;
nr_seq_lote_dirf_w	bigint;
nr_titulo_w		bigint;


BEGIN

select	nr_seq_lote_dirf,
	nr_titulo,
	cd_tributo,
	cd_darf
into STRICT	nr_seq_lote_dirf_w,
	nr_titulo_w,
	cd_tributo_w,
	cd_darf_w
from	dirf_titulo_pagar
where	nr_sequencia = nr_sequencia_p;

delete 	from dirf_titulo_pagar
where	nr_sequencia = nr_sequencia_p;

insert into dirf_log_exclusao(	nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_lote_dirf,
					nr_titulo,
					cd_tributo,
					cd_darf,
					ie_tipo_alteracao)
			values (	nextval('dirf_log_exclusao_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_lote_dirf_w,
					nr_titulo_w,
					cd_tributo_w,
					cd_darf_w,
					'E');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE remover_titulo_dirf ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
