-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS material_atend_paciente_update ON material_atend_paciente CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_material_atend_paciente_update() RETURNS trigger AS $BODY$
declare

cd_material_w			bigint;
cd_estabelecimento_w		smallint;
ds_module_w 			varchar(255);
osuser_w			varchar(100);
qt_registro_w			bigint;
osuser_log_w				varchar(100);
ds_module_log_w				varchar(255);
cont_w				bigint;
qt_reg_w	smallint;
ds_log_w			varchar(2000);
nr_seq_log_mat_w		bigint;
dt_geracao_resumo_new_w		timestamp;
dt_geracao_resumo_old_w		timestamp;
ds_call_stack_w			varchar(2000);
ie_status_acerto_w		smallint;
ie_log_valor_mat_w		parametro_faturamento.ie_log_valor_mat%type;
BEGIN
  BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto final;
end if;

if (NEW.cd_motivo_exc_conta is not null) then
	NEW.nr_interno_conta	:= null;
end if;

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	atendimento_paciente
where	nr_atendimento = NEW.nr_atendimento;

select	coalesce(max(ie_log_valor_mat),'N')
into STRICT	ie_log_valor_mat_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_w;

if (coalesce(OLD.nr_interno_conta,0) <> 0) and (coalesce(NEW.nr_interno_conta,0) <> coalesce(OLD.nr_interno_conta,0)) and (NEW.cd_motivo_exc_conta is null) then
	
	BEGIN
	
	select	substr(max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),1,255)
	into STRICT	ds_module_log_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );
	
	ds_call_stack_w	:= substr(dbms_utility.format_call_stack,1,1800);
	
	insert into matpaci_conta_log(
		nr_sequencia,           
		dt_atualizacao,         
		nm_usuario,             
		dt_atualizacao_nrec,    
		nm_usuario_nrec,        
		nr_atendimento,         
		nr_interno_conta,       
		nr_conta_origem,        
		nr_seq_material,
		ds_module,
		ds_call_stack)
	values (
		nextval('matpaci_conta_log_seq'),           
		LOCALTIMESTAMP,         
		NEW.nm_usuario,             
		LOCALTIMESTAMP,    
		NEW.nm_usuario,        
		NEW.nr_atendimento,         
		NEW.nr_interno_conta,       
		OLD.nr_interno_conta,        
		NEW.nr_sequencia,
		ds_module_log_w,
		ds_call_stack_w);
	exception
		when others then
		ds_log_w	:= '';
	end;
			
end if;

if (NEW.nr_interno_conta is null) and (OLD.nr_interno_conta is not null) and (NEW.cd_motivo_exc_conta is not null) then
	NEW.nr_seq_conta_origem	:= OLD.nr_interno_conta;
end if;

if (OLD.nr_interno_conta is null) and (NEW.nr_interno_conta is not null) then
	NEW.nr_seq_conta_origem	:= null;
end if;

if (coalesce(NEW.cd_convenio,0) <> coalesce(OLD.cd_convenio,0))then
	BEGIN
	select obter_material_conta(
		cd_estabelecimento_w,
		NEW.cd_convenio,
		NEW.cd_categoria,
		NEW.cd_material_prescricao,
		NEW.cd_material_exec,
		NEW.cd_material,
		null,
		null,
		NEW.dt_atendimento,
		NEW.cd_local_estoque,
		NEW.nr_prescricao)
	into STRICT	cd_material_w
	;

	if (cd_material_w is not null) and (cd_material_w <> NEW.cd_material) then
		NEW.cd_material	:= cd_material_w;
	end if;
	end;
end if;

-- marcus 4/1/2006

if (NEW.cd_motivo_exc_conta is not null) then
	NEW.ie_emite_conta		:= null;
end if;

if (NEW.nr_receita is not null) then /* matheus os 49104 01/02/07 - para atualizar o movimento com a receita dcb*/

	update	movimento_estoque
	set	nr_receita = NEW.nr_receita
	where	nr_seq_tab_orig = OLD.nr_sequencia
	and	ie_origem_documento = '3'
	and	nr_receita is null;
end if;

if (OLD.nr_atendimento <> NEW.nr_atendimento) then
	update	movimento_estoque
	set	nr_atendimento = NEW.nr_atendimento
	where	nr_seq_tab_orig = NEW.nr_sequencia
	and	ie_origem_documento = '3';
end if;

if (OLD.ie_valor_informado	= 'N') and (NEW.ie_valor_informado	= 'S') then
	insert into log_valor_informado(NR_SEQUENCIA, NR_SEQ_ITEM, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, IE_TIPO_ITEM, NR_ATENDIMENTO, NR_INTERNO_CONTA, IE_ACAO, VL_ATUAL, VL_ANTERIOR)
			values (nextval('log_valor_informado_seq'), NEW.nr_sequencia, LOCALTIMESTAMP, NEW.nm_usuario, LOCALTIMESTAMP, NEW.nm_usuario, 'M', NEW.nr_atendimento, NEW.nr_interno_conta, '1', NEW.vl_material, OLD.vl_material);
	/*gravar_log_valor_informado(2, :new.nr_sequencia, :new.nr_atendimento, :new.nr_interno_conta, :new.nm_usuario);*/


