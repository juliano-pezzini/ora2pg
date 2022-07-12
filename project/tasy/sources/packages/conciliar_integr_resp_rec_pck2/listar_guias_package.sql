-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck2.listar_guias () AS $body$
DECLARE


current_setting('conciliar_integr_resp_rec_pck2.i')::integer integer := 0;
j integer := 0;
k integer := 0;
t integer := 0;
nr_seq_res_rec_prot_w	imp_resp_recurso_prot.nr_sequencia%type;
nr_seq_guia_w		    integer := 0;
conta_anterior_w	    bigint;
nr_seq_protocolo_w	    protocolo_convenio.nr_seq_protocolo%type;

cguias CURSOR FOR
	SELECT	coalesce(nr_interno_conta,0) nr_conta,
            nr_guia_operadora nr_operadora,
            nr_guia_prestador nr_guia_prest,
            cd_senha cd_senha,
            nr_seq_conta_guia nr_seq_conta_guia,
            vl_informado_guia  vl_informado,
            nr_sequencia nr_sequencia,
            cd_autorizacao cd_autorizacao
	from	imp_resp_recurso_guia
	where	nr_seq_res_rec_prot = nr_seq_res_rec_prot_w
	and	    coalesce(ie_status,'P') = 'P';

cguias_w	cguias%rowtype;

ccontas CURSOR FOR
	SELECT	c.nr_interno_conta,
            g.cd_autorizacao,
        	g.vl_guia,
            cg.cd_senha,
            cg.nr_doc_convenio,
            obter_saldo_conpaci(g.nr_interno_conta, g.cd_autorizacao)vl_saldo,
        	g.vl_participante
	from	conta_paciente c,
            conta_paciente_guia g,
            atendimento_paciente a,
            atend_categoria_convenio cg
	where	c.nr_interno_conta = g.nr_interno_conta
	and	    a.nr_atendimento   = c.nr_atendimento
	and	    cg.nr_seq_interno  = obter_atecaco_atendimento(a.nr_atendimento)
	and	    c.nr_seq_protocolo = nr_seq_protocolo_w
	order by c.nr_interno_conta;
cconta_guia_w ccontas%rowtype;

ctissconta CURSOR FOR
SELECT	a.nr_interno_conta,		
        a.cd_autorizacao,			
        a.nr_guia_prestador,		
        a.cd_senha,			
        a.vl_total,
        a.nr_sequencia,
        b.nr_sequencia nr_seq_prot_tiss
from	tiss_conta_guia a,
        tiss_protocolo_guia b
where	a.nr_seq_prot_guia = b.nr_sequencia
and	    b.nr_seq_protocolo = nr_seq_protocolo_w;

ctissconta_w ctissconta%rowtype;		



BEGIN
j := 0;
k := 0;
PERFORM set_config('conciliar_integr_resp_rec_pck2.i', 0, false);
t := 0;

if (current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v.count > 0) then

    FOR current_setting('conciliar_integr_resp_rec_pck2.i')::integer IN current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v.first .. current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v.last LOOP

        if (current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).ie_status = 'C') then
            nr_seq_res_rec_prot_w := current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_sequencia;
            nr_seq_protocolo_w := current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_seq_protocolo;
            RAISE NOTICE 'lote: %', current_setting('conciliar_integr_resp_rec_pck2.campos_lote_w')::campos_lote_v(current_setting('conciliar_integr_resp_rec_pck2.i')::integer).nr_sequencia;
            RAISE NOTICE 'Protoc Tasy: %', nr_seq_protocolo_w;

            nr_seq_guia_w := 1;
            conta_anterior_w := 0;
            for cconta_guia_w in ccontas loop

                if (conta_anterior_w = cconta_guia_w.nr_interno_conta) then
                    nr_seq_guia_w := nr_seq_guia_w + 1;
                else
                    nr_seq_guia_w := 1;
                end if;

        
                RAISE NOTICE 'conta: %', cconta_guia_w.nr_interno_conta;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].nr_interno_conta  := cconta_guia_w.nr_interno_conta;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].cd_autorizacao	:= cconta_guia_w.cd_autorizacao;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].vl_guia			:= cconta_guia_w.vl_guia;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].vl_participante	:= cconta_guia_w.vl_participante;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].nr_seq_ret_item	:= 0;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].vl_saldo			:= cconta_guia_w.vl_saldo;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].ie_conciliado		:= 'N';
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].ie_lido           := 'N';
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].cd_senha			:= cconta_guia_w.cd_senha;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].nr_doc_convenio	:= cconta_guia_w.nr_doc_convenio;
                current_setting('conciliar_integr_resp_rec_pck2.campos_conta_w')::campos_conta_v[j].seq_guia			:= nr_seq_guia_w;

                conta_anterior_w				    := cconta_guia_w.nr_interno_conta;
                j := j + 1;

            end loop;

        
        
            for cguias_w in cguias loop
        
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].nr_seq_res_rec_prot := nr_seq_res_rec_prot_w;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].nr_interno_conta	:= cguias_w.nr_conta;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].nr_guia_operadora	:= cguias_w.nr_operadora;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].nr_guia_prestador	:= cguias_w.nr_guia_prest;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].cd_senha		    := cguias_w.cd_senha;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].cd_autorizacao     := cguias_w.cd_autorizacao;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].nr_seq_conta_guia	:= cguias_w.nr_seq_conta_guia;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].ie_status		    := 'P';
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].vl_informado		:= cguias_w.vl_informado;
                current_setting('conciliar_integr_resp_rec_pck2.campos_guia_w')::campos_guia_v[k].nr_sequencia		:= cguias_w.nr_sequencia;
        
                k := k + 1;
            end loop;

            for ctissconta_w in ctissconta loop
        
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].nr_seq_protocolo	:= nr_seq_protocolo_w;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].nr_seq_prot_tiss	:= ctissconta_w.nr_seq_prot_tiss;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].nr_interno_conta	:= ctissconta_w.nr_interno_conta;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].cd_autorizacao	    := ctissconta_w.cd_autorizacao;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].nr_guia_prestador	:= ctissconta_w.nr_guia_prestador;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].cd_senha		    := ctissconta_w.cd_senha;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].vl_total		    := ctissconta_w.vl_total;
                current_setting('conciliar_integr_resp_rec_pck2.tiss_conta_guia_w')::tiss_conta_guia_v[t].nr_sequencia	    := ctissconta_w.nr_sequencia;

                t := t + 1;
            end loop;
        end if;

    END LOOP;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck2.listar_guias () FROM PUBLIC;
