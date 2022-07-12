-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE conciliar_integr_resp_rec_pck2.analisando_grg () AS $body$
DECLARE


guias_conciliada CURSOR FOR
SELECT  b.nr_interno_conta,
        b.cd_autorizacao,
        a.cd_convenio,
        a.nr_seq_lote,
        a.cd_estabelecimento,
        a.nm_usuario,
        b.nr_sequencia,
        b.vl_informado_guia
from    imp_resp_recurso_prot a,
        imp_resp_recurso_guia  b 
where   b.nr_seq_res_rec_prot = a.nr_sequencia
and     b.ie_status = 'C';


nr_interno_conta_imp_guia_w     imp_resp_recurso_guia.nr_interno_conta%type;
cd_autorizacao_imp_guia_w       imp_resp_recurso_guia.cd_autorizacao%type;
cd_convenio_imp_prot_w			imp_resp_recurso_prot.cd_convenio%type;
nr_seq_lote_imp_prot_w          imp_resp_recurso_prot.nr_seq_lote%type;
nr_seq_res_recurso_guia_w       imp_resp_recurso_guia.nr_sequencia%type;
nr_seq_lote_audit_w             lote_auditoria.nr_sequencia%type;
nr_seq_lote_hist_w              lote_audit_hist.nr_sequencia%type;
nr_seq_guia_w                   lote_audit_hist_guia.nr_sequencia%type;
cd_estabelecimento_imp_prot_w   imp_resp_recurso_prot.cd_estabelecimento%type;
nr_seq_lote_hist_seq_w		    lote_audit_hist.nr_sequencia%type;
nm_usuario_w                    imp_resp_recurso_prot.nm_usuario%type;
vl_informado_guia_w             imp_resp_recurso_guia.vl_informado_guia%type;
nr_seq_lote_hist_guia_w         lote_audit_hist_guia.nr_sequencia%type;


BEGIN


open guias_conciliada;

		loop
			fetch guias_conciliada into
                nr_interno_conta_imp_guia_w,
                cd_autorizacao_imp_guia_w,
                cd_convenio_imp_prot_w,
                nr_seq_lote_imp_prot_w,
                cd_estabelecimento_imp_prot_w,
                nm_usuario_w,
                nr_seq_res_recurso_guia_w,
                vl_informado_guia_w;

			EXIT WHEN NOT FOUND; /* apply on guias_conciliada */

            select	max(nr_seq_lote_audit) nr_seq_lote_audit,
                    max(nr_seq_lote_hist) nr_seq_lote_hist,
                    max(nr_seq_guia) nr_seq_guia
            into STRICT	nr_seq_lote_audit_w,
                    nr_seq_lote_hist_w,
                    nr_seq_guia_w
            from (SELECT	b.nr_seq_lote_audit nr_seq_lote_audit,
                    b.nr_sequencia nr_seq_lote_hist,
                    a.nr_sequencia nr_seq_guia,
                    c.cd_convenio cd_convenio
                from	lote_auditoria c,
                        lote_audit_hist b,
                        lote_audit_hist_guia a
                where	a.cd_autorizacao	= cd_autorizacao_imp_guia_w
                and		a.nr_seq_lote_hist	= b.nr_sequencia
                and		b.nr_seq_lote_audit	= c.nr_sequencia
                and		coalesce(cd_autorizacao_imp_guia_w,'X') <> 'X'
                and ((a.dt_baixa_glosa IS NOT NULL AND a.dt_baixa_glosa::text <> '') or b.nr_sequencia <> (obter_ultima_analise(b.nr_seq_lote_audit))::numeric )
                and     coalesce(c.dt_fechamento::text, '') = ''
                
union

                SELECT	b.nr_seq_lote_audit nr_seq_lote_audit,
                        b.nr_sequencia nr_seq_lote_hist,
                        a.nr_sequencia nr_seq_guia,
                        c.cd_convenio cd_convenio
                from	lote_auditoria c,
                        lote_audit_hist b,
                        lote_audit_hist_guia a
                where	a.nr_interno_conta	= nr_interno_conta_imp_guia_w
                and		a.nr_seq_lote_hist	= b.nr_sequencia
                and		b.nr_seq_lote_audit	= c.nr_sequencia
                and		coalesce(nr_interno_conta_imp_guia_w,0) <> 0
                and ((a.dt_baixa_glosa IS NOT NULL AND a.dt_baixa_glosa::text <> '') or b.nr_sequencia <> (obter_ultima_analise(b.nr_seq_lote_audit))::numeric )
                and     coalesce(c.dt_fechamento::text, '') = '') alias15
                where	cd_convenio	= cd_convenio_imp_prot_w;

                if (coalesce(nr_seq_lote_audit_w::text, '') = '') then
                        
                        criar_lote_audit_hist(nr_seq_lote_imp_prot_w,
											cd_estabelecimento_imp_prot_w,
											nm_usuario_w,
											nr_seq_lote_hist_seq_w);

                        
                        nr_seq_lote_hist_guia_w
                                 := conciliar_integr_resp_rec_pck2.gerar_lote_audit_hist_guia(
                                nr_interno_conta_imp_guia_w, cd_autorizacao_imp_guia_w, nr_seq_lote_hist_seq_w, nm_usuario_w, vl_informado_guia_w, nr_seq_lote_hist_guia_w
                                );

                        CALL CALL conciliar_integr_resp_rec_pck2.gerar_lote_audit_hist_item(
                                    nr_seq_res_recurso_guia_w,
                                    nr_seq_lote_hist_seq_w,
                                    nr_seq_lote_hist_guia_w
                                    );

                                                                    
                end if;					
										

                /*if	(nr_seq_lote_audit_w is not null) then
        				
                end if;*/
				
            
        end loop;
	close guias_conciliada;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conciliar_integr_resp_rec_pck2.analisando_grg () FROM PUBLIC;
