-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE colunas AS (nm_coluna_w varchar(255));


CREATE OR REPLACE PROCEDURE gerar_w_painel_quimio (cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
/* vetor */
type vetor is table of colunas index by integer;

/* globais */
 
vetor_w				vetor;
nr_seq_grupo_w			bigint;
i				integer;
cd_status_quimio_w		varchar(10);
qt_tempo_apresent_pac_mapa_w	bigint;
ie_somente_agendamentos_dia_w 	varchar(1);
nr_seq_apres_w			integer;

c01 CURSOR FOR 
	SELECT nr_sequencia 
	from	qt_local_grupo 
	where	ie_situacao = 'A' 
	and	((cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0)) 
	order by 1;

c02 CURSOR FOR 
	SELECT b.nr_seq_apres, 
		'SEQ=' || b.nr_sequencia || ';' || 
		'DESC=' || coalesce(b.ds_abrev,b.ds_local) || ';' || 
 		'HINT=' || a.nr_atendimento || '-' || substr(obter_nome_pf(a.cd_pessoa_fisica),1,59) || ';' || 
		'STATUS=' || substr(obter_status_painel_quimio(b.nr_sequencia, a.nr_sequencia,'AQ'),1,5)|| ';' || 
 		'SEQAGE=' || a.nr_sequencia || ';' || 
 		'ATEND=' || a.nr_atendimento 
	from	agenda_quimio a, 
		qt_local b 
	where	a.nr_seq_local 		= b.nr_sequencia 
	and 	b.nr_seq_grupo_quimio 	= nr_seq_grupo_w		 
	and	a.ie_status_agenda	= 'Q' 
	and	coalesce(b.ie_situacao,'A') = 'A' 
	and	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0)) 
	and	((b.cd_setor_atendimento = cd_setor_atendimento_p) or (cd_setor_atendimento_p = 0)) 
	and	(clock_timestamp()	<= (a.dt_agenda + (qt_tempo_apresent_pac_mapa_w / 1440)) or (qt_tempo_apresent_pac_mapa_w = 0)) 
	and	((trunc(a.dt_agenda) = trunc(clock_timestamp())) or (ie_somente_agendamentos_dia_w = 'N')) 
	
union
 
	SELECT b.nr_seq_apres, 
		'SEQ=' || b.nr_sequencia || ';' || 
		'DESC=' || coalesce(b.ds_abrev,b.ds_local) || ';' || 
 		'HINT=' || a.nr_atendimento || '-' || substr(obter_nome_paciente_setor(a.nr_seq_paciente),1,59) || '- ' || wheb_mensagem_pck.get_texto(802308) || ' ' || a.nr_ciclo || '- ' || wheb_mensagem_pck.get_texto(802309) || ' ' || a.ds_dia_ciclo || '-' || a.dt_Real || ';' || 
		'STATUS=' || substr(obter_status_painel_quimio(b.nr_sequencia, a.nr_seq_atendimento,'Q'),1,5)|| ';' || 
 		'SEQAGE=' || a.nr_seq_atendimento|| ';' || 
 		'ATEND=' || a.nr_atendimento 
	from	paciente_atendimento a, 
		qt_local b 
	where	a.nr_seq_local 		= b.nr_sequencia 
	and 	b.nr_seq_grupo_quimio 	= nr_seq_grupo_w		 
	and	Qt_Obter_Status_Mapa(obter_status_paciente_qt(a.nr_seq_atendimento,a.dt_inicio_adm,a.dt_fim_adm,a.nr_seq_local,a.ie_exige_liberacao,a.dt_chegada,'C'), cd_status_quimio_w) = 'S' 
	and	coalesce(b.ie_situacao,'A') = 'A' 
	and	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0)) 
	and	((b.cd_setor_atendimento = cd_setor_atendimento_p) or (cd_setor_atendimento_p = 0)) 
	and	(clock_timestamp()	<= (a.dt_real + (qt_tempo_apresent_pac_mapa_w / 1440)) or (qt_tempo_apresent_pac_mapa_w = 0)) 
	and	((trunc(a.dt_real) = trunc(clock_timestamp())) or (ie_somente_agendamentos_dia_w = 'N')) 
	
union all
 
	Select b.nr_seq_apres, 
		'SEQ=' || b.nr_sequencia || ';' || 
		'DESC=' || coalesce(b.ds_abrev,b.ds_local) || ';' || 
 		'HINT=' || coalesce(b.ds_abrev,b.ds_local) || ';' || 
		'STATUS=' || substr(obter_status_painel_quimio(b.nr_sequencia, null,'AQ'),1,5)|| ';' || 
 		'SEQAGE=' || null|| ';' || 
 		'ATEND=' || null 
	from	qt_local b 
	where 	b.nr_seq_grupo_quimio = nr_seq_grupo_w	 
	and not exists (select 1 
			from 	agenda_quimio x 
			where 	x.nr_seq_local 		= b.nr_sequencia 
			and	x.ie_status_agenda	= 'Q' 
			and	(clock_timestamp()	<= (x.dt_agenda + (qt_tempo_apresent_pac_mapa_w / 1440)) or (qt_tempo_apresent_pac_mapa_w = 0)) 
			and	((trunc(x.dt_agenda) = trunc(clock_timestamp())) or (ie_somente_agendamentos_dia_w = 'N'))) 
	and not exists (select 1 
			from 	paciente_atendimento x 
			where 	x.nr_seq_local 		= b.nr_sequencia 
			and	Qt_Obter_Status_Mapa(obter_status_paciente_qt(x.nr_seq_atendimento,x.dt_inicio_adm,x.dt_fim_adm,x.nr_seq_local,x.ie_exige_liberacao,x.dt_chegada,'C'), cd_status_quimio_w) = 'S' 
			and	(clock_timestamp()	<= (x.dt_real + (qt_tempo_apresent_pac_mapa_w / 1440)) or (qt_tempo_apresent_pac_mapa_w = 0)) 
			and	((trunc(x.dt_real) = trunc(clock_timestamp())) or (ie_somente_agendamentos_dia_w = 'N'))) 
	and	coalesce(b.ie_situacao,'A') = 'A' 
	and	((b.cd_estabelecimento = cd_estabelecimento_p) or (cd_estabelecimento_p = 0)) 
	and	((b.cd_setor_atendimento = cd_setor_atendimento_p) or (cd_setor_atendimento_p = 0)) 
	order by 1;
	
 

