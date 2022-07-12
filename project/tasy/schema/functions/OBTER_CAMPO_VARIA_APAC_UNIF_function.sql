-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_campo_varia_apac_unif ( nr_sequencia_p bigint, ie_exc_dt_sem_cid_p text default 'N') RETURNS varchar AS $body$
DECLARE


ie_tipo_laudo_apac_w		varchar(3);
ds_varia_w			varchar(141);
cd_forma_organizacao_w		integer;
dt_inicio_validade_w		sus_apac_unif.dt_inicio_validade%type;
dt_fim_validade_w		sus_apac_unif.dt_fim_validade%type;
dt_emissao_w			sus_apac_unif.dt_emissao%type;
ie_tipo_apac_w			sus_apac_unif.ie_tipo_apac%type;
ie_ajusta_radio_w		varchar(1) := 'N';


BEGIN

begin
select	a.ie_tipo_laudo_apac,
	c.cd_forma_organizacao,
	b.dt_inicio_validade,
	b.dt_fim_validade,
	b.dt_emissao,
	b.ie_tipo_apac
into STRICT	ie_tipo_laudo_apac_w,
	cd_forma_organizacao_w,
	dt_inicio_validade_w,
	dt_fim_validade_w,
	dt_emissao_w,
	ie_tipo_apac_w
from	sus_forma_organizacao c,
	sus_procedimento a,
	sus_apac_unif b
where	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	a.nr_seq_forma_org	= c.nr_sequencia
and	b.nr_sequencia		= nr_sequencia_p;
exception
when others then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(174179);
	/*'Problemas ao obter as inforamacoes para o campo varia.'*/

end;

if (trunc(dt_inicio_validade_w,'month') >= to_date('01/05/2019','dd/mm/yyyy')) then
	ie_ajusta_radio_w := 'S';
end if;

/*if	(ie_tipo_laudo_apac_w = '06') and
	(cd_forma_organizacao_w <> 60405) then*/
if (ie_tipo_laudo_apac_w = '06') then
	/*MEDIC*/

	begin
	select	'3' ||
		coalesce(rpad(qt_peso,3,' '),'   ') ||
		coalesce(lpad(qt_altura_cm,3,0),'   ') ||
		coalesce(ie_transplantado,'N') ||
		coalesce(lpad(CASE WHEN coalesce(ie_transplantado,'N')='S' THEN qt_transplante  ELSE 0 END ,2,0),'00') ||
		'  '||
		coalesce(ie_gestante,'N')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
		ds_varia_w := null;
		end;
