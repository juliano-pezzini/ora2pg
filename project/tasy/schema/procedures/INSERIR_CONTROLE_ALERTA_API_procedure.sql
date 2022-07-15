-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_controle_alerta_api ( cd_api_p alerta_api.cd_api%type, ie_status_requisicao_p alerta_api.ie_status_requisicao%type, nr_seq_cpoe_p alerta_api.nr_seq_cpoe%type, nr_prescricao_p alerta_api.nr_prescricao%type, nr_seq_material_p alerta_api.nr_seq_material%type, nr_seq_controle_p INOUT alerta_api.nr_sequencia%type, dt_validade_p alerta_api.dt_validade%type default null, ds_erro_p alerta_api.ds_resultado%type default null, ie_load_cache_p text default null) AS $body$
DECLARE


	nr_sequencia_w	alerta_api.nr_sequencia%type;

	c_oldItems CURSOR FOR
		SELECT distinct
			   a.cd_api cd_api,
			   a.nr_seq_cpoe nr_seq_cpoe
		  from alerta_api a
		 where nr_sequencia = nr_seq_controle_p
		   and (a.nr_seq_cpoe IS NOT NULL AND a.nr_seq_cpoe::text <> '')
		   and coalesce(ie_load_cache_p, 'N') = 'N';

	procedure delete_items is
	;
BEGIN
		if ((coalesce(nr_seq_controle_p, 0) > 0) or (coalesce(ie_load_cache_p, 'N') = 'S')) then
			/* Gambiarra pra limpar os itens das requisicoes anteriores */

			for oldItems_w in c_oldItems
			loop
				delete from alerta_api
				 where nr_seq_cpoe = oldItems_w.nr_seq_cpoe
				   and cd_api = oldItems_w.cd_api
				   and nr_seq_controle < nr_seq_controle_p
				   and (nr_seq_cpoe IS NOT NULL AND nr_seq_cpoe::text <> '');
			end loop;

			if (coalesce(cd_api_p, 'ALL') <> 'ALL') then
				delete from alerta_api
				where nr_sequencia = nr_seq_controle_p;
			end if;
			
			commit;

		elsif (coalesce(nr_seq_cpoe_p, 0) > 0) then

			delete from alerta_api
			 where nr_seq_cpoe = nr_seq_cpoe_p
			   and ((cd_api = cd_api_p) or (coalesce(cd_api_p, 'ALL') = 'ALL'));
			
			commit;

		elsif (coalesce(nr_prescricao_p, 0) > 0) then

			delete from alerta_api
			 where nr_prescricao = nr_prescricao_p
			   and ((cd_api = cd_api_p) or (coalesce(cd_api_p, 'ALL') = 'ALL'));

			commit;

		end if;	
	end;

	procedure update_items is
	begin
		if ((coalesce(nr_seq_controle_p, 0) > 0) or (coalesce(ie_load_cache_p, 'N') = 'S')) then

			update alerta_api
			   set ie_status_requisicao = ie_status_requisicao_p,
				   dt_validade = dt_validade_p,
				   ds_resultado = ds_erro_p
			 where nr_sequencia = nr_seq_controle_p;

			commit;
		
		elsif (coalesce(nr_seq_cpoe_p, 0) > 0) then

			update alerta_api
			   set ie_status_requisicao = ie_status_requisicao_p,
				   dt_validade = dt_validade_p,
				   ds_resultado = ds_erro_p
			 where nr_seq_cpoe = nr_seq_cpoe_p
			   and ((cd_api = cd_api_p) or (coalesce(cd_api_p, 'ALL') = 'ALL'))
			   and ie_status_requisicao = 'I';

			commit;

		elsif (coalesce(nr_prescricao_p, 0) > 0) then

			update alerta_api
			   set ie_status_requisicao = ie_status_requisicao_p,
				   dt_validade = dt_validade_p,	
				   ds_resultado = ds_erro_p
			 where nr_prescricao = nr_prescricao_p
			   and ((cd_api = cd_api_p) or (coalesce(cd_api_p, 'ALL') = 'ALL'))
			   and ie_status_requisicao = 'I';

			commit;

		end if;
	end;

begin



	if (ie_status_requisicao_p = 'I') then

		if ((cd_api_p IS NOT NULL AND cd_api_p::text <> '') and (ie_status_requisicao_p IS NOT NULL AND ie_status_requisicao_p::text <> '') and
			((coalesce(nr_seq_cpoe_p, 0) > 0) or (coalesce(nr_prescricao_p, 0) > 0) or (coalesce(ie_load_cache_p, 'N') = 'S'))) then

			delete_items();

			$if dbms_db_version.version >= 11 $then
				nr_sequencia_w := nextval('alerta_api_seq');
			$else
				select nextval('alerta_api_seq') into STRICT nr_sequencia_w;
			$end

			insert into alerta_api(
				nr_sequencia,
				cd_api,
				ie_status_requisicao,
				nr_prescricao,
				nr_seq_material,
				nr_seq_cpoe,
				dt_validade)
			values (	
				nr_sequencia_w,		
				cd_api_p,
				ie_status_requisicao_p,
				nr_prescricao_p,
				0,
				nr_seq_cpoe_p,
				dt_validade_p);

			commit;
			
			nr_seq_controle_p := nr_sequencia_w;
		
		end if;
		
	elsif (ie_status_requisicao_p in ('E', 'F')) then

		update_items();

	elsif (ie_status_requisicao_p in ('D')) then

		delete_items();

	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_controle_alerta_api ( cd_api_p alerta_api.cd_api%type, ie_status_requisicao_p alerta_api.ie_status_requisicao%type, nr_seq_cpoe_p alerta_api.nr_seq_cpoe%type, nr_prescricao_p alerta_api.nr_prescricao%type, nr_seq_material_p alerta_api.nr_seq_material%type, nr_seq_controle_p INOUT alerta_api.nr_sequencia%type, dt_validade_p alerta_api.dt_validade%type default null, ds_erro_p alerta_api.ds_resultado%type default null, ie_load_cache_p text default null) FROM PUBLIC;

