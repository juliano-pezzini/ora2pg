-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_appointment_data () AS $body$
BEGIN
		merge into hdm_indic_dm_app_details y
		using (	SELECT  a.si_type,
				a.ds_type,
				b.si_form,
				b.ds_form,
				c.nm_place,
				d.si_status,
				d.ds_status,
				e.nr_reason_cancel,
				e.ds_reason_cancel,
				f.si_confirmed,
				f.ds_confirmed,
				g.si_cancelled,
				g.ds_cancelled
			from (	select	x.vl_dominio si_type,
						x.ds_valor_dominio ds_type
					from	valor_dominio_v x
					where	x.cd_dominio = 6085 and x.ie_situacao = 'A'
					
union

					SELECT	'0' si_type,
						wheb_mensagem_pck.get_texto(371621) ds_type
					) a,
				(	select	x.vl_dominio si_form,
						x.ds_valor_dominio ds_form
					from	valor_dominio_v x
					where	x.cd_dominio = 5800 and x.ie_situacao = 'A'
					
union

					select	'0' si_form,
						wheb_mensagem_pck.get_texto(383298) ds_form
					) b,
				(	select	mprev_obter_dados_agenda(x.cd_agenda, 'NM') nm_place
					from	mprev_local_atend_agenda x
					
union

					select	wheb_mensagem_pck.get_texto(383299) nm_place
					) c,
				(	select	x.vl_dominio si_status,
						x.ds_valor_dominio ds_status
					from	valor_dominio_v x
					where	x.cd_dominio = 6125 and x.ie_situacao = 'A') d,
				(	select	x.nr_sequencia nr_reason_cancel,
						substr(x.ds_motivo,1,255) ds_reason_cancel
					from	agenda_motivo_cancelamento x
					
union

					select	0 nr_reason_cancel,
						wheb_mensagem_pck.get_texto(386223) ds_reason_cancel
					) e,
				(	select	x.vl_dominio si_confirmed,
						x.ds_valor_dominio ds_confirmed
					from	valor_dominio_v x
					where	x.cd_dominio = 6 and x.ie_situacao = 'A') f,
				(	select	x.vl_dominio si_cancelled,
						x.ds_valor_dominio ds_cancelled
					from	valor_dominio_v x
					where	x.cd_dominio = 6 and x.ie_situacao = 'A') g
			) x
		on (	y.si_type = x.si_type and
			y.si_form = x.si_form  and
			y.nm_place = x.nm_place and
			y.nr_reason_cancel = x.nr_reason_cancel and
			y.si_status = x.si_status and
			y.si_confirmed = x.si_confirmed  and
			y.si_cancelled = x.si_cancelled)
		when not matched then
			insert(y.nr_sequencia,
				y.dt_atualizacao, 
				y.nm_usuario, 
				y.dt_atualizacao_nrec, 
				y.nm_usuario_nrec, 
				y.si_type, 
				y.si_form, 
				y.nm_place, 
				y.nr_reason_cancel, 
				y.si_status, 
				y.si_confirmed, 
				y.si_cancelled, 
				--y.qt_days_wait, 

				y.ds_cancelled, 
				y.ds_confirmed, 
				y.ds_form, 
				y.ds_reason_cancel, 
				y.ds_status, 
				y.ds_type)
			values (nextval('hdm_indic_dm_app_details_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.si_type, 
				x.si_form, 
				x.nm_place,
				x.nr_reason_cancel, 
				x.si_status, 
				x.si_confirmed, 
				x.si_cancelled, 
				--x.qt_days_wait, 

				x.ds_cancelled, 
				x.ds_confirmed, 
				x.ds_form, 
				x.ds_reason_cancel, 
				x.ds_status, 
				x.ds_type);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_appointment_data () FROM PUBLIC;