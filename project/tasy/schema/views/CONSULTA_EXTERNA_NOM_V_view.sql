-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_externa_nom_v (ie_tipo_registro, cabecario, clues, curpprestador, nombreprestador, primerapellidoprestador, segundoapellidoprestador, tipopersonal, especificatipopersonal, cedulaprofesional, servicioatencion, curppaciente, nombre, primerapellido, segundoapellido, fechanacimiento, entidadnacimiento, edad, claveedad, sexo, seconsideraindigena, spss, numeroafiliacionspss, prospera, folioprospera, imss, numeroafiliacionimss, issste, numeroafiliacionissste, otraafiliacion, numerootraafiliacion, peso, talla, tipodificultad, gradodificultad, origendificultad, migrante, fechaconsulta, relaciontemporal, descripciondiagnostico1, primeravezdiagnostico1, suivecausesdiagnostico1, codigociediagnostico1, descripciondiagnostico2, primeravezdiagnostico2, suivecausesdiagnostico2, codigociediagnostico2, primeravezanio, imc10, sintomaticorespiratoriotb, relaciontemporalembarazo, trimestregestacional, primeravezaltoriesgo, complicacionpordiabetes, complicacioninfeccionurinaria, complicacioneclamsiaeclamsia, complicacionporhemorragia, otrasaccanalisisclinicos, otrasaccprescacidofolico, otrasaccapoyotranslado, puerpera, infeccionpuerperal, aceptapf, peripostmenopausia, its, apoyopsicoemocional, patologiamamariabenigna, cancermamario, colposcopia, cancercervicouterino, ninosanort, pesoparatalla, imc5, pruebaedi, resultadoedi, resultadobatelle, aplicacioncedulacancer, confirmacioncancer, edasrt, edasplantratamiento, recuperadodeshidratacion, numerosobresvsotratamiento, numerosobresvsopromocion, irasrt, irasplantratamiento, neumoniart, informaprevencionaccidentes, lineavida, cartillavacunacion, referidopor, contrarreferido, telemedicina, dt_entrada, cd_pessoa_fisica, nr_atendimento) AS SELECT
	0 IE_TIPO_REGISTRO,
	'clues|curpPrestador|nombrePrestador|primerApellidoPrestador|segundoApellidoPrestador|tipoPersonal|especificaTipoPersonal|cedulaProfesional|servicioAtencion|especificarServicio|'||
	'curpPaciente|nombre|primerApellido|segundoApellido|fechaNacimiento|entidadeNacimiento|edad|claveEdad|sexo|seConsideraIndigena|spss|numeroAfiliacionSpss|prospera|folioProspera|imss|'||
	'numeroAfiliacionImss|issste|numeroAfiliacionIssste|otraAfiliacion|numeroOtraAfiliacion|peso|talla|tipoDificultad|gradoDificultad|origenDificultad|migrante|fechaConsulta|'||
	'relacionTemporal|descripcionDiagnostico1|primeraVezDiagnostico1|suiveCausesDiagnostico1|codigoCIEDiagnostico1|descripcionDiagnostico2|primeraVezDiagnostico2|suiveCausesDiagnostico2|'||
	'codigoCIEDiagnostico2|descripcionDiagnostico3|primeraVezDiagnostico3|suiveCausesDiagnostico3|codigoCIEDiagnostico3|primeraVezAnio|imc10-19|sintomaticoRespiratorioTb|'||
	'relacionTemporalEmbarazo|trimestreGestacional|primeraVezAltoRiesgo|complicacionPorDiabetes|complicacionPorInfeccionUrinaria|complicacionPorPreeclamsiaEclamsia|complicacionPorHemorragia|'||
	'otrasAccAnalisisClinicos|otrasAccPrescAcidoFolico|otrasAccApoyoTranslado|puerpera|infeccionPuerperal|aceptaPF|terapiaHormonal|periPostMenopausia|its|apoyoPsicoemocional|patologiaMamariaBenigna|'||
	'cancerMamario|colposcopia|cancerCervicouterino|ninoSanoRT|pesoParaTalla|imc5-19|pruebaEDI|resultadoEDI|resultadoBatelle|aplicacionCedulaCancer|confirmacionCancer|edasRT|'||
	'edasPlanTratamiento|recuperadoDeshidratacion|numeroSobresVSOTratamiento|numeroSobresVSOPromocion|irasRT|irasPlanTratamiento|neumoniaRT|informaPrevencionAccidentes|'||
	'lineaVida|cartillaVacunacion|referidoPor|contrarreferido|telemedicina' CABECARIO,
	null clues,
	null curpprestador,
	null nombreprestador,
	null primerapellidoprestador,
	null segundoapellidoprestador,
	null tipopersonal,
	null especificatipopersonal,
	null cedulaprofesional,
	null servicioatencion,
	null curppaciente,
	null nombre,
	null primerapellido,
	null segundoapellido,
	null fechanacimiento,
	null entidadnacimiento,
	null edad,
	null claveedad,
	null sexo,
	null seconsideraindigena,
	null spss,
	null numeroafiliacionspss,
	null prospera,
	null folioprospera,
	null imss,
	null numeroafiliacionimss,
	null issste,
	null numeroafiliacionissste,
	null otraafiliacion,
	null numerootraafiliacion,
	null peso,
	null talla,
	null tipodificultad,
	null gradodificultad,
	null origendificultad,
	null migrante,
	null fechaconsulta,
	null relaciontemporal,
	null descripciondiagnostico1,
	null primeravezdiagnostico1,
	null suivecausesdiagnostico1,
	null codigociediagnostico1,
	null descripciondiagnostico2,
	null primeravezdiagnostico2,
	null suivecausesdiagnostico2,
	null codigociediagnostico2,
	null primeravezanio,
	null imc10,
	null sintomaticorespiratoriotb,
	null relaciontemporalembarazo,
	null trimestregestacional,
	null primeravezaltoriesgo,
	null complicacionpordiabetes,
	null complicacioninfeccionurinaria,
	null complicacioneclamsiaeclamsia,
	null complicacionporhemorragia,
	null otrasaccanalisisclinicos,
	null otrasaccprescacidofolico,
	null otrasaccapoyotranslado,
	null puerpera,
	null infeccionpuerperal,
	null aceptapf,
	null peripostmenopausia,
	null its,
	null apoyopsicoemocional,
	null patologiamamariabenigna,
	null cancermamario,
	null colposcopia,
	null cancercervicouterino,
	null ninosanort,
	null pesoparatalla,
	null imc5, 
	null pruebaedi,
	null resultadoedi,
	null resultadobatelle,
	null aplicacioncedulacancer,
	null confirmacioncancer,
	null edasrt,
	null edasplantratamiento,
	null recuperadodeshidratacion,
	null numerosobresvsotratamiento,
	null numerosobresvsopromocion,
	null irasrt,
	null irasplantratamiento,
	null neumoniart,
	null informaprevencionaccidentes,
	null lineavida,
	null cartillavacunacion,
	null referidopor,
	null contrarreferido,
	null telemedicina,
	null dt_entrada,
	null cd_pessoa_fisica,
	null nr_atendimento