elsif (ie_tipo_laudo_apac_w = '04') then
	/* RADIO */

	begin
	select	'R' ||
		coalesce(rpad(cd_cid_topografia,4,' '),'    ') ||
		coalesce(CASE WHEN ie_linfonodos_reg_inv='O' THEN '3'  ELSE ie_linfonodos_reg_inv END ,' ') ||
		coalesce(CASE WHEN coalesce(cd_estadio,99)=99 THEN ' '  ELSE to_char(CASE WHEN obter_valor_dominio(2502,cd_estadio)='0' THEN 0 WHEN obter_valor_dominio(2502,cd_estadio)='I' THEN 1 WHEN obter_valor_dominio(2502,cd_estadio)='II' THEN 2 WHEN obter_valor_dominio(2502,cd_estadio)='III' THEN 3 WHEN obter_valor_dominio(2502,cd_estadio)='IV' THEN 4  ELSE 4 END ) END ,' ') ||
		coalesce(lpad(substr(cd_grau_histopat,1,2),2,' '),'  ') ||
		coalesce(to_char(dt_diag_cito_hist,'YYYYMMDD'),'        ') ||
		coalesce(ie_tratamento_ant,' ') ||
		coalesce(rpad(cd_cid_primeiro_trat,4,' '),'    ') ||
		CASE WHEN ie_exc_dt_sem_cid_p='S' THEN			CASE WHEN coalesce(cd_cid_primeiro_trat,'X')='X' THEN '        '  ELSE coalesce(to_char(dt_pri_tratamento,'YYYYMMDD'),'        ') END   ELSE coalesce(to_char(dt_pri_tratamento,'YYYYMMDD'),'        ') END  ||
		coalesce(rpad(cd_cid_segundo_trat,4,' '),'    ') ||
		CASE WHEN ie_exc_dt_sem_cid_p='S' THEN 			CASE WHEN coalesce(cd_cid_segundo_trat,'X')='X' THEN '        '  ELSE coalesce(to_char(dt_seg_tratamento,'YYYYMMDD'),'        ') END   ELSE coalesce(to_char(dt_seg_tratamento,'YYYYMMDD'),'        ') END  ||
		coalesce(rpad(cd_cid_terceiro_trat,4,' '),'    ') ||
		CASE WHEN ie_exc_dt_sem_cid_p='S' THEN 			CASE WHEN coalesce(cd_cid_terceiro_trat,'X')='X' THEN '        '  ELSE coalesce(to_char(dt_ter_tratamento,'YYYYMMDD'),'        ') END   ELSE coalesce(to_char(dt_ter_tratamento,'YYYYMMDD'),'        ') END  ||
		coalesce(ie_tratamento_ant,' ') ||
		coalesce(to_char(dt_inicio_tratamento,'YYYYMMDD'),'        ') ||
		coalesce(ie_finalidade,' ') ||
		coalesce(rpad(cd_cid_pri_radiacao,4,' '),'    ') ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '    '  ELSE coalesce(rpad(cd_cid_seg_radiacao,4,' '),'    ') END  ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '    '  ELSE coalesce(rpad(cd_cid_ter_radiacao,4,' '),'    ') END  ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '   '  ELSE coalesce(lpad(nr_campos_pri_radi,3,0),'   ') END  ||
		coalesce(to_char(dt_inicio_pri_radi,'YYYYMMDD'),'        ') ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '        '  ELSE coalesce(to_char(dt_inicio_seg_radi,'YYYYMMDD'),'        ') END  ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '        '  ELSE coalesce(to_char(dt_inicio_ter_radi,'YYYYMMDD'),'        ') END  ||
		coalesce(to_char(dt_fim_pri_radi,'YYYYMMDD'),'        ') ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '        '  ELSE coalesce(to_char(dt_fim_seg_radi,'YYYYMMDD'),'        ') END  ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '        '  ELSE coalesce(to_char(dt_fim_ter_radi,'YYYYMMDD'),'        ') END  ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ') ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '   '  ELSE coalesce(lpad(nr_campos_seg_radi,3,0),'   ') END  ||
		CASE WHEN ie_ajusta_radio_w='S' THEN '   '  ELSE coalesce(lpad(nr_campos_ter_radi,3,0),'   ') END 		
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
			ds_varia_w := null;
	end;
elsif (ie_tipo_laudo_apac_w = '03') then
	/* QUIMIO */

	begin
	select	'Q' ||
		'    '||
                --nvl(rpad(cd_cid_topografia,4,' '),'    ') ||

		--nvl(decode(ie_linfonodos_reg_inv,'O','3',ie_linfonodos_reg_inv),' ') ||
                'S'||
		coalesce(CASE WHEN coalesce(cd_estadio,99)=99 THEN ' '  ELSE to_char(CASE WHEN obter_valor_dominio(2502,cd_estadio)='0' THEN 0 WHEN obter_valor_dominio(2502,cd_estadio)='I' THEN 1 WHEN obter_valor_dominio(2502,cd_estadio)='II' THEN 2 WHEN obter_valor_dominio(2502,cd_estadio)='III' THEN 3 WHEN obter_valor_dominio(2502,cd_estadio)='IV' THEN 4  ELSE 4 END ) END ,' ') ||
		coalesce(lpad(substr(cd_grau_histopat,1,2),2,' '),'  ') ||
		coalesce(to_char(dt_diag_cito_hist,'YYYYMMDD'),'        ') ||
		--nvl(ie_tratamento_ant,' ') ||
                ' '||
		coalesce(rpad(cd_cid_primeiro_trat,4,' '),'    ') ||
		CASE WHEN ie_exc_dt_sem_cid_p='S' THEN			CASE WHEN coalesce(cd_cid_primeiro_trat,'X')='X' THEN '        '  ELSE coalesce(to_char(dt_pri_tratamento,'YYYYMMDD'),'        ') END   ELSE coalesce(to_char(dt_pri_tratamento,'YYYYMMDD'),'        ') END  ||
		coalesce(rpad(cd_cid_segundo_trat,4,' '),'    ') ||
		CASE WHEN ie_exc_dt_sem_cid_p='S' THEN 			CASE WHEN coalesce(cd_cid_segundo_trat,'X')='X' THEN '        '  ELSE coalesce(to_char(dt_seg_tratamento,'YYYYMMDD'),'        ') END   ELSE coalesce(to_char(dt_seg_tratamento,'YYYYMMDD'),'        ') END  ||
		coalesce(rpad(cd_cid_terceiro_trat,4,' '),'    ') ||
		CASE WHEN ie_exc_dt_sem_cid_p='S' THEN 			CASE WHEN coalesce(cd_cid_terceiro_trat,'X')='X' THEN '        '  ELSE coalesce(to_char(dt_ter_tratamento,'YYYYMMDD'),'        ') END   ELSE coalesce(to_char(dt_ter_tratamento,'YYYYMMDD'),'        ') END  ||
		coalesce(ie_tratamento_ant,' ') ||
		coalesce(to_char(dt_inicio_tratamento,'YYYYMMDD'),'        ') ||
		coalesce(rpad(substr(ds_sigla_esquema,1,5),5,' '),'     ') ||
		coalesce(lpad(qt_meses_planejados,3,0),'   ') ||
		coalesce(lpad(qt_meses_autorizados,3,0),'   ') ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ') ||
		coalesce(rpad(substr(elimina_caracteres_especiais(ds_sigla_esquema),6,15),10,' '),'          ')|| 
                coalesce(lpad(cd_medic_antineo_1,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_2,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_3,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_4,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_5,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_6,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_7,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_8,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_9,3,'0'),'   ')||
                coalesce(lpad(cd_medic_antineo_10,3,'0'),'   ')
        into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
			ds_varia_w := null;
	end;
