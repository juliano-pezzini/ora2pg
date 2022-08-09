-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualiza_compara_preco ( nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
 
nr_sequencia_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
cd_proc_unif_w		bigint;
ie_origem_proc_unif_w	bigint;
qt_ato_medico_w		bigint	:= 0;
qt_ato_anestesista_w	bigint	:= 0;
vl_matmed_w		double precision	:= 0;
vl_diaria_w		double precision	:= 0;
vl_taxas_w		double precision	:= 0;
vl_medico_w		double precision	:= 0;
vl_sadt_w		double precision	:= 0;
vl_contraste_w		double precision	:= 0;
vl_gesso_w		double precision	:= 0;
vl_quimioterapia_w	double precision	:= 0;
vl_dialise_w		double precision	:= 0;
vl_tph_w		double precision	:= 0;
vl_filme_rx_w		double precision	:= 0;
vl_filme_ressonancia_w	double precision	:= 0;
vl_anestesia_w		double precision	:= 0;
vl_sadt_rx_w		double precision	:= 0;
vl_sadt_pc_w		double precision	:= 0;
vl_outros_w		double precision	:= 0;
vl_ato_medico_w		double precision	:= 0;
vl_ato_anestesista_w	double precision	:= 0;
vl_procedimento_w	double precision	:= 0;
cd_porte_w		smallint;
dt_competencia_w	timestamp		:= clock_timestamp();
dt_comp_unif_w		timestamp		:= clock_timestamp();
ie_versao_w		varchar(20);
vl_adic_plant_w		double precision	:= 0;
vl_sa_unif_w		double precision	:= 0;
vl_sh_unif_w		double precision	:= 0;
vl_sp_unif_w		double precision	:= 0;
vl_sadt_unif_w		double precision	:= 0;
vl_total_hosp_unif_w	double precision	:= 0;
vl_total_amb_unif_w	double precision	:= 0;
vl_proc_unif_w		double precision	:= 0;
qt_pontos_ato_unif_w	integer	:= 0;
cd_reg_proc_w		smallint;
nr_seq_regra_w		bigint	:= 0;
vl_aux_w		double precision;

 
C01 CURSOR FOR 
	SELECT	cd_procedimento, 
		ie_origem_proced, 
		cd_proc_unif, 
		ie_origem_proc_unif 
	from	sus_origem 
	order by cd_procedimento;

 

BEGIN 
 
OPEN C01;
LOOP 
FETCH C01 into 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	cd_proc_unif_w, 
	ie_origem_proc_unif_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	/* Obter os valores do procedimento */
 
	SELECT * FROM define_preco_proc_sus(clock_timestamp(), cd_procedimento_w, ie_origem_proced_w, cd_estabelecimento_p, qt_ato_medico_w, qt_ato_anestesista_w, vl_matmed_w, vl_diaria_w, vl_taxas_w, vl_medico_w, vl_sadt_w, vl_contraste_w, vl_gesso_w, vl_quimioterapia_w, vl_dialise_w, vl_tph_w, vl_filme_rx_w, vl_filme_ressonancia_w, vl_anestesia_w, vl_sadt_rx_w, vl_sadt_pc_w, vl_outros_w, vl_ato_medico_w, vl_ato_anestesista_w, vl_procedimento_w, cd_porte_w, dt_competencia_w, ie_versao_w, vl_adic_plant_w) INTO STRICT qt_ato_medico_w, qt_ato_anestesista_w, vl_matmed_w, vl_diaria_w, vl_taxas_w, vl_medico_w, vl_sadt_w, vl_contraste_w, vl_gesso_w, vl_quimioterapia_w, vl_dialise_w, vl_tph_w, vl_filme_rx_w, vl_filme_ressonancia_w, vl_anestesia_w, vl_sadt_rx_w, vl_sadt_pc_w, vl_outros_w, vl_ato_medico_w, vl_ato_anestesista_w, vl_procedimento_w, cd_porte_w, dt_competencia_w, ie_versao_w, vl_adic_plant_w;
 
	if (ie_origem_proced_w = 2) then 
		vl_procedimento_w	:= vl_medico_w + vl_matmed_w + vl_sadt_w;
	end if;
 
	/* Obter os valores do procedimento unificado */
 
	SELECT * FROM Sus_Define_Preco_Proced( 
		clock_timestamp(), cd_proc_unif_w, ie_origem_proc_unif_w, cd_estabelecimento_p, null, vl_sa_unif_w, vl_sh_unif_w, vl_sp_unif_w, vl_sadt_unif_w, vl_total_hosp_unif_w, vl_total_amb_unif_w, qt_pontos_ato_unif_w, vl_aux_w, vl_aux_w, vl_aux_w, dt_comp_unif_w) INTO STRICT vl_sa_unif_w, vl_sh_unif_w, vl_sp_unif_w, vl_sadt_unif_w, vl_total_hosp_unif_w, vl_total_amb_unif_w, qt_pontos_ato_unif_w, vl_aux_w, vl_aux_w, vl_aux_w, dt_comp_unif_w;
 
	cd_reg_proc_w	:= sus_obter_tiporeg_proc(cd_proc_unif_w, ie_origem_proc_unif_w, 'C', 0);
 
	if (cd_reg_proc_w in (1,2)) then 
		vl_proc_unif_w	:= vl_total_amb_unif_w;
	elsif (cd_reg_proc_w in (3,4,5)) then 
		vl_proc_unif_w	:= vl_sh_unif_w + vl_sp_unif_w + vl_sadt_unif_w;
	end if;
 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_seq_regra_w 
	from	sus_compara_preco_proc 
	where	cd_procedimento		= cd_procedimento_w 
	and	ie_origem_proced	= ie_origem_proced_w 
	and	cd_proc_unif		= cd_proc_unif_w 
	and	ie_origem_proc_unif	= ie_origem_proc_unif_w;
 
	if (nr_seq_regra_w		= 0) then 
		select	nextval('sus_compara_preco_proc_seq') 
		into STRICT	nr_sequencia_w 
		;
 
		insert into sus_compara_preco_proc(nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			cd_procedimento, 
			ie_origem_proced, 
			vl_medico, 
			vl_matmed, 
			vl_sadt, 
			vl_procedimento, 
			qt_ato_medico, 
			cd_proc_unif, 
			ie_origem_proc_unif, 
			vl_sp_unif, 
			vl_sh_unif, 
			vl_sadt_unif, 
			vl_procedimento_unif, 
			qt_pontos_ato_unif) 
		values (nr_sequencia_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_procedimento_w, 
			ie_origem_proced_w, 
			vl_medico_w, 
			vl_matmed_w, 
			vl_sadt_w, 
			vl_procedimento_w, 
			qt_ato_medico_w, 
			cd_proc_unif_w, 
			ie_origem_proc_unif_w, 
			vl_sp_unif_w, 
			vl_sh_unif_w, 
			vl_sadt_unif_w, 
			vl_proc_unif_w, 
			qt_pontos_ato_unif_w);
	elsif (nr_seq_regra_w		> 0) then 
		update	sus_compara_preco_proc 
		set	dt_atualizacao		= clock_timestamp(), 
			nm_usuario		= nm_usuario_p, 
			cd_procedimento		= cd_procedimento_w, 
			ie_origem_proced	= ie_origem_proced_w, 
			vl_medico		= vl_medico_w, 
			vl_matmed		= vl_matmed_w, 
			vl_sadt			= vl_sadt_w, 
			vl_procedimento		= vl_procedimento_w, 
			qt_ato_medico		= qt_ato_medico_w, 
			cd_proc_unif		= cd_proc_unif_w, 
			ie_origem_proc_unif	= ie_origem_proc_unif_w, 
			vl_sp_unif		= vl_sp_unif_w, 
			vl_sh_unif		= vl_sh_unif_w, 
			vl_sadt_unif		= vl_sadt_unif_w, 
			vl_procedimento_unif	= vl_proc_unif_w, 
			qt_pontos_ato_unif	= qt_pontos_ato_unif_w 
		where	nr_sequencia		= nr_seq_regra_w;
	end if;
	end;
END LOOP;
CLOSE C01;
 
commit;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualiza_compara_preco ( nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
