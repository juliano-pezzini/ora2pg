-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS cpoe_reval_events_insert_wms ON cpoe_revalidation_events CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_cpoe_reval_events_insert_wms() RETURNS trigger AS $BODY$
declare

reg_integracao_p			gerar_int_padrao.reg_integracao;
cd_local_estoque_w			ap_lote.cd_local_estoque%type;
cd_setor_atendimento_w		ap_lote.cd_setor_atendimento%type;
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;
nr_seq_lote_w				ap_lote.nr_sequencia%type;
ie_status_lote_w			ap_lote.ie_status_lote%type;
ie_param_119_w				varchar(1):= 'N';

c07 CURSOR FOR
	SELECT	e.cd_local_estoque,
			e.cd_setor_atendimento,
			b.cd_estabelecimento,
			e.nr_sequencia,
			e.ie_status_lote
	from 	prescr_medica b,
			prescr_material c,
			prescr_mat_hor d,
			ap_lote e,
			cpoe_material f	
	where 	b.nr_prescricao = c.nr_prescricao
	and 	c.nr_prescricao = d.nr_prescricao
	and 	c.nr_sequencia = d.nr_seq_material
	and 	d.nr_seq_lote = e.nr_sequencia
	and 	c.nr_seq_mat_cpoe = f.nr_Sequencia
	and 	b.nr_atendimento = NEW.nr_atendimento
	and 	f.nr_sequencia = NEW.nr_seq_material;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
	ie_param_119_w := obter_param_usuario(7029, 119, wheb_usuario_pck.get_cd_perfil, NEW.nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_param_119_w);

	if (coalesce(ie_param_119_w,'N') = 'S') then
		open C07;
		loop
		fetch C07 into	
			cd_local_estoque_w,
			cd_setor_atendimento_w,
			cd_estabelecimento_w,
			nr_seq_lote_w,
			ie_status_lote_w;
		EXIT WHEN NOT FOUND; /* apply on C07 */
			BEGIN
			reg_integracao_p.cd_estab_documento		:= cd_estabelecimento_w;
			reg_integracao_p.cd_local_estoque		:= cd_local_estoque_w;
			reg_integracao_p.cd_setor_atendimento	:= cd_setor_atendimento_w;
			reg_integracao_p.nr_seq_agrupador		:= nr_seq_lote_w;
			reg_integracao_p.ie_operacao			:= 'A';

			reg_integracao_p := gerar_int_padrao.gravar_integracao('260', nr_seq_lote_w, NEW.nm_usuario, reg_integracao_p);

			CALL intdisp_movto_mat_hor(nr_seq_lote_w,ie_status_lote_w,cd_local_estoque_w,2); -- EOD
			CALL intdisp_movto_mat_hor(nr_seq_lote_w,ie_status_lote_w,cd_local_estoque_w,1); -- EOA
			end;
		end loop;
		close C07;
	end if;
end if;
exception
when others then
	CALL grava_log_tasy(1812,substr('Error cpoe_revalidation_events nr_seq_lote_w' || nr_seq_lote_w || 
	'Stack=' || SQLERRM(SQLSTATE) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,2000),'INTEGRATION');
  END;
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_cpoe_reval_events_insert_wms() FROM PUBLIC;

CREATE TRIGGER cpoe_reval_events_insert_wms
	AFTER INSERT ON cpoe_revalidation_events FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_cpoe_reval_events_insert_wms();
