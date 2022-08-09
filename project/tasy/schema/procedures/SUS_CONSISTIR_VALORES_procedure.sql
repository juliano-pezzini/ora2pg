-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consistir_valores (nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_atendimento_w	bigint;
nr_interno_conta_w	bigint;
nr_aih_w		bigint;
vl_sh_w			double precision;
vl_sp_w			double precision;
vl_sadt_w		double precision;
vl_opm_w		double precision;
vl_sangue_w		double precision;
vl_recem_nato_w		double precision;
vl_uti_w		double precision;
vl_acomp_w		double precision;
vl_uti_nn_w		double precision;
vl_neuro_w		double precision;
vl_transp_w		double precision;
qt_pto_sp_w		double precision;
vl_pto_sp_w		double precision;
vl_analg_w		double precision;
vl_nutri_w		double precision;
vl_comp1_w		double precision;
vl_agrav_w		double precision;
vl_rcivil_w		double precision;
vl_sifilis_hiv_w	double precision;
vl_total_w		double precision;

c01 CURSOR FOR 
	SELECT	nr_aih, 
		vl_serv_hosp, 
		vl_serv_prof, 
		vl_sadt, 
		vl_opm, 
		vl_sangue, 
		vl_recem_nato, 
		vl_uti, 
		vl_acompanhante, 
		vl_uti_nn, 
		vl_neuro, 
		vl_transplante, 
		qt_ponto_sp, 
		vl_ponto_sp, 
		vl_analgesia, 
		vl_nutricao, 
		vl_componente, 
		vl_notif_agravo, 
		vl_reg_civil, 
		vl_sifilis_hiv, 
		(vl_serv_hosp + vl_serv_prof + vl_sadt + vl_opm + vl_sangue + 
		 vl_recem_nato + vl_uti + vl_acompanhante + vl_uti_nn + vl_neuro + 
		 vl_transplante + vl_analgesia + vl_nutricao + vl_componente + vl_notif_agravo + 
		 vl_reg_civil + vl_sifilis_hiv) 
	from	sus_daih160 
	where	nr_seq_protocolo = nr_seq_protocolo_p 
	 and	ie_tipo_valor = 'C';

BEGIN
 
delete FROM sus_daih160 
where nr_seq_protocolo = nr_seq_protocolo_p 
 and ie_tipo_valor = 'D';
 
open c01;
loop 
fetch c01 into	nr_aih_w, 
		vl_sh_w, 
		vl_sp_w, 
		vl_sadt_w, 
		vl_opm_w, 
		vl_sangue_w, 
		vl_recem_nato_w, 
		vl_uti_w, 
		vl_acomp_w, 
		vl_uti_nn_w, 
		vl_neuro_w, 
		vl_transp_w, 
		qt_pto_sp_w, 
		vl_pto_sp_w, 
		vl_analg_w, 
		vl_nutri_w, 
		vl_comp1_w, 
		vl_agrav_w, 
		vl_rcivil_w, 
		vl_sifilis_hiv_w, 
		vl_total_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
	select coalesce(max(a.nr_atendimento),0), 
	    coalesce(max(a.nr_interno_conta),0), 
	    coalesce(qt_pto_sp_w 	- sum(CASE WHEN CASE WHEN c.ie_tipo_servico_sus=4 THEN 1 WHEN c.ie_tipo_servico_sus=6 THEN 1 WHEN c.ie_tipo_servico_sus=7 THEN 1  ELSE 0 END =1 THEN h.qt_ato_medico  ELSE 0 END ),0) qt_ato_sp, 
	    coalesce(vl_sh_w 	- sum(CASE WHEN g.cd_grupo_sus=3 THEN h.vl_matmed WHEN g.cd_grupo_sus=6 THEN h.vl_matmed  ELSE 0 END ),0) vl_sh, 
	    coalesce(vl_sp_w		- sum(CASE WHEN g.cd_grupo_sus=10 THEN 0  ELSE h.vl_medico END ),0) vl_sp, 
	    coalesce(vl_sadt_w	- sum(h.vl_sadt),0) vl_sadt, 
	    coalesce(vl_uti_w	- sum(CASE WHEN g.cd_grupo_sus=4 THEN h.vl_matmed  ELSE 0 END ),0) vl_uti_esp, 
	    coalesce(vl_acomp_w	- sum(CASE WHEN g.cd_grupo_sus=5 THEN h.vl_matmed  ELSE 0 END ),0) vl_acomp, 
	    coalesce(vl_sangue_w	- sum(CASE WHEN g.cd_grupo_sus=7 THEN h.vl_matmed  ELSE 0 END ),0) vl_sangue, 
	    coalesce(vl_transp_w	- sum(CASE WHEN g.cd_grupo_sus=8 THEN h.vl_matmed  ELSE 0 END ),0) vl_transp, 
	    coalesce(vl_neuro_w	- sum(CASE WHEN g.cd_grupo_sus=9 THEN h.vl_matmed  ELSE 0 END ),0) vl_neuro, 
	    coalesce(vl_recem_nato_w	- sum(CASE WHEN g.cd_grupo_sus=10 THEN h.vl_matmed  ELSE 0 END ),0) vl_rn, 
	    coalesce(vl_opm_w	- sum(CASE WHEN g.cd_grupo_sus=11 THEN h.vl_matmed  ELSE 0 END ),0) vl_opm, 
	    coalesce(vl_uti_nn_w	- sum(CASE WHEN g.cd_grupo_sus=12 THEN h.vl_matmed  ELSE 0 END ),0) vl_uti, 
	    coalesce(vl_analg_w	- sum(CASE WHEN g.cd_grupo_sus=13 THEN h.vl_matmed  ELSE 0 END ),0) vl_analg, 
	    coalesce(vl_nutri_w	- sum(CASE WHEN g.cd_grupo_sus=14 THEN h.vl_matmed  ELSE 0 END ),0) vl_nutri, 
	    coalesce(vl_comp1_w	- sum(CASE WHEN g.cd_grupo_sus=15 THEN h.vl_matmed  ELSE 0 END ),0) vl_comp1, 
	    coalesce(vl_agrav_w	- sum(CASE WHEN g.cd_grupo_sus=16 THEN h.vl_matmed  ELSE 0 END ),0) vl_agrav, 
	    coalesce(vl_rcivil_w	- sum(CASE WHEN g.cd_grupo_sus=17 THEN h.vl_matmed  ELSE 0 END ),0) vl_rcivil, 
	    coalesce(vl_total_w	- sum(h.vl_sadt + h.vl_matmed + h.vl_medico + coalesce(h.vl_ato_anestesista,0)),0) vl_total 
	into STRICT	nr_atendimento_w, 
		nr_interno_conta_w, 
		qt_pto_sp_w, 
		vl_sh_w, 
		vl_sp_w, 
		vl_sadt_w, 
		vl_uti_w, 
		vl_acomp_w, 
		vl_sangue_w, 
		vl_transp_w, 
		vl_neuro_w, 
		vl_recem_nato_w, 
		vl_opm_w, 
		vl_uti_nn_w, 
		vl_analg_w, 
		vl_nutri_w, 
		vl_comp1_w, 
		vl_agrav_w, 
		vl_rcivil_w, 
		vl_total_w 
	from	procedimento g, 
		sus_aih a, 
		procedimento_paciente c, 
		sus_valor_proc_paciente h, 
		conta_paciente d 
	where c.nr_interno_conta	= d.nr_interno_conta 
	 and c.nr_sequencia		= h.nr_sequencia 
	 and d.nr_interno_conta	= a.nr_interno_conta 
	 and c.cd_procedimento		= g.cd_procedimento 
	 and c.ie_origem_proced	= g.ie_origem_proced 
	 and coalesce(c.cd_motivo_exc_conta::text, '') = '' 
	 and d.nr_seq_protocolo = nr_seq_protocolo_p 
	 and a.nr_aih		 = nr_aih_w 
	 and coalesce(d.ie_cancelamento::text, '') = '';
 
	if (vl_total_w <> 0) then 
		insert into sus_daih160(nr_sequencia, nr_seq_protocolo, nr_interno_conta, nr_atendimento, nr_aih, 
			 ie_tipo_valor, nm_usuario, dt_atualizacao, vl_serv_hosp, vl_serv_prof, 
			 vl_sadt, vl_opm, vl_sangue, vl_recem_nato, vl_uti, 
			 vl_acompanhante, vl_uti_nn, vl_neuro, vl_transplante, qt_ponto_sp, 
			 vl_ponto_sp, vl_analgesia, vl_nutricao, vl_componente, vl_notif_agravo, 
			 vl_reg_civil, vl_sifilis_hiv, vl_total) 
		values (nextval('sus_daih160_seq'), nr_seq_protocolo_p, nr_interno_conta_w, nr_atendimento_w, nr_aih_w, 
			'D', nm_usuario_p, clock_timestamp(), vl_sh_w, vl_sp_w, 
			vl_sadt_w, vl_opm_w, vl_sangue_w, vl_recem_nato_w, vl_uti_w, 
			vl_acomp_w, vl_uti_nn_w, vl_neuro_w, vl_transp_w, qt_pto_sp_w, 
			vl_pto_sp_w, vl_analg_w, vl_nutri_w, vl_comp1_w, vl_agrav_w, 
			vl_rcivil_w, vl_sifilis_hiv_w, vl_total_w);
	end if;
 
end loop;
close c01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consistir_valores (nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