end if;

if (OLD.ie_valor_informado	= 'S') and (NEW.ie_valor_informado	= 'S') and (OLD.vl_material		<> NEW.vl_material) then
	insert into log_valor_informado(NR_SEQUENCIA, NR_SEQ_ITEM, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, IE_TIPO_ITEM, NR_ATENDIMENTO, NR_INTERNO_CONTA, IE_ACAO, VL_ATUAL, VL_ANTERIOR)
			values (nextval('log_valor_informado_seq'), NEW.nr_sequencia, LOCALTIMESTAMP, NEW.nm_usuario, LOCALTIMESTAMP, NEW.nm_usuario, 'M', NEW.nr_atendimento, NEW.nr_interno_conta, '1', NEW.vl_material, OLD.vl_material);
end if;

if (OLD.ie_valor_informado	= 'S') and (NEW.ie_valor_informado	= 'N') then
	insert into log_valor_informado(NR_SEQUENCIA, NR_SEQ_ITEM, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, IE_TIPO_ITEM, NR_ATENDIMENTO, NR_INTERNO_CONTA, IE_ACAO, VL_ANTERIOR)
			values (nextval('log_valor_informado_seq'), NEW.nr_sequencia, LOCALTIMESTAMP, NEW.nm_usuario, LOCALTIMESTAMP, NEW.nm_usuario, 'M', NEW.nr_atendimento, NEW.nr_interno_conta, '2', OLD.vl_material);		
end if;

if (OLD.tx_material is null) then
	NEW.tx_material:= 100;
end if;

if (coalesce(OLD.nr_interno_conta,0)	<>  coalesce(NEW.nr_interno_conta,0))  and (obter_funcao_ativa <> 1116) then

	select	count(*)
	into STRICT	qt_registro_w
	from	auditoria_matpaci a,
		auditoria_conta_paciente b
	where	b.nr_sequencia		= a.nr_seq_auditoria
	and	a.nr_seq_matpaci	= NEW.nr_sequencia
	and	b.dt_liberacao	is null;
	
	if (qt_registro_w	> 0) and (obter_valor_param_usuario(67,269,obter_perfil_ativo,NEW.nm_usuario,0)	= 'S') then
		-- Nao e possivel alterar a conta do procedimento, pois o mesmo se encontra em um periodo de auditoria!

		CALL Wheb_mensagem_pck.exibir_mensagem_abort(184900);		
	end if;

	select	max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),
		max(osuser)
	into STRICT	ds_module_w,
		osuser_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') )
	and 	upper(program) not like '%TASY%';

	/*if	(ds_module_w is not null) then
		insert into logxxx_tasy (cd_log, dt_atualizacao, nm_usuario, ds_log) 
			values (88890, sysdate, substr(osuser_w,1,15), 'Material mudando conta: ' || 
					:old.nr_interno_conta || '  para ' || :new.nr_interno_conta || '  ' || ds_module_w);
	end if;*/

end if;
/*Matheus */


if (coalesce(OLD.nr_interno_conta,0)	<>  coalesce(NEW.nr_interno_conta,0)) and (coalesce(NEW.nr_lote_contabil,0) <> 0) then

	select	max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),
		max(osuser)
	into STRICT	ds_module_w,
		osuser_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );

	ds_log_w	:= substr(dbms_utility.format_call_stack,1,1800);
							--'Material mudando conta c/lote ctb: '

	ds_log_w	:= substr(	ds_log_w || wheb_mensagem_pck.get_texto(308370) ||
					OLD.nr_interno_conta || '  para ' || NEW.nr_interno_conta || '  ' || 'L:' || NEW.nr_lote_contabil || ' ' || ds_module_w,1,2000);
	
	/*insert into logxxx_tasy(
		cd_log,
		dt_atualizacao,
		nm_usuario,
		ds_log) 
	values(	88919,
		sysdate,
		substr(osuser_w,1,15),
		substr(ds_log_w,1,2000));*/

	
end if;

/*Fim alteracao Matheus*/




/* Atualizacao do nro da conta */


