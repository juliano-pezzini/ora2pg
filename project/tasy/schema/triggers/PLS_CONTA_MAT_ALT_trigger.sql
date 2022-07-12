-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_mat_alt ON pls_conta_mat CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_mat_alt() RETURNS trigger AS $BODY$
declare
 
cd_material_w	integer;
ds_log_call_w			varchar(1500);
ds_observacao_w			varchar(4000);
 
BEGIN 
if (coalesce(wheb_usuario_pck.get_ie_lote_contabil,'N') = 'N') and (coalesce(wheb_usuario_pck.get_ie_atualizacao_contabil,'N') = 'N') then 
	if ( pls_se_aplicacao_tasy = 'N') or 
		(((NEW.ie_glosa = 'S') and ((OLD.ie_glosa = 'N') or (OLD.ie_glosa is null)) and (NEW.vl_liberado > 0)) or 
		((NEW.vl_liberado > 0) and ((OLD.vl_liberado = 0) or (OLD.vl_liberado is null)) and (NEW.ie_glosa	= 'S')))then 
		 
		ds_log_call_w := substr(pls_obter_detalhe_exec(false),1,1500);/*substr(	' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)|| 
				' CallStack: '|| chr(13) || chr(10)|| dbms_utility.format_call_stack,1,1500);*/
 
				--' Função ativa : '|| obter_funcao_ativa || chr(13) ||chr(10)|| 
		--ds_observacao_w := 'Conta: '||:old.nr_seq_conta||' ; Conta mat: '||:old.nr_sequencia;	 
		ds_observacao_w := wheb_mensagem_pck.get_texto(298854, 'NR_SEQ_CONTA_W=' || OLD.nr_seq_conta || ';NR_SEQUENCIA_W=' || OLD.nr_sequencia);
		 
		if (coalesce(OLD.vl_material_imp,0) <> coalesce(NEW.vl_material_imp,0)) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Valor apresentado: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||:old.vl_material_imp||' - Modificada: '||:new.vl_material_imp||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(298861, 'OLD_VL_MATERIAL_IMP=' || OLD.vl_material_imp || ';NEW_VL_MATERIAL_IMP=' || NEW.vl_material_imp) ||chr(13)||chr(10);
						 
		end if;
		 
		if (coalesce(OLD.vl_liberado,0) <> coalesce(NEW.vl_liberado,0)) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Valor liberado: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||:old.vl_liberado||' - Modificada: '||:new.vl_liberado||chr(13)||chr(10);*/
 
			 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(298856, 'VL_LIBERADO_OLD_W=' || OLD.vl_liberado || ';VL_LIBERADO_NEW_W=' || NEW.vl_liberado) || chr(13)||chr(10);
						 
		end if;
 		 
		if (coalesce(OLD.qt_material_imp,0) <> coalesce(NEW.qt_material_imp,0)) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Quantidade apresentada: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||:old.qt_material_imp||' - Modificada: '||:new.qt_material_imp||chr(13)||chr(10);*/
 
			ds_observacao_w	:=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299088, 'OLD_QT_MATERIAL_IMP=' || OLD.qt_material_imp || ';NEW_QT_MATERIAL_IMP=' || NEW.qt_material_imp) ||chr(13)||chr(10);
		end if;
			 
		if (coalesce(to_char(OLD.dt_recebimento_nf),'X') <> coalesce(to_char(NEW.dt_recebimento_nf),'X')) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Dt. recebimento NF: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||to_char(:old.dt_recebimento_nf, 'dd/mm/yyyy')||' - Modificada: '||to_char(:new.dt_recebimento_nf, 'dd/mm/yyyy')||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299089, 'OLD_DT_RECEBIMENTO_NF=' || to_char(OLD.dt_recebimento_nf, 'dd/mm/yyyy') || ';NEW_DT_RECEBIMENTO_NF= ' || to_char(NEW.dt_recebimento_nf, 'dd/mm/yyyy')) ||chr(13)||chr(10);
		end if;
 
		if (coalesce(to_char(OLD.dt_emissao_nf),'X') <> coalesce(to_char(NEW.dt_emissao_nf),'X')) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Dt. emissão NF: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||to_char(:old.dt_emissao_nf, 'dd/mm/yyyy')||' - Modificada: '||to_char(:new.dt_emissao_nf, 'dd/mm/yyyy')||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299093, 'OLD_DT_EMISSAO_NF=' || to_char(OLD.dt_emissao_nf, 'dd/mm/yyyy') || ';NEW_DT_EMISSAO_NF=' || to_char(NEW.dt_emissao_nf, 'dd/mm/yyyy')) ||chr(13)||chr(10);
		end if;
 
		if (coalesce(to_char(OLD.dt_atendimento),'X') <> coalesce(to_char(NEW.dt_atendimento),'X')) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Dt. material: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||to_char(:old.dt_atendimento, 'dd/mm/yyyy')||' - Modificada: '||to_char(:new.dt_atendimento, 'dd/mm/yyyy')||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299102, 'OLD_DT_ATENDIMENTO=' || to_char(OLD.dt_atendimento, 'dd/mm/yyyy') || ';NEW_DT_ATENDIMENTO=' || to_char(NEW.dt_atendimento, 'dd/mm/yyyy'))||chr(13)||chr(10);
		end if;
 
		if (coalesce(OLD.nr_nota_fiscal,0) <> coalesce(NEW.nr_nota_fiscal,0)) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Nota fiscal: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||:old.nr_nota_fiscal||' - Modificada: '||:new.nr_nota_fiscal||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299105, 'OLD_NR_NOTA_FISCAL=' || OLD.nr_nota_fiscal || ';NEW_NR_NOTA_FISCAL=' || NEW.nr_nota_fiscal)||chr(13)||chr(10);
		end if;
 
		if (coalesce(OLD.nr_seq_prest_fornec,0) <> coalesce(NEW.nr_seq_prest_fornec,0)) then 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Fornecedor: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||pls_obter_cod_prestador(:old.nr_seq_prest_fornec, null)||' - '||pls_obter_dados_prestador(:old.nr_seq_prest_fornec,'N')||' - Modificada: '||pls_obter_cod_prestador(:new.nr_seq_prest_fornec, null)||' - '||pls_obter_dados_prestador(:new.nr_seq_prest_fornec,'N')||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299107, 'OLD_NR_SEQ_PREST_FORNEC=' ||pls_obter_cod_prestador(OLD.nr_seq_prest_fornec, null)|| ';OLD_NR_SEQ_PREST_FORNEC_UM='||pls_obter_dados_prestador(OLD.nr_seq_prest_fornec,'N')|| ';NEW_NR_SEQ_PREST_FORNEC=' ||pls_obter_cod_prestador(NEW.nr_seq_prest_fornec, null)|| ';NEW_NR_SEQ_PREST_FORNEC_UM=' || pls_obter_dados_prestador(NEW.nr_seq_prest_fornec,'N'))||chr(13)||chr(10);
		end if;
 
		if (coalesce(OLD.nr_seq_setor_atend,0) <> coalesce(NEW.nr_seq_setor_atend,0)) then	 
			/*ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						'Setor atendimento: '||chr(13)||chr(10)|| 
						chr(9)||'Anterior: '||pls_obter_dados_setor_atend(:old.nr_seq_setor_atend,'DS')||' - Modificada: '||pls_obter_dados_setor_atend(:new.nr_seq_setor_atend,'DS')||chr(13)||chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w||chr(13)||chr(10)|| 
						wheb_mensagem_pck.get_texto(299111, 'OLD_NR_SEQ_SETOR_ATEND='||pls_obter_dados_setor_atend(OLD.nr_seq_setor_atend,'DS')|| ';NEW_NR_SEQ_SETOR_ATEND='||pls_obter_dados_setor_atend(NEW.nr_seq_setor_atend,'DS'))||chr(13)||chr(10);
		end if;
 
		if (coalesce(OLD.nr_seq_material, 0) <> coalesce(NEW.nr_seq_material, 0)) then	 
			/*ds_observacao_w :=	ds_observacao_w || chr(13) || chr(10) || 
						'Material: '|| chr(13) || chr(10) || 
						chr(9) || 'Anterior: ' || pls_obter_desc_material(:old.nr_seq_material) || ' - Modificada: ' || 
						pls_obter_desc_material(:new.nr_seq_material) || chr(13) || chr(10);*/
 
			ds_observacao_w :=	ds_observacao_w || chr(13) || chr(10) || 
						wheb_mensagem_pck.get_texto(299115, 'OLD_NR_SEQ_MATERIAL=' || pls_obter_desc_material(OLD.nr_seq_material) || ';NEW_NR_SEQ_MATERIAL=' || pls_obter_desc_material(NEW.nr_seq_material)) || chr(13) || chr(10);
		end if;
		 
		 
		insert into plsprco_cta( 	nr_sequencia, dt_atualizacao, nm_usuario, 
							dt_atualizacao_nrec, nm_usuario_nrec, nm_tabela, 
							ds_log, ds_log_call, ds_funcao_ativa, 
							ie_aplicacao_tasy, nm_maquina, nr_seq_conta_mat, ie_opcao ) 
				values ( 	nextval('plsprco_cta_seq'), LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,wheb_mensagem_pck.get_texto(299116)),1,14), 
							LOCALTIMESTAMP, substr(coalesce(wheb_usuario_pck.get_nm_usuario,wheb_mensagem_pck.get_texto(299116)),1,14), 'PLS_CONTA_MAT', 
							ds_observacao_w, ds_log_call_w, obter_funcao_ativa, 
							'N', wheb_usuario_pck.get_machine, OLD.nr_sequencia, '0');
		--end if; 
	end if;
end if;
 
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_mat_alt() FROM PUBLIC;

CREATE TRIGGER pls_conta_mat_alt
	BEFORE UPDATE ON pls_conta_mat FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_mat_alt();