elsif (ie_tipo_laudo_apac_w = '02') or
	((ie_tipo_laudo_apac_w = '10') and (trunc(dt_inicio_validade_w) < to_date('01/07/2014','dd/mm/yyyy')) and (trunc(dt_emissao_w) < to_date('01/07/2014','dd/mm/yyyy')) and (trunc(dt_fim_validade_w) < to_date('01/08/2014','dd/mm/yyyy')) and (ie_tipo_apac_w = 2)) then
	/* NEFROLOGIA */

	begin
	select	'N' ||
		coalesce(to_char(dt_pri_dialise,'YYYYMMDD'),'        ') ||
		coalesce(lpad(substr(qt_altura_cm,1,3),3,0),'   ') ||
		coalesce(lpad(substr(qt_peso,1,3),3,0),'   ') ||
		coalesce(lpad(substr(qt_diurese,1,4),4,0),'    ') ||
		coalesce(lpad(substr(qt_glicose,1,4),4,0),'    ') ||
		coalesce(ie_acesso_vascular,' ') ||
		coalesce(ie_ultra_abdomen,' ') ||
		coalesce(lpad(substr(nr_tru,1,4),4,0),'    ') ||
		coalesce(lpad(substr(qt_interv_fistola,1,2),2,0),'  ') ||
		coalesce(ie_inscrito_cncdo,'N') ||
		coalesce(lpad(substr(pr_albumina,1,2),2,0),'  ') ||
		coalesce(CASE WHEN ie_hcv='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(CASE WHEN ie_hb_sangue='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(CASE WHEN ie_hiv='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(lpad(substr(pr_hb,1,2),2,0),'00') ||
		coalesce(rpad(substr(cd_cid_principal,1,4),4,' '),'    ') ||
		coalesce(rpad(substr(cd_cid_secundario,1,4),4,' '),'    ')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
			ds_varia_w := null;
	end;
/*elsif	(ie_tipo_laudo_apac_w = '00') or
	(cd_forma_organizacao_w = 60405) then*/
elsif	((ie_tipo_laudo_apac_w = '00') or (ie_tipo_laudo_apac_w = '07')) then	
	begin
	select	'O' ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
		when others then
			ds_varia_w := null;
	end;
elsif (ie_tipo_laudo_apac_w = '10') and
	((trunc(dt_inicio_validade_w) >= to_date('01/07/2014','dd/mm/yyyy')) or (trunc(dt_emissao_w) >= to_date('01/07/2014','dd/mm/yyyy')) or (trunc(dt_fim_validade_w) >= to_date('01/08/2014','dd/mm/yyyy')) or (ie_tipo_apac_w = 1))then
	begin
	
	begin
	select	'T' ||
		coalesce(rpad(substr(cd_cid_principal,1,4),4,' '),'    ') ||
		coalesce(rpad(substr(cd_cid_secundario,1,4),4,' '),'    ') ||
		coalesce(rpad(ie_caract_tratamento,1,' '),' ') ||
		coalesce(to_char(dt_pri_dialise,'YYYYMMDD'),'        ') ||
		coalesce(to_char(dt_inicio_dialise_cli,'YYYYMMDD'),'        ') ||
		coalesce(rpad(ie_acesso_vasc_dial,1,' '),' ') ||
		coalesce(rpad(ie_acomp_nefrol,1,' '),' ') ||
		coalesce(rpad(ie_situacao_usu_ini,1,' '),' ') ||
		coalesce(rpad(ie_situacao_trasp,1,' '),' ') ||
		coalesce(rpad(ie_dados_apto,1,' '),' ') ||
		coalesce(lpad(substr(pr_hb,1,4),4,0),'    ') ||
		coalesce(lpad(substr(qt_fosforo,1,4),4,0),'    ') ||
		coalesce(lpad(substr(qt_ktv_semanal,1,4),4,0),'    ') ||
		coalesce(lpad(substr(nr_tru,1,4),4,0),'    ') ||
		coalesce(lpad(substr(pr_albumina,1,4),4,0),'    ') ||
		coalesce(lpad(substr(qt_pth,1,4),4,0),'    ') ||
		coalesce(CASE WHEN ie_hiv='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(CASE WHEN ie_hcv='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(CASE WHEN ie_hb_sangue='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(ie_inter_clinica,'I') ||
		coalesce(ie_peritonite_diag,'I')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
	when others then
		ds_varia_w := null;
	end;
		
	end;
elsif (ie_tipo_laudo_apac_w = '11') then
	begin
	
	begin
	select	'M' ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ') ||
		coalesce(rpad(ie_caract_tratamento,1,' '),' ') ||
		coalesce(to_char(dt_inicio_tratamento,'YYYYMMDD'),'        ') ||
		coalesce(ie_encaminhado_fav,'N') ||
		coalesce(ie_encam_imp_cateter,'N') ||
		coalesce(lpad(qt_altura_cm,3,0),'   ') ||
		coalesce(lpad(qt_peso,3,0),'   ') ||
		coalesce(lpad(ie_situacao_vacina,1,' '),' ') ||
		coalesce(lpad(ie_anti_hbs,1,' '),' ') ||
		coalesce(ie_influenza,'I') ||
		coalesce(ie_difteria_tetano,'I') ||
		coalesce(ie_pneumococica,'I') ||
		coalesce(lpad(pr_hb,4,0),'    ') ||
		coalesce(lpad(qt_fosforo,4,0),'    ') ||
		coalesce(lpad(pr_albumina,4,0),'    ') ||
		coalesce(lpad(qt_pth,4,0),'    ') ||
		coalesce(CASE WHEN ie_hiv='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(CASE WHEN ie_hcv='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(CASE WHEN ie_hb_sangue='S' THEN 'P'  ELSE 'N' END ,'N') ||
		coalesce(ie_ieca,'I') ||
		coalesce(ie_bra,'I')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
	when others then
		ds_varia_w := null;
	end;
		
	end;
elsif (ie_tipo_laudo_apac_w = '12') then
	begin
	
	begin
	select	'F' ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ') ||
		coalesce(ie_duplex_previo,'N') ||
		coalesce(ie_cateter_outros,'N') ||
		coalesce(ie_fav_previas,'N') ||
		coalesce(ie_flebites,'N') ||
		coalesce(ie_hematomas,'N') ||
		coalesce(ie_veia_visivel,'N') ||
		coalesce(ie_presenca_pulso,'N') ||
		coalesce(lpad(qt_diametro_veia,4,0),'    ') ||
		coalesce(lpad(qt_diametro_arteria,4,0),'    ') ||
		coalesce(lpad(ie_fremito_traj_fav,1,' '),' ') ||
		coalesce(ie_pulso_fremito,'N')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
	when others then
		ds_varia_w := null;
	end;
		
	end;
elsif (ie_tipo_laudo_apac_w = '05') then
	begin
	
	begin
	select	'B' ||
		coalesce(rpad(qt_icm_atual_pac,3,' '),'   ') ||
		coalesce(rpad(pr_exces_peso_perd,3,' '),'   ') ||
		coalesce(rpad(qt_kilogr_perdido,3,' '),'   ') ||
		coalesce(ie_gastrec_desv_duode,'N') ||
		coalesce(ie_gastrec_vert_manga,'N') ||
		coalesce(ie_gastrec_deri_intes,'N') ||
		coalesce(ie_gastrec_vert_banda,'N') ||
		coalesce(to_char(dt_cirur_bariatrica,'YYYYMMDD'),'        ') ||
		coalesce(lpad(nr_aih_bariatrica,13,'0'),'0000000000000') ||
		' '||
		coalesce(ie_comorbidades,'N') ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_i10,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_o243,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_e780,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_m190,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_g473,'N') END  ||
		coalesce(rpad(cd_cid_outro_comor,4,' '),'    ') ||
		coalesce(ie_uso_medicamento,'N') ||
		coalesce(ie_pratica_ativ_fisica,'N') ||
		coalesce(ie_uso_polivitaminico,'N') ||
		coalesce(ie_reganho_peso,'N') ||
		coalesce(ie_ades_alim_saud,'N') ||
		coalesce(ie_dermo_abdominal,'N') ||
		coalesce(rpad(qt_dermo_abdominal,3,' '),'   ') ||
		coalesce(ie_mamoplastia,'N') ||
		coalesce(rpad(qt_mamoplastia,3,' '),'   ') ||
		coalesce(ie_dermo_braquial,'N') ||
		coalesce(rpad(qt_dermo_braquial,3,' '),'   ') ||
		coalesce(ie_dermo_crural,'N') ||
		coalesce(rpad(qt_dermo_crural,3,' '),'   ') ||
		coalesce(ie_reconst_microcir,'N') ||
		coalesce(rpad(qt_reconst_microcir,3,' '),'   ') ||
		'     '||
		coalesce(rpad(qt_meses_acompanha,2,' '),'  ') ||
		coalesce(rpad(qt_anos_acompanha,4,' '),'    ') ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
	when others then
		ds_varia_w := null;
	end;
	
	end;
elsif (ie_tipo_laudo_apac_w = '09') then
	begin
	
	begin
	select	'P' ||
		coalesce(rpad(qt_icm_atual_pac,3,' '),'   ') ||
		coalesce(to_char(dt_avaliacao_atual,'YYYYMMDD'),'        ') ||
		coalesce(rpad(qt_peso,3,' '),'   ') ||
		coalesce(rpad(qt_imc_pri_avaliacao,3,' '),'   ') ||
		coalesce(to_char(dt_pri_avaliacao,'YYYYMMDD'),'        ') ||
		coalesce(ie_aval_nutricionista,'N') ||
		coalesce(ie_aval_med_psiquiatr,'N') ||
		coalesce(ie_aval_cirur_geral,'N') ||
		coalesce(ie_aval_psicologo,'N') ||
		coalesce(ie_aval_endocrino,'N') ||
		coalesce(ie_aval_med_clinico,'N') ||
		coalesce(ie_aval_cirur_digesti,'N') ||
		coalesce(ie_grupo_multiprofis,'N') ||
		coalesce(ie_aval_risco_cirurg,'N') ||
		coalesce(ie_real_exam_laborat,'N') ||
		coalesce(ie_comorbidades,'N') ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_i10,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_o243,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_e780,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_m190,'N') END  ||
		CASE WHEN coalesce(ie_comorbidades,'N')='N' THEN ' '  ELSE coalesce(ie_cid_g473,'N') END  ||
		coalesce(rpad(cd_cid_outro_comor,4,' '),'    ') ||
		coalesce(ie_uso_medicamento,'N') ||
		coalesce(ie_uso_polivitaminico,'N') ||
		coalesce(ie_perda_peso_pre_op,'N') ||
		coalesce(ie_esofagogastroduo,'N') ||
		coalesce(ie_ultr_abdomen_tot,'N') ||
		coalesce(ie_ecocardio_transt,'N') ||
		coalesce(ie_ultras_doppl_col,'N') ||
		coalesce(ie_prova_pulmon_bro,'N') ||
		CASE WHEN coalesce(ie_apto_proc_cirurg,'N')='P' THEN 'A'  ELSE coalesce(ie_apto_proc_cirurg,'N') END  ||
		coalesce(rpad(cd_cid_principal,4,' '),'    ') ||
		coalesce(rpad(cd_cid_secundario,4,' '),'    ')
	into STRICT	ds_varia_w
	from	sus_apac_unif
	where	nr_sequencia	= nr_sequencia_p;
	exception
	when others then
		ds_varia_w := null;
	end;
	
	end;
end if;

return ds_varia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_campo_varia_apac_unif ( nr_sequencia_p bigint, ie_exc_dt_sem_cid_p text default 'N') FROM PUBLIC;
