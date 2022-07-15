-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fin_reabrir_mes (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_w	varchar(15);
dt_fechamento_w	timestamp;


BEGIN

select	nm_usuario,
	dt_fechamento
into STRICT	nm_usuario_w,
	dt_fechamento_w
from	fin_mes_ref
where	nr_sequencia	= nr_sequencia_p;

update	fin_mes_ref
set	DT_ATUALIZACAO		= clock_timestamp(),
	NM_USUARIO			= nm_usuario_p,
	DT_FECHAMENTO			 = NULL,
	NM_USUARIO_FECHAMENTO	 = NULL
where	nr_sequencia	= nr_sequencia_p;

/* inserir histórico de reabertura - ahoffelder - 22/09/2009 - OS 167526 */

insert	into fin_mes_ref_hist(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_fin_mes,
	ds_historico)
	values (nextval('fin_mes_ref_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_sequencia_p,
	OBTER_DESC_EXPRESSAO(726352) || chr(13) || OBTER_DESC_EXPRESSAO(708282) || nm_usuario_w || chr(13) || OBTER_DESC_EXPRESSAO(708260) || ' ' || PKG_DATE_FORMATERS.to_varchar(dt_fechamento_w, 'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, nm_usuario_p));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fin_reabrir_mes (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

