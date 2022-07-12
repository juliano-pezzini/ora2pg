-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS adiantamento_after_insert ON adiantamento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_adiantamento_after_insert() RETURNS trigger AS $BODY$
declare
  qt_reg_w bigint;
  reg_integracao_p                gerar_int_padrao.reg_integracao;
  BEGIN
  if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
  select count(*)
  into STRICT qt_reg_w
  from intpd_fila_transmissao
  where nr_seq_documento                               = to_char(NEW.nr_adiantamento)
  and to_char(dt_atualizacao, 'dd/mm/yyyy hh24:mi:ss') = to_char(LOCALTIMESTAMP,'dd/mm/yyyy hh24:mi:ss')
  and ie_evento                                       in ('323');
  if (qt_reg_w                                         = 0) then
    /*envio de cadastros financeiros - baixa de titulo*/


    reg_integracao_p := gerar_int_padrao.gravar_integracao('323', NEW.nr_adiantamento, NEW.nm_usuario, reg_integracao_p);
  end if;
  end if;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_adiantamento_after_insert() FROM PUBLIC;

CREATE TRIGGER adiantamento_after_insert
	AFTER INSERT ON adiantamento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_adiantamento_after_insert();
