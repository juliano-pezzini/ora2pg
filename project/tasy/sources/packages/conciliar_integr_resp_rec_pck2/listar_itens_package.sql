-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck2.listar_itens () AS $body$
DECLARE

k integer;
current_setting('conciliar_integr_resp_rec_pck2.i')::integer integer;
y integer;
p integer;
nr_interno_conta_v      conta_paciente.nr_interno_conta%type;
cd_autorizacao_v        conta_paciente_guia.cd_autorizacao%type;
nr_seq_res_rec_guia_v   imp_resp_recurso_guia.nr_sequencia%type;

c_itens CURSOR FOR	
	SELECT	a.cd_procedimento cd_procedimento,
			a.nm_usuario,
			a.nm_usuario_nrec,
			a.dt_atualizacao,	
			a.dt_atualizacao_nrec,
			a.cd_glosa cd_motivo_glosa_tiss,
			(SELECT	max(b.cd_motivo_glosa) from motivo_glosa b where ie_situacao = 'A' and	cd_motivo_glosa_conv = a.cd_glosa) cd_glosa,
			coalesce((select	f.cd_funcao from funcao_medico f where f.ie_grau_partic_tiss = a.cd_grau_participacao  LIMIT 1),'0') cd_funcao,
			a.cd_setor_responsavel,
			coalesce(a.cd_setor_exec,0)cd_setor_exec,
			a.ds_justificativa_operadora,
			a.ds_justificativa_prestador,
			a.qt_glosada,
			a.vl_acatado,	
			a.vl_glosa_aceita,
			a.nm_usuario_responsavel,
			a.ie_tipo_guia,
			a.dt_realizacao,
			--a.IE_TIPO_PAGAMENTO,			
			--a.CD_GRAU_PARTICIPACAO ie_grau_tiss,
			a.vl_informado vl_informado,
			a.qt_executada,
			--a.VL_LIBERADO VL_LIBERADO,            
			a.cd_motivo_interno cd_motivo_interno,
			--a.VL_GLOSADO,
			(select	max(b.ie_acao_glosa) from motivo_glosa b where ie_situacao = 'A' and	cd_motivo_glosa_conv = a.cd_glosa) ie_acao_glosa,
			a.nr_sequencia nr_sequencia
	from	imp_resp_recurso_item a
	where	a.nr_seq_res_rec_guia = nr_seq_res_rec_guia_v
    and	coalesce(ie_status, 'P') = 'P';

c_itens_w c_itens%rowtype;


c_proced_conta CURSOR FOR
SELECT	nr_sequencia,
        cd_procedimento,
        ie_origem_proced,
        cd_procedimento_tuss,
        cd_procedimento_convenio,
        dt_procedimento,
        dt_conta,
        cd_setor_atendimento,
    	vl_procedimento,
        vl_medico,
        vl_custo_operacional,
        cd_edicao_amb,
        ie_funcao_medico,
        coalesce(nr_doc_convenio,cd_autorizacao_v) nr_doc_convenio,
        nr_interno_conta
from	procedimento_paciente
where	nr_interno_conta  = nr_interno_conta_v
and	    coalesce(nr_doc_convenio,cd_autorizacao_v) = cd_autorizacao_v
and	    coalesce(cd_motivo_exc_conta::text, '') = ''
and	    qt_procedimento > 0

union

select	p.nr_sequencia,
        p.cd_procedimento,
        p.ie_origem_proced,
        p.cd_procedimento_tuss,
        p.cd_procedimento_convenio,
        p.dt_procedimento,
        p.dt_conta,
        p.cd_setor_atendimento,
        pp.vl_conta,
        pp.vl_participante,
        0 vl_custo_operacional,
        p.cd_edicao_amb,
        pp.ie_funcao ie_funcao_medico,
        coalesce(pp.nr_doc_honor_conv,cd_autorizacao_v) nr_doc_convenio,
        p.nr_interno_conta
from	procedimento_paciente p,
        procedimento_participante pp
where	p.nr_interno_conta  = nr_interno_conta_v
and 	p.nr_sequencia = pp.nr_sequencia
and	    coalesce(pp.NR_DOC_HONOR_CONV,cd_autorizacao_v) = cd_autorizacao_v
and	    coalesce(p.cd_motivo_exc_conta::text, '') = ''
and	    p.qt_procedimento > 0
order by cd_procedimento, nr_sequencia desc;

c_proced_conta_w c_proced_conta%rowtype;	

c_materiais_conta CURSOR FOR
	SELECT	a.nr_sequencia nr_sequencia,
            a.cd_material cd_material,
            a.cd_material_tiss cd_material_tiss,
            a.cd_material_tuss cd_material_tuss,
            a.cd_material_convenio cd_material_convenio,
            a.dt_atendimento dt_atendimento,
            a.dt_conta dt_conta,
            a.vl_material vl_material,
            a.qt_material qt_material,
            a.vl_unitario vl_unitario,
            coalesce(tiss_obter_codigo_tabela(a.nr_seq_tiss_tabela),'00') cd_edicao,
            coalesce(a.nr_doc_convenio,cd_autorizacao_v) nr_doc_convenio,
            a.cd_setor_atendimento
	from	material_atend_paciente a
	where	a.nr_interno_conta = nr_interno_conta_v
	and	    coalesce(a.nr_doc_convenio,cd_autorizacao_v) = cd_autorizacao_v
	and	    coalesce(cd_motivo_exc_conta::text, '') = ''
	and	    qt_material > 0
	order by cd_material, nr_sequencia desc;

