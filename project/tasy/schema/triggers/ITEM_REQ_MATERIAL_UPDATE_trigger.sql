-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS item_req_material_update ON item_requisicao_material CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_item_req_material_update() RETURNS trigger AS $BODY$
declare
nr_seq_terceiro_w				bigint;
nr_sequencia_w				bigint;
nr_seq_operacao_w			bigint;
nr_seq_oper_terc_w			bigint 	:= 0;
ie_entrada_saida_w				varchar(01)	:= 'S';
ie_existe_w				integer;
qt_reg_w					smallint;
BEGIN
  BEGIN 
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N') then 
	goto Final;
end if;
if (coalesce(obter_tipo_motivo_baixa_req(coalesce(NEW.cd_motivo_baixa,0)),0) > 0) and 
	(NEW.dt_atendimento is null  AND NEW.dt_reprovacao is null) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(266078);
	--'Não pode ter codigo de baixa com data de atendimento nula!!! '); 
end if;
 
if (coalesce(obter_tipo_motivo_baixa_req(coalesce(NEW.cd_motivo_baixa,0)),0) = 0) and (NEW.dt_atendimento is not null ) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(395271);
	--'Não pode ter data de atendimento sem motivo de baixa.'); 
end if;
 
BEGIN 
select	coalesce(max(b.nr_seq_terceiro),0), 
	max(c.ie_entrada_saida) 
into STRICT	nr_seq_terceiro_w, 
	ie_entrada_saida_w 
from 	Operacao_estoque c, 
	centro_custo b, 
	requisicao_material a 
where	a.cd_centro_custo 	= b.cd_centro_custo 
and	a.nr_requisicao		= NEW.nr_requisicao 
and	a.cd_operacao_estoque	= c.cd_operacao_estoque;
exception 
	when others then 
		nr_seq_terceiro_w	:= 0;
end;
 
if (nr_seq_terceiro_w > 0) then 
	BEGIN 
	BEGIN 
	select nr_sequencia 
	into STRICT nr_seq_oper_terc_w 
	from terceiro_operacao 
	where nr_seq_terceiro 	= nr_seq_terceiro_w 
	 and nr_doc			= NEW.nr_requisicao 
	 and nr_seq_doc		= NEW.nr_sequencia;
	exception 
		when others then	 
			nr_seq_oper_terc_w	:= 0;
	end;
		 
	if (coalesce(obter_tipo_motivo_baixa_req(NEW.cd_motivo_baixa),0) in (1,5)) and /* Matheus OS61284 11/07/07 inclui motivo 5*/
 
	 	(nr_seq_oper_terc_w = 0) then 
 
		nr_seq_operacao_w := obter_param_usuario(907, 60, obter_perfil_ativo, NEW.nm_usuario, NEW.cd_estabelecimento, nr_seq_operacao_w);
		select	count(*) 
		into STRICT	ie_existe_w 
		from	operacao_terceiro 
		where	nr_sequencia = coalesce(nr_seq_operacao_w,1);	
		if (ie_existe_w	= 0) then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(266079);
			--'Não existe operação de terceiro cadastrada.' || chr(10) || chr(13)); 
		end if;
		 
		BEGIN 
 
		select nextval('terceiro_operacao_seq') 
		into STRICT	nr_sequencia_w 
		;
		insert into terceiro_operacao( 
			nr_sequencia, 
			cd_estabelecimento, 
			nr_seq_terceiro, 
			nr_seq_operacao, 
			tx_operacao, 
			dt_atualizacao, 
			nm_usuario, 
			nr_doc, 
			nr_seq_doc, 
			dt_operacao, 
			nr_seq_conta, 
			cd_material, 
			ie_origem_proced, 
			cd_procedimento, 
			qt_operacao, 
			vl_operacao) 
		values (nr_sequencia_w, 
			NEW.cd_estabelecimento, 
			nr_seq_terceiro_w, 
			coalesce(nr_seq_operacao_w,1), 
			100, 
			LOCALTIMESTAMP, 
			NEW.nm_usuario, 
			NEW.nr_requisicao, 
			NEW.nr_sequencia, 
			NEW.dt_atendimento, 
			null, 
 			NEW.cd_material, 
			null, 
			null, 
			CASE WHEN ie_entrada_saida_w='S' THEN  NEW.qt_material_atendida  ELSE NEW.qt_material_atendida * -1 END , 
			0);
		CALL atualizar_operacao_terceiro(nr_sequencia_w, NEW.nm_usuario);
		end;
	elsif (coalesce(obter_tipo_motivo_baixa_req(NEW.cd_motivo_baixa),0) = 0) then 
		BEGIN 
		delete from terceiro_operacao 
		where	nr_sequencia = nr_seq_oper_terc_w;
		end;
	end if;
	end;
end if;
<<Final>> 
qt_reg_w	:= 0;
 
  END;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_item_req_material_update() FROM PUBLIC;

CREATE TRIGGER item_req_material_update
	BEFORE UPDATE ON item_requisicao_material FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_item_req_material_update();