/*if	(nvl(:old.nr_interno_conta,0) = 0) and
	(nvl(:new.nr_interno_conta,0) <> 0) and
	(:old.cd_motivo_exc_conta is null) then
	
	select 	max(nr_sequencia)
	into	nr_seq_log_mat_w
	from 	mat_atend_pac_log
	where 	nr_seq_mat = :new.nr_sequencia
	and 	nr_atendimento = :new.nr_atendimento
	and 	ie_acao = 'I';
	
	begin
	update  mat_atend_pac_log 
	set	nr_interno_conta = :new.nr_interno_conta
	where	nr_seq_log_mat_w <> 0
	and 	nr_sequencia = nr_seq_log_mat_w
	and 	nr_seq_mat = :new.nr_sequencia
	and 	nr_interno_conta is null
	and 	nr_atendimento = :new.nr_atendimento
	and 	ie_acao = 'I';
	exception
		when others then
		ds_log_w	:= '';
	end;
		
end if;*/



if (NEW.qt_material	<> OLD.qt_material) or (NEW.nr_seq_proc_princ <> OLD.nr_seq_proc_princ) then

	select	substr(max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),1,255),
			substr(max(osuser),1,100)
	into STRICT	ds_module_log_w,
			osuser_log_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );
	
	ds_call_stack_w	:= substr(dbms_utility.format_call_stack,1,1800);
	
	insert	into mat_atend_pac_log(
		nr_sequencia,
		nr_seq_mat,
		dt_atualizacao,	
		nm_usuario,
		ds_module,
		nr_atendimento,
		nr_interno_conta,
		cd_material,
		dt_atendimento,
		ie_acao,
		qt_material,
		vl_material,
		cd_perfil,
		cd_funcao,
		ie_valor_informado,
		nr_seq_proc_pacote,
		nr_seq_proc_princ,
		cd_setor_atendimento,
		dt_entrada_unidade,
		nr_seq_atepacu,
		nr_prescricao,
		cd_local_estoque,
		qt_material_ant,
		ds_call_stack)
values (nextval('mat_atend_pac_log_seq'),
		NEW.nr_sequencia,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		ds_module_log_w,
		NEW.nr_atendimento,
		NEW.nr_interno_conta,
		NEW.cd_material,
		NEW.dt_atendimento,
		'AQ',
		NEW.qt_material,
		NEW.vl_material,
		obter_perfil_ativo,
		obter_funcao_ativa,
		NEW.ie_valor_informado,
		NEW.nr_seq_proc_pacote,
		NEW.nr_seq_proc_princ,
		NEW.cd_setor_atendimento,
		NEW.dt_entrada_unidade,
		NEW.nr_seq_atepacu,
		NEW.nr_prescricao,
		NEW.cd_local_estoque,
		OLD.qt_material,
		ds_call_stack_w);
end if;

if (OLD.cd_motivo_exc_conta is null) and (NEW.cd_motivo_exc_conta is not null) then
	select	count(*)
	into STRICT	cont_w
	from	material_repasse
	where	nr_seq_material	= NEW.nr_sequencia;
	if (cont_w > 0) then
		-- Este material possui repasse gerado!  Nao e possivel excluir o material.

		CALL Wheb_mensagem_pck.exibir_mensagem_abort(184899);		
	end if;
end if;

if (NEW.cd_motivo_exc_conta is not null) then
	CALL avisar_material_excluido(NEW.cd_material, NEW.nm_usuario, NEW.nr_atendimento);
end if;

-- OS 465559

select	max(dt_geracao_resumo),
	max(ie_status_acerto)
into STRICT	dt_geracao_resumo_new_w,
	ie_status_acerto_w
from 	conta_paciente
where 	nr_interno_conta = coalesce(NEW.nr_interno_conta,0);

select	max(dt_geracao_resumo)
into STRICT	dt_geracao_resumo_old_w
from 	conta_paciente
where 	nr_interno_conta = coalesce(OLD.nr_interno_conta,0);

if (dt_geracao_resumo_new_w is not null) then
	update	conta_paciente
	set 	dt_geracao_resumo  = NULL
	where 	nr_interno_conta = NEW.nr_interno_conta;		
end if;	

if (dt_geracao_resumo_old_w is not null) then
	update	conta_paciente
	set 	dt_geracao_resumo  = NULL
	where 	nr_interno_conta = OLD.nr_interno_conta;		
end if;