c_materiais_conta_w	c_materiais_conta%rowtype;


BEGIN
k := 0;
PERFORM set_config('conciliar_integr_resp_rec_pck2.i', 0, false);
y := 0;
p := 0;
if (current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v.count > 0) then
	for current_setting('conciliar_integr_resp_rec_pck2.i')::integer in current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v.first .. current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v.last loop
		if (current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).ie_status = 'C') then
			nr_interno_conta_v      := current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_interno_conta;
            cd_autorizacao_v        := current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).cd_autorizacao;
            nr_seq_res_rec_guia_v   := current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_sequencia;
			for c_itens_w in c_itens loop

					current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_procedimento				:= c_itens_w.cd_procedimento;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].nm_usuario					:= c_itens_w.nm_usuario;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].nm_usuario_nrec				:= c_itens_w.nm_usuario_nrec;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].dt_atualizacao				:= c_itens_w.dt_atualizacao;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].dt_atualizacao_nrec 			:= c_itens_w.dt_atualizacao_nrec;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_motivo_glosa_tiss			:= c_itens_w.cd_motivo_glosa_tiss;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_glosa						:= c_itens_w.cd_glosa;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_funcao		    			:= c_itens_w.cd_funcao;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_setor_responsavel			:= c_itens_w.cd_setor_responsavel;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_setor_exec                 := c_itens_w.cd_setor_exec;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].ds_justificativa_operadora    := c_itens_w.ds_justificativa_operadora;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].ds_justificativa_prestador    := c_itens_w.ds_justificativa_prestador;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].qt_glosada                    := c_itens_w.qt_glosada;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].vl_acatado	                := c_itens_w.vl_acatado;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].vl_glosa_aceita               := c_itens_w.vl_glosa_aceita;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].nm_usuario_responsavel        := c_itens_w.nm_usuario_responsavel;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].ie_tipo_guia					:= c_itens_w.ie_tipo_guia;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].dt_realizacao					:= c_itens_w.dt_realizacao;
                    --campos_itens_w(k).IE_TIPO_PAGAMENTO			:= c_itens_w.IE_TIPO_PAGAMENTO;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].vl_informado					:= c_itens_w.vl_informado;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].qt_executada					:= c_itens_w.qt_executada;
                    --campos_itens_w(k).VL_LIBERADO					:= c_itens_w.VL_LIBERADO;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].cd_motivo_interno				:= c_itens_w.cd_motivo_interno;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].ie_status		        		:= 'P';
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].nr_sequencia	        		:= c_itens_w.nr_sequencia;
                    current_setting('conciliar_integr_resp_rec_pck2.campos_itens_w')::campos_itens_v[k].nr_seq_res_rec_guia			:= nr_seq_res_rec_guia_v;

				k := k + 1;
			end loop;


			for c_materiais_conta_w in c_materiais_conta loop

				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].nr_sequencia		:= c_materiais_conta_w.nr_sequencia;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].cd_material		:= c_materiais_conta_w.cd_material;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].cd_material_tiss	:= c_materiais_conta_w.cd_material_tiss;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].cd_material_tuss	:= c_materiais_conta_w.cd_material_tuss;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].cd_material_convenio	:= c_materiais_conta_w.cd_material_convenio;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].dt_atendimento	:= c_materiais_conta_w.dt_atendimento;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].dt_conta		:= c_materiais_conta_w.dt_conta;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].cd_setor_atendimento	:= c_materiais_conta_w.cd_setor_atendimento;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].vl_material		:= c_materiais_conta_w.vl_material;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].vl_unitario		:= c_materiais_conta_w.vl_unitario;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].qt_material		:= c_materiais_conta_w.qt_material;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].cd_edicao		:= c_materiais_conta_w.cd_edicao;
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].ie_conciliado	:= 'N';
				current_setting('conciliar_integr_resp_rec_pck2.campos_material_conta_w')::campos_material_conta_v[y].nr_doc_convenio	:= c_materiais_conta_w.nr_doc_convenio;


				y := y + 1;
			end loop;

			for c_proced_conta_w in c_proced_conta loop

				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].nr_sequencia		:= c_proced_conta_w.nr_sequencia;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].cd_procedimento	:= c_proced_conta_w.cd_procedimento;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].ie_origem_proced	:= c_proced_conta_w.ie_origem_proced;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].cd_procedimento_tuss	:= c_proced_conta_w.cd_procedimento_tuss;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].cd_procedimento_convenio:= c_proced_conta_w.cd_procedimento_convenio;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].DT_ATENDIMENTO		:= c_proced_conta_w.DT_PROCEDIMENTO;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].dt_conta		:= c_proced_conta_w.dt_conta;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].cd_setor_atendimento	:= c_proced_conta_w.cd_setor_atendimento;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].vl_procedimento	:= c_proced_conta_w.vl_procedimento;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].vl_medico		:= c_proced_conta_w.vl_medico;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].vl_custo_operacional	:= c_proced_conta_w.vl_custo_operacional;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].cd_edicao		:= c_proced_conta_w.cd_edicao_amb;
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].ie_conciliado		:= 'N';
				current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].nr_doc_convenio	:= c_proced_conta_w.nr_doc_convenio;
                current_setting('conciliar_integr_resp_rec_pck2.campos_proced_conta_w')::campos_proced_conta_v[p].nr_interno_conta   := c_proced_conta_w.nr_interno_conta;

				p := p + 1;
			end loop;


		end if;
	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck2.listar_itens () FROM PUBLIC;