-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_venc_jur_mult_cre ( nm_usuario_p text, vl_juros_p bigint, vl_multa_p bigint, dt_vencimento_p timestamp, ie_zera_multa_juros_p text, nr_titulo_p bigint, ie_portal_p text) AS $body$
BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	if (ie_zera_multa_juros_p = 'S') then
		update	titulo_receber
		set	VL_SALDO_JUROS			= vl_juros_p,
			VL_SALDO_MULTA			= CASE WHEN coalesce(ie_portal_p,'S')='S' THEN CASE WHEN VL_SALDO_MULTA=0 THEN  vl_multa_p  ELSE VL_SALDO_MULTA END   ELSE vl_multa_p END ,  /* -- Edgar 08/03/2013, OS 560273, se a multa já foi gerada em uma alteração de vencimento, a mesma não deve sofrer alterações*/
			DT_PAGAMENTO_PREVISTO		= dt_vencimento_p,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp()
		where   nr_titulo			= nr_titulo_p;
	end if;
	if (ie_zera_multa_juros_p = 'N') then
		update	titulo_receber
		set	VL_SALDO_JUROS			= vl_juros_p + VL_SALDO_JUROS,
			VL_SALDO_MULTA			= vl_multa_p + VL_SALDO_MULTA,
			DT_PAGAMENTO_PREVISTO		= dt_vencimento_p,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao			= clock_timestamp()
		where   nr_titulo			= nr_titulo_p;
	end if;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_venc_jur_mult_cre ( nm_usuario_p text, vl_juros_p bigint, vl_multa_p bigint, dt_vencimento_p timestamp, ie_zera_multa_juros_p text, nr_titulo_p bigint, ie_portal_p text) FROM PUBLIC;
