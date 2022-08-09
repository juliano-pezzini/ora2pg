-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_ipasgo_dados_matmed_tr ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) AS $body$
DECLARE


cd_material_w			integer;
qt_material_w			double precision;
vl_material_w			double precision;
dt_material_w			timestamp;
cd_setor_atendimento_w		integer;
ds_setor_atendimento_w		integer;
cd_convenio_parametro_w		integer;
cd_cnpj_w			varchar(14);
nr_matricula_prestador_w	varchar(08);
nr_seq_mat_w			bigint := -1;
cd_cgc_prestador_w		varchar(14);
ds_unidade_compl_w		varchar(01);
nr_atendimento_w		bigint;
nr_seq_atepacu_w		bigint;
ie_gerar_unid_compl_w		varchar(01) := 'N';
cd_tipo_fatura_w		integer;
nr_seq_tipo_fatura_w		bigint;
qt_proc_alto_custo_w		bigint := 0;
nr_ato_ipasgo_w			procedimento_paciente.nr_ato_ipasgo%type;
qt_ato_w			bigint := 1;
qt_ato_ww			bigint := 0;
nr_ato_proc_princ_w		procedimento_paciente.nr_ato_ipasgo%type;
ie_ord_loc_util_w		varchar(15) := 'N';
ie_ordem0_w			varchar(15);
ie_ordem1_w			varchar(15);
ie_ordem2_w			varchar(15);
ie_ordem3_w			varchar(15);
ie_ordem4_w			varchar(15);
ie_ordem5_w			varchar(15);
nr_seq_proc_princ_w		material_atend_paciente.nr_seq_proc_princ%type;
cd_estab_atual_w		smallint 	:= Wheb_usuario_pck.get_cd_estabelecimento;
cd_cgc_w			estabelecimento.cd_cgc%type;
cd_procedimento_w		procedimento_paciente.cd_procedimento%type;
cd_motivo_exc_conta_w   procedimento_paciente.cd_motivo_exc_conta%type;
ie_origem_proced_w		procedimento_paciente.ie_origem_proced%type;
ie_ord_presc_agr_w		varchar(15) := 'N';
ie_ato_tabela_w			varchar(15) := 'N';
ie_busca_devolucao_w		varchar(01);

c01 CURSOR FOR
SELECT	w.cd_material,
	w.qt_material,
	w.vl_material,
	w.dt_material,
	w.cd_setor_atendimento,
	w.cd_cgc_prestador,
	w.nr_seq_atepacu,
	w.nr_ato_ipasgo,
	w.ie_ordem3,
	w.ie_ordem4,
	w.ie_ordem1, -- somente para ordenar	
	w.nr_prescricao, -- somente para ordenar	
	w.Ie_ordem2,	 -- ordenar_medicamento_diluente_material_kit
	w.Ie_ordem5,
	w.nr_sequencia_prescricao,
	w.nr_seq_proc_princ,
	w.ie_ordem0
from (	select	substr(elimina_caracteres_especiais(coalesce(a.cd_material_convenio,a.cd_material)),1,6) cd_material,
		CASE WHEN obter_qte_conversao_matpaci2(a.nr_sequencia)=0 THEN a.qt_material  ELSE obter_qte_conversao_matpaci2(a.nr_sequencia) END  qt_material,
		a.vl_unitario * qt_material vl_material,
		a.dt_atendimento dt_material,
		a.cd_setor_atendimento,
		a.cd_cgc_prestador,
		a.nr_seq_atepacu,
		coalesce(obter_nr_ato_ipasgo_mat(a.nr_seq_proc_princ,a.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0) nr_ato_ipasgo,
		substr(CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN coalesce(obter_conversao_meio_ext_ipe(cd_cnpj_w,'W_IPASGO_DADOS_MATMED_TRAT','CD_LOCAL_UTIL_MATMED',a.cd_setor_atendimento),				CASE WHEN coalesce(ie_gerar_unid_compl_w,'N')='S' THEN (select substr(coalesce(max(x.cd_unidade_compl),0),1,1) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu)  ELSE a.cd_setor_atendimento END )  ELSE '0' END ,1,1) ie_ordem3,
		CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN a.cd_setor_atendimento  ELSE 0 END  ie_ordem4,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_prescricao,0)  ELSE 0 END  ie_ordem1, -- somente para ordenar	
		coalesce(a.nr_prescricao,0) nr_prescricao, -- somente para ordenar	
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = a.nr_prescricao and a.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem2,	 -- ordenar_medicamento_diluente_material_kit
		CASE WHEN ie_ord_presc_agr_w='N' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = a.nr_prescricao and a.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem5,
		a.nr_sequencia_prescricao,
		coalesce(a.nr_seq_proc_princ,0) nr_seq_proc_princ,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_seq_proc_princ,0)  ELSE 0 END  ie_ordem0
	from	material_atend_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	--and	qt_proc_alto_custo_w = 0
	and	cd_tipo_fatura_w not in (4, 17)
	and	a.vl_unitario > 0
	and	a.qt_material > 0
	and	ie_busca_devolucao_w = 'N'
	
