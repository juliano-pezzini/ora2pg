-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS movto_trans_financ_delete ON movto_trans_financ CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_movto_trans_financ_delete() RETURNS trigger AS $BODY$
declare

nr_seq_saldo_banco_w		bigint;
ie_acao_w			integer;
ds_historico_w			varchar(4000);
/* Projeto Multimoeda - Variaveis */


vl_transacao_estrang_w		double precision;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
BEGIN

if (OLD.dt_fechamento_lote is not null) then
	/* O lote de caixa ja foi fechado, o lancamento nao pode ser excluido!
	Lote: :old.nr_seq_lote
	Seq: :old.nr_sequencia
	Dt fechamento: :old.dt_fechamento_lote */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(244040, 'NR_SEQ_LOTE_W=' || OLD.nr_seq_lote ||
							';NR_SEQUENCIA_W=' || OLD.nr_sequencia ||
							';DT_FECHAMENTO_LOTE_W=' || OLD.dt_fechamento_lote);
end if;

if (OLD.nr_lote_contabil <> 0) then
	/* Este lancamento ja esta contablizado, nao pode ser excluido! */


	CALL wheb_mensagem_pck.exibir_mensagem_abort(244042);
end if;

if (OLD.nr_seq_banco	is not null) then
	BEGIN

	select	ie_acao
	into STRICT	ie_acao_w
	from	transacao_financeira
	where	nr_sequencia = OLD.nr_seq_trans_financ;

	if (ie_acao_w <> 0) then
		/* A acao desta transacao nao permite que o lancamento seja excluido! */


		CALL wheb_mensagem_pck.exibir_mensagem_abort(244043);
	end if;

	/* Projeto Multimoeda - Verifica se a transacao e moeda estrangeira */


	if (coalesce(OLD.vl_transacao_estrang,0) <> 0) then
		vl_transacao_estrang_w := OLD.vl_transacao_estrang * -1;
	else
		vl_transacao_estrang_w := null;
	end if;
	
	nr_seq_saldo_banco_w := Atualizar_Saldo_Movto_Bco(	OLD.nr_sequencia, OLD.nm_usuario, (OLD.vl_transacao * -1), OLD.nr_seq_banco, OLD.dt_transacao, OLD.nr_seq_trans_financ, nr_seq_saldo_banco_w, vl_transacao_estrang_w);
	end;
end if;

/* Grava o agendamento da informacao para atualizacao do fluxo de caixa. */


CALL gravar_agend_fluxo_caixa(OLD.nr_sequencia,null,'CBT',OLD.dt_transacao,'E',OLD.nm_usuario);
if (OLD.nr_seq_banco is not null) then
	CALL gravar_agend_fluxo_caixa(OLD.nr_sequencia,OLD.nr_seq_banco,'CBS',OLD.dt_transacao,'E',OLD.nm_usuario);
end if;

exception
when	others then
	BEGIN

	ds_historico_w	:=	substr(wheb_mensagem_pck.get_texto(304242),1,255) || ': ' || trim(both to_char(OLD.vl_transacao,'999999990.00')) || chr(13) || chr(10) ||
				substr(wheb_mensagem_pck.get_texto(304243),1,255) || ': ' || OLD.nr_seq_trans_financ || chr(13) || chr(10) ||
				substr(wheb_mensagem_pck.get_texto(304244),1,255) || ': ' || OLD.nr_sequencia;

	ds_historico_w	:= substr(sqlerrm,1,2000) || chr(13) || chr(10) || ds_historico_w;

	CALL gerar_banco_caixa_hist(	OLD.nr_seq_banco,
				OLD.nr_seq_caixa,
				ds_historico_w,
				OLD.nm_usuario,
				'S',
				'S');

	/* ds_historico_w */


	CALL wheb_mensagem_pck.exibir_mensagem_abort(244091,'DS_HISTORICO_W=' || ds_historico_w);

	end;

end;
end if;

  END;
RETURN OLD;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_movto_trans_financ_delete() FROM PUBLIC;

CREATE TRIGGER movto_trans_financ_delete
	BEFORE DELETE ON movto_trans_financ FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_movto_trans_financ_delete();
