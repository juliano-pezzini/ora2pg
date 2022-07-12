-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS movto_cartao_cr_update ON movto_cartao_cr CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_movto_cartao_cr_update() RETURNS trigger AS $BODY$
DECLARE

dt_fechamento_w		timestamp	:= null;
nr_recibo_w		bigint;
qt_reg_w	smallint;
BEGIN
if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
if (OLD.nr_seq_caixa_rec is not null) and (NEW.dt_cancelamento is null) and (coalesce(OLD.vl_transacao,0) <> coalesce(NEW.vl_transacao,0)) then

	if (	NEW.dt_transacao	<>	OLD.dt_transacao) then
		/* Projeto Davita  - Não deixa gerar movimento contabil após fechamento  da data */


		CALL philips_contabil_pck.valida_se_dia_fechado(OBTER_EMPRESA_ESTAB(NEW.cd_estabelecimento),NEW.dt_transacao);
	end if;	
	
	select	max(dt_fechamento),
		max(nr_recibo)
	into STRICT	dt_fechamento_w,
		nr_recibo_w
	from	caixa_receb
	where	nr_sequencia	= OLD.nr_seq_caixa_rec;

	if (dt_fechamento_w is not null) then
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(277731, 'NR_RECIBO_P=' || nr_recibo_w);
	end if;
end if;

<<Final>>
qt_reg_w	:= 0;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_movto_cartao_cr_update() FROM PUBLIC;

CREATE TRIGGER movto_cartao_cr_update
	BEFORE UPDATE ON movto_cartao_cr FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_movto_cartao_cr_update();