union all

	SELECT	substr(elimina_caracteres_especiais(coalesce(a.cd_material_convenio,a.cd_material)),1,6) cd_material,
		CASE WHEN obter_qte_conversao_matpaci2(a.nr_sequencia)=0 THEN a.qt_material  ELSE obter_qte_conversao_matpaci2(a.nr_sequencia) END  qt_material,
		a.vl_unitario * qt_material vl_material,
		a.dt_atendimento dt_material,
		a.cd_setor_atendimento,
		a.cd_cgc_prestador,
		a.nr_seq_atepacu,
		coalesce(obter_nr_ato_ipasgo_mat(a.nr_seq_proc_princ,a.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0) nr_ato_ipasgo,
		substr(CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN coalesce(obter_conversao_meio_ext_ipe(cd_cnpj_w,'W_IPASGO_DADOS_MATMED_TRAT','CD_LOCAL_UTIL_MATMED',a.cd_setor_atendimento),				CASE WHEN coalesce(ie_gerar_unid_compl_w,'N')='S' THEN (select substr(coalesce(max(x.cd_unidade_compl),0),1,1) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu)  ELSE a.cd_setor_atendimento END )  ELSE '0' END ,1,1) ie_ordem3,
		CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN a.cd_setor_atendimento  ELSE 0 END  ie_ordem4,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_prescricao,0)  ELSE 0 END  ie_ordem1, -- somente para ordenar	
		coalesce(a.nr_prescricao,0) nr_prescricao, -- somente para ordenar	
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = a.nr_prescricao and a.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem2,	 -- ordenar_medicamento_diluente_material_kit
		CASE WHEN ie_ord_presc_agr_w='N' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = a.nr_prescricao and a.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem5,
		a.nr_sequencia_prescricao,
		coalesce(a.nr_seq_proc_princ,0) nr_seq_proc_princ,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_seq_proc_princ,0)  ELSE 0 END  ie_ordem0
	from	material_atend_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	--and	qt_proc_alto_custo_w = 0
	and	cd_tipo_fatura_w = 17
	and	a.vl_material > 0
	