union all

select
	--prestador servico--	
	2 ie_tipo_registro,
	'' cabecario,	   
	pessoa_juridica.cd_internacional clues,
	coalesce(substr(upper(pessoa_juridica.cd_curp),1,18), 'XXXX999999XXXXXX99') curpprestador,
	coalesce(substr(upper(pessoa_juridica.ds_razao_social),1,50), 'XX') nombreprestador,
	coalesce(substr(upper(pessoa_juridica.nm_fantasia),1,50), 'XX') primerapellidoprestador,
	coalesce(substr(upper(pessoa_juridica.ds_nome_abrev),1,50), 'XX') segundoapellidoprestador,
	(select max(profissional.ie_profissional) from atend_profissional profissional where b.nr_atendimento = profissional.nr_atendimento)  tipopersonal,
	(select max(CASE WHEN profissional.ie_profissional='12' THEN obter_desc_expressao(308221) END ) from atend_profissional profissional where b.nr_atendimento = profissional.nr_atendimento) especificatipopersonal, 
	(select
	 max(case 
		when profissional.ie_profissional in ('2','3','4','6','8')
		then coalesce(lpad(coalesce(pessoa_fisica_medico.ds_codigo_prof, m.nr_crm),8,0),0) 
		else '0'
	 end)
	from atend_profissional profissional where b.nr_atendimento = profissional.nr_atendimento) cedulaprofesional, 
	CASE WHEN b.ie_clinica=2 THEN 3 WHEN b.ie_clinica=1 THEN 4 WHEN b.ie_clinica=3 THEN 5 WHEN b.ie_clinica=1000 THEN 6 WHEN b.ie_clinica=1001 THEN 7 WHEN b.ie_clinica=1002 THEN 8 WHEN b.ie_clinica=1004 THEN 9 WHEN b.ie_clinica=1005 THEN 13 WHEN b.ie_clinica=1006 THEN 14 WHEN b.ie_clinica=4 THEN 16 WHEN b.ie_clinica=1007 THEN 17 WHEN b.ie_clinica=1008 THEN 22 WHEN b.ie_clinica=1009 THEN 23  ELSE 88 END  servicioatencion,
	--dados paciente--
	coalesce(substr(upper(pf_p.cd_curp),1,18), 'XXXX999999XXXXXX99') curppaciente,
	substr(upper(y.ds_given_name),1,50) nombre,	 
	coalesce(substr(upper(y.ds_family_name),1,50), 'XX') primerapellido,
	coalesce(substr(upper(y.ds_component_name_1),1,50), 'XX') segundoapellido, 
	coalesce(to_char(pf_p.dt_nascimento, 'dd/mm/yyyy'), null) fechanacimiento,
	CASE WHEN i.ie_brasileiro='S' THEN  obter_dados_cat_entidade(pf_p.cd_pessoa_fisica, 'CD_ENTIDADE') END  entidadnacimiento,
	case
		when obter_idade(pf_p.dt_nascimento, b.dt_inicio_atendimento, 'A') is not null 
		then coalesce(obter_idade_imc_nom(b.nr_atendimento,pf_p.dt_nascimento,b.dt_inicio_atendimento,'EDAD'),-1)
		else 999
	end as edad,
	case
		when obter_idade(pf_p.dt_nascimento, b.dt_inicio_atendimento, 'A') is not null 
		then obter_idade_imc_nom(b.nr_atendimento,pf_p.dt_nascimento,b.dt_inicio_atendimento,'CLAVEEDAD')
		else 9
	end as claveedad,
	CASE WHEN pf_p.ie_sexo='M' THEN  1  WHEN pf_p.ie_sexo='F' THEN  2  ELSE 9 END  sexo,
	CASE WHEN pf_p.nr_seq_cor_pele=201 THEN  1  ELSE 0 END  seconsideraindigena,
	--derechohaniencia--
	(CASE WHEN pf_p.nr_spss IS NOT NULL THEN 1 ELSE 0 END) spss,
	case 
		when pf_p.nr_spss is not null 
		then substr(pf_p.nr_spss,1,13)
	end as numeroafiliacionspss,
	CASE WHEN n.cd_tipo_convenio_mx=13 THEN  1  ELSE 0 END  prospera,
	CASE WHEN n.cd_tipo_convenio_mx=13 THEN  elimina_caractere_especial(substr(p.nr_doc_convenio,1,16)) END  folioprospera,
	CASE WHEN n.cd_tipo_convenio_mx=2 THEN  1  ELSE 0 END  imss,
	CASE WHEN n.cd_tipo_convenio_mx=2 THEN  substr(p.nr_doc_convenio,1,11) END  numeroafiliacionimss,
	CASE WHEN n.cd_tipo_convenio_mx=3 THEN  1  ELSE 0 END  issste,
	CASE WHEN n.cd_tipo_convenio_mx=3 THEN  substr(p.nr_doc_convenio,1,13) END  numeroafiliacionissste,
	CASE WHEN n.cd_tipo_convenio_mx=15 THEN  1  ELSE 0 END  otraafiliacion,
	CASE WHEN n.cd_tipo_convenio_mx=15 THEN  substr(p.nr_doc_convenio,1,15) END  numerootraafiliacion, 
	-- outros dados--
	coalesce(coalesce((select	max(qt_peso)		
			from	atendimento_sinal_vital	
			where	nr_sequencia = (select	coalesce(max(nr_sequencia),-1)
						from	atendimento_sinal_vital
						where	qt_peso is not null
						and	nr_atendimento	= b.nr_atendimento
						and	coalesce(ie_situacao,'A') = 'A'
						and	coalesce(ie_rn,'N')	= 'N')), pf_p.qt_peso), '999') peso,		
	coalesce(coalesce((select	max(qt_altura_cm)		
		from	atendimento_sinal_vital	
		where	nr_sequencia = (select	coalesce(max(nr_sequencia),-1)
		from	atendimento_sinal_vital
		where	qt_altura_cm is not null
		and	nr_atendimento	= b.nr_atendimento
		and	coalesce(ie_situacao,'A') = 'A'
		and	coalesce(ie_rn,'N')	= 'N')), pf_p.qt_altura_cm), '999') talla,			
    
	(select max(CASE WHEN ptd.nr_seq_tipo_def=48 THEN 1 WHEN ptd.nr_seq_tipo_def=49 THEN 2 WHEN ptd.nr_seq_tipo_def=50 THEN 3 WHEN ptd.nr_seq_tipo_def=51 THEN 4 WHEN ptd.nr_seq_tipo_def=52 THEN 5 WHEN ptd.nr_seq_tipo_def=53 THEN 6 WHEN ptd.nr_seq_tipo_def=54 THEN 7 WHEN ptd.nr_seq_tipo_def=55 THEN 8 WHEN ptd.nr_seq_tipo_def=56 THEN 9 END )
     from pf_tipo_deficiencia ptd 
     where pf_p.cd_pessoa_fisica = ptd.cd_pessoa_fisica and ptd.dt_inativacao is null and ptd.dt_liberacao is not null) tipodificultad,
     
	(select max(CASE WHEN ptd.nr_seq_tipo_def=56 THEN 9  ELSE ptd.ie_grau_deficiencia END )
     from pf_tipo_deficiencia ptd 
     where pf_p.cd_pessoa_fisica = ptd.cd_pessoa_fisica
     and ptd.dt_inativacao is null and ptd.dt_liberacao is not null) gradodificultad,
       
	(select max(CASE WHEN PTD.NR_SEQ_TIPO_DEF=56 THEN 9  ELSE CASE WHEN ptd.nr_seq_causa_lesao=6 THEN 1 WHEN ptd.nr_seq_causa_lesao=8 THEN 2 WHEN ptd.nr_seq_causa_lesao=9 THEN 3 WHEN ptd.nr_seq_causa_lesao=10 THEN 4 WHEN ptd.nr_seq_causa_lesao=11 THEN 5 WHEN ptd.nr_seq_causa_lesao=12 THEN 6 WHEN ptd.nr_seq_causa_lesao=13 THEN 9 END  END ) 
     from pf_tipo_deficiencia ptd 
     where pf_p.cd_pessoa_fisica = ptd.cd_pessoa_fisica
     and ptd.dt_inativacao IS NULL and ptd.dt_liberacao IS NOT NULL ) AS origendificultad,  
		  
	-1 migrante,
	--consulta--
	to_char(b.dt_entrada, 'dd/mm/yyyy') fechaconsulta,
	case 
		when(select count(*) from atendimento_paciente ap where (to_char(ap.dt_inicio_atendimento, 'yyyy') = extract(year from b.dt_inicio_atendimento)) and b.nr_atendimento = ap.nr_atendimento) > 1 
		then 1
		else 0 
	end as relaciontemporal,	
	elimina_caractere_especial(substr(upper((select max(cd.ds_doenca_cid) 
						from diagnostico_doenca dd, cid_doenca cd 
						where dd.nr_atendimento = b.nr_atendimento 
						and dd.cd_doenca = cd.cd_doenca_cid 
						and dd.ie_classificacao_doenca = 'P')),1, 255)) descripciondiagnostico1,
	case 
		when ((select count(*) from diagnostico_doenca ddp where to_char(ddp.dt_diagnostico, 'yyyy') = extract(year from b.dt_entrada) and ddp.nr_atendimento = b.nr_atendimento and ddp.ie_classificacao_doenca = 'P') > 1)
		then 0 
		else 1 
	end as primeravezdiagnostico1,
	case
		when(select max(cd.ds_doenca_cid) from diagnostico_doenca dd, cid_doenca cd where dd.nr_atendimento = b.nr_atendimento and dd.cd_doenca = cd.cd_doenca_cid and dd.ie_classificacao_doenca = 'P') is not null
		then coalesce((select CASE WHEN coalesce(ie_suive_morb, ie_causa)='S' THEN  0  ELSE 1 END  from cid_doenca a2 
			where a2.cd_doenca_cid = (select max(cd_doenca) 
						from diagnostico_doenca 
						where nr_atendimento = b.nr_atendimento 
						and ie_classificacao_doenca = 'P')), 0)
	end as suivecausesdiagnostico1,
	(select max(cd.cd_doenca_cid) from diagnostico_doenca dd, cid_doenca cd where dd.nr_atendimento = b.nr_atendimento and dd.cd_doenca = cd.cd_doenca_cid and dd.ie_classificacao_doenca = 'P') codigociediagnostico1,
	elimina_caractere_especial(substr(upper((select max(cd.ds_doenca_cid) 
						from diagnostico_doenca dd, cid_doenca cd 
						where dd.nr_atendimento = b.nr_atendimento 
						and dd.cd_doenca = cd.cd_doenca_cid 
						and dd.ie_classificacao_doenca = 'S')),1, 255)) descripciondiagnostico2, 
	case 
		when ((select count(*) from diagnostico_doenca ddp where to_char(ddp.dt_diagnostico, 'yyyy') = extract(year from b.dt_entrada) and ddp.nr_atendimento = b.nr_atendimento and ddp.ie_classificacao_doenca = 'S') > 1)
		then 0 
		else 1 
	end as primeravezdiagnostico2,
	case
		when(select max(ds_diagnostico) from diagnostico_doenca where nr_atendimento = b.nr_atendimento and ie_classificacao_doenca = 'S') is not null
		then coalesce((select CASE WHEN coalesce(ie_suive_morb, ie_causa)='S' THEN  0  ELSE 1 END  from cid_doenca a2 
				where a2.cd_doenca_cid = (select max(cd_doenca) 
				from diagnostico_doenca 
				where nr_atendimento = b.nr_atendimento 
				and ie_classificacao_doenca = 'S')), 'N') 
	end as suivecausesdiagnostico2,
	(select max(cd.cd_doenca_cid) from diagnostico_doenca dd, cid_doenca cd where dd.nr_atendimento = b.nr_atendimento and dd.cd_doenca = cd.cd_doenca_cid and dd.ie_classificacao_doenca = 'S') codigociediagnostico2,
	0 primeravezanio,
	coalesce(obter_idade_imc_nom(b.nr_atendimento,null,null,'IMC'),-1) imc10,
	nvl2((select cc1.cd_doenca_cid 
		from cid_doenca cc1, diagnostico_doenca ddp 
		where cc1.cd_categoria_cid in ('A15', 'A16', 'A17', 'A18', 'A19') 
		and cc1.cd_doenca_cid like ddp.cd_doenca 
		and ddp.nr_atendimento = b.nr_atendimento), 1, 0) sintomaticorespiratoriotb,
	--salud reproductiva--
	CASE WHEN(select max(coalesce(b.ie_paciente_gravida,ag.ie_pac_gravida)) 		from atendimento_gravidez ag 		where to_char(ag.dt_liberacao, 'yyyy') = extract(year from b.dt_inicio_atendimento) 		and ag.nr_atendimento = b.nr_atendimento		and ag.ie_situacao = 'A' )='N' THEN 0 WHEN(select max(coalesce(b.ie_paciente_gravida,ag.ie_pac_gravida)) 		from atendimento_gravidez ag 		where to_char(ag.dt_liberacao, 'yyyy') = extract(year from b.dt_inicio_atendimento) 		and ag.nr_atendimento = b.nr_atendimento		and ag.ie_situacao = 'A' )='S' THEN 1  ELSE -1 END  relaciontemporalembarazo,
	(select max(
		case
		when(ag.dt_ultima_menstruacao is not null) and (coalesce(b.ie_paciente_gravida,ag.ie_pac_gravida) is not null)
		then 
			case
				when trunc( months_between( trunc(b.dt_inicio_atendimento), trunc(ag.dt_ultima_menstruacao)  )) <= 3
				then 1
				when trunc( months_between( trunc(b.dt_inicio_atendimento), trunc(ag.dt_ultima_menstruacao)  )) <= 6
				then 2
				when trunc( months_between( trunc(b.dt_inicio_atendimento), trunc(ag.dt_ultima_menstruacao)  )) > 6
				then 3
		  end
		else -1	
		end)
	 from atendimento_gravidez ag 
	 where ie_situacao = 'A' 
	 and ag.nr_atendimento  = b.nr_atendimento) as trimestregestacional,
  
	(select max(CASE WHEN coalesce(b.ie_paciente_gravida,ag.ie_pac_gravida) IS NULL THEN  0  ELSE CASE WHEN ag.ie_risco_gravidez='S' THEN 1  ELSE 0 END  END ) 
	from atendimento_gravidez ag where ie_situacao = 'A' and ag.nr_atendimento  = b.nr_atendimento)  primeravezaltoriesgo,
	(select max(CASE WHEN coalesce(b.ie_paciente_gravida,ag.ie_pac_gravida) IS NULL THEN  0  ELSE CASE WHEN pp.ie_diabetes='S' THEN 1  ELSE 0 END  END ) 
	from atendimento_gravidez ag where ie_situacao = 'A' and ag.nr_atendimento  = b.nr_atendimento) complicacionpordiabetes,
	(select max(CASE WHEN coalesce(b.ie_paciente_gravida,ag.ie_pac_gravida) IS NULL THEN  0  ELSE CASE WHEN pp.ie_infeccao_urinaria='S' THEN 1  ELSE 0 END  END ) 
	from atendimento_gravidez ag where ie_situacao = 'A' and ag.nr_atendimento  = b.nr_atendimento) complicacioninfeccionurinaria,
	-1 complicacioneclamsiaeclamsia,
	0 complicacionporhemorragia,
	0 otrasaccanalisisclinicos,
	0 otrasaccprescacidofolico,
	0 otrasaccapoyotranslado,
	--puerperio--
	-1 puerpera,
	-1 infeccionpuerperal,
	-1 aceptapf,
	--terapia hormonal--
	-1 peripostmenopausia,
	nvl2((select cc1.cd_doenca_cid 
		from cid_doenca cc1, diagnostico_doenca ddp 
		where cc1.cd_categoria_cid in ('A50', 'A51', 'A52', 'A53', 'A54', 'A55', 'A56', 'A57', 'A58', 'A59','A60', 'A61', 'A62', 'A63', 'A64') 
		and cc1.cd_doenca_cid like ddp.cd_doenca 
		and ddp.nr_atendimento = b.nr_atendimento), 1, 0) its,
	-1 apoyopsicoemocional,
	case 
		when pf_p.ie_sexo = 'F'
		then 
			case 
			when exists (select * from cid_doenca cc1, diagnostico_doenca ddp where cc1.cd_categoria_cid in ('N60') and cc1.cd_doenca_cid like ddp.cd_doenca and ddp.nr_atendimento = b.nr_atendimento)
			then 1
			else 0
		end
		else -1
	end as patologiamamariabenigna,
	-1 cancermamario,
	-1 colposcopia,
	-1 cancercervicouterino,
	--salud de nino--
	case 
		when(obter_idade(pf_p.dt_nascimento, b.dt_inicio_atendimento, 'A') > 10)
		then 
			case 
			when(select count(nr_atendimento) from atendimento_paciente ap where ap.cd_pessoa_fisica = pf_p.cd_pessoa_fisica) > 1
			then 1
			else 0
		end
		else -1
	end as ninosanort,
	-1 pesoparatalla,
	case 
		when(obter_idade(pf_p.dt_nascimento, b.dt_inicio_atendimento, 'A')) between 5 and 19
		then coalesce(obter_idade_imc_nom(b.nr_atendimento,null,null,'IMC'),-1)
		else -1
	end as imc5,
	-1 pruebaedi,
	-1 resultadoedi,
	-1 resultadobatelle,
	--cáncer en menores de 18 años--
	-1 aplicacioncedulacancer,
	-1 confirmacioncancer,
	--enfermedades diarreicas agudas (eda’s)--
	-1 edasrt,
	-1 edasplantratamiento,
	0 recuperadodeshidratacion,
	0 numerosobresvsotratamiento,
	0 numerosobresvsopromocion,
	--enfermedades respiratorias agudas ira´s --
	case 
		when(obter_idade(pf_p.dt_nascimento, b.dt_inicio_atendimento, 'A') < 5)
		then 
			case 
				when exists (select * from cid_doenca cc1, diagnostico_doenca ddp where cc1.cd_categoria_cid in ('J00', 'J02', 'J03', 'J04', 'J05', 'J06', 'J09', 'J10', 'J11', 'J12', 'J13', 'J14','J15', 'J16', 'J17', 'J18', 'J19', 'J20','J21','J22') and cc1.cd_doenca_cid like ddp.cd_doenca and ddp.nr_atendimento = b.nr_atendimento)
				then 1	
				else 0
			end
		else -1
	end as irasrt,
	case 
		when(obter_idade(pf_p.dt_nascimento, b.dt_inicio_atendimento, 'A') < 5)
		then 
			case 
				when(select max(ddp.ie_sintomatico) from diagnostico_doenca ddp where ddp.nr_atendimento = b.nr_atendimento) = 'S'
				then 1
				else 0
			end
		else -1
	end as irasplantratamiento,
	-1 neumoniart,
	0 informaprevencionaccidentes,
	0 lineavida,
	0 cartillavacunacion,
	-1 referidopor,
	0 contrarreferido,
	0 telemedicina,
	b.dt_entrada dt_entrada,
	pf_p.cd_pessoa_fisica cd_pessoa_fisica,
	b.nr_atendimento nr_atendimento
