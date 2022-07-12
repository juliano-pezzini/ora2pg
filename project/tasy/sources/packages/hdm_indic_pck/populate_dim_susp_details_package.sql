-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_susp_details () AS $body$
BEGIN
		merge into hdm_indic_dm_susp_details y
		using (	SELECT	a.si_status,
				a.ds_status,
				b.ds_reason,
				c.si_reason_kind,
				c.ds_reason_kind
			from (	select	'A' si_status,
						wheb_mensagem_pck.get_texto(388907) ds_status
					
					
union

					SELECT	'I',
						wheb_mensagem_pck.get_texto(388908)
					) a,
				(	select	ds_motivo ds_reason
					from	mprev_motivo_susp_atend
					
union

					select	wheb_mensagem_pck.get_texto(386223)
					) b,
				(	select	vl_dominio si_reason_kind,
						ds_valor_dominio ds_reason_kind
					from	valor_dominio_v
					where	cd_dominio = 7304 and ie_situacao = 'A'
					
union

					select	'0',
						wheb_mensagem_pck.get_texto(371621)
					) c) x
		on (	y.ds_reason = x.ds_reason and
			y.si_status = x.si_status and
			y.si_reason_kind = x.si_reason_kind)
		when not matched then
			insert(y.nr_sequencia,
				y.dt_atualizacao,
				y.nm_usuario,
				y.dt_atualizacao_nrec,
				y.nm_usuario_nrec,
				y.si_status,
				y.si_reason,
				y.si_reason_kind,
				y.ds_status,
				y.ds_reason,
				y.ds_reason_kind)
			values (nextval('hdm_indic_dm_susp_details_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.si_status,
				'X',
				x.si_reason_kind,
				x.ds_status,
				x.ds_reason,
				x.ds_reason_kind);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_susp_details () FROM PUBLIC;