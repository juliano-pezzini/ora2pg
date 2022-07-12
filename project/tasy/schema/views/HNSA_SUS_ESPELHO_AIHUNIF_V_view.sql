-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hnsa_sus_espelho_aihunif_v (cd_procedimento, cd_proced, nr_sequencia, nr_cpf, cd_credor, qt_procedimento, cd_cbo, dt_competencia, ie_ordem, cd_proc, ie_funcao_equipe, nr_seq_ordem, nr_seq_ordem_princ, ds_procedimento, nr_interno_conta, cd_cgc_cnes, cd_servico, cd_classificacao, ds_serv_class) AS select	Sus_Obter_Procedimento_Editado(cd_procedimento) cd_procedimento,
	cd_Procedimento cd_proced,
	nr_sequencia,
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CPF'),1,15) nr_cpf,
	lpad(Sus_Obter_Prestador_Aih(nr_sequencia,null),14,'0') cd_credor,
	qt_procedimento,
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') || CASE WHEN Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') IS NULL THEN	''  ELSE CASE WHEN Sus_Validar_Regra(3,cd_procedimento,7,dt_procedimento)=0 THEN ''  ELSE '(1)' END  END ,1,30)  cd_cbo,
	CASE WHEN sus_validar_regra(13,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN 	CASE WHEN sus_validar_regra(7,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN 	CASE WHEN sus_validar_regra(31,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN null  ELSE to_char(dt_procedimento,'mm/yyyy') END   ELSE to_char(dt_procedimento,'mm/yyyy') END   ELSE to_char(dt_procedimento,'mm/yyyy') END  dt_competencia,
	Sus_Ordenar_Proc_Aih(nr_sequencia) ie_ordem,
	cd_procedimento cd_proc,
	1 ie_funcao_equipe,
	Sus_obter_seq_ordem(nr_sequencia) nr_seq_ordem,
	Sus_obter_seq_ordem_princ(nr_sequencia) nr_seq_ordem_princ,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100) ds_procedimento,
	nr_interno_conta,
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CNPJ'),1,20) CD_CGC_CNES,
	substr(sus_obter_dados_servico(nr_seq_servico,'C'),1,3) cd_servico,
	lpad(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'C'),1,3),3,'0') cd_classificacao,
	upper(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'D')||' ('||sus_obter_dados_servico(nr_seq_servico,'D')||')',1,255)) ds_serv_class
FROM	procedimento_paciente
where	cd_motivo_exc_conta is null
and	ie_origem_proced	= 7
and	qt_procedimento	> 0
and	sus_validar_regra(11, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and	sus_validar_regra(13, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and	sus_validar_regra(7, cd_procedimento, ie_origem_proced,dt_procedimento)  = 0
and	Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','G') <>'2'
and	Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','F') not in ('30206','30204')

union

select	Sus_Obter_Procedimento_Editado(a.cd_procedimento) cd_procedimento,
	cd_Procedimento cd_proced,
	a.nr_sequencia,
	substr(Obter_Dados_Espelho_Aih(b.nr_sequencia,b.nr_seq_partic,'CPF'),1,15)  nr_cpf,
	lpad(Sus_Obter_Prest_Partic_Aih(a.nr_sequencia,b.nr_Seq_partic),14,'0') cd_credor,
	a.qt_procedimento,
	substr(Obter_Dados_Espelho_Aih(b.nr_sequencia,b.nr_seq_partic,'CBO') || CASE WHEN Obter_Dados_Espelho_Aih(b.nr_sequencia,b.nr_seq_partic,'CBO') IS NULL THEN ''  ELSE CASE WHEN Sus_Obter_Indicador_Equipe(b.ie_funcao)=0 THEN ''  ELSE '('||Sus_Obter_Indicador_Equipe(b.ie_funcao)||')' END  END ,1,30)  cd_cbo,
	'' dt_competencia,
	Sus_Ordenar_Proc_Aih(a.nr_sequencia) ie_ordem,
	a.cd_procedimento cd_proc,
	coalesce(Sus_Obter_Indicador_Equipe(b.ie_funcao),0) ie_funcao_equipe,
	Sus_obter_seq_ordem(a.nr_sequencia) nr_seq_ordem,
	Sus_obter_seq_ordem_princ(a.nr_sequencia) nr_seq_ordem_princ,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100) ds_procedimento,
	nr_interno_conta,
	substr(Obter_Dados_Espelho_Aih(b.nr_sequencia,b.nr_seq_partic,'CNPJ'),1,20) CD_CGC_CNES,
	substr(sus_obter_dados_servico(a.nr_seq_servico,'C'),1,3) cd_servico,
	lpad(substr(sus_obter_dados_serv_classif(a.nr_seq_servico_classif,'C'),1,3),3,'0') cd_classificacao,
	upper(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'D')||' ('||sus_obter_dados_servico(nr_seq_servico,'D')||')',1,255)) ds_serv_class
