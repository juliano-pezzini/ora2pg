-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE refazer_avaliacao (nm_usuario_p text, nr_seq_processo_p bigint, nr_seq_avaliacao_p bigint, ie_tipo_acao_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_tipo_avaliacao_w		pre_cad_avaliacao.nr_seq_tipo_avaliacao%type;
nr_seq_precad_pf_w			pre_cad_avaliacao.nr_seq_precad_pf%type;
nr_seq_precad_pj_w			pre_cad_avaliacao.nr_seq_precad_pj%type;
nr_seq_precad_mat_w			pre_cad_avaliacao.nr_seq_precad_mat%type;
nr_nivel_w						pre_cad_avaliacao.nr_nivel%type;
										

BEGIN

select max(nr_seq_tipo_avaliacao)
into STRICT nr_seq_tipo_avaliacao_w
from pre_cad_avaliacao
where nr_sequencia = nr_seq_avaliacao_p;

select max(nr_seq_precad_pf)
into STRICT nr_seq_precad_pf_w
from pre_cad_avaliacao
where nr_sequencia = nr_seq_avaliacao_p;

select max(nr_seq_precad_pj)
into STRICT nr_seq_precad_pj_w
from pre_cad_avaliacao
where nr_sequencia = nr_seq_avaliacao_p;

select max(nr_seq_precad_mat)
into STRICT nr_seq_precad_mat_w
from pre_cad_avaliacao
where nr_sequencia = nr_seq_avaliacao_p;

select max(nr_nivel)
into STRICT nr_nivel_w
from pre_cad_avaliacao
where nr_sequencia = nr_seq_avaliacao_p;

insert into pre_cad_avaliacao(nr_sequencia,
										nr_seq_tipo_avaliacao,
										cd_estabelecimento,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										nr_seq_precad_pf,
										nr_seq_precad_pj,
										nr_seq_precad_mat,
										ie_situacao,
										nr_nivel
										) values (
										nextval('pre_cad_avaliacao_seq'),
										nr_seq_tipo_avaliacao_w,
										cd_estabelecimento_p,
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										nr_seq_precad_pf_w,
										nr_seq_precad_pj_w,
										nr_seq_precad_mat_w,
										'A',
										nr_nivel_w);

update pre_cad_avaliacao set
dt_inativacao = clock_timestamp(),
nm_usuario_inativacao = nm_usuario_p
where nr_sequencia = nr_seq_avaliacao_p;

insert into processo_precad_hist(nr_sequencia,
										dt_atualizacao,
										nm_usuario,
										dt_atualizacao_nrec,
										nm_usuario_nrec,
										dt_liberacao,
										nm_usuario_lib,
										nr_seq_processo,
										ds_historico
										) values (
										nextval('processo_precad_hist_seq'),
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										clock_timestamp(),
										nm_usuario_p,
										nr_seq_processo_p,
										ie_tipo_acao_p);
										
CALL enviar_email_avaliacao_precad(nr_seq_processo_p,nr_seq_tipo_avaliacao_w,nr_nivel_w,nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE refazer_avaliacao (nm_usuario_p text, nr_seq_processo_p bigint, nr_seq_avaliacao_p bigint, ie_tipo_acao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

