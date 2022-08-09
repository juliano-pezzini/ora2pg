-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_copiar_metrica_mes ( nr_seq_mes_origem_p bigint, nr_seq_mes_destino_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

delete	from ctb_metrica_real
where	nr_seq_mes_ref	= nr_seq_mes_destino_p;

commit;

insert into ctb_metrica_real(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_centro_custo,
	nr_seq_metrica,
	nr_seq_mes_ref,
	qt_metrica_real)
(SELECT	nextval('ctb_metrica_real_seq'),
	a.cd_estabelecimento,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	a.cd_centro_custo,
	a.nr_seq_metrica,
	nr_seq_mes_destino_p,
	a.qt_metrica_real
from	ctb_metrica_real a
where	a.nr_seq_mes_ref		= nr_seq_mes_origem_p
and	a.cd_estabelecimento	= cd_estabelecimento_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_copiar_metrica_mes ( nr_seq_mes_origem_p bigint, nr_seq_mes_destino_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