from	procedimento_participante	b,
	procedimento_paciente		a
where	a.nr_sequencia		= b.nr_sequencia
and	cd_motivo_exc_conta is null
and	ie_origem_proced	= 7
and	a.qt_procedimento	> 0
and	sus_validar_regra(11, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and	sus_validar_regra(13, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and	sus_validar_regra(7, cd_procedimento, ie_origem_proced,dt_procedimento)  = 0
and	Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','G') <> '2'
and	Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','F') not in ('30206','30204')

union

select	Sus_Obter_Procedimento_Editado(cd_procedimento) cd_procedimento,
	cd_Procedimento cd_proced,
	min(nr_sequencia) nr_sequencia,
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CPF'),1,15) nr_cpf,
	lpad(Sus_Obter_Prestador_Aih(nr_sequencia,null),14,'0') cd_credor,
	sum(qt_procedimento) qt_procedimento,
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') || CASE WHEN Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') IS NULL THEN 	''  ELSE CASE WHEN Sus_Validar_Regra(3,cd_procedimento,7,dt_procedimento)=0 THEN ''  ELSE '(1)' END  END ,1,30)  cd_cbo,
	to_char(dt_procedimento,'mm/yyyy') dt_competencia,
	min(Sus_Ordenar_Proc_Aih(nr_sequencia)) ie_ordem,
	cd_procedimento cd_proc,
	1 ie_funcao_equipe,
	min(Sus_obter_seq_ordem(nr_sequencia)) nr_seq_ordem,
	min(Sus_obter_seq_ordem_princ(nr_sequencia)) nr_seq_ordem_princ,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100) ds_procedimento,
	nr_interno_conta,
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CNPJ'),1,20) CD_CGC_CNES,
	substr(sus_obter_dados_servico(nr_seq_servico,'C'),1,3) cd_servico,
	lpad(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'C'),1,3),3,'0') cd_classificacao,
	upper(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'D')||' ('||sus_obter_dados_servico(nr_seq_servico,'D')||')',1,255)) ds_serv_class
from	procedimento_paciente
where	cd_motivo_exc_conta is null
and	ie_origem_proced	= 7
and	qt_procedimento	> 0
and	sus_validar_regra(11, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and	sus_validar_regra(13, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and	sus_validar_regra(7, cd_procedimento, ie_origem_proced,dt_procedimento)  = 0
and	((Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','G') = '2') or (Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','F') in ('30206', '30204')))
group by lpad(Sus_Obter_Prestador_Aih(nr_sequencia,null),14,'0'),
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CPF'),1,15),
	cd_Procedimento,
	to_char(dt_procedimento,'mm/yyyy'),
	substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') || CASE WHEN Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') IS NULL THEN ''  ELSE CASE WHEN Sus_Validar_Regra(3,cd_procedimento,7,dt_procedimento)=0 THEN ''  ELSE '(1)' END  END ,1,30),
	ie_origem_proced,nr_interno_conta,substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CNPJ'),1,20),
	substr(sus_obter_dados_servico(nr_seq_servico,'C'),1,3),
	lpad(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'C'),1,3),3,'0'),
	upper(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'D')||' ('||sus_obter_dados_servico(nr_seq_servico,'D')||')',1,255))

