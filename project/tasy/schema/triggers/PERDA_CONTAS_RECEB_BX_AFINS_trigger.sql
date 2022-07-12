-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS perda_contas_receb_bx_afins ON perda_contas_receb_baixa CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_perda_contas_receb_bx_afins() RETURNS trigger AS $BODY$
declare

ie_tipo_consistencia_w		varchar(15);
nr_seq_cobranca_w		bigint;
cd_estabelecimento_w		smallint;
nr_seq_hist_cob_liq_w		bigint;
nr_seq_hist_cob_pend_w		bigint;
nr_seq_hist_cob_perda_baixa_w	bigint;
nr_seq_hist_cob_perda_est_bx_w	bigint;
nr_seq_historico_w			bigint;

nr_titulo_w			bigint;
nr_seq_cheque_w			bigint;
vl_acobrar_w			double precision;

vl_cheque_w				cheque_cr.vl_cheque%type;
vl_saldo_negociado_w	cheque_cr.vl_saldo_negociado%type;

c01 CURSOR FOR
SELECT	nr_sequencia,
	vl_acobrar
from	cobranca
where	nr_seq_cheque = nr_seq_cheque_w

union

SELECT	nr_sequencia,
	vl_acobrar
from	cobranca
where	nr_titulo = nr_titulo_w;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
select	max(ie_tipo_consistencia)
into STRICT	ie_tipo_consistencia_w
from	fin_tipo_baixa_perda
where	nr_sequencia = NEW.nr_seq_tipo_baixa;

if (ie_tipo_consistencia_w in (0,1,2)) then
	BEGIN
	select	nr_titulo,
		nr_seq_cheque,
		cd_estabelecimento
	into STRICT	nr_titulo_w,
		nr_seq_cheque_w,
		cd_estabelecimento_w
	from	perda_contas_receber
	where	nr_sequencia = NEW.nr_seq_perda;
	
	select	max(nr_seq_hist_cob),
		max(nr_seq_hist_cob_pend),
		max(nr_seq_hist_cob_perda_baixa),
		max(nr_seq_hist_cob_perda_est_bx)
	into STRICT	nr_seq_hist_cob_liq_w,
		nr_seq_hist_cob_pend_w,
		nr_seq_hist_cob_perda_baixa_w,
		nr_seq_hist_cob_perda_est_bx_w
	from	parametro_contas_receber
	where	cd_estabelecimento	= cd_estabelecimento_w;
	
	if (nr_seq_hist_cob_perda_baixa_w is null) or (nr_seq_hist_cob_perda_est_bx_w is null) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(231544);
	end if;

	open c01;
	loop
	fetch c01 into	
		nr_seq_cobranca_w,
		vl_acobrar_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		BEGIN		
		vl_acobrar_w		:= vl_acobrar_w - NEW.vl_baixa;
		
		update	cobranca
		set	vl_acobrar	= vl_acobrar_w,
			nm_usuario	= NEW.nm_usuario,
			dt_atualizacao	= LOCALTIMESTAMP
		where	nr_sequencia	= nr_seq_cobranca_w;
		
		if (NEW.vl_baixa > 0) then
			nr_seq_historico_w	:= nr_seq_hist_cob_perda_baixa_w;
		else
			nr_seq_historico_w	:= nr_seq_hist_cob_perda_est_bx_w;
		end if;
		
		insert into cobranca_historico(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			nr_seq_cobranca,
			nr_seq_historico,
			dt_historico,
			ds_historico)
		values (	nextval('cobranca_historico_seq'),
			NEW.nm_usuario,
			LOCALTIMESTAMP,
			NEW.nm_usuario,
			LOCALTIMESTAMP,
			nr_seq_cobranca_w,
			nr_seq_historico_w,
			LOCALTIMESTAMP,
			substr(wheb_mensagem_pck.get_texto(304189) || campo_mascara_virgula(NEW.vl_baixa) || chr(13) || chr(10) || wheb_mensagem_pck.get_texto(304196) || to_char(NEW.dt_baixa,'dd/mm/yyyy hh24:mi:ss'),1,4000));
		end;
	end loop;
	close c01;
	end;
end if;

/*OS 1799459 Se o cheque tiver baixa por perda, verificar se a perda foi cancelada, para devolver o saldo negociado ao cheque e poder ser negociado novamente*/


if (ie_tipo_consistencia_w = 4) then

	select	max(nr_seq_cheque)
	into STRICT	nr_seq_cheque_w
	from	perda_contas_receber
	where	nr_sequencia = NEW.nr_seq_perda;
	
	if (nr_seq_cheque_w is not null) then

		--Nao chamei a atualizar_saldo_neg_cheque_cr aqui onde faz esse calculo pois ia dar mutante

		select	max(vl_cheque),
				max(vl_saldo_negociado)
		into STRICT	vl_cheque_w,
				vl_saldo_negociado_w
		from	cheque_cr
		where	nr_seq_cheque = nr_seq_cheque_w;
		
		if  ((coalesce(vl_saldo_negociado_w,0) + coalesce(NEW.vl_baixa,0)) <= vl_cheque_w) then --O saldo negociado atual do cheque somado com o valor dessa baixa deve ser menor ou no maximo igual ao valor do cheque
				update	cheque_cr
				set		vl_saldo_negociado	= vl_saldo_negociado + coalesce(NEW.vl_baixa,0)
				where	nr_seq_cheque		= nr_seq_cheque_w;
		end if;
		
	end if;
end if;
/*OS 1799459 - FIM*/


end if;

RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_perda_contas_receb_bx_afins() FROM PUBLIC;

CREATE TRIGGER perda_contas_receb_bx_afins
	AFTER INSERT ON perda_contas_receb_baixa FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_perda_contas_receb_bx_afins();