union all

	select	substr(elimina_caracteres_especiais(coalesce(a.cd_material_convenio,a.cd_material)),1,6) cd_material,
		sum(CASE WHEN obter_qte_conversao_matpaci2(a.nr_sequencia)=0 THEN a.qt_material  ELSE obter_qte_conversao_matpaci2(a.nr_sequencia) END ) qt_material,
		sum(a.vl_unitario * a.qt_material) vl_material ,
		trunc(a.dt_atendimento,'dd') dt_material,
		a.cd_setor_atendimento,
		a.cd_cgc_prestador,
		a.nr_seq_atepacu,
		coalesce(obter_nr_ato_ipasgo_mat(a.nr_seq_proc_princ,a.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0) nr_ato_ipasgo,
		substr(CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN coalesce(obter_conversao_meio_ext_ipe(cd_cnpj_w,'W_IPASGO_DADOS_MATMED_TRAT','CD_LOCAL_UTIL_MATMED',a.cd_setor_atendimento),			CASE WHEN coalesce(ie_gerar_unid_compl_w,'N')='S' THEN (select substr(coalesce(max(x.cd_unidade_compl),0),1,1) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu)  ELSE a.cd_setor_atendimento END )  ELSE '0' END ,1,1) ie_ordem3,
		CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN a.cd_setor_atendimento  ELSE 0 END  ie_ordem4,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_prescricao,99999999)  ELSE 0 END  ie_ordem1, -- somente para ordenar	
		coalesce(a.nr_prescricao,99999999) nr_prescricao, -- somente para ordenar	
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = a.nr_prescricao and a.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem2,	 -- ordenar_medicamento_diluente_material_kit
		CASE WHEN ie_ord_presc_agr_w='N' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = a.nr_prescricao and a.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem5,	 -- ordenar_medicamento_diluente_material_kit
		a.nr_sequencia_prescricao,
		coalesce(a.nr_seq_proc_princ,0) nr_seq_proc_princ,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_seq_proc_princ,0)  ELSE 0 END  ie_ordem0
	from	material_atend_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	--and	qt_proc_alto_custo_w = 0
	and	cd_tipo_fatura_w = 4
	group by	substr(elimina_caracteres_especiais(coalesce(a.cd_material_convenio,a.cd_material)),1,6),
		a.cd_setor_atendimento,
		a.cd_cgc_prestador,
		a.nr_seq_atepacu,
		trunc(a.dt_atendimento,'dd'),
		a.nr_prescricao,
		a.nr_sequencia_prescricao,
		coalesce(a.nr_seq_proc_princ,0),
		coalesce(obter_nr_ato_ipasgo_mat(a.nr_seq_proc_princ,a.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0)
	
union all

	select	substr(elimina_caracteres_especiais(coalesce(b.cd_procedimento_convenio,b.cd_procedimento)),1,6) cd_material,
		sum(b.qt_procedimento) qt_material,
		sum(CASE WHEN coalesce(ipasgo_obter_se_respcred_soma(b.ie_responsavel_credito),'N')='N' THEN b.vl_procedimento  ELSE (b.vl_custo_operacional+b.vl_medico) END ) vl_material ,
		trunc(b.dt_procedimento,'dd') dt_material,
		b.cd_setor_atendimento,
		b.cd_cgc_prestador,
		b.nr_seq_atepacu,
		coalesce(obter_nr_ato_ipasgo_mat(b.nr_seq_proc_princ,b.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0) nr_ato_ipasgo,
		substr(CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN coalesce(obter_conversao_meio_ext_ipe(cd_cnpj_w,'W_IPASGO_DADOS_MATMED_TRAT','CD_LOCAL_UTIL_MATMED',b.cd_setor_atendimento),			CASE WHEN coalesce(ie_gerar_unid_compl_w,'N')='S' THEN (select substr(coalesce(max(x.cd_unidade_compl),0),1,1) from atend_paciente_unidade x where x.nr_seq_interno = b.nr_seq_atepacu)  ELSE b.cd_setor_atendimento END )  ELSE '0' END ,1,1) ie_ordem3,
		CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN b.cd_setor_atendimento  ELSE 0 END  ie_ordem4,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(b.nr_prescricao,99999999)  ELSE 0 END  ie_ordem1, -- somente para ordenar	
		coalesce(b.nr_prescricao,99999999) nr_prescricao, -- somente para ordenar	
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = b.nr_prescricao and b.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem2,	 -- ordenar_medicamento_diluente_material_kit
		CASE WHEN ie_ord_presc_agr_w='N' THEN coalesce((select max(x.nr_seq_arquivo) from w_ipasgo_ordem_matmet x where x.nr_prescricao = b.nr_prescricao and b.nr_sequencia_prescricao = x.nr_sequencia_prescricao), 999999)  ELSE 0 END  Ie_ordem5,	 -- ordenar_medicamento_diluente_material_kit
		b.nr_sequencia_prescricao,
		coalesce(b.nr_seq_proc_princ,0) nr_seq_proc_princ,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(b.nr_seq_proc_princ,0)  ELSE 0 END  ie_ordem0
	from	procedimento_paciente b
	where	b.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
	and	(b.nr_seq_proc_pacote IS NOT NULL AND b.nr_seq_proc_pacote::text <> '')
	and	ipasgo_obter_se_pacote_mat(b.nr_sequencia,b.nr_atendimento,b.dt_procedimento) = 'S'
	--and	qt_proc_alto_custo_w = 0
	group by	substr(elimina_caracteres_especiais(coalesce(b.cd_procedimento_convenio,b.cd_procedimento)),1,6),
		b.cd_setor_atendimento,
		b.cd_cgc_prestador,
		b.nr_seq_atepacu,
		trunc(b.dt_procedimento,'dd'),
		b.nr_prescricao,
		b.nr_sequencia_prescricao,
		coalesce(b.nr_seq_proc_princ,0),
		coalesce(obter_nr_ato_ipasgo_mat(b.nr_seq_proc_princ,b.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0)
        
union all
 
	select	substr(elimina_caracteres_especiais(coalesce(a.cd_material_convenio,a.cd_material)),1,6) cd_material,
		sum(CASE WHEN obter_qte_conversao_matpaci2(a.nr_sequencia)=0 THEN a.qt_material  ELSE obter_qte_conversao_matpaci2(a.nr_sequencia) END ) qt_material,
		sum(a.vl_unitario * qt_material) vl_material,
		trunc(a.dt_conta, 'dd') dt_material,
		a.cd_setor_atendimento,
		a.cd_cgc_prestador,
		a.nr_seq_atepacu,
		coalesce(obter_nr_ato_ipasgo_mat(a.nr_seq_proc_princ,a.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0) nr_ato_ipasgo,
		substr(CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN coalesce(obter_conversao_meio_ext_ipe(cd_cnpj_w,'W_IPASGO_DADOS_MATMED_TRAT','CD_LOCAL_UTIL_MATMED',a.cd_setor_atendimento),				CASE WHEN coalesce(ie_gerar_unid_compl_w,'N')='S' THEN (select substr(coalesce(max(x.cd_unidade_compl),0),1,1) from atend_paciente_unidade x where x.nr_seq_interno = a.nr_seq_atepacu)  ELSE a.cd_setor_atendimento END )  ELSE '0' END ,1,1) ie_ordem3,
		CASE WHEN coalesce(ie_ord_loc_util_w,'N')='S' THEN a.cd_setor_atendimento  ELSE 0 END  ie_ordem4,
		/*Ajuste efetuado pois nao estava agrupando quando havia devolucao usando a funcao Devolucao de materiais assim nao descontava OS 2203271*/

                0 ie_ordem1, -- somente para ordenar	
		0 nr_prescricao, -- somente para ordenar	
		0 Ie_ordem2,	 -- ordenar_medicamento_diluente_material_kit
		0 Ie_ordem5,
		0 nr_sequencia_prescricao,
		coalesce(a.nr_seq_proc_princ,0) nr_seq_proc_princ,
		CASE WHEN ie_ord_presc_agr_w='S' THEN coalesce(a.nr_seq_proc_princ,0)  ELSE 0 END  ie_ordem0
	from	material_atend_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	coalesce(a.nr_seq_proc_pacote::text, '') = ''
	--and	qt_proc_alto_custo_w = 0
	and	cd_tipo_fatura_w not in (4, 17)
	and	a.vl_unitario > 0
	and	ie_busca_devolucao_w = 'S'
	group by	substr(elimina_caracteres_especiais(coalesce(a.cd_material_convenio,a.cd_material)),1,6),
                trunc(a.dt_conta,'dd'),
                a.cd_setor_atendimento,
                a.cd_cgc_prestador,
                a.nr_seq_atepacu,
                coalesce(obter_nr_ato_ipasgo_mat(a.nr_seq_proc_princ,a.nr_interno_conta,ie_ato_tabela_w,nm_usuario_p,dt_mesano_referencia_p),0),
                CASE WHEN coalesce('S','N')='S' THEN a.cd_setor_atendimento  ELSE 0 END ,
                0,
                0,
                0,
                coalesce(a.nr_seq_proc_princ,0),
                CASE WHEN 'S'='S' THEN coalesce(a.nr_seq_proc_princ,0)  ELSE 0 END ) w
where	w.vl_material > 0
order by	nr_ato_ipasgo, 
	ie_ordem0, 
	dt_material, 
	ie_ordem1,
	Ie_ordem2,
	ie_ordem3,
	ie_ordem4,
	nr_prescricao,
	Ie_ordem5,
	nr_sequencia_prescricao;

type 		fetch_array is table of c01%rowtype;
s_array 	fetch_array;
i		integer := 1;
type vetor is table of fetch_array index by integer;
vetor_c01_w			vetor;

BEGIN
ie_gerar_unid_compl_w := obter_param_usuario(999, 39, obter_perfil_Ativo, nm_usuario_p, Wheb_Usuario_pck.get_cd_estabelecimento, ie_gerar_unid_compl_w);
ie_ord_loc_util_w := obter_param_usuario(999, 91, obter_perfil_Ativo, nm_usuario_p, Wheb_Usuario_pck.get_cd_estabelecimento, ie_ord_loc_util_w);
ie_ord_presc_agr_w := obter_param_usuario(999, 97, obter_perfil_Ativo, nm_usuario_p, Wheb_Usuario_pck.get_cd_estabelecimento, ie_ord_presc_agr_w);
ie_ato_tabela_w := obter_param_usuario(999, 98, obter_perfil_Ativo, nm_usuario_p, Wheb_Usuario_pck.get_cd_estabelecimento, ie_ato_tabela_w);
ie_busca_devolucao_w := obter_param_usuario(999, 104, obter_perfil_ativo, nm_usuario_p, Wheb_Usuario_pck.get_cd_estabelecimento, ie_busca_devolucao_w);

CALL gerar_ordem_ipasgo_matmed(nr_interno_conta_p, nm_usuario_p);

select	cd_convenio_parametro,
	nr_atendimento,
	nr_seq_tipo_fatura
into STRICT	cd_convenio_parametro_w,
	nr_atendimento_w,
	nr_seq_tipo_fatura_w
from	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;

select	cd_cgc
into STRICT	cd_cnpj_w
from	convenio
where	cd_convenio = cd_convenio_parametro_w;

select	cd_tipo_fatura
into STRICT	cd_tipo_fatura_w
from	fatur_tipo_fatura
where	nr_sequencia = nr_seq_tipo_fatura_w;

select	obter_cgc_estabelecimento(cd_estab_atual_w)
into STRICT	cd_cgc_w
;

if (cd_tipo_fatura_w 	= 3) then
	select	count(*)
	into STRICT	qt_proc_alto_custo_w
	from	procedimento a,
		procedimento_paciente b
	where	b.nr_atendimento 	= nr_atendimento_w
	and	b.nr_interno_conta	= nr_interno_conta_p
	and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
	and	a.cd_procedimento	= b.cd_procedimento
	and	a.ie_origem_proced	= b.ie_origem_proced
	and	coalesce(b.ie_proc_princ_atend,'S') = 'S'
	and	somente_numero(b.cd_procedimento_convenio) in (70025, 70033);
end if;

open c01;
loop
fetch c01 bulk collect into s_array limit 100000;
	vetor_c01_w(i) := s_array;
	i := i + 1;
EXIT WHEN NOT FOUND; /* apply on c01 */
end loop;
close c01;

for i in 1..vetor_c01_w.count loop
	begin
	s_array := vetor_c01_w(i);
	for z in 1..s_array.count loop
		begin

		cd_material_w			:= s_array[z].cd_material;
		qt_material_w			:= s_array[z].qt_material;
		vl_material_w			:= s_array[z].vl_material;
		dt_material_w			:= s_array[z].dt_material;
		cd_setor_atendimento_w		:= s_array[z].cd_setor_atendimento;
		cd_cgc_prestador_w		:= s_array[z].cd_cgc_prestador;
		nr_seq_atepacu_w		:= s_array[z].nr_seq_atepacu;
		nr_ato_ipasgo_w			:= s_array[z].nr_ato_ipasgo;
		ie_ordem0_w			:= s_array[z].ie_ordem0;
		ie_ordem1_w			:= s_array[z].ie_ordem1;
		ie_ordem2_w			:= s_array[z].ie_ordem2;
		ie_ordem3_w			:= s_array[z].ie_ordem3;
		ie_ordem4_w			:= s_array[z].ie_ordem4;
		ie_ordem5_w			:= s_array[z].ie_ordem5;
		nr_seq_proc_princ_w		:= s_array[z].nr_seq_proc_princ;

		qt_ato_w := 1;

		select	coalesce(max(cd_prestador_convenio),'00000000')
		into STRICT	nr_matricula_prestador_w
		from	convenio_prestador
		where	cd_convenio = cd_convenio_parametro_w
		and	cd_cgc = cd_cgc_prestador_w
		and	cd_estabelecimento = cd_estab_atual_w;

		begin
		if (coalesce(ie_gerar_unid_compl_w,'N') = 'S') and (coalesce(nr_seq_atepacu_w,0) > 0) then
			select	substr(coalesce(max(cd_unidade_compl),0),1,1)
			into STRICT	ds_unidade_compl_w
			from	atend_paciente_unidade
			where	nr_seq_interno = nr_seq_atepacu_w;

			ds_unidade_compl_w := somente_numero(ds_unidade_compl_w);

			if (ds_unidade_compl_w = 0) or	 /*Conforme layout, 1 - Leito, 2 - Sala cirurgica, 3 - Ambulatorio, 4 - Bercario e 5 - UTI*/
				(ds_unidade_compl_w > 5) or (ds_unidade_compl_w < 0) then
				ds_unidade_compl_w := '';
			end if;
		end if;
		exception
		when others then
			ds_unidade_compl_w := '';
		end;

		/*Buscar as conversoes meio externo*/

		begin
		select	coalesce(max(cd_externo), ds_unidade_compl_w, to_char(cd_setor_atendimento_w))
		into STRICT	ds_setor_atendimento_w
		from	conversao_meio_externo
		where	cd_cgc		= cd_cnpj_w
		and	upper(nm_tabela) 	= 'W_IPASGO_DADOS_MATMED_TRAT'
		and	upper(nm_atributo)	= 'CD_LOCAL_UTIL_MATMED'
		and	cd_interno	= to_char(cd_setor_atendimento_w);
		exception
		when others then
			ds_setor_atendimento_w := 0;
		end;

		qt_linha_arq_p	:= qt_linha_arq_p + 1;		

		if (nr_ato_ipasgo_w > 1) and (qt_ato_w <> nr_ato_ipasgo_w) then			
			qt_ato_w 	:= nr_ato_ipasgo_w;			
		end if;

		if (qt_ato_w <> qt_ato_ww) then
			begin
			qt_ato_ww 	:= qt_ato_w;
			nr_seq_mat_w	:= 0;
			end;
		else
			nr_seq_mat_w 	:= nr_seq_mat_w + 1;
		end if;

		if (coalesce(nr_seq_proc_princ_w,0) > 0) then
			begin
				select cd_motivo_exc_conta
				into STRICT cd_motivo_exc_conta_w
				from 	procedimento_paciente
				where 	nr_sequencia = nr_seq_proc_princ_w;
			exception
			when others then
				cd_motivo_exc_conta_w := null;
			end;
			if (coalesce(cd_motivo_exc_conta_w::text, '') = '') then
				nr_ato_proc_princ_w := obter_nr_ato_ipasgo_mat(nr_seq_proc_princ_w,nr_interno_conta_p,'S',nm_usuario_p,dt_mesano_referencia_p);
				if (nr_ato_proc_princ_w <> 0) then
					qt_ato_w := nr_ato_proc_princ_w;
				end if;
			end if;
		end if;

		insert into w_ipasgo_dados_matmed_trat(
			nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_linha,
			tp_registro,
			nr_linha_atend,
			nr_linha_ato,
			nr_linha_matmed,
			nr_matricula_prestador,
			cd_matmed,
			qt_matmed,
			vl_matmed,
			dt_matmed,
			cd_local_util_matmed,
			dt_mesano_referencia,
			nr_interno_conta,
			ds_linha,
			nr_seq_tipo_fatura,
			qt_matmed_gravado,
			vl_matmed_gravado,
			dt_matmed_gravado)
		values (	nextval('w_ipasgo_dados_matmed_trat_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			qt_linha_arq_p,
			9,
			qt_linha_atend_p,
			1,
			nr_seq_mat_w,
			nr_matricula_prestador_w,
			cd_material_w,
			qt_material_w,
			vl_material_w,
			dt_material_w,
			1,
			dt_mesano_referencia_p,
			nr_interno_conta_p,
			qt_linha_arq_p || '|' ||
			'9' || '|' || 
			qt_linha_atend_p || '|' || 
			qt_ato_w || '|' || 
			nr_seq_mat_w || '|' || 
			nr_matricula_prestador_w || '|' || 
			cd_material_w || '|' || 
			replace(replace(Campo_Mascara_virgula_casas(qt_material_w,4),'.',''),',','.') || '|' || 
			replace(replace(Campo_Mascara_virgula_casas(vl_material_w,4),'.',''),',','.') || '|' || 
			to_char(dt_material_w,'YYYY-MM-DD') || '|' || 
			ds_setor_atendimento_w || '|' || 
			'||',
			nr_seq_tipo_fatura_p,
			replace(replace(Campo_Mascara_virgula_casas(qt_material_w,4),'.',''),',','.'),
			replace(replace(Campo_Mascara_virgula_casas(vl_material_w,4),'.',''),',','.'),
			to_char(dt_material_w,'YYYY-MM-DD'));

		end;
	end loop;
	end;
end loop;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_ipasgo_dados_matmed_tr ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) FROM PUBLIC;