BEGIN 
 
cd_status_quimio_w		:= coalesce(obter_valor_param_usuario(865, 34, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), '81');
qt_tempo_apresent_pac_mapa_w	:= coalesce(obter_valor_param_usuario(865, 136, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 0);
ie_somente_agendamentos_dia_w	:= coalesce(obter_valor_param_usuario(865, 194, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p), 'N');
CALL exec_sql_dinamico('','truncate table w_painel_quimio');
 
OPEN c01;
LOOP 
FETCH c01 INTO 
	nr_seq_grupo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
	for i in 1..40 loop 
		begin 
			vetor_w[i].nm_coluna_w := null;
		end;
	end loop;
	 
	i := 1;
	OPEN c02;
	LOOP 
	FETCH c02 INTO	 
		nr_seq_apres_w, 
		vetor_w[i].nm_coluna_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		i := i + 1;
	END LOOP;
	CLOSE c02;	
	 
	insert into w_painel_quimio( 
		CD_ITEM, 
		DS_ITEM1, 
		DS_ITEM2, 
		DS_ITEM3, 
		DS_ITEM4, 
		DS_ITEM5, 
		DS_ITEM6, 
		DS_ITEM7, 
		DS_ITEM8, 
		DS_ITEM9, 
		DS_ITEM10, 
		DS_ITEM11, 
		DS_ITEM12, 
		DS_ITEM13, 
		DS_ITEM14, 
		DS_ITEM15, 
		DS_ITEM16, 
		DS_ITEM17, 
		DS_ITEM18, 
		DS_ITEM19, 
		DS_ITEM20, 
		DS_ITEM21, 
		DS_ITEM22, 
		DS_ITEM23, 
		DS_ITEM24, 
		DS_ITEM25, 
		DS_ITEM26, 
		DS_ITEM27, 
		DS_ITEM28, 
		DS_ITEM29, 
		DS_ITEM30, 
		DS_ITEM31, 
		DS_ITEM32, 
		DS_ITEM33, 
		DS_ITEM34, 
		DS_ITEM35, 
		DS_ITEM36, 
		DS_ITEM37, 
		DS_ITEM38, 
		DS_ITEM39, 
		DS_ITEM40        
	) values ( 
		nr_seq_grupo_w, 
		vetor_w[1].nm_coluna_w, 
		vetor_w[2].nm_coluna_w, 
		vetor_w[3].nm_coluna_w, 
		vetor_w[4].nm_coluna_w, 
		vetor_w[5].nm_coluna_w, 
		vetor_w[6].nm_coluna_w, 
		vetor_w[7].nm_coluna_w, 
		vetor_w[8].nm_coluna_w, 
		vetor_w[9].nm_coluna_w, 
		vetor_w[10].nm_coluna_w, 
		vetor_w[11].nm_coluna_w, 
		vetor_w[12].nm_coluna_w, 
		vetor_w[13].nm_coluna_w, 
		vetor_w[14].nm_coluna_w, 
		vetor_w[15].nm_coluna_w, 
		vetor_w[16].nm_coluna_w, 
		vetor_w[17].nm_coluna_w, 
		vetor_w[18].nm_coluna_w, 
		vetor_w[19].nm_coluna_w, 
		vetor_w[20].nm_coluna_w, 
		vetor_w[21].nm_coluna_w, 
		vetor_w[22].nm_coluna_w, 
		vetor_w[23].nm_coluna_w, 
		vetor_w[24].nm_coluna_w, 
		vetor_w[25].nm_coluna_w, 
		vetor_w[26].nm_coluna_w, 
		vetor_w[27].nm_coluna_w, 
		vetor_w[28].nm_coluna_w, 
		vetor_w[29].nm_coluna_w, 
		vetor_w[30].nm_coluna_w, 
		vetor_w[31].nm_coluna_w, 
		vetor_w[32].nm_coluna_w, 
		vetor_w[33].nm_coluna_w, 
		vetor_w[34].nm_coluna_w, 
		vetor_w[35].nm_coluna_w, 
		vetor_w[36].nm_coluna_w, 
		vetor_w[37].nm_coluna_w, 
		vetor_w[38].nm_coluna_w, 
		vetor_w[39].nm_coluna_w, 
		vetor_w[40].nm_coluna_w 
		);
		 
	 
END LOOP;
CLOSE c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_painel_quimio (cd_estabelecimento_p bigint, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