if (ie_status_acerto_w = 2) and (NEW.vl_material <> OLD.vl_material) then

	select	substr(max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),1,255),
			substr(max(osuser),1,100)
	into STRICT	ds_module_log_w,
			osuser_log_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );
	
	ds_call_stack_w	:= substr(dbms_utility.format_call_stack,1,1800);
	
	insert	into mat_atend_pac_log(
		nr_sequencia,
		nr_seq_mat,
		dt_atualizacao,	
		nm_usuario,
		ds_module,
		nr_atendimento,
		nr_interno_conta,
		cd_material,
		dt_atendimento,
		ie_acao,
		qt_material,
		vl_material,
		cd_perfil,
		cd_funcao,
		ie_valor_informado,
		nr_seq_proc_pacote,
		nr_seq_proc_princ,
		cd_setor_atendimento,
		dt_entrada_unidade,
		nr_seq_atepacu,
		nr_prescricao,
		cd_local_estoque,
		qt_material_ant,
		ds_call_stack)
	values (nextval('mat_atend_pac_log_seq'),
		NEW.nr_sequencia,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		ds_module_log_w,
		NEW.nr_atendimento,
		NEW.nr_interno_conta,
		NEW.cd_material,
		NEW.dt_atendimento,
		'AV',
		NEW.qt_material,
		NEW.vl_material,
		obter_perfil_ativo,
		obter_funcao_ativa,
		NEW.ie_valor_informado,
		NEW.nr_seq_proc_pacote,
		NEW.nr_seq_proc_princ,
		NEW.cd_setor_atendimento,
		NEW.dt_entrada_unidade,
		NEW.nr_seq_atepacu,
		NEW.nr_prescricao,
		NEW.cd_local_estoque,
		OLD.qt_material,
		ds_call_stack_w);
end if;

if (coalesce(NEW.vl_material, 0) <> coalesce(OLD.vl_material, 0)) and (ie_log_valor_mat_w = 'S') then
	
	select	substr(max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),1,255)
	into STRICT	ds_module_log_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );

	ds_call_stack_w	:= substr(dbms_utility.format_call_stack,1,1800);
	
	insert	into mat_atend_pac_log(
		nr_sequencia,
		nr_seq_mat,
		dt_atualizacao,	
		nm_usuario,
		ds_module,
		nr_atendimento,
		nr_interno_conta,
		cd_material,
		dt_atendimento,
		ie_acao,
		qt_material,
		vl_material,
		cd_perfil,
		cd_funcao,
		ie_valor_informado,
		nr_seq_proc_pacote,
		nr_seq_proc_princ,
		cd_setor_atendimento,
		dt_entrada_unidade,
		nr_seq_atepacu,
		nr_prescricao,
		cd_local_estoque,
		qt_material_ant,
		ds_call_stack)
	values (nextval('mat_atend_pac_log_seq'),
		NEW.nr_sequencia,
		LOCALTIMESTAMP,
		NEW.nm_usuario,
		ds_module_log_w,
		NEW.nr_atendimento,
		NEW.nr_interno_conta,
		NEW.cd_material,
		NEW.dt_atendimento,
		'AV',
		NEW.qt_material,
		NEW.vl_material,
		obter_perfil_ativo,
		obter_funcao_ativa,
		NEW.ie_valor_informado,
		NEW.nr_seq_proc_pacote,
		NEW.nr_seq_proc_princ,
		NEW.cd_setor_atendimento,
		NEW.dt_entrada_unidade,
		NEW.nr_seq_atepacu,
		NEW.nr_prescricao,
		NEW.cd_local_estoque,
		OLD.qt_material,
		ds_call_stack_w);
	
end if;

if (OLD.cd_local_estoque <> NEW.cd_local_estoque) then
	CALL grava_log_tasy(44200, ' :old.cd_local_estoque= ' || OLD.cd_local_estoque ||
						' :new.cd_local_estoque= ' || NEW.cd_local_estoque ||
						' :new.nr_atendimento= ' || NEW.nr_atendimento ||
						' :new.nr_sequencia= ' || NEW.nr_sequencia ||
						' :new.ds_stack= ' || NEW.ds_stack, NEW.nr_sequencia);
end if;

if (OLD.dt_atualizacao_estoque <> NEW.dt_atualizacao_estoque) then
	CALL grava_log_tasy(44200, ' :old.dt_atualizacao_estoque= ' || OLD.dt_atualizacao_estoque ||
						' :new.dt_atualizacao_estoque= ' || NEW.dt_atualizacao_estoque ||
						' :new.nr_atendimento= ' || NEW.nr_atendimento ||
						' :new.nr_sequencia= ' || NEW.nr_sequencia ||
						' :new.ds_stack= ' || NEW.ds_stack, NEW.nr_sequencia);
end if;

if (OLD.nr_seq_tipo_baixa <> NEW.nr_seq_tipo_baixa) then
	CALL grava_log_tasy(44200, ' :old.nr_seq_tipo_baixa= ' || OLD.nr_seq_tipo_baixa ||
						' :new.nr_seq_tipo_baixa= ' || NEW.nr_seq_tipo_baixa ||
						' :new.nr_atendimento= ' || NEW.nr_atendimento ||
						' :new.nr_sequencia= ' || NEW.nr_sequencia ||
						' :new.ds_stack= ' || NEW.ds_stack, NEW.nr_sequencia);
end if;

<<final>>
qt_reg_w	:= 0;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_material_atend_paciente_update() FROM PUBLIC;

CREATE TRIGGER material_atend_paciente_update
	BEFORE UPDATE ON material_atend_paciente FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_material_atend_paciente_update();
