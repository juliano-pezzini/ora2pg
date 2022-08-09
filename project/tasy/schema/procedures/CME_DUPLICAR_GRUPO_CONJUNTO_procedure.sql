-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_duplicar_grupo_conjunto ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_grupo_conj_w	bigint;
ds_grupo_w		varchar(200);


BEGIN

select	nextval('cm_grupo_conjunto_seq')
into STRICT	nr_seq_grupo_conj_w
;

insert into cm_grupo_conjunto(
	nr_sequencia,
	ds_grupo,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_situacao,
	qt_tempo_esterelizacao,
	qt_consiste_agenda)
SELECT	nr_seq_grupo_conj_w,
	substr(wheb_mensagem_pck.get_texto(790857, 'DS_GRUPO='|| ds_grupo),1,200),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_situacao,
	qt_tempo_esterelizacao,
	qt_consiste_agenda
from	cm_grupo_conjunto
where	nr_sequencia	= nr_sequencia_p;

insert into cm_grupo_classif(
	nr_sequencia,
	nr_seq_grupo,
	nr_seq_classificacao,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
SELECT	nextval('cm_grupo_classif_seq'),
	nr_seq_grupo_conj_w,
	nr_seq_classificacao,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p
from	cm_grupo_classif
where	nr_seq_grupo	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_duplicar_grupo_conjunto ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
