-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_duplicar_classif_conjunto (nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_classif_conj_w	bigint;
nr_seq_conjunto_w	bigint;
nr_seq_conj_w		bigint;

/* variaveis do cursor c01 */

nm_conjunto_w			varchar(200);
ie_situacao_w			varchar(1);
nr_seq_embalagem_w		bigint;
ie_controle_fisico_w		varchar(1);
ds_conjunto_w			varchar(2000);
cd_estabelecimento_w		smallint;
qt_ponto_w			double precision;
cd_setor_atendimento_w		integer;
qt_limite_esterilizacao_w	bigint;
qt_tempo_esterelizacao_w	bigint;
dt_revisao_w			timestamp;
qt_min_intervalo_prep_w		integer;
ds_observacao_w			varchar(255);
ds_reduzida_w			varchar(20);
cd_especialidade_w		integer;
qt_consiste_agenda_w		integer;
cd_medico_w			varchar(10);
ie_agendamento_w		varchar(1);
ie_gerar_conj_auto_w		varchar(1);

C01 CURSOR FOR
	SELECT	nextval('cm_conjunto_seq'),
		nr_sequencia,
		substr(wheb_mensagem_pck.get_texto(310759) || ' ' || nm_conjunto,1,200),
		ie_situacao,
		nr_seq_embalagem,
		ie_controle_fisico,
		ds_conjunto,
		cd_estabelecimento,
		qt_ponto,
		cd_setor_atendimento,
		qt_limite_esterilizacao,
		qt_tempo_esterelizacao,
		dt_revisao,
		qt_min_intervalo_prep,
		ds_observacao,
		ds_reduzida,
		cd_especialidade,
		qt_consiste_agenda,
		cd_medico,
		ie_agendamento,
		ie_gerar_conj_auto
	from	cm_conjunto
	where	nr_seq_classif	= nr_sequencia_p;


BEGIN

select	nextval('cm_classif_conjunto_seq')
into STRICT	nr_seq_classif_conj_w
;

/* Classificação do conjunto */

insert into cm_classif_conjunto(
	nr_sequencia,
	ds_classificacao,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_situacao,
	ie_requisicao)
SELECT	nr_seq_classif_conj_w,
	substr(wheb_mensagem_pck.get_texto(310759) || ' ' || ds_classificacao,1,200),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ie_situacao,
	ie_requisicao
from	cm_classif_conjunto
where	nr_sequencia	= nr_sequencia_p;

/* Conjuntos, cotas e itens */

open C01;
loop
fetch C01 into
	nr_seq_conjunto_w,
	nr_seq_conj_w,
	nm_conjunto_w,
	ie_situacao_w,
	nr_seq_embalagem_w,
	ie_controle_fisico_w,
	ds_conjunto_w,
	cd_estabelecimento_w,
	qt_ponto_w,
	cd_setor_atendimento_w,
	qt_limite_esterilizacao_w,
	qt_tempo_esterelizacao_w,
	dt_revisao_w,
	qt_min_intervalo_prep_w,
	ds_observacao_w,
	ds_reduzida_w,
	cd_especialidade_w,
	qt_consiste_agenda_w,
	cd_medico_w,
	ie_agendamento_w,
	ie_gerar_conj_auto_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	/* Conjuntos */

	insert into cm_conjunto(
		nr_sequencia,
		nm_conjunto,
		nr_seq_classif,
		dt_atualizacao,
		nm_usuario,
		ie_situacao,
		nr_seq_embalagem,
		ie_controle_fisico,
		ds_conjunto,
		cd_estabelecimento,
		qt_ponto,
		cd_setor_atendimento,
		qt_limite_esterilizacao,
		qt_tempo_esterelizacao,
		dt_revisao,
		qt_min_intervalo_prep,
		ds_observacao,
		ds_reduzida,
		cd_especialidade,
		qt_consiste_agenda,
		cd_medico,
		ie_agendamento,
		ie_gerar_conj_auto)
	values (nr_seq_conjunto_w,
		nm_conjunto_w,
		nr_seq_classif_conj_w,
		clock_timestamp(),
		nm_usuario_p,
		ie_situacao_w,
		nr_seq_embalagem_w,
		ie_controle_fisico_w,
		ds_conjunto_w,
		cd_estabelecimento_w,
		qt_ponto_w,
		cd_setor_atendimento_w,
		qt_limite_esterilizacao_w,
		qt_tempo_esterelizacao_w,
		dt_revisao_w,
		qt_min_intervalo_prep_w,
		ds_observacao_w,
		ds_reduzida_w,
		cd_especialidade_w,
		qt_consiste_agenda_w,
		cd_medico_w,
		ie_agendamento_w,
		coalesce(ie_gerar_conj_auto_w,'S'));

	/* Cotas */

	insert into cm_conjunto_cota(
		nr_sequencia,
		cd_estabelecimento,
		qt_conjunto,
		ie_periodo,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_conjunto,
		cd_setor_atendimento,
		ie_situacao)
	SELECT	nextval('cm_conjunto_cota_seq'),
		cd_estabelecimento,
		qt_conjunto,
		ie_periodo,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_conjunto_w,
		cd_setor_atendimento,
		ie_situacao
	from	cm_conjunto_cota
	where	nr_seq_conjunto = nr_seq_conj_w;

	/* Itens */

	insert into cm_conjunto_item(
		nr_seq_conjunto,
		nr_seq_item,
		qt_item,
		dt_atualizacao,
		nm_usuario,
		ie_indispensavel)
	SELECT	nr_seq_conjunto_w,
		nr_seq_item,
		qt_item,
		clock_timestamp(),
		nm_usuario_p,
		ie_indispensavel
	from	cm_conjunto_item
	where	nr_seq_conjunto = nr_seq_conj_w;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_duplicar_classif_conjunto (nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
