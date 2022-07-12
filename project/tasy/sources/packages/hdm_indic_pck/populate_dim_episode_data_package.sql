-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_episode_data () AS $body$
BEGIN
		merge into hdm_indic_dm_episode_det y
		using(	SELECT	a.vl_dominio si_type,
				a.ds_valor_dominio ds_type,
				b.vl_dominio si_form, 
				b.ds_valor_dominio ds_form,
				mprev_obter_dados_agenda(z.cd_agenda, 'NM') nm_place,
				'N' si_default
			from	valor_dominio_v a,
				valor_dominio_v b,
				mprev_local_atend_agenda z
			where	a.cd_dominio = 6085
			and	b.cd_dominio = 5800
			
union

			/* Without form */


			SELECT  a.vl_dominio si_type, 
				a.ds_valor_dominio ds_type,	  
				'0' si_form, 
				wheb_mensagem_pck.get_texto(383298) ds_form,
				mprev_obter_dados_agenda(z.cd_agenda, 'NM') nm_place,
				'N' si_default
			from	valor_dominio_v a,
				mprev_local_atend_agenda z
			where	a.cd_dominio = 6085
			
union

			/* Without place */


			select	a.vl_dominio si_type, 
				a.ds_valor_dominio ds_type,
				b.vl_dominio si_form, 
				b.ds_valor_dominio ds_form,
				wheb_mensagem_pck.get_texto(383299) nm_place,
				'N' si_default
			from	valor_dominio_v a,
				valor_dominio_v b
			where	a.cd_dominio = 6085
			and	b.cd_dominio = 5800
			
union

			/* Without form and place */


			select  a.vl_dominio si_type, 
				a.ds_valor_dominio ds_type,	  
				'0' si_form, 
				wheb_mensagem_pck.get_texto(383298) ds_form,
				wheb_mensagem_pck.get_texto(383299) nm_place,
				'N' si_default
			from	valor_dominio_v A
			where	a.cd_dominio = 6085
			
union

			/* Without form, place and type */


			select  '0' si_type, 
				wheb_mensagem_pck.get_texto(371621) ds_type,
				'0' si_form, 
				wheb_mensagem_pck.get_texto(383298) ds_form,
				wheb_mensagem_pck.get_texto(383299) nm_place,
				'S' si_default
			
			) x
		on (	(y.si_type = x.si_type and
			y.si_form = x.si_form and
			y.nm_place = x.nm_place) or (y.nr_sequencia = 0))
		when not matched then
			insert(y.nr_sequencia, 
				y.dt_atualizacao, 
				y.nm_usuario, 
				y.dt_atualizacao_nrec, 
				y.nm_usuario_nrec, 
				y.si_type, 
				y.si_form, 
				y.nm_place,
				y.ds_type,
				y.ds_form)
			values (CASE WHEN x.si_default='S' THEN  0  ELSE nextval('hdm_indic_dm_episode_det_seq') END ,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.si_type, 
				x.si_form, 
				x.nm_place,
				x.ds_type,
				x.ds_form);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_episode_data () FROM PUBLIC;
