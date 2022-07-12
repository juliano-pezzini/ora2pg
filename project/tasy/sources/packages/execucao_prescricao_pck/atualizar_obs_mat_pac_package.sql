-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE execucao_prescricao_pck.atualizar_obs_mat_pac ( nr_sequencia_p bigint, ds_observacao_p text, ie_opcao_p text) AS $body$
BEGIN

		if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
			
			if (ie_opcao_p = 'M') then
				update	material_atend_paciente
				set	ds_observacao	= SUBSTR(ds_observacao || ' ' || ds_observacao_p,1,255)
				where	nr_sequencia	= nr_sequencia_p;
			elsif (ie_opcao_p = 'P') then
				update	procedimento_paciente
				set	ds_observacao	= SUBSTR(ds_observacao || ' ' || ds_observacao_p,1,255)
				where	nr_sequencia	= nr_sequencia_p;
			end if;		

		commit;

		end if;

	end;	
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE execucao_prescricao_pck.atualizar_obs_mat_pac ( nr_sequencia_p bigint, ds_observacao_p text, ie_opcao_p text) FROM PUBLIC;