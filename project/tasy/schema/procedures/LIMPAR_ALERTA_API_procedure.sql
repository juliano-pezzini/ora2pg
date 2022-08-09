-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_alerta_api ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_api_p text, nr_seq_cpoe_p bigint default null) AS $body$
DECLARE


	ds_API_available_w	varchar(255);
	nr_seq_cpoe_temp_w	cpoe_material.nr_sequencia%type;


BEGIN



if	((nr_prescricao_p >  0) and (nr_seq_material_p > 0) and ((cd_api_p IS NOT NULL AND cd_api_p::text <> '') or cd_api_p != '')) then
	delete from alerta_api
	where 	nr_prescricao 	= nr_prescricao_p
	and 	nr_seq_material 	= nr_seq_material_p
	and 	cd_api 	= cd_api_p
	and     coalesce(ie_status_requisicao::text, '') = '';

elsif (nr_seq_material_p > 0) and (coalesce(cd_api_p::text, '') = '' or cd_api_p = '') then
	delete from alerta_api
	where 	nr_prescricao 	= nr_prescricao_p
	and 	nr_seq_material 	= nr_seq_material_p
	and     coalesce(ie_status_requisicao::text, '') = '';

elsif (nr_seq_material_p = 0) and (coalesce(cd_api_p::text, '') = '' or cd_api_p = '') then
	delete from alerta_api
	where 	nr_prescricao 	= nr_prescricao_p
	and     coalesce(ie_status_requisicao::text, '') = '';

elsif (coalesce(nr_seq_cpoe_p,0) > 0) then

	if ((cd_api_p IS NOT NULL AND cd_api_p::text <> '') or cd_api_p != '') then
		delete from alerta_api
		where 	nr_seq_cpoe = nr_seq_cpoe_p
		and 	cd_api 	= cd_api_p
		and     coalesce(ie_status_requisicao::text, '') = '';
	else
		delete from alerta_api
		where 	nr_seq_cpoe = nr_seq_cpoe_p	
		and     coalesce(ie_status_requisicao::text, '') = '';
	end if;
	
else
	delete from alerta_api
	where 	nr_prescricao 	= nr_prescricao_p
	and 	cd_api 	= cd_api_p
	and     coalesce(ie_status_requisicao::text, '') = '';
end if;


	/* Limpar os alertas das APIs desabilitadas */

	if (coalesce(nr_prescricao_p, 0) > 0) then
		select max(get_list_API_available(a.nr_atendimento, a.cd_pessoa_fisica, 'N'))
		  into STRICT ds_API_available_w
		  from prescr_medica a
		 where a.nr_prescricao = nr_prescricao_p;
		
		delete from alerta_api
		 where nr_sequencia in (
								SELECT a.nr_sequencia
								  from alerta_api a
								  left join table(lista_pck.obter_lista_char(ds_API_available_w)) x on x.cd_registro = a.cd_api
								 where nr_prescricao = nr_prescricao_p
								   and coalesce(x.cd_registro::text, '') = ''
								   and coalesce(ie_status_requisicao::text, '') = '' 
								);

	elsif (coalesce(nr_seq_cpoe_p,0) > 0) then
		select max(get_list_API_available(a.nr_atendimento, a.cd_pessoa_fisica, 'N')), max(a.nr_sequencia)
		  into STRICT ds_API_available_w,
			   nr_seq_cpoe_temp_w	
		  from cpoe_material a
		 where a.nr_sequencia = nr_seq_cpoe_p;

		if (coalesce(nr_seq_cpoe_temp_w, 0) > 0) then
			delete from alerta_api
			 where nr_sequencia in (
									SELECT a.nr_sequencia
									  from alerta_api a
									  left join table(lista_pck.obter_lista_char(ds_API_available_w)) x on x.cd_registro = a.cd_api
									 where nr_seq_cpoe = nr_seq_cpoe_p
									   and coalesce(x.cd_registro::text, '') = ''
									   and coalesce(ie_status_requisicao::text, '') = '' 
									);
		end if;

	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_alerta_api ( nr_prescricao_p bigint, nr_seq_material_p bigint, cd_api_p text, nr_seq_cpoe_p bigint default null) FROM PUBLIC;
