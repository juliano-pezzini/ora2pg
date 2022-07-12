-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS intpd_ordem_compra ON ordem_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_intpd_ordem_compra() RETURNS trigger AS $BODY$
declare
 
reg_integracao_p		gerar_int_padrao.reg_integracao;
qt_registros_w			bigint;
BEGIN
  BEGIN 
 
if (TG_OP = 'INSERT' or TG_OP = 'UPDATE') then 
	 
	reg_integracao_p.cd_estab_documento	:= NEW.cd_estabelecimento;
	reg_integracao_p.ie_tipo_ordem		:= NEW.ie_tipo_ordem;
	reg_integracao_p.nr_seq_tipo_compra	:= NEW.nr_seq_tipo_compra;
	reg_integracao_p.nr_seq_mod_compra	:= NEW.nr_seq_mod_compra;
	reg_integracao_p.ds_id_origin		:= NEW.ie_origem_imp;
	 
	BEGIN 
	select	1 
	into STRICT	qt_registros_w 
	from	intpd_fila_transmissao 
	where	nr_seq_documento = NEW.nr_ordem_compra 
	and	ie_evento = '2'  LIMIT 1;
	exception 
	when others then 
		qt_registros_w := 0;
	end;
	 
	if (qt_registros_w = 0) and /*Somente faz a inserção caso não tenha nenhum registro dessa ordem de compra na fila. Se tiver, manda alteração no final dessa trigger*/
 
		(OLD.dt_aprovacao is null) and (NEW.dt_aprovacao is not null) and (NEW.dt_baixa is null) then		 
		 
		reg_integracao_p.ie_operacao		:= 'I';				
		reg_integracao_p := gerar_int_padrao.gravar_integracao('2', NEW.nr_ordem_compra, NEW.nm_usuario, reg_integracao_p);
 
	elsif (TG_OP = 'UPDATE') and /*Quando já tem um registro desta ordem de compra na fila, manda o update*/
 
		(qt_registros_w > 0) then 
		 
		BEGIN 
		select	1 
		into STRICT	qt_registros_w 
		from	intpd_fila_transmissao 
		where	nr_seq_documento = NEW.nr_ordem_compra 
		and	ie_evento = '2' 
		and	coalesce(ie_status,'P') not in ('P','R')  LIMIT 1;
		exception 
		when others then 
			qt_registros_w := 0;
		end;
 
		if (qt_registros_w > 0) then 
		 
			reg_integracao_p.ie_operacao		:= 'A';			
			reg_integracao_p := gerar_int_padrao.gravar_integracao('2', NEW.nr_ordem_compra, NEW.nm_usuario, reg_integracao_p);
		end if;
	end if;
elsif (TG_OP = 'DELETE') then 
	 
	reg_integracao_p.cd_estab_documento	:= null;
	reg_integracao_p.ie_tipo_ordem		:= null;
	reg_integracao_p.nr_seq_tipo_compra	:= null;
	reg_integracao_p.nr_seq_mod_compra	:= null;
	reg_integracao_p.ds_id_origin		:= null;
	 
	 
	BEGIN 
	select	1 
	into STRICT	qt_registros_w 
	from	intpd_fila_transmissao 
	where	nr_seq_documento = OLD.nr_ordem_compra 
	and	ie_evento = '2' 
	and	ie_status in ('S')  LIMIT 1;
	exception 
	when others then 
		qt_registros_w := 0;
	end;
 
	if (qt_registros_w > 0) then	 
		reg_integracao_p.ie_operacao		:= 'E';
		reg_integracao_p := gerar_int_padrao.gravar_integracao('2', OLD.nr_ordem_compra, OLD.nm_usuario, reg_integracao_p);
	end if;
end if;
 
  END;
IF TG_OP = 'DELETE' THEN
	RETURN OLD;
ELSE
	RETURN NEW;
END IF;

end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_intpd_ordem_compra() FROM PUBLIC;

CREATE TRIGGER intpd_ordem_compra
	BEFORE INSERT OR UPDATE OR DELETE ON ordem_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_intpd_ordem_compra();