FROM person_name y, pessoa_fisica pf_p, pessoa_juridica, pessoa_fisica pessoa_fisica_medico, atend_categoria_convenio p, medico m, nacionalidade i, estabelecimento e, categoria_convenio cc, atendimento_paciente b
LEFT OUTER JOIN parto pp ON (b.nr_atendimento = pp.nr_atendimento)
, convenio n
LEFT OUTER JOIN cat_derechohabiencia k ON (n.cd_tipo_convenio_mx = k.nr_sequencia)
WHERE b.cd_estabelecimento 			= e.cd_estabelecimento and pf_p.cd_pessoa_fisica 			= b.cd_pessoa_fisica and pessoa_fisica_medico.cd_pessoa_fisica 	= b.cd_medico_resp and pessoa_fisica_medico.cd_pessoa_fisica 	= m.cd_pessoa_fisica and pessoa_juridica.cd_cgc 			= e.cd_cgc and p.nr_atendimento 			= b.nr_atendimento and p.cd_convenio 				= cc.cd_convenio and p.cd_categoria 				= cc.cd_categoria and n.cd_convenio 				= cc.cd_convenio   and i.cd_nacionalidade 			= pf_p.cd_nacionalidade and b.ie_tipo_atendimento 			= 7 and y.nr_sequencia				= pf_p.nr_seq_person_name and y.ds_type 				= 'main';

