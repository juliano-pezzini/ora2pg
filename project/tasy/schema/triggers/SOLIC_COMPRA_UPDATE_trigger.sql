-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS solic_compra_update ON solic_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_solic_compra_update() RETURNS trigger AS $BODY$
declare

reg_integracao_p		gerar_int_padrao.reg_integracao;
ie_gera_oc_solic_opme_w		varchar(1);
qt_registros_w			bigint;
qt_proc_reprov_w		bigint;
ie_status_w  bigint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	if (compras_pck.get_is_sci_insert = 'S' and  obter_bloq_canc_proj_rec(compras_pck.get_nr_seq_proj_rec) > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1144309);  -- Registro associado a um projeto bloqueado ou cancelado. 
	elsif (compras_pck.get_is_sci_insert = 'N') then
		select count(*)
		into STRICT   ie_status_w
		from   solic_compra_item
		where  nr_solic_compra = NEW.nr_solic_compra and obter_bloq_canc_proj_rec(nr_seq_proj_rec) > 0;
		
		if (ie_status_w > 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(1144309);  -- Registro associado a um projeto bloqueado ou cancelado. 
		end if;
	end if;

	CALL compras_pck.set_nr_seq_proj_rec(null);
	CALL compras_pck.set_is_sci_insert('N');
	
	select	count(*)
	into STRICT	qt_registros_w
	from	parametro_compras
	where	cd_estabelecimento = NEW.cd_estabelecimento;

	if (qt_registros_w > 0) then

		select	coalesce(ie_gerar_oc_solic_consig,'N')
		into STRICT	ie_gera_oc_solic_opme_w
		from	parametro_compras
		where	cd_estabelecimento = NEW.cd_estabelecimento;

		if (ie_gera_oc_solic_opme_w = 'S') and (OLD.dt_autorizacao is null) and (NEW.dt_autorizacao is not null) and (NEW.cd_fornec_sugerido is not null) then
				
			CALL gerar_oc_solic_opme(
				NEW.nr_solic_compra,
				NEW.cd_centro_custo,
				NEW.cd_local_estoque,
				NEW.cd_pessoa_solicitante,
				NEW.cd_estabelecimento,
				NEW.cd_fornec_sugerido,
				NEW.cd_setor_atendimento,
				NEW.nm_usuario);
			
		end if;
		
		if (OLD.dt_autorizacao is null) and (NEW.dt_autorizacao is not null) then
			
			/* OS 1558691 - Alteracao para nao enviar para integracao caso um dos itens tenha sido reprovado*/


			select count(*)
			into STRICT qt_proc_reprov_w
			from processo_aprov_compra a
			where a.ie_aprov_reprov = 'R'
			and a.nr_sequencia in (SELECT distinct nr_seq_aprovacao
				   from solic_compra_item
				   where nr_solic_compra = NEW.nr_solic_compra);
				
			if (qt_proc_reprov_w = 0) then
			BEGIN	
				reg_integracao_p.ie_operacao		:=	'I';
				reg_integracao_p.cd_estab_documento	:=	NEW.cd_estabelecimento;
				reg_integracao_p.cd_local_estoque	:=	NEW.cd_local_estoque;	
				reg_integracao_p.cd_centro_custo	:=	NEW.cd_centro_custo;
				reg_integracao_p.ie_tipo_solicitacao	:=	NEW.ie_tipo_solicitacao;
				reg_integracao_p.ie_tipo_compra	:=	NEW.ie_tipo_compra;
				reg_integracao_p.nr_seq_forma_compra	:=	NEW.nr_seq_forma_compra;
				reg_integracao_p.ie_tipo_servico	:=	NEW.ie_tipo_servico;
				reg_integracao_p.nr_prescricao		:=	NEW.nr_prescricao;
				reg_integracao_p := gerar_int_padrao.gravar_integracao('6', NEW.nr_solic_compra, NEW.nm_usuario, reg_integracao_p);
			end;
			end if;		
			
		end if;
	end if;

end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_solic_compra_update() FROM PUBLIC;

CREATE TRIGGER solic_compra_update
	BEFORE UPDATE ON solic_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_solic_compra_update();
