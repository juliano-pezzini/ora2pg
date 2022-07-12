-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS pls_conta_proc_tiss_update ON pls_conta_proc CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_pls_conta_proc_tiss_update() RETURNS trigger AS $BODY$
declare

ie_tipo_evento_w	pls_monitor_tiss_alt.ie_tipo_evento%type	:= null;
ie_status_conta_w	pls_conta.ie_status%type;
qt_registros_w		integer;
qt_reg_pag_w		integer;

BEGIN
-- Essa trigger foi comentada pois o processo de alteração de valores do monitoramento
-- foi retirado, pois no processo do Tasy a conta passava a ser enviada somente duas vezes
-- uma no fechamento, com os valores apresentados, e uma no pagamento, com os valores pagos
-- como não é possível o envio de registros de alteração de valores após o envio de pagamento
-- e  não é possível a alteração dos valores apresentados, para o atual processo do Tasy e do
-- monitoramento, esse processo torna-se inútil. O conceito do processo de alteração seria
-- para qualquer informação, não somente para valores, quando tivermos uma estrutura que permita
-- o envio de qualquer alteração no item ou na conta, poderemos retomar esse processo.
null;

/*
if	(wheb_usuario_pck.get_ie_executar_trigger = 'S') then

	if	(:old.vl_liberado <> :new.vl_liberado) or
		(:old.vl_procedimento <> :new.vl_procedimento) or
		(:old.vl_glosa <> :new.vl_glosa) or
		(:old.vl_procedimento_imp <> :new.vl_procedimento_imp) then

		select	a.ie_status
		into	ie_status_conta_w
		from	pls_conta a
		where	a.nr_sequencia	= :new.nr_seq_conta;

		if	(ie_status_conta_w = 'F') then

			--Apenas envia como alteração caso a conta fechada já tenha sido enviada ou foi processada no monitoramento
			select	count(1)
			into	qt_registros_w
			from	pls_monitor_tiss_alt
			where	nr_seq_conta 		= :new.nr_seq_conta
			and	nr_seq_conta_proc	= :new.nr_sequencia
			and	ie_tipo_evento		= 'FC'
			and	ie_status		in ('A','PR');

			--Não envia a alteração de valor se a conta já tiver seu pagamento aceito
			select	count(1)
			into	qt_reg_pag_w
			from	pls_monitor_tiss_alt
			where	nr_seq_conta 		= :new.nr_seq_conta
			and	nr_seq_conta_proc	= :new.nr_sequencia
			and	ie_tipo_evento		= 'PC'
			and	ie_status		in ('A','PR');

			if	(qt_reg_pag_w > 0) then
				ie_tipo_evento_w := null;
			elsif	(qt_registros_w > 0) then
				ie_tipo_evento_w := 'AV';
			end if;
		end if;
	end if;

	if	(ie_tipo_evento_w is not null) and
		(:old.ie_status <> 'M') then
		pls_tiss_gravar_log_monitor(ie_tipo_evento_w,
					:new.nr_seq_conta,
					:new.nr_sequencia,
					null,
					null,
					null,
					null,
					:new.qt_procedimento_imp,
					:new.vl_provisao,
					:new.qt_procedimento,
					:new.vl_liberado,
					:new.nm_usuario,
					sysdate);
	end if;
end if;
*/
RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_pls_conta_proc_tiss_update() FROM PUBLIC;

CREATE TRIGGER pls_conta_proc_tiss_update
	BEFORE UPDATE ON pls_conta_proc FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_pls_conta_proc_tiss_update();