union

select	Sus_Obter_Procedimento_Editado(cd_procedimento) cd_procedimento,
	cd_Procedimento cd_proced,
	min(nr_sequencia) nr_sequencia,
	max(substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CPF'),1,15)) nr_cpf,
	max(lpad(Sus_Obter_Prestador_Aih(nr_sequencia,null),14,'0')) cd_credor,
	sum(qt_procedimento) qt_procedimento,
	max(substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') || CASE WHEN Obter_Dados_Espelho_Aih(nr_sequencia,null,'CBO') IS NULL THEN 	''  ELSE CASE WHEN Sus_Validar_Regra(3,cd_procedimento,7,dt_procedimento)=0 THEN ''  ELSE '(1)' END  END ,1,30))  cd_cbo,
	CASE WHEN sus_validar_regra(13,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN 	CASE WHEN sus_validar_regra(7,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN 	CASE WHEN sus_validar_regra(31,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN null  ELSE to_char(dt_procedimento,'mm/yyyy') END   ELSE to_char(dt_procedimento,'mm/yyyy') END   ELSE to_char(dt_procedimento,'mm/yyyy') END  dt_competencia,
	min(Sus_Ordenar_Proc_Aih(nr_sequencia)) ie_ordem,
	cd_procedimento cd_proc,
	1 ie_funcao_equipe,
	min(Sus_obter_seq_ordem(nr_sequencia)) nr_seq_ordem,
	min(Sus_obter_seq_ordem_princ(nr_sequencia)) nr_seq_ordem_princ,
	substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,100) ds_procedimento,
	nr_interno_conta,
	max(substr(Obter_Dados_Espelho_Aih(nr_sequencia,null,'CNPJ'),1,20)) CD_CGC_CNES,
	substr(sus_obter_dados_servico(nr_seq_servico,'C'),1,3) cd_servico,
	lpad(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'C'),1,3),3,'0') cd_classificacao,
	upper(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'D')||' ('||sus_obter_dados_servico(nr_seq_servico,'D')||')',1,255)) ds_serv_class
from	procedimento_paciente
where	cd_motivo_exc_conta is null
and	ie_origem_proced	= 7
and	qt_procedimento	> 0
and	sus_validar_regra(11, cd_procedimento, ie_origem_proced,dt_procedimento) = 0
and (sus_validar_regra(13, cd_procedimento, ie_origem_proced,dt_procedimento) > 0 or
	sus_validar_regra(7, cd_procedimento, ie_origem_proced,dt_procedimento)  > 0)
and	Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','G') <>'2'
and	Sus_Obter_Estrut_Proc(cd_procedimento,ie_origem_proced,'C','F') not in ('30206','30204')
group by cd_procedimento,
	nr_interno_conta,
	ie_origem_proced,
	CASE WHEN sus_validar_regra(13,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN 	CASE WHEN sus_validar_regra(7,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN 	CASE WHEN sus_validar_regra(31,cd_procedimento,ie_origem_proced,dt_procedimento)=0 THEN null  ELSE to_char(dt_procedimento,'mm/yyyy') END   ELSE to_char(dt_procedimento,'mm/yyyy') END   ELSE to_char(dt_procedimento,'mm/yyyy') END ,
	substr(sus_obter_dados_servico(nr_seq_servico,'C'),1,3),
	lpad(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'C'),1,3),3,'0'),
	upper(substr(sus_obter_dados_serv_classif(nr_seq_servico_classif,'D')||' ('||sus_obter_dados_servico(nr_seq_servico,'D')||')',1,255))
order by ie_ordem, nr_seq_ordem, nr_seq_ordem_princ, cd_proced desc, ie_funcao_equipe;

